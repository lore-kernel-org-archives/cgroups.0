From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Wed, 21 Apr 2021 12:18:22 -0700
Message-ID: <CALvZod5+5ycobmSt=NC3VJF4FRMFmBQEN7SQgipyTDbzHEbPUQ@mail.gmail.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <699e51ba-825d-b243-8205-4d8cff478a66@sony.com> <CALvZod7AEjzWa6AR4Ym1jpfzT32hmepxvci6hXvNJTEQvcQqEw@mail.gmail.com>
 <1f8d300b-9a8b-de09-6d5d-6a9c20c66d24@sony.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=50kzeCPGjm2JMXyK7PkTEiD0mm3C2OtO1PpsOLUYSss=;
        b=T5uVrfbF8qU1G524RKlJRFgst7C0N8b4H2i02+jwmhpvtNGQJmtRwATMQyisjPGKwT
         gsYjxwjD/BmmQlIvAf37RXRIKswGX+Hv5IHJWeJIGmVhisndacaJ5qoPcN/oMkAWKI2K
         rXoWb3LP/jKJJcJoTQxXEwTnmALDSCLAr8aF4kENjxcOQsR1FiyM3YpiQEEA+/MirhaW
         +P/0OecI6/mj//o2QV4f3/hm4ceifXZNLLqS/ltvN0Gkvy/DDlCZBBrWKzInmGXh+DJB
         lq2C30XJHf5e6QSu2w8xVzy48r71MroUUoeyLBA+TWWQtRq16jzncXwVIx0S3LBgkBnU
         pXTA==
In-Reply-To: <1f8d300b-9a8b-de09-6d5d-6a9c20c66d24-7U/KSKJipcs@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peter enderborg <Peter.Enderborg-7U/KSKJipcs@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 21, 2021 at 11:46 AM <Peter.Enderborg-7U/KSKJipcs@public.gmane.org> wrote:
>
> On 4/21/21 8:28 PM, Shakeel Butt wrote:
> > On Wed, Apr 21, 2021 at 10:06 AM peter enderborg
> > <peter.enderborg-7U/KSKJipcs@public.gmane.org> wrote:
> >> On 4/20/21 3:44 AM, Shakeel Butt wrote:
> > [...]
> >> I think this is the wrong way to go.
> > Which one? Are you talking about the kernel one? We already talked out
> > of that. To decide to OOM, we need to look at a very diverse set of
> > metrics and it seems like that would be very hard to do flexibly
> > inside the kernel.
> You dont need to decide to oom, but when oom occurs you
> can take a proper action.

No, we want the flexibility to decide when to oom-kill. Kernel is very
conservative in triggering the oom-kill.

> >
[...]
> > Actually no. It is missing the flexibility to monitor metrics which a
> > user care and based on which they decide to trigger oom-kill. Not sure
> > how will watchdog replace psi/vmpressure? Userspace keeps petting the
> > watchdog does not mean that system is not suffering.
>
> The userspace should very much do what it do. But when it
> does not do what it should do, including kick the WD. Then
> the kernel kicks in and kill a pre defined process or as many
> as needed until the monitoring can start to kick and have the
> control.
>

Roman already suggested something similar (i.e. oom-killer core and
extended and core watching extended) but completely in userspace. I
don't see why we would want to do that in the kernel instead.

> >
> > In addition oom priorities change dynamically and changing it in your
> > system seems very hard. Cgroup awareness is missing too.
>
> Why is that hard? Moving a object in a rb-tree is as good it get.
>

It is a group of objects. Anyways that is implementation detail.

The message I got from this exchange is that we can have a watchdog
(userspace or kernel) to further improve the reliability of userspace
oom-killers.
