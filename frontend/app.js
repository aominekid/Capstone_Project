document.getElementById("upload-form").addEventListener("submit", async function (e) {
    e.preventDefault();
    
    const fileInput = document.getElementById("file");
    const file = fileInput.files[0];
    
    if (!file) {
      alert("Bitte wähle eine Datei aus!");
      return;
    }
    
    const formData = new FormData();
    formData.append("file", file);
  
    // Füge hier den API-Aufruf für den Upload hinzu
    alert("Datei wurde ausgewählt: " + file.name);
  });
  