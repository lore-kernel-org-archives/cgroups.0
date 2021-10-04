From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup-v1: Grant CAP_SYS_NICE holders permission to
 move tasks between cgroups
Date: Mon, 4 Oct 2021 09:57:07 -0700
Message-ID: <CAJuCfpHprdJWpR_HPSVm6DFEOJj4RWmWC10=ZdGYF_JFAvV+_g@mail.gmail.com>
References: <20210617090941.340135-1-lee.jones@linaro.org> <YMs08Ij8PZ/gemLL@slm.duckdns.org>
 <YMs5ssb50B208Aad@dell> <CAJuCfpHvRuapSMa2KMdF4_-8fKdqtx_gYVKyw5dYT6XjfRrDfg@mail.gmail.com>
 <YVsuw+UBZDY6Rkzd@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=25uBBIA1tJtjRBCrl2+9kZTZSoh3JSnwsuWmdRiH3hw=;
        b=sMaFKtZMy7Lb9v6s8A+fwAAgVLAYKBFj8zIFXbpoSpe+u1jxti9e3ls2YLh1M81V2e
         DxUta+jM+Eq0qo+mwhMsFbOi8O0IYr9vy0WFpgx4Gu3hmdkHsV1Wa4rNGtVUs3m4yzPX
         G8UX9dKhmcywIZr+XjuRX9/jicCUTq5Hdl+vvxm/Ca01CcyAQukkssL9md+12MIz0Q+S
         rb9jFkGZXowUv6BulYMFgzJpx6X8AU8hJv1Ipj7MQPom24gfewwUnA0oN0xOe9LIHimZ
         fSen5G5BLL0QMQ1/taR3zAaqEWn80368BNU4vX87L3ru4KNPekwk5BsLaF6H7H1rKsWs
         xRxQ==
In-Reply-To: <YVsuw+UBZDY6Rkzd-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On Mon, Oct 4, 2021 at 9:41 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Thu, Sep 30, 2021 at 02:20:53PM -0700, Suren Baghdasaryan wrote:
> > Some of the controllers are moving to cgroup v2 but not all of them
> > are there yet. For example, there are still some issues with moving
> > the cpu controller to v2 which I believe were discussed during Android
> > Microconference at LPC 2021.
>
> Care to provide a summary?

Unfortunately I could not be present at LPC this year but Wei I
believe was the presenter (CC'ing him).
Wei, could you please summarize the issues with moving the cpu
controller to cgroups v2?
Also CC'ing John, who I believe tried to upstream this patch before.
Thanks,
Suren.


>
> Thanks.
>
> --
> tejun
