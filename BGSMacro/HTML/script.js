function openTab(tabId) {
    document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab').forEach(button => button.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
    event.target.classList.add('active');
    if (tabId === 'tab10') updateMacroList();

    // window.chrome.webview.addEventListener("message", function(event) {
    //     alert("Received " + event.data);
    // });

    // const message = {
    //     action: "runMacro", 
    //     params: {
    //         toggle: "on",  
    //         count: 1  
    //     }
    // };

    // window.chrome.webview.postMessage(JSON.stringify(message));
}


function updateMacroList() {
    const list = document.getElementById('enabledMacros');
    const orderList = document.getElementById('macroOrderList');
    list.innerHTML = '';
    orderList.innerHTML = '';

    document.querySelectorAll('.macro-toggle:checked').forEach(checkbox => {
        const macroName = checkbox.dataset.name;


        const li = document.createElement('li');
        li.textContent = macroName;
        li.draggable = true;
        li.classList.add('macro-item');
        orderList.appendChild(li);
    });

    enableDragAndDrop();
}

function enableDragAndDrop() {
    const items = document.querySelectorAll('.sortable li');

    items.forEach(item => {
        item.addEventListener('dragstart', () => {
            item.classList.add('dragging');
            const img = new Image();
            img.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMSIgaGVpZ2h0PSIxIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjwvc3ZnPg==';
            e.dataTransfer.setDragImage(img, 0, 0);
        });

        item.addEventListener('dragend', () => {
            item.classList.remove('dragging');
        });
    });

    const list = document.querySelector('.sortable');
    list.addEventListener('dragover', e => {
        e.preventDefault();
        const afterElement = getDragAfterElement(list, e.clientY);
        const dragging = document.querySelector('.dragging');
        if (afterElement == null) {
            list.appendChild(dragging);
        } else {
            list.insertBefore(dragging, afterElement);
        }
    });
}

function getDragAfterElement(container, y) {
    const draggableElements = [...container.querySelectorAll('li:not(.dragging)')];

    return draggableElements.reduce((closest, child) => {
        const box = child.getBoundingClientRect();
        const offset = y - box.top - box.height / 2;
        if (offset < 0 && offset > closest.offset) {
            return { offset: offset, element: child };
        } else {
            return closest;
        }
    }, { offset: Number.NEGATIVE_INFINITY }).element;
}


function setTabTitle(tabId) {
    const tabTitle = document.querySelector(`#${tabId} h1`)?.textContent || tabId;

}
document.addEventListener("DOMContentLoaded", () => {
    const sliders = document.querySelectorAll(".macro-slider");
    const inputs = document.querySelectorAll(".macro-input");

    sliders.forEach(slider => {
        slider.addEventListener("input", () => {
            const targetId = slider.getAttribute("data-target");
            const input = document.getElementById(targetId);
            input.value = slider.value;
        });
    });

    inputs.forEach(input => {
        input.addEventListener("input", () => {
            const val = parseInt(input.value) || 1;
            const sliderId = input.getAttribute("data-slider");
            const slider = document.getElementById(sliderId);
            if (val > parseInt(slider.max)) {
                slider.value = slider.max;
            } else {
                slider.value = val;
            }
        });
    });
});
