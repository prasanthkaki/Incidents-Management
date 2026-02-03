let currentPage = 1;
let limit = 10;
let totalPages = 1;
let incidentToDelete = null;
let masterData = null;

$(document).ready(function () {
    fetchIncidents();
});

function fetchIncidents(page = 1) {
    $.ajax({
        url: "http://127.0.0.1:8000/incidents/list",
        method: "GET",
        data: {
            page: page,
            limit: limit
        },
        success: function (response) {
            renderTable(response.data);
            updatePagination(response.page, response.total);
        },
        error: function () {
            alert("Failed to load incidents");
        }
    });
}

function updatePagination(page, total) {
    currentPage = page;
    totalPages = Math.ceil(total / limit);

    $("#pageInfo").text(`Page ${currentPage} of ${totalPages}`);
    $("#totalInfo").text(`Total: ${total} incidents`);

    $("#prevBtn").prop("disabled", currentPage === 1);
    $("#nextBtn").prop("disabled", currentPage === totalPages || totalPages === 0);
}

$("#refreshBtn").click(function () {
    fetchIncidents(currentPage);
});

$("#prevBtn").click(function () {
    if (currentPage > 1) {
        fetchIncidents(currentPage - 1);
    }
});

$("#nextBtn").click(function () {
    if (currentPage < totalPages) {
        fetchIncidents(currentPage + 1);
    }
});

function renderTable(incidents) {
    const tbody = $("#incident-table tbody");
    tbody.empty();

    if (!incidents || incidents.length === 0) {
        $("#incident-table").hide();
        $("#empty-state").removeClass("hidden");
        return;
    }

    $("#incident-table").show();
    $("#empty-state").addClass("hidden");

    incidents.forEach(incident => {
        const severityClass = incident.severity.toLowerCase();
        const row = `
            <tr>
                <td>${incident.title}</td>
                <td>${incident.description}</td>
                <td>${incident.erp_module}</td>
                <td>${incident.environment}</td>
                <td>${incident.business_unit}</td>
                <td>
                    <span class="severity severity-${incident.severity.toLowerCase()}">
                        ${incident.severity}
                    </span>
                </td>
                <td>${incident.category}</td>
                <td>${incident.status}</td>
                <td>${formatDate(incident.created_at)}</td>
                <td class="actions">
                    <i class="fa-solid fa-pen edit-icon"
                    title="Edit"
                    data-id="${incident.id}"></i>

                    <i class="fa-solid fa-trash delete-icon"
                    title="Delete"
                    data-id="${incident.id}"></i>
                </td>
            </tr>
        `;
        tbody.append(row);
    });
}

function formatDate(dateStr) {
    const date = new Date(dateStr);

    const day = date.getDate();
    const month = date.toLocaleString('en-US', { month: 'short' });
    const year = date.getFullYear();

    let hours = date.getHours();
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');

    const ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12 || 12; // convert 0 -> 12

    return `${day} ${month}, ${year} ${hours}:${minutes}:${seconds} ${ampm}`;
}


$(document).on("click", ".delete-icon", function () {
    incidentToDelete = $(this).data("id");
    $("#deleteModal").removeClass("hidden");
});

$("#cancelDelete").click(function () {
    incidentToDelete = null;
    $("#deleteModal").addClass("hidden");
});

$("#confirmDelete").click(function () {
    if (!incidentToDelete) return;

    $.ajax({
        url: `http://127.0.0.1:8000/incidents/delete-incident/${incidentToDelete}`,
        method: "DELETE",
        success: function () {
            $("#deleteModal").addClass("hidden");
            fetchIncidents(currentPage);
        },
        error: function () {
            alert("Failed to delete incident");
            $("#deleteModal").addClass("hidden");
        }
    });
});

function populateDropdowns(data) {
    fillSelectFromObject("#erp_module_id", data.erp_module, "Select ERP Module");
    fillSelectFromObject("#env_id", data.environments, "Select Environment");
    fillSelectFromObject("#business_unit_id", data.business_unit, "Select Business Unit");
    fillSelectFromObject("#category_id", data.categories, "Select Category");
    fillSelectFromObject("#status", data.status, "Select Status");
}

function fillSelectFromObject(selector, obj, placeholder) {
    const select = $(selector);
    select.empty();

    select.append(`<option value="">${placeholder}</option>`);

    for (const key in obj) {
        if (obj.hasOwnProperty(key)) {
            select.append(
                `<option value="${key}">${obj[key]}</option>`
            );
        }
    }
}

function openIncidentModal() {
    $("#incidentModal").removeClass("hidden");
    if (masterData) {
        populateDropdowns(masterData);
        return;
    }

    $.ajax({
        url: "http://127.0.0.1:8000/incidents/drop-down",
        method: "GET",
        success: function (response) {
            masterData = response.data;
            populateDropdowns(masterData);
        },
        error: function () {
            alert("Failed to load master data");
        }
    });
}

$("#createBtn").click(function () {
    $("#incidentModal").removeClass("hidden");
});

$(".close-btn").click(function () {
    $("#incidentModal").addClass("hidden");
});

$(window).click(function (e) {
    if (e.target.id === "incidentModal") {
        $("#incidentModal").addClass("hidden");
    }
});

$("#createBtn").click(function () {
    openIncidentModal();
});

function closeIncidentModal() {
    $("#incidentModal").addClass("hidden");
}

$(".close-btn").on("click", closeIncidentModal);

$("#incidentForm").on("submit", function (e) {
    e.preventDefault();

    const payload = {
        title: $("#title").val(),
        description: $("#description").val(),
        client_id: 10, // hardcoded for now
        erp_module_id: $("#erp_module_id").val(),
        env_id: $("#env_id").val(),
        business_unit_id: $("#business_unit_id").val(),
        category_id: $("#category_id").val(),
        status: $("#status").val()
    };

    $.ajax({
        url: "http://127.0.0.1:8000/incidents/create-incident",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(payload),
        success: function () {
            closeIncidentModal();
            $("#incidentForm")[0].reset();
            fetchIncidents(currentPage || 1);
        },
        error: function (xhr) {
            alert(xhr.responseJSON?.detail || "Failed to create incident");
        }
    });
});