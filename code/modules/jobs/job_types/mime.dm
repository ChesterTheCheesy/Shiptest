/datum/job/mime
	name = "Mime"
	wiki_page = "Mime" //WS Edit - Wikilinks/Warning

	outfit = /datum/outfit/job/mime

	access = list(ACCESS_THEATRE)
	minimal_access = list(ACCESS_THEATRE)

	display_order = JOB_DISPLAY_ORDER_MIME

/datum/job/mime/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	H.apply_pref_name("mime", M.client)

/datum/outfit/job/mime
	name = "Mime"
	job_icon = "mime"
	jobtype = /datum/job/mime

	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/mime
	alt_uniform = /obj/item/clothing/under/rank/civilian/mime/sexy //WS Edit - Alt Uniforms
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/color/white
	head = /obj/item/clothing/head/frenchberet
	suit = /obj/item/clothing/suit/toggle/suspenders
	backpack_contents = list(
		/obj/item/book/mimery = 1,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing = 1
		)

	backpack = /obj/item/storage/backpack/mime
	satchel = /obj/item/storage/backpack/mime

/datum/outfit/job/mime/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/mime/speak(null))
		H.mind.miming = TRUE

	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.add_hud_to(H)

/obj/item/book/mimery
	name = "Guide to Dank Mimery"
	desc = "A primer on basic pantomime."
	icon_state ="bookmime"

/obj/item/book/mimery/attack_self(mob/user,)
	user.set_machine(src)
	var/dat = "<B>Guide to Dank Mimery</B><BR>"
	dat += "Teaches one of three classic pantomime routines, allowing a practiced mime to conjure invisible objects into corporeal existence.<BR>"
	dat += "Once you have mastered your routine, this book will have no more to say to you.<BR>"
	dat += "<HR>"
	dat += "<A href='byond://?src=[REF(src)];invisible_wall=1'>Invisible Wall</A><BR>"
	dat += "<A href='byond://?src=[REF(src)];invisible_chair=1'>Invisible Chair</A><BR>"
	dat += "<A href='byond://?src=[REF(src)];invisible_box=1'>Invisible Box</A><BR>"
	user << browse(dat, "window=book")

/obj/item/book/mimery/Topic(href, href_list)
	..()
	if (usr.stat || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED) || src.loc != usr)
		return
	if (!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.is_holding(src) && H.mind)
		H.set_machine(src)
		if (href_list["invisible_wall"])
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall(null))
		if (href_list["invisible_chair"])
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair(null))
		if (href_list["invisible_box"])
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_box(null))
	to_chat(usr, span_notice("The book disappears into thin air."))
	qdel(src)
