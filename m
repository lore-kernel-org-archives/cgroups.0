From: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Getting notifications of the tasks file
Date: Tue, 7 Aug 2012 19:33:02 +0800
Message-ID: <CAC8teKU92-+XecOgTzeD7kt4VfKREqtOoih-qpvMSMt77Qextg@mail.gmail.com>
References: <5486539.IgfTNnpt1m@valencia>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        bh=6vcm3GVXhQ7lTfQgNIa2XfRic+ea83YWV422sDXqaao=;
        b=hQpe34hEViKNolg/bmzNZF94EJXV5v/KuGHnbpZOlo0R2rKNhRQxkoLSHQD+0/MKYE
         EhKfsnV6c2hxEFwaLXpdMrQuijQfZLsGhkO6YOrgo0gO2Kuev2wX984CbSvVYvINouTw
         0vcjVvM5P8oHvFBUDzbkhiEP5eYRytM8+6Jzp5AV1qANDZfWa3zrqARsqQrGzZBNDgU3
         aSx09dvR/edao7g3vMdtuFMkykAqiIMQq77ImQqL3DdUKVuNIMk8ZSqed9psCHQmFSeU
         T8uJf3+NuASl2Smmf38HNsz/UABKkKp3MnCbpuTO/YORpcFOn6kuMEjMGXrtrlPcJW3T
         bvDQ==
In-Reply-To: <5486539.IgfTNnpt1m@valencia>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?VsOtY3RvciBGZXJuw6FuZGV6IE1hcnTDrW5leg==?= <vfernandez-JE8hqn47KVKB+jHODAdFcQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Did you try inotify() ?

-zyh

2012/7/31 V=C3=ADctor Fern=C3=A1ndez Mart=C3=ADnez <vfernandez@barracud=
a.com>:
> I'm trying to use the eventfd notification API to get notified when t=
he tasks
> file changes. This way I would like to know when child processes are =
spawned
> and when they exit. However, I always get EINVAL when writing to
> cgroup.event_control. Even cgroup_event_listener.c returns that error=
:
>
> # cat /sys/fs/cgroup/memory/grp0/tasks
> 3590
> 23902
> # ./cgroup_event_listener /sys/fs/cgroup/memory/grp0/tasks 0
> Cannot write to cgroup.event_control: Invalid argument
>
> I have also tried to monitor cgroup.procs.
>
> Is it possible to monitor the tasks file at all or is this a bug? If =
0 is a
> wrong argument, which argument should I use instead?
>
>
> Thanks.
>
>
> Barracuda Networks AG
> Vorsitzender des Aufsichtsrates/ Chairman of the supervisory board: D=
ean Drako
> Vorstand/ Executive Board: Dr. Wieland Alge, Mag. Guenter Klausner
> Sitz der Gesellschaft/ Registered office: 6020 Innsbruck, Austria
> Handelsgericht Innsbruck Firmenbuch/ Registration Number: 184392s
> UID-Nr/ VAT Number: ATU47509003
>
> Diese Nachricht und allfaellige angehaengte Dokumente sind vertraulic=
h und nur fuer den/die Adressaten bestimmt. Sollten Sie nicht der beabs=
ichtigte Adressat sein, ist jede Offenlegung, Weiterleitung oder sonsti=
ge Verwendung dieser Information nicht gestattet. In diesem Fall bitten=
 wir, den Absender zu verstaendigen und die Information zu vernichten. =
=46uer Uebermittlungsfehler oder sonstige Irrtuemer bei Uebermittlung b=
esteht keine Haftung.
>
> This message and any attached files are confidential and intended sol=
ely for the addressee(s). Any publication, transmission or other use of=
 the information by a person or entity other than the intended addresse=
e is prohibited. If you receive this in error please contact the sender=
 and delete the material. The sender does not accept liability for any =
errors or omissions as a result of the transmission.
>
>
> 'Like' us on Facebook for exclusive content and other resources on al=
l Barracuda Networks solutions.
> Visit http://barracudanetworks.com/facebook
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
