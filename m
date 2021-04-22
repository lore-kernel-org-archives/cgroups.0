From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Thu, 22 Apr 2021 07:27:04 -0700
Message-ID: <CALvZod5dr8Uy84wJ5-a=zyR52_k5AU64GtFAsJpBRE89DEt-yg@mail.gmail.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <699e51ba-825d-b243-8205-4d8cff478a66@sony.com> <CALvZod7AEjzWa6AR4Ym1jpfzT32hmepxvci6hXvNJTEQvcQqEw@mail.gmail.com>
 <1f8d300b-9a8b-de09-6d5d-6a9c20c66d24@sony.com> <CALvZod5+5ycobmSt=NC3VJF4FRMFmBQEN7SQgipyTDbzHEbPUQ@mail.gmail.com>
 <6eaa4c24-c565-bc5d-dbca-b73c72569a16@sony.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YUbZYT4OBaB64X7LHgzjKFjOfvV90LK9Vn0x4eZD4WE=;
        b=m03NQBJsiIYmZLHNAhp0ZNgR6JE1hvKR6rXrXKgEbpcm/xxcVWpyWKSe4UJSSFoEA0
         6VERSKMt3H1owy6VkbUcLEpYa4p+4xzIUeG0QGSkO/4n+f5U0hQJcuEKfVa7RGzmuZDc
         gs1Qs8aNheTNoYmGGp+2vAbMg2xCCtRdzRMSlQaC5Fo28MNBGDgSyPMkwk6copXCONZy
         gohJAjVusy8MudtqtIcM1D/lHeYMhSVwV6qeQtp/AircejjDw5yUBk08fU3A2mZyrMX8
         LEUxOeNIb2m0yU9EvunJ87XnZGy56PrEY71VEgmDdl12YHu9jtL4MBtBenFNr+/I+XRy
         ev5w==
In-Reply-To: <6eaa4c24-c565-bc5d-dbca-b73c72569a16-7U/KSKJipcs@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peter enderborg <Peter.Enderborg-7U/KSKJipcs@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 21, 2021 at 10:39 PM <Peter.Enderborg-7U/KSKJipcs@public.gmane.org> wrote:
>
> On 4/21/21 9:18 PM, Shakeel Butt wrote:
> > On Wed, Apr 21, 2021 at 11:46 AM <Peter.Enderborg-7U/KSKJipcs@public.gmane.org> wrote:
> >> On 4/21/21 8:28 PM, Shakeel Butt wrote:
> >>> On Wed, Apr 21, 2021 at 10:06 AM peter enderborg
> >>> <peter.enderborg-7U/KSKJipcs@public.gmane.org> wrote:
> >>>> On 4/20/21 3:44 AM, Shakeel Butt wrote:
> >>> [...]
> >>>> I think this is the wrong way to go.
> >>> Which one? Are you talking about the kernel one? We already talked out
> >>> of that. To decide to OOM, we need to look at a very diverse set of
> >>> metrics and it seems like that would be very hard to do flexibly
> >>> inside the kernel.
> >> You dont need to decide to oom, but when oom occurs you
> >> can take a proper action.
> > No, we want the flexibility to decide when to oom-kill. Kernel is very
> > conservative in triggering the oom-kill.
>
> It wont do it for you. We use this code to solve that:

Sorry what do you mean by "It wont do it for you"?

[...]
> int __init lowmemorykiller_register_oom_notifier(void)
> {
>     register_oom_notifier(&lowmemorykiller_oom_nb);

This code is using oom_notify_list. That is only called when the
kernel has already decided to go for the oom-kill. My point was the
kernel is very conservative in deciding to trigger the oom-kill and
the applications can suffer for long. We already have solutions for
this issue in the form of userspace oom-killers (Android's lmkd and
Facebook's oomd) which monitors a diverse set of metrics to early
detect the application suffering and trigger SIGKILLs to release the
memory pressure on the system.

BTW with the userspace oom-killers, we would like to avoid the kernel
oom-killer and memory.swap.high has been introduced in the kernel for
that purpose.
