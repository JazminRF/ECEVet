module ecevet::registro {
    use std::signer; // Global Storage trabaja sobre el signer y address como vimos anteriormente.
    use aptos_std::table::{Self, Table};
    use std::signer::address_of;
    use std::string::{String,utf8};

    use std::vector::{ length, borrow}; // Solo para crear un vector no es necesario importar la libreria.

  //Constantes para el control de errores
    const YA_INICIALIZADO: u64 = 1;
    /// Aun no se ha inicializado la Agenda.
    const NO_INICIALIZADO: u64 = 2;
    /// El Registro buscado no fue encontrado con el Nombre proporcionado.
    const REGISTRO_NO_EXISTE: u64 = 3;
    /// El nombre que se esta intentado usar ya existe
    const REGISTRO_YA_EXISTE: u64 = 4;
    /// No se proporcionaron valores a modificar.
    const NADA_A_MODIFICAR: u64 = 5;

    struct Persona has key , copy,drop{  
        idPersona:u64,
        name: String, //Se dividio en apPaterno y apMaterno pero se recorto aqui
        adressP: String,
        phone: String,
        email:String,
    }
    struct Mascota has key ,store, copy, drop{
        idMascota: String,
        nombre:String,
        especie: String,
        raza: String,
        color:String,
        fechaNacimiento: String,
        propietario : String,
        foto:String,
    } 

//Inicializar un registro individual----------------------------
    public entry fun publicarPersona(ecevet: &signer, idPersona: u64,name:String,adressP:String,phone:String,email:String) { // La funcion recibe 2 parametros, pero en realidad al ejecutarla, solo enviaremos 1.
        let propietario1=Persona{ idPersona:0, name:  utf8(b"Jazmin Rodriguez Flores"),adressP: utf8(b"Pachuca, Hidalgo"), phone:utf8(b"771120458"),email: utf8(b"jrodriguez@gmail.com")};
        move_to(ecevet, propietario1) // A esta accion se le llama empaquetar, o pack. Nota la omision del ; Porque es esto?
    }
    public entry fun publicarMascota(ecevet: &signer, idMascota: String,nombre:String,especie:String, raza:String, color:String, fechaNacimiento:String, propietario:String, foto:String) { // La funcion recibe 2 parametros, pero en realidad al ejecutarla, solo enviaremos 1.
        let perro1=Mascota{ idMascota: utf8(b"1"), nombre:utf8(b"Gofy"), especie: utf8(b"Perro"),raza:utf8(b"Beagle"),color:utf8(b"negro y blanco"),fechaNacimiento: utf8(b"15/11/2020"), propietario : utf8(b"Jazmin Rodriguez"),foto:utf8(b"c:/documento/gofy.jpg")};
	
        move_to(ecevet, perro1) // A esta accion se le llama empaquetar, o pack. 
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_Persona(direccion: address): u64 acquires Persona {
        // Usamos borrow_global para obtener ese recurso.
        borrow_global<Persona>(direccion).idPersona // Recuerda que el recurso es simplemente un struct, por lo que podemos acceder a sus campos con .
        // Nota que esta operacion es una referencia inmutable. Tambien a diferencia de la operacion de publicar y move_to, aca usamos la address.
    }
    //Obtener de Persona -------------------------------------------------------
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_idPersona(direccion: address): u64 acquires Persona {
        // Usamos borrow_global para obtener ese recurso.
        borrow_global<Persona>(direccion).idPersona // Recuerda que el recurso es simplemente un struct, por lo que podemos acceder a sus campos con .
        // Nota que esta operacion es una referencia inmutable. Tambien a diferencia de la operacion de publicar y move_to, aca usamos la address.
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_Name(direccion: address): String acquires Persona {
        // Usamos borrow_global para obtener ese recurso.
        borrow_global<Persona>(direccion).name // Recuerda que el recurso es simplemente un struct, por lo que podemos acceder a sus campos con .
        // Nota que esta operacion es una referencia inmutable. Tambien a diferencia de la operacion de publicar y move_to, aca usamos la address.
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_adressP(direccion: address): String acquires Persona {
        // Usamos borrow_global para obtener ese recurso.
        borrow_global<Persona>(direccion).adressP // Recuerda que el recurso es simplemente un struct, por lo que podemos acceder a sus campos con .
        // Nota que esta operacion es una referencia inmutable. Tambien a diferencia de la operacion de publicar y move_to, aca usamos la address.
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_Phone(direccion: address): String acquires Persona {
        // Usamos borrow_global para obtener ese recurso.
        borrow_global<Persona>(direccion).phone// Recuerda que el recurso es simplemente un struct, por lo que podemos acceder a sus campos con .
        // Nota que esta operacion es una referencia inmutable. Tambien a diferencia de la operacion de publicar y move_to, aca usamos la address.
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_Email(direccion: address): String acquires Persona {
        // Usamos borrow_global para obtener ese recurso.
        borrow_global<Persona>(direccion).email// Recuerda que el recurso es simplemente un struct, por lo que podemos acceder a sus campos con .
        // Nota que esta operacion es una referencia inmutable. Tambien a diferencia de la operacion de publicar y move_to, aca usamos la address.
    }
    #[view] // Solo estamos validando algo, asi que podemos usarlo como view
    public fun existe(direccion: address): bool { // No estamos adquiriendo el recurso, solo estamos verificando si existe o no
        exists<Persona>(direccion) // Usamos la operacion exists, la cual retorna true o falso dependiendo si el recurso existe o no en la cuenta dada.
        // Como exists regresa un bool podemos regresar ese valor directamente.
    }
     // Restablece el valor del recurso `Contador del id` de la `cuenta` a 0
    // Aca usamos signer en vez de address. Es decir, que solo la persona que firme la transaccion puede reestablecer su contador.
    public entry fun restablecer(ecevet: &signer) acquires Persona { // aquires dado a que vamos a adquirir ese recurso
        // Recibimos signer como parametro, pero recordemos que borrow_global y borrow_global_mute requieren un address ...
        let referencia_persona = &mut borrow_global_mut<Persona>(signer::address_of(ecevet)).idPersona; // Por lo que convertimos usando la operacion address_of
        *referencia_persona = 0
    }
    // Elimina el recurso `Contador` bajo la `cuenta` y regresa su valor
    // Estamos usando signer como parametro, es decir, que solo puedes borrar el recurso de tu cuenta si llamas a este metodo.
    public entry fun eliminarPersona(ecevet: &signer) acquires Persona { // aquires dado a que vamos a adquirir ese recurso
        // move_from basicamente saca el recurso del global storage. 
        // Una vez que hagamos esto, el recurso ya no estara en el global storage a menos que lo regresemos.
        let persona = move_from<Persona>(signer::address_of(ecevet)); // Como usamos signer, hay que convertirlo en address.
        // Ahora, ya adquirimos el recurso, ya esta fuera del global storage y lo tenemos almacenado en la variable contador
        // Como podemos deshacernos de el? No podemos simplemente ignorarlo porque no tiene drop...
        let Persona { idPersona: _ ,name:_,adressP:_,phone:_,email:_} = persona; // Recuerda la desestructuracion de structs.
        // y podemos parar, dado a que u64 tiene drop y lo podemos ignorar.
    }
    public entry fun incrementar(direccion: address) acquires Persona { // aquires dado a que vamos a adquirir ese recurso
        // Vamos a obtener una referencia mutable al valor del contador
        // Para esto usamos la operacion borrow_global_mut, le indicamos el tipo del recurso que vamos a recibir, osea Contador
        let referencia_persona = &mut borrow_global_mut<Persona>(direccion).idPersona; // Y accedemos a su campo valor usando .
        *referencia_persona = *referencia_persona + 1 // Y como es mutable, podemos modificar su valor directamente usando dereferenciacion.
    }
    //Obtener de mascota///////////////////////////////////----------------------------
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_idMascota(direccion: address): String acquires Mascota {
        borrow_global<Mascota>(direccion).idMascota // Recuerda que el recurso es simplemente un struct, por lo que podemos acceder a sus campos con .
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_nombreMascota(direccion: address): String acquires Mascota {
        borrow_global<Mascota>(direccion).nombre 
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_especieMascota(direccion: address): String acquires Mascota {
        borrow_global<Mascota>(direccion).especie 
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_razaMascota(direccion: address): String acquires Mascota {
        borrow_global<Mascota>(direccion).raza
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_colorMascota(direccion: address): String acquires Mascota {
        borrow_global<Mascota>(direccion).color
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_fechMascota(direccion: address): String acquires Mascota {
        borrow_global<Mascota>(direccion).fechaNacimiento
    }
    #[view] // Podemos especificar que es un metodo de vista
    public fun obtener_propietarioMascota(direccion: address): String acquires Mascota {
        borrow_global<Mascota>(direccion).propietario

    }#[view] // Podemos especificar que es un metodo de vista
    public fun obtener_fotoMascota(direccion: address): String acquires Mascota {
        borrow_global<Mascota>(direccion).foto
    }
    public entry fun eliminarMAscota(ecevet: &signer) acquires Mascota { // aquires dado a que vamos a adquirir ese recurso
        // move_from basicamente saca el recurso del global storage. 
        // Una vez que hagamos esto, el recurso ya no estara en el global storage a menos que lo regresemos.
        let mascota1 = move_from<Mascota>(signer::address_of(ecevet)); // Como usamos signer, hay que convertirlo en address.
        // Ahora, ya adquirimos el recurso, ya esta fuera del global storage y lo tenemos almacenado en la variable contador
        // Como podemos deshacernos de el? No podemos simplemente ignorarlo porque no tiene drop...
        let Mascota { idMascota: _ ,nombre:_,especie:_,raza:_, color:_, fechaNacimiento:_,propietario:_, foto:_} = mascota1; // Recuerda la desestructuracion de structs.
        // y podemos parar, dado a que u64 tiene drop y lo podemos ignorar.
    }
}