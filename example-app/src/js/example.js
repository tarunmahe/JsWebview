import { AdmobController } from 'admobads';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    AdmobController.echo({ value: inputValue })
}
