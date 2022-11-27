--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


-- Thanks https://steamcommunity.com/id/Lord_Junes
Translates.German = {
    -- Magnet
    {
        Building = Buildings.MagnetCrude,
        Name = "Magnet",
        Description = "Zieht %d/s Objekt(e) an.\nZieht Bereich %dx%d an.\nEnthält Bereich: {L,T;R,B}",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },
    {
        Building = Buildings.MagnetGood, Name = "Guter magnet",
        Description = "Zieht %d/s Objekt(e) an. Der Einzugsbereich %dx%d.\nEnthält den Einzugsbereich: {L,T;R,B}",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },
    {
        Building = Buildings.MagnetSuper, Name = "Super magnet",
        Description = "Zieht %d/s Objekt(e) an. Der Einzugsbereich %dx%d.\nEnthält den Einzugsbereich: {L,T;R,B}",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },

    -- Pump
    {
        Building = Buildings.PumpCrude,
        Name = "Pumpe",
        Description = "Transportiert Objekte.",
    },
    {
        Building = Buildings.PumpGood,
        Name = "Gute Pumpe",
        Description = "Transportiert Objekte.",
    },
    {
        Building = Buildings.PumpSuper,
        Name = "Super Pumpe",
        Description = "Transportiert Objekte.",
    },
    {
        Building = Buildings.PumpSuperLong,
        Name = "Super Pumpe - lang",
        Description = "Transportiert Objekte.",
    },

    -- Overflow Pump
    {
        Building = Buildings.OverflowPumpCrude,
        Name = "Überlaufpumpe",
        Description = "Überlädt Objekte, wenn die Quelle überläuft.",
    },
    {
        Building = Buildings.OverflowPumpGood,
        Name = "Eine gute Überlaufpumpe",
        Description = "Überlädt Objekte, wenn die Quelle überläuft.",
    },
    {
        Building = Buildings.OverflowPumpSuper,
        Name = "Super Überlaufpumpe",
        Description = "Überlädt Objekte, wenn die Quelle überläuft.",
    },

    -- Balancer
    {
        Building = Buildings.BalancerCrude,
        Name = "Ausgleichspumpe",
        Description = "Balanciert Objekte nach Anzahl.",
    },
    {
        Building = Buildings.BalancerGood,
        Name = "Gute Ausgleichspumpe",
        Description = "Balanciert Objekte nach Anzahl.",
    },
    {
        Building = Buildings.BalancerSuper,
        Name = "Super Ausgleichspumpe",
        Description = "Balanciert Objekte nach Anzahl.",
    },
    {
        Building = Buildings.BalancerSuperLong,
        Name = "Super Ausgleichspumpe - Lang",
        Description = "Balanciert Objekte nach Anzahl.",
    },

    -- Transmitter    
    {
        Building = Buildings.TransmitterCrude,
        Name = "Sender",
        Description = "Sendet die Objekte an den Empfänger. Geschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.TransmitterGood,
        Name = "Guter Sender",
        Description = "Sendet die Objekte an den Empfänger. Geschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.TransmitterSuper,
        Name = "Super Sender",
        Description = "Sendet die Objekte an den Empfänger. Geschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },

    -- Receiver
    {
        Building = Buildings.ReceiverCrude,
        Name = "Empfänger",
        Description = "Empfängt die Objekte vom Absender.\nGeschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.ReceiverGood,
        Name = "Guter Empfänger",
        Description = "Empfängt die Objekte vom Absender.\nGeschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.ReceiverSuper,
        Name = "Super Empfänger",
        Description = "Empfängt die Objekte vom Absender.\nGeschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },

    -- Switch
    {
        Building = Buildings.SwitchSuper,
        Name = "Umschalttafel",
        Description = "Deaktiviert die Objektlogik.\nGruppennamen: \"[GroupName]\".",
    },

    -- Extractor
    {
        Building = Buildings.Extractor,
        Name = "Extraktor",
        Description = "Ruft ein Objekt aus dem Speicher ab.",
    },

    -- Inspector
    {
        Building = Buildings.Inspector,
        Name = "Inspektor",
        Description = "Prüft die Objekte im Bereich und deaktiviert die Gruppenlogik.\nGruppennamen: \"[GroupName]\".",
    },
}