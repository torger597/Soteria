/obj/item/weapon/gun/projectile/automatic/marine
	name = "AK-47"
	desc = "A cheap to produce and maintain rifle, used for a millenia."
	icon = 'icons/mob/Marine_Weapons.dmi'
	icon_state = "AK47"
	item_state = "AK47"
	w_class = 4.0
	max_shells = 30
	caliber = "a762"
	origin_tech = "combat=6;materials=2"
	ammo_type = "/obj/item/ammo_casing/a762"
	automatic = 1
	fire_delay = 0
	fire_cooldown = 0
	projectiles_per_shot = 1
	fire_delay_wielded = 0
	fire_delay_unwielded = 14
	force_wielded = 10
	force_unwielded = 5
	rangedrop = -5
	load_method = MAGAZINE
	isHandgun()
		return 0
/obj/item/weapon/gun/projectile/automatic/marine/verb/wield()
	set name = "Wield"
	set category = "Object"
	set src in usr
	toggle_wield(usr)
/obj/item/weapon/gun/projectile/automatic/marine
	can_wield()
		return 1
/obj/item/weapon/gun/projectile/automatic/marine/ak47
	name = "AK-47"
	desc = "A cheap to produce and maintain rifle, used for a millenia."
	icon = 'icons/mob/Marine_Weapons.dmi'
	icon_state = "AK47"
	w_class = 4.0
	max_shells = 30
	caliber = "a762"
	origin_tech = "combat=6;materials=2"
	ammo_type = "/obj/item/ammo_casing/a762"
	automatic = 1
	fire_delay = 0
	fire_cooldown = 0
	projectiles_per_shot = 1
	rangedrop = -2

	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/ak47mag/empty(src)
		update_icon()
		return


	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			user.visible_message("<span class='rose'>Calmly, [user] reaches up and unloads, then drops the magazine from their AK-47 in one smooth movement.</span>")
			update_icon()
		return
/obj/item/weapon/gun/projectile/automatic/marine/marinerifle
	name = "MR246"
	desc = "Slightly bulky but lightweight, this rifle is the standard NT Marine Assault Rifle. Firing with surprisingly low recoil, it is an effective assault weapon and is capable of selected fire modes. Fires 6.5x55mm ammunition."
	icon_state = "MarineRifle"
	w_class = 4.0
	max_shells = 35
	caliber = "a65m55"
	ammo_type = "/obj/item/ammo_casing/a65m55"
	rangedrop = -4
	fire_delay_unwielded = 12

	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/marineriflemag/empty(src)
		update_icon()
		return


	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			user.visible_message("<span class='rose'>Calmly, [user] reaches up and unloads, then drops the magazine from their Assault Rifle in one smooth movement.</span>")
			update_icon()
		return
/obj/item/weapon/gun/projectile/automatic/marine/marinerifle/adv
	name = "MR246-A"
	desc = "Slightly bulky but lightweight this rifle is the standard NT Marine Assault Rifle equipped with an advanced tactical scope. Firing with surprisingly low recoil it is an effective assault weapon and is capable of selected fire modes. Fires 6.5x55mm ammunition."
	icon_state = "MarineRifle_adv"
	w_class = 4.0
	max_shells = 35
	caliber = "a65m55"
	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/marineriflemag/empty(src)
		update_icon()
		return


	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			user.visible_message("<span class='rose'>Calmly, [user] reaches up and unloads, then drops the magazine from their Assault Rifle in one smooth movement.</span>")
			update_icon()
		return
/obj/item/weapon/gun/projectile/automatic/marine/smg
	name = "Saber Mk2"
	desc = "A redesign of the Saber SMG, this model has a front loading magazine chamber housing more rounds, a rear stock for increased stability, and comes with an attached red-dot targeting HUD. Fires .45 cal. rounds."
	icon = 'icons/mob/Marine_Weapons.dmi'
	icon_state = "MarineSMG"
	item_state = "MarineSMG"
	w_class = 3.0
	max_shells = 25
	caliber = ".45"
	ammo_type = "/obj/item/ammo_casing/c45"
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/marinesmgmag/empty(src)
		update_icon()
		return
	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			user.visible_message("<span class='rose'>Calmly, [user] reaches up and unloads, then drops the magazine from their Submachinegun in one smooth movement.</span>")
			playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
			update_icon()
		return
/obj/item/weapon/gun/projectile/automatic/marine/smg/attack_hand(mob/user as mob)
	if(loc == user)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			user << "<span class='notice'>You unscrew [silenced] from [src].</span>"
			user.put_in_hands(silenced)
			silenced = 0
			update_icon()
			return
	..()
/obj/item/weapon/gun/projectile/automatic/marine/smg/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			user << "<span class='notice'>You'll need [src] in your hands to do that.</span>"
			return
		user.drop_item()
		user << "<span class='notice'>You screw [I] onto [src].</span>"
		silenced = I	//dodgy?
		I.loc = src		//put the silencer into the gun
		update_icon()
		return
	..()
/obj/item/weapon/gun/projectile/automatic/marine/smg/update_icon()
	..()
	if(silenced)
		icon_state = "MarineSMGSD"
	else
		icon_state = "MarineSMG"
/obj/item/weapon/gun/projectile/automatic/marine/carbine
	name = "MC165"
	desc = "The MC165 is a lightweight carbine used by light-infantry, known for being an effective CQC and mid-ranged weapon. Fires 6.5x55mm ammunition."
	icon = 'icons/mob/Marine_Weapons.dmi'
	icon_state = "MarineCarbine"
	item_state = "MarineCarbine"
	w_class = 3.0
	max_shells = 30
	origin_tech = "combat=6;materials=2"
	caliber = "a65m55"
	ammo_type = "/obj/item/ammo_casing/a65m55"
	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/marineriflemag/empty(src)
		update_icon()
		return
	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			user.visible_message("<span class='rose'>Calmly, [user] reaches up and unloads, then drops the magazine from their Carbine in one smooth movement.</span>")
			update_icon()
		return
/obj/item/weapon/gun/projectile/automatic/marine/marinepistol
	name = "M2445"
	desc = "A slightly bulky standard issue sidearm for Marines this weapon is a very reliable pistol with advanced firing mechanisms enabling it to fire without oxygen. Fires magnum rounds."
	icon_state = "MarinePistol"
	item_state = "MarinePistol"
	w_class = 3.0
	max_shells = 12
	caliber = ".45 magnum"
	origin_tech = "combat=6;materials=2"
	ammo_type = "/obj/item/ammo_casing/c45magnum"
	automatic = 1
	rangedrop = 0
	load_method = MAGAZINE
	isHandgun()
		return 1
	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/marinepistolmag/empty(src)
		update_icon()
		return
	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
			update_icon()
		return