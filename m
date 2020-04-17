From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: folding CONFIG_MEMCG_SWAP as default
Date: Fri, 17 Apr 2020 10:35:53 -0700
Message-ID: <CALvZod5DT-2TB-6KFZshmSt=wq+jg5+b5aAsWequP8zxs+tMpQ@mail.gmail.com>
References: <1587134624-184860-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200417155317.GS26707@dhcp22.suse.cz> <CALvZod7Xa4Xs=7zC8OZ7GOfvfDBv+yNbGCzBxeoMgAeRGRtw0A@mail.gmail.com>
 <20200417165442.GT26707@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hg6IIRdiW7K53TeUTBkQvnSYbhXlq293hVwvftTtBpY=;
        b=Vwy15InWoEv70r74M82Y4LbZS+npes2VXDKaQjvNzJCyqXXde6NHxQmepyDO1vO1Ed
         QDNopRM8cYIGGVlIEjKd+dGyO5LuF1d+Q2N/vxATnmmxvpcx+M0krPVJ1FqlJ7cqNwKo
         abPmzqwu2buigwodzTtOZwOtMqDaU+rl6ytqqrGgQCavM2QpTg5jlHsA4MT8wIDgkznQ
         JW2QXCTMfMZAsl8/CeoVzsVwyLAzmmoN1DUqVnO9Xr2rEQjGt+dDHagHVSfVGsFNJCTC
         n2/DA4IBZ9iunwXNNtnrGUlBMZeYdzqgKOc97c2kAxzVrGkAkc9ui2UYAmYpuHqRWJpF
         UdGw==
In-Reply-To: <20200417165442.GT26707-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Apr 17, 2020 at 9:54 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri 17-04-20 09:41:04, Shakeel Butt wrote:
> > On Fri, Apr 17, 2020 at 9:03 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Fri 17-04-20 22:43:43, Alex Shi wrote:
> > > > This patch fold MEMCG_SWAP feature into kernel as default function. That
> > > > required a short size memcg id for each of page. As Johannes mentioned
> > > >
> > > > "the overhead of tracking is tiny - 512k per G of swap (0.04%).'
> > > >
> > > > So all swapout page could be tracked for its memcg id.
> > >
> > > I am perfectly OK with dropping the CONFIG_MEMCG_SWAP. The code that is
> > > guarded by it is negligible and the resulting code is much easier to
> > > read so no objection on that front. I just do not really see any real
> > > reason to flip the default for cgroup v1. Why do we want/need that?
> > >
> >
> > Yes, the changelog is lacking the motivation of this change. This is
> > proposed by Johannes and I was actually expecting the patch from him.
> > The motivation is to make the things simpler for per-memcg LRU locking
> > and workingset for anon memory (Johannes has described these really
> > well, lemme find the email). If we keep the differentiation between
> > cgroup v1 and v2, then there is actually no point of this cleanup as
> > per-memcg LRU locking and anon workingset still has to handle the
> > !do_swap_account case.
>
> All those details really have to go into the changelog. I have to say
> that I still do not understand why the actual accounting swap or not
> makes any difference for per per-memcg LRU.

Here is Johannes explanation:
https://lore.kernel.org/linux-mm/20200413180725.GA99267-druUgvl0LCNAfugRpC6u6w@public.gmane.org/

> Especially when your patch

You mean Alex's patch.

> keeps the kernel command line parameter still in place.
>
> Anyway, it would be much more simpler to have a patch that drops the
> CONFIG_MEMCG_SWAP and a separate one which switches the default
> beahvior. I am not saying I am ok with the later but if the
> justification is convincing then I might change my mind.
> --
> Michal Hocko
> SUSE Labs
