object municipio{
	
	var clubes = #{}
	
	method sancionarClub(club){
		
		if (club.cantidadDeSocios() < 500){
			self.error("tiene menos de 500 socio, no se lo puede sancionar de manera integral")
		}else{
			club.recibirSancion()
		}
	}
	
	method sancionarActividad(club, actividad){
		club.aplicarSancionAUnaActividad().recibirSancion()
	}
	
	method reanudarActividadSocial(club, actividad){
		club.reanudar(actividad)
	}
	
	method evaluarClub(club){
		club.evaluarActividades()
	}
	
}


class Socio {
	
	var property actividades = #{}
	var property antiguedad = 0
	
	method agregarActividad(unaActividad) {
		
		actividades.add(unaActividad)
	}
	
	method esEstrella() = antiguedad > 20
	
}

class Jugador inherits Socio{
	
	var property partidosJugados = 0
	var property valorPase = 0
	var clubPerteneciente = "null"
	
	override method esEstrella() = partidosJugados >= 50 or clubPerteneciente.perfil().esEstrella(self)
}

class Club{
	
	var property gastoMensual = 0
	var property cantidadDeSocios = 0
	var property actividades = #{}
	const property perfil = "null"
	
	
	method esEstrella(socio){
		return socio.antiguedad()> 20 || socio.partidosJugados() >50 || self.requerimientosEspeciales(socio)
	}
	method requerimientosEspeciales(socio){
		return socio.valorPase()> valorParaSerEstrella.valor()
	}
	
	method todosLosCapitanes() = actividades.map({actividad => actividad.capitan()})
	method todosLosOrganizadores() = actividades.map({actividad => actividad.organizador()})
	
	method sociosDestacados() = #{self.todosLosCapitanes() + self.todosLosOrganizadores()}
	
	method sociosDestacadosEstrellas() = self.sociosDestacados().filter({socio => socio.esEstrella()})
	
	method esPrestigioso() = actividades.any({actividad => actividad.esExperimentado()})
	
	method aplicarSancionAUnaActividad(unaActividad){
		unaActividad.recibirSancion()
	}
	
	method recibirSancion(){
		actividades.foreach({actividad => actividad.recibirSancion()})
	}
	
	method reanudar(actividad){
		actividad.reanudar()
	}
	
	method evaluarActividades(){
		return actividades.foreach({actividad => actividad.evaluacion()}).sum()
	}
}

class Perfil {
	
	method esEstrella(jugador)
	method evaluacionBruta(unClub)
}

object profesional {
	
	method esEstrella(jugador) = jugador.valorPase() > valorParaSerEstrella.valor()
	
	//Punto nº4 
	method evaluacionBruta(unClub) = (unClub.sumarEvaluacionActividades() * 2) - (5 *unClub.gastoMensual()) 	
}

object comunitario {
	
	method esEstrella(jugador) = jugador.actividades().size() > 3
	
	//Punto nº4 
	method evaluacionBruta(unClub) = unClub.sumarEvaluacionActividades()
}

object tradicional {
	
	method esEstrella(jugador) {
		return profesional.esEstrella(jugador)
		 	   or	 
		 	   comunitario.esEstrella(jugador)
		 	   
	}
	
	method evaluacionBruta(unClub) = unClub.sumarEvaluacionActividades() - unClub.gastoMensual()						  
}


class Actividad{
	
	method recibirSancion()
	
	method evaluacion()
	
	method esExperimentado()
}

class ActividadSocial inherits Actividad{
	
	var property organizador = "null"
	var property estaSuspendida = false
	const property valorDeActividad = 0
	
	override method recibirSancion(){
		self.estaSuspendida(true) 
	}
	
	method reanudar(){
		estaSuspendida = false
	}
	
	override method evaluacion() {
		
		var valor = 0
		
		if(!estaSuspendida) {
			
			valor = valorDeActividad
		}
		
		return valor
	}
	
}
class ActividadDeportiva inherits Actividad{
	
	var property capitan = "null"
	var plantel= #{}
	var property cantidadDeJugadores = 0
	var property suspensiones = 0
	var property campeonatos = 0
	
	override method esExperimentado() {
		
		return plantel.all({jugador => jugador.partidosJugados() >= 10})
		
	}
	
	method recibirCampeonato(){
		campeonatos += 1
	}
	
	override method recibirSancion(){
		suspensiones += 1 
	}
	
	override method evaluacion(){
		return (self.campeonatos() * 5) + (plantel.size() *2) + self.premioSiEsEstrella(capitan) - self.calcularSuspensiones()	}
	
	method calcularSuspensiones() = suspensiones*20
	
	method premioSiEsEstrella(unJugador){
		return if(capitan.esEstrella()) {5}
			   else {0}
	}
	
	method calcularEstrellasPlantel(){
		return plantel.sum({jugador => self.premioSiEsEstrella(jugador)})
	}
}

class EquipoDeFutbol inherits ActividadDeportiva{
	
	override method evaluacion() = super() + self.calcularEstrellasPlantel()
	
	override method calcularSuspensiones() = suspensiones * 30
}

class ClubProfesional inherits Club {
	
	
}

class ClubComunitario inherits Club {
	
	override method requerimientosEspeciales(socio){
		return socio.actividades().size() >= 3
	}
}

class ClubTradicional inherits Club {
	
	override method requerimientosEspeciales(socio){
		return super(socio) || socio.actividades().size() >= 3
		
	}
}

object valorParaSerEstrella {
	
	var valor
	
	method asignarValor(unaCantidad) {
		valor = unaCantidad
	}
	
	method valor() = valor
}