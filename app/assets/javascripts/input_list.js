class InputList extends HTMLElement {
  constructor() {
    super();
    this.addEventListener("click", e => this.processClick(e));
  }

  connectedCallback() {
    const ul = document.createElement("ul");
    const div = document.createElement("div");
    div.appendChild(ul);

    this.removeBtn = document.createElement("span");
    this.removeBtn.classList.add("remove");
    this.removeBtn.innerHTML = "X";

    this.items.forEach((item) => {
      let li = document.createElement("li");
      let input = this.inputFor(item);
      li.appendChild(input);
      li.appendChild(this.removeBtn.cloneNode(true));
      ul.appendChild(li);
    });
    div.appendChild(this.addNewButton());
    this.appendChild(div);
  }

  addNewButton() {
    let btn = document.createElement("button");
    btn.type = "button";
    btn.classList.add("add-item");
    btn.innerText = "Add New";
    return btn;
  }

  processClick(event) {
    if (event.target.classList.contains("remove")) {
      this.removeItem(event.target.parentNode);
    } else if (event.target.classList.contains("add-item")) {
      this.addItem();
    }

  }

  addItem() {
    let li = document.createElement('li');
    li.appendChild(this.inputFor(""));
    li.appendChild(this.removeBtn.cloneNode(true));
    this.querySelector("ul").appendChild(li);
  }


  inputFor(value) {
    let input = document.createElement("input");
    input.type = "text";
    input.name = this.inputName;
    input.value = value;
    return input;
  }

  removeItem(li) {
    if (li.parentNode.childNodes.length > 1) {
      li.remove();
    } else {
      li.querySelector('input').value = '';
    }
  }

  get inputName() {
    for(var i = 0; i < this.attributes.length; i++) {
      let attr = this.attributes[i];
      if (attr.name === 'input-name') {
        return attr.value;
      }
    }
  }

  get items() {
    const items = [];

    for(var i = 0; i < this.attributes.length; i++) {
      let attr = this.attributes[i];
      if (attr.name.includes('list-item')) {
        items.push(attr.value);
      }
    }

    return items;
  }
}

customElements.define('input-list', InputList);
