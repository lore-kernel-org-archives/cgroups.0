From: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Date: Tue, 19 Jan 2021 19:31:51 -0800
Message-ID: <CAOFY-A2C4=fWQB69rmP1Ff1Sh=NLCPKT1kD-Lpq29342YJvaWA@mail.gmail.com>
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
 <20210113184302.GA355124@carbon.dhcp.thefacebook.com> <CALvZod4V3M=P8_Z14asBG8bKa=mYic4_OPLeoz5M7J5tsx=Gug@mail.gmail.com>
 <CAHbLzkrqX9mJb0E_Y4Q76x=bZpg3RNxKa3k8cG_NiU+++1LWsQ@mail.gmail.com> <CALvZod4Ncf4H8VWgetWoRnOWPT4h+QDK_CY+oK11Q4akcs4Eqw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fdl7GPtsxeMh7s7EVrXO7P1C9iXb8ZW1ZclmtoYnKZY=;
        b=XRj0OR0yGsv+epSl7d7M4vSTDzOw8TE2P27nx2xkX1druNKB/zY1MLIhPX5bW6xzLD
         9gt4WvlLpPI2Z1J2sD18aHWuVfycYVSh/xRV0qIJClEPF/Fs1mNtP15zXbVLKzFC1e9K
         45o705TxRDXsjPcu12SPKb+4/0hp56TX2USuvEdw6bnS1dAbR2HhTGsf8elVBFPFKkJ0
         sWZ9SbFx/0guJ+yAHlvOGObJoBhPFVMMmZhIDFKy7zgegHpmlReufMXCd9ULz/FaelBU
         yO1xZKXX2wwPO5S9NaDeEUWiMMAycQ4BL2I3G6GpPwiK+S23Q4F4d8MZFA2YOlUFpGO4
         C6mw==
In-Reply-To: <CALvZod4Ncf4H8VWgetWoRnOWPT4h+QDK_CY+oK11Q4akcs4Eqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jan 13, 2021 at 11:55 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Jan 13, 2021 at 11:49 AM Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Wed, Jan 13, 2021 at 11:13 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Wed, Jan 13, 2021 at 10:43 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > > >
> > > > On Tue, Jan 12, 2021 at 04:18:44PM -0800, Shakeel Butt wrote:
> > > > > On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > >
> > > > > > On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > > > > > >
> > > > > [snip]
> > > > > > > Historically we have a corresponding vmstat counter to each charged page.
> > > > > > > It helps with finding accounting/stastistics issues: we can check that
> > > > > > > memory.current ~= anon + file + sock + slab + percpu + stack.
> > > > > > > It would be nice to preserve such ability.
> > > > > > >
> > > > > >
> > > > > > Perhaps one option would be to have it count as a file page, or have a
> > > > > > new category.
> > > > > >
> > > > >
> > > > > Oh these are actually already accounted for in NR_FILE_MAPPED.
> > > >
> > > > Well, it's confusing. Can't we fix this by looking at the new page memcg flag?
> > >
> > > Yes we can. I am inclined more towards just using NR_FILE_PAGES (as
> > > Arjun suggested) instead of adding a new metric.
> >
> > IMHO I tend to agree with Roman, it sounds confusing. I'm not sure how
> > people relies on the counter to have ballpark estimation about the
> > amount of reclaimable memory for specific memcg, but they are
> > unreclaimable. And, I don't think they are accounted to
> > NR_ACTIVE_FILE/NR_INACTIVE_FILE, right? So, the disparity between
> > NR_FILE_PAGES and NR_{IN}ACTIVE_FILE may be confusing either.
> >
>
> Please note that due to shmem/tmpfs there is already disparity between
> NR_FILE_PAGES and NR_{IN}ACTIVE_FILE.
>
> BTW I don't have a strong opinion against adding a new metric. If
> there is consensus we can add one.

Just wanted to see if there were any thoughts/consensus on what the
best way to proceed is - should there be a v2 patch with specific
changes? Or is NR_FILE_PAGES alright?

And similar query, for pre-charging vs. post charging.

Thanks,
-Arjun
