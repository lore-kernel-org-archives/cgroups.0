From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] mm: memcg: fix tracking of pending stats updates values
Date: Mon, 25 Sep 2023 10:11:05 -0700
Message-ID: <CAJD7tkbWz7mx6mUrvFQHP10ncqL-iVwD4ymHTm=oXW5qGgrZtA@mail.gmail.com>
References: <20230922175741.635002-1-yosryahmed@google.com> <ZRGQIhWF02SRzN4D@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695661904; x=1696266704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/hhWT30YqLg2rKDYw/SVPqxcdoluiD8cyVoB8LNRKU=;
        b=BhbFLIYhbToxGSyNhmIR8RyXG8uDpP3SL/ihsVdl2fCTdoC/u3JkUu3jFcM8J9LOVR
         D0IwmB8UB5VHnsFDTQ/cmCpvDwBTgJYK0ZhOno12xXmA8s+MK6OPB5D848e5PNSElx+Y
         ptjSZDGTj7fx91tqgAz2vP1Di68wx5SYSOb/4blCBoY2M1w5lHoYqTQtvPHuolmbHfw1
         BIApqzBaC/dLNjPS4UWVoNmjwOW7XC8tZjQj3Or/ADiCk/S5wezNBFfMEPRQqDu35vL0
         mxxfPQpvZCylecGQZi+WKUyq2/9L+Tp6TVjNMwE+h50ji7lwrUuLuDKFIsetsQ90Me+e
         nADg==
In-Reply-To: <ZRGQIhWF02SRzN4D-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 25, 2023 at 6:50=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Fri 22-09-23 17:57:38, Yosry Ahmed wrote:
> > While working on adjacent code [1], I realized that the values passed
> > into memcg_rstat_updated() to keep track of the magnitude of pending
> > updates is consistent. It is mostly in pages, but sometimes it can be i=
n
> > bytes or KBs. Fix that.
>
> What kind of practical difference does this change make? Is it worth
> additional code?

As explained in patch 2's commit message, the value passed into
memcg_rstat_updated() is used for the "flush only if not worth it"
heuristic. As we have discussed in different threads in the past few
weeks, unnecessary flushes can cause increased global lock contention
and/or latency.

Byte-sized paths (percpu, slab, zswap, ..) feed bytes into the
heuristic, but those are interpreted as pages, which means we will
flush earlier than we should. This was noticed by code inspection. How
much does this matter in practice? I would say it depends on the
workload: how many percpu/slab allocations are being made vs. how many
flushes are requested.

On a system with 100 cpus, 25M of stat updates are needed for a flush
usually, but ~6K of slab/percpu updates will also (mistakenly) cause a
flush.

>
> > Patch 1 reworks memcg_page_state_unit() so that we can reuse it in patc=
h
> > 2 to check and normalize the units of state updates.
> >
> > [1]https://lore.kernel.org/lkml/20230921081057.3440885-1-yosryahmed@goo=
gle.com/
> >
> > v1 -> v2:
> > - Rebased on top of mm-unstable.
> >
> > Yosry Ahmed (2):
> >   mm: memcg: refactor page state unit helpers
> >   mm: memcg: normalize the value passed into memcg_rstat_updated()
> >
> >  mm/memcontrol.c | 64 +++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 51 insertions(+), 13 deletions(-)
> >
> > --
> > 2.42.0.515.g380fc7ccd1-goog
>
> --
> Michal Hocko
> SUSE Labs
