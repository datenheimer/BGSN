window.addEventListener("DOMContentLoaded", () => {

    window.chrome.webview.addEventListener("message", event => {
        let data;
        try {
            data = typeof event.data === "string" ? JSON.parse(event.data) : event.data;
        } catch (err) {
            return;
        }
        createMacroTab(data);
    });
});

function createMacroTab(macro) {
    if (!macro || typeof macro !== 'object') {
        console.error("❌ Invalid macro object:", macro);
        return;
    }

    const { params } = macro;

    if (!params) {
        return;
    }

    const existingTab = document.getElementById(params.name);

    if (existingTab) {
        const checkbox = existingTab.querySelector('.macro-toggle');
        if (checkbox) {
            checkbox.checked = !!params.toggle;
        }
        const customParams = params.customParams || {};
        Object.entries(customParams).forEach(([key, param]) => {
            const input = existingTab.querySelector(`[data-name="${key}"]`);
            if (input) {
                input.value = param.value;
            } else {
                const paramDiv = document.createElement('div');
                const paramLabel = document.createElement('label');
                paramLabel.textContent = key;

                let paramInput;
                if (param.type === 'range') {
                    paramInput = document.createElement('input');
                    paramInput.type = 'range';
                    paramInput.min = param.min;
                    paramInput.max = param.max;
                    paramInput.value = param.value;
                } else if (param.type === 'number') {
                    paramInput = document.createElement('input');
                    paramInput.type = 'number';
                    paramInput.value = param.value;
                }

                paramInput.dataset.name = key;
                paramInput.oninput = (e) => updateMacroParam(e.target.value, params.name, key, param.state);

                paramDiv.appendChild(paramLabel);
                paramDiv.appendChild(paramInput);
                existingTab.appendChild(paramDiv);
            }
        });

        return;
    }

    const tabButton = document.createElement('button');
    tabButton.classList.add('tab');
    tabButton.textContent = params.name;
    tabButton.onclick = () => openTab(params.name);

    document.querySelector('.tab-menu').appendChild(tabButton);

    const tabContent = document.createElement('div');
    tabContent.id = params.name;
    tabContent.classList.add('tab-content');

    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.checked = !!params.toggle;
    checkbox.classList.add('macro-toggle');
    checkbox.dataset.name = params.name;
    checkbox.onchange = (e) => updateMacroState(e.target.checked, params.name);

    const label = document.createElement('label');
    label.textContent = `${params.name} Enabled`;

    const customParams = params.customParams || {};
    Object.entries(customParams).forEach(([key, param]) => {
        const paramDiv = document.createElement('div');
        const paramLabel = document.createElement('label');
        paramLabel.textContent = key;

        let paramInput;
        if (param.type === 'range') {
            paramInput = document.createElement('input');
            paramInput.type = 'range';
            paramInput.min = param.min;
            paramInput.max = param.max;
            paramInput.value = param.value;
        } else if (param.type === 'number') {
            paramInput = document.createElement('input');
            paramInput.type = 'number';
            paramInput.value = param.value;
        } else if (param.type === 'boolean') {
            paramInput = document.createElement('input');
            paramInput.type = 'checkbox';
            paramInput.checked = param.value;
        }

        paramInput.dataset.name = key;
        paramInput.oninput = (e) => updateMacroParam(e.target.value, params.name, key, params.state);

        paramDiv.appendChild(paramLabel);
        paramDiv.appendChild(paramInput);
        tabContent.appendChild(paramDiv);
    });

    tabContent.appendChild(checkbox);
    tabContent.appendChild(label);
    document.body.appendChild(tabContent);
}


function updateMacroState(state, macroName) {
    const message = {
        action: "changeParams",
        params: {
            name: macroName,
            toggle: state,
            customParams: [] 
        }
    };
    window.chrome.webview.postMessage(JSON.stringify(message));
}

function updateMacroParam(value, macroName, paramName, state) {
    const message = {
        action: "changeParams", 
        params: {
            name: macroName,
            toggle: state,
            customParams: [{ name: paramName, value: value }]
        }
    };
    console.log(message)
    window.chrome.webview.postMessage(JSON.stringify(message));
}


function openTab(tabId) {
    document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab').forEach(button => button.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
    event.target.classList.add('active');
}
document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
});