From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Wed, 21 Apr 2021 11:28:38 -0700
Message-ID: <CALvZod7AEjzWa6AR4Ym1jpfzT32hmepxvci6hXvNJTEQvcQqEw@mail.gmail.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <699e51ba-825d-b243-8205-4d8cff478a66@sony.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a3pKNRpAYonIhJIPLG+pbIg/iVXk4BkHo5q1/p/dOgo=;
        b=AAoUTPD7oBRut/ALdKm+tPO6jlrcqGZAJSsoMj8iGEp6Zg/YqD6yGfx1Yxi3bpHRcC
         6siZpF6fb7tuWkT2EQdMnCumN2CMDnOPzmvpYcF5S431ORvspnkulpHEa/t3mERwZHmG
         7n3krkLX85vE9LhJodHreS7aSegTTQ/WxNpSKGKsxY71e1fntE2ffpomx7mY2GomwzyC
         Fn/HKakuhmUzJhMig93Y0mlLSeVwDWqQW1R2IcjuZ2uEzJLnTN1ZOJ46woQnyDOezz0w
         8orZmdhMXW7tHjrcFjkfhhtVhtnhc4W9irW2IzCsysbkc4u1Eo89TJanvCB8v4SRoloM
         rKvw==
In-Reply-To: <699e51ba-825d-b243-8205-4d8cff478a66-7U/KSKJipcs@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peter enderborg <peter.enderborg-7U/KSKJipcs@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 21, 2021 at 10:06 AM peter enderborg
<peter.enderborg-7U/KSKJipcs@public.gmane.org> wrote:
>
> On 4/20/21 3:44 AM, Shakeel Butt wrote:
[...]
>
> I think this is the wrong way to go.

Which one? Are you talking about the kernel one? We already talked out
of that. To decide to OOM, we need to look at a very diverse set of
metrics and it seems like that would be very hard to do flexibly
inside the kernel.

>
> I sent a patch for android lowmemorykiller some years ago.
>
> http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2017-February/100319.html
>
> It has been improved since than, so it can act handle oom callbacks, it can act on vmpressure and psi
> and as a shrinker. The patches has not been ported to resent kernels though.
>
> I don't think vmpressure and psi is that relevant now. (They are what userspace act on)  But the basic idea is to have a priority queue
> within the kernel. It need pick up new processes and dying process.  And then it has a order, and that
> is set with oom adj values by activity manager in android.  I see this model can be reused for
> something that is between a standard oom and userspace.  Instead of vmpressure and psi
> a watchdog might be a better way.  If userspace (in android the activity manager or lmkd) does not kick the watchdog,
> the watchdog bite the task according to the priority and kills it.  This priority list does not have to be a list generated
> within kernel. But it has the advantage that you inherent parents properties.  We use a rb-tree for that.
>
> All that is missing is the watchdog.
>

Actually no. It is missing the flexibility to monitor metrics which a
user care and based on which they decide to trigger oom-kill. Not sure
how will watchdog replace psi/vmpressure? Userspace keeps petting the
watchdog does not mean that system is not suffering.

In addition oom priorities change dynamically and changing it in your
system seems very hard. Cgroup awareness is missing too.

Anyways, there are already widely deployed userspace oom-killer
solutions (lmkd, oomd). I am aiming to further improve the
reliability.
