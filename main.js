document.addEventListener('DOMContentLoaded', () => {
  console.log('Area Services App Loaded!');
  // Add any interactivity or dynamic functionality here
});
document.addEventListener('DOMContentLoaded', function () {
  const sidebarButton = document.getElementById('sidebarToggle');
  const sidebarContent = document.getElementById('sidebarContent');
  const closeButton = document.getElementById('closeSidebar');

  if (sidebarButton && sidebarContent && closeButton) {
    // Open the sidebar when the menu button is clicked
    sidebarButton.addEventListener('click', function () {
      sidebarContent.style.transform = 'translateX(0)';
      sidebarButton.style.display = 'none'; // Hide the menu button
    });

    // Close the sidebar when the close button is clicked
    closeButton.addEventListener('click', function () {
      sidebarContent.style.transform = 'translateX(100%)';
      sidebarButton.style.display = 'block'; // Show the menu button
    });
  } else {
    console.error('One or more elements are not found in the DOM.');
  }
});
