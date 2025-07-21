// see app/javascripts/bpluser/folder_tools.js.bak for original jqeury version

const addCheckedToURL = () => {
  let checkboxValues = new URLSearchParams(
    Array.from(document.querySelectorAll('[name="selected[]"]:checked'))
      .map(input => ['id', input.value])
  ).toString();

  document.querySelectorAll('#citeLink, #emailLink, #copyLink').forEach(link => {
    const baseUrl = link.href.split('?')[0];
    link.href = `${baseUrl}?${checkboxValues}`;
  });
};

document.addEventListener('DOMContentLoaded', () => {
  // Remove duplicate buttons from form
  document.querySelectorAll('#cite_btn, #email_btn').forEach(btn => btn.remove());

  // Add click event for any checkbox in doc list
  document.querySelectorAll('input[type="checkbox"][name="selected[]"]').forEach(checkbox => {
    checkbox.addEventListener('click', addCheckedToURL);
  });

  // Select/unselect all
  const selectAll = document.getElementById('selectAllItems');
  if (selectAll) {
    selectAll.addEventListener('click', () => {
      const isChecked = selectAll.checked;
      document.querySelectorAll('input[type="checkbox"][name="selected[]"]').forEach(checkbox => {
        checkbox.checked = isChecked;
      });
      addCheckedToURL();
    });
  }
});

export { addCheckedToURL };
