<div align="center">

<h2>Universidad de Costa Rica</h2>

<h1>Proyecto Final</h1>

<h2>Sistemas Digitales II</h2>

<h3>Grupo 02</h3>

---

### Integrantes

Brandon Jiménez Campos &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C33972  
Daniel Sáenz Obando &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C37099  
Rodrigo Sánchez Araya &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C37259  

</div>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## Metodología

---

Para garantizar coherencia, calidad y un buen trabajo en paralelo, se utilizó.

1. **Formato de código estandarizado**

    - Plantilla llamada `template.v` para tener una misma estructura.
    - Uso de la herramienta Verible para formateo automático y consistencia en todo el código.
    - Señales llamadas igual al estándar y en minúscula.
    - Nombres de estados en mayúscula.
<br>

2. **Flujo de trabajo con GitHub**
   
    - Desarrollo por branches para funcionalidades aisladas.
    - Manejo de tareas mediante Issues.
    - Revisiones de código mediante Pull Requests.
<br>

3. **Repartición de módulos**
   
    - Daniel Sáenz: Módulo Transmisor.
    - Rodrigo Sánchez: Módulo Sincronizador.
    - Brandon Jiménez: Modulo Receptor.

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## Diagrama de bloques y resultados de pruebas individuales

---

### Módulo TRANSMIT

<p align="center">
    <img src="./images/transmit_block_diagram.png" width="100%" alt="Diagrama bloques transmisor">
    <br>
  <em>Figura 1. Diagrama de bloques del módulo TRANSMIT.</em>
</p>

<br>
<br>

<p align="center">
  <img src="images/prueba1_transmit.png" alt="Prueba transmit" width="100%">
  <br>
  <em>Figura 2. Prueba del módulo TRANSMIT.</em>
</p>

---

### Módulo SYNCHRONIZATION

<p align="center">
    <img src="./images/sync_block_diagram.png" width="100%" alt="Diagrama bloques transmisor">
    <br>
  <em>Figura 3. Diagrama de bloques del módulo SYNCHRONIZATION.</em>
</p>

<br>
<br>

<p align="center">
  <img src="images/Prueba_syncronization.jpeg" alt="Prueba Sync OK" width="100%">
  <br>
  <em>Figura 4. Sincronización exitosa del módulo SYNCHRONIZATION.</em>
</p>

<br>
<br>

<p align="center">
  <img src="images/Prueba_sync_2.jpeg" alt="Prueba Sync Error" width="100%">
  <br>
  <em>Figura 5. Detección de error en el módulo SYNCHRONIZATION.</em>
</p>

<br>
<br>

---

### Módulo RECEIVE

<p align="center">
    <img src="./images/receive_block.png" width="100%" alt="Diagrama bloques receptor">
    <br>
  <em>Figura 6. Diagrama de bloques del módulo RECEIVE.</em>
</p>

<br>
<br>

<p align="center">
  <img src="images/prueba1_receive.png" alt="Prueba Receive 1" width="100%">
  <br>
  <em>Figura 7. Prueba de recepción.</em>
</p>

<br>
<br>

<p align="center">
  <img src="images/prueba2_receive.png" alt="Prueba Receive 2" width="100%">
  <br>
  <em>Figura 8. No se encuentra sincronizado.</em>
</p>

<br>
<br>


<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## Resultados en conjunto
---











<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## Conclusiones y Recomendaciones

---

## Conclusiones

- La metodología empleado permitió avanzar rápido y mantener coherencia entre los tres bloques: Transmisor, Sincronizador y Receptor.
<br>
  
- Al integrar los 3 módulos simplificados se verificó el correcto funcionamiento, cumpliendo así la cláusula 36 del estándar IEEE 802.3.
<br>
  
- El manejo del _running disparity_ y la lógica de los code groups funcionó correctamente tanto en pruebas individuales como en la simulación completa.
<br>

- El uso de GitHub permitió un trabajo ordenado, sin conflictos y con integración sencilla entre módulos.
<br>

## Recomendaciones

- Realizar la sintetización de los módulos.
<br>

- Explorar la implementación del bloque de Auto-Negotiation.





