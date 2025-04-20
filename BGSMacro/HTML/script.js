window.addEventListener("DOMContentLoaded", () => {
    window.chrome.webview.addEventListener("message", event => {
        let data;
        try {
            data = typeof event.data === "string" ? JSON.parse(event.data) : event.data;
        } catch {
            return;
        }
        createMacroTab(data);
    });
});

function createMacroTab(macro) {
    if (!macro || typeof macro !== 'object') return;

    const { params } = macro;
    if (!params) return;

    const existingTab = document.getElementById(params.name);
    const customParams = params.customParams || {};

    if (existingTab) {
        updateExistingTab(existingTab, params.name, !!params.toggle, customParams);
        return;
    }

    createTabButton(params.name);
    const tabContent = createTabContent(params.name, !!params.toggle);

    const paramGrid = document.createElement('div');
    paramGrid.classList.add('param-grid');
    tabContent.appendChild(paramGrid);

    Object.entries(customParams).forEach(([key, param]) => {
        const paramTile = createParamTile(key, param, params.name);
        paramGrid.appendChild(paramTile);
    });

    const countTile = document.createElement('div');
    countTile.classList.add('param-tile');

    const countLabel = document.createElement('label');
    countLabel.textContent = 'Loops:';

    const countSlider = document.createElement('input');
    countSlider.type = 'range';
    countSlider.min = 0;
    countSlider.max = 1000;
    countSlider.value = macro.count || 0;
    countSlider.classList.add('count-slider');
    countSlider.dataset.name = 'count';

    const countValue = document.createElement('span');
    countValue.textContent = countSlider.value;

    countSlider.oninput = function (e) {
        countValue.textContent = e.target.value;
        updateCount(params.name, e.target.value);
    };

    countTile.append(countLabel, countSlider, countValue);
    paramGrid.appendChild(countTile);

    document.getElementById("page-wrapper").appendChild(tabContent);
}

function updateExistingTab(tab, name, toggle, customParams) {
    const checkbox = tab.querySelector('.macro-toggle');
    if (checkbox) checkbox.checked = toggle;

    Object.entries(customParams).forEach(([key, param]) => {
        const input = tab.querySelector(`[data-name="${key}"]`);
        const span = tab.querySelector(`[data-display="${key}"]`);

        if (input) {
            if (param.type === 'boolean') {
                input.checked = param.value;
            } else if (param.type === 'dropdown') {
                input.value = param.value;
            } else {
                input.value = param.value;
                if (span) span.textContent = param.value;
            }
        } else {
            const newTile = createParamTile(key, param, name);
            tab.querySelector('.param-grid')?.appendChild(newTile);
        }
    });
}

function createParamTile(key, param, macroName) {
    const tile = document.createElement('div');
    tile.classList.add('param-tile');

    const label = document.createElement('label');
    label.textContent = key + ":";

    let input = document.createElement('input');
    let display = document.createElement('span');
    display.dataset.display = key;

    input.dataset.name = key;

    switch (param.type) {
        case 'range':
            if (param.min == null || param.max == null || param.value == null) return tile;
            input.type = 'range';
            input.min = param.min;
            input.max = param.max;
            input.value = param.value;
            display.textContent = param.value;
            break;

        case 'number':
            if (param.value == null) return tile;
            input.type = 'number';
            input.value = param.value;
            display.textContent = param.value;
            break;

        case 'boolean':
            input.type = 'checkbox';
            input.checked = !!param.value;
            break;

        case 'dropdown':
            if (!Array.isArray(param.options) || param.options.length === 0) return tile;
            input = document.createElement('select');
            input.dataset.name = key;
            param.options.forEach(option => {
                const optionElement = document.createElement('option');
                optionElement.value = option;
                optionElement.textContent = option;
                input.appendChild(optionElement);
            });
            input.value = param.value || param.options[0];
            break;

        default:
            return tile; 
    }

    input.oninput = (e) => {
        const val = input.type === 'checkbox' ? e.target.checked : e.target.value;
        updateMacroParam(val, macroName, key, param.state);
        if (display && (param.type === 'range' || param.type === 'number')) {
            display.textContent = val;
        }
    };

    tile.appendChild(label);
    tile.appendChild(input);
    if (display && (param.type === 'range' || param.type === 'number')) {
        tile.appendChild(display);
    }

    return tile;
}

function createTabButton(name) {
    const button = document.createElement('button');
    button.classList.add('tab');
    button.textContent = name;
    button.onclick = (event) => openTab(name, event);
    document.querySelector('.tab-menu').appendChild(button);
}

function createTabContent(name, toggle) {
    const tabContent = document.createElement('div');
    tabContent.id = name;
    tabContent.classList.add('tab-content');

    const toggleWrapper = document.createElement('div');
    toggleWrapper.classList.add('toggle-wrapper');

    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.checked = toggle;
    checkbox.classList.add('macro-toggle');
    checkbox.dataset.name = name;
    checkbox.onchange = (e) => updateMacroState(e.target.checked, name);

    const label = document.createElement('label');
    label.textContent = `${name} Enabled`;

    toggleWrapper.append(checkbox, label);
    tabContent.appendChild(toggleWrapper);

    return tabContent;
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
            customParams: [{ name: paramName, value }]
        }
    };
    console.log(message);
    window.chrome.webview.postMessage(JSON.stringify(message));
}

function updateCount(macroName, count) {
    const message = {
        action: "changeParams",
        params: {
            name: macroName,
            count: count,
            customParams: []
        }
    };
    window.chrome.webview.postMessage(JSON.stringify(message));
}

function openTab(tabId, event) {
    document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab').forEach(button => button.classList.remove('active'));
    document.getElementById(tabId)?.classList.add('active');
    event?.target.classList.add('active');
}

document.addEventListener('contextmenu', e => e.preventDefault());
