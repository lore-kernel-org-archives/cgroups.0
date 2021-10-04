From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup-v1: Grant CAP_SYS_NICE holders permission to
 move tasks between cgroups
Date: Mon, 4 Oct 2021 10:23:59 -0700
Message-ID: <CALAqxLV-tOgBMAWd36sg+bh3s0XXqKWD+P-CYgVXf7Won4auAA@mail.gmail.com>
References: <20210617090941.340135-1-lee.jones@linaro.org> <YMs08Ij8PZ/gemLL@slm.duckdns.org>
 <YMs5ssb50B208Aad@dell> <CAJuCfpHvRuapSMa2KMdF4_-8fKdqtx_gYVKyw5dYT6XjfRrDfg@mail.gmail.com>
 <YVsuw+UBZDY6Rkzd@slm.duckdns.org> <CAJuCfpHprdJWpR_HPSVm6DFEOJj4RWmWC10=ZdGYF_JFAvV+_g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kEcLDwK9m1057jui6AApVi77iUKrt1BBHKk+cl8sBwg=;
        b=TnB++IRae/jo7gqmQjvRKcHMHKTEqCZDZphTfi5vqyHYACWjXUvpjyPRFMIh9KZN4I
         WnSWO3bAsjSUNczaIep4vUgkrW4Xkc2ZKwYP9nvihsSLiG2BAOx8GhVX9b6/+iiS0tFH
         k0r5k6pUly5KokxDk1+787vNZJfhPAsJHdfl2BFuxeaST/d+CUl2KLhb51OQxSLZYfD2
         pjjuWIBmQsmt3Ohu1veqNZMuquHHpjwDPqYrnVG9FfFe7XhCnvRQCLFCQI6HDiAOcJXc
         tf2e/QLDCOpEgcy6ghQvYIWqFc6qRvU5YXWA5oML13c00Wf4o9ga0BnaVrt40rNS7YOk
         OjNQ==
In-Reply-To: <CAJuCfpHprdJWpR_HPSVm6DFEOJj4RWmWC10=ZdGYF_JFAvV+_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Oct 4, 2021 at 9:57 AM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Oct 4, 2021 at 9:41 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Thu, Sep 30, 2021 at 02:20:53PM -0700, Suren Baghdasaryan wrote:
> > > Some of the controllers are moving to cgroup v2 but not all of them
> > > are there yet. For example, there are still some issues with moving
> > > the cpu controller to v2 which I believe were discussed during Android
> > > Microconference at LPC 2021.
> >
> > Care to provide a summary?
>
> Unfortunately I could not be present at LPC this year but Wei I
> believe was the presenter (CC'ing him).
> Wei, could you please summarize the issues with moving the cpu
> controller to cgroups v2?

Tejun: We were sorry you didn't join as we were hoping for your
attendance for the discussion!

For reference, here's the video of the session:
  https://www.youtube.com/watch?v=O_lCFGinFPM&t=2941s

And continued discussion from the BoF:
  https://youtu.be/i5BdYn6SNQc?t=703

But Wei can still chime in with a more focused summary, maybe?


> Also CC'ing John, who I believe tried to upstream this patch before.

We sort of went in a big circle of creating a config time option w/
CAP_SYS_NICE, then a new CAP_CGROUP_MIGRATE then switching to
CAP_SYS_RESOURCE and then back to CAP_CGROUP_MIGRATE, and when that
was panned I gave up and we kept the small patch in the Android tree
that uses CAP_SYS_NICE.

Links to previous attempts & discussion:
v1: https://lore.kernel.org/lkml/1475556090-6278-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org/#t
v2: https://lore.kernel.org/lkml/1476743724-9104-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org/
v4: https://lore.kernel.org/lkml/1478647728-30357-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org/
v5: https://lore.kernel.org/lkml/1481593143-18756-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org/

thanks
-john
