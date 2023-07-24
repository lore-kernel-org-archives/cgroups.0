From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: use rstat for non-hierarchical stats
Date: Mon, 24 Jul 2023 11:34:13 -0700
Message-ID: <CAJD7tkYPr7wsxX9uy7VdL0P4UL=OQWtryKzxcevK8Ja19jbaOg@mail.gmail.com>
References: <20230719174613.3062124-1-yosryahmed@google.com> <20230724113104.6994bd471fb926ceeaf46707@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690223690; x=1690828490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHsSjCzPEu8aIR0EiXrFcnff9X89cuZKlKes/xQyYu4=;
        b=tgJjvbb8fbr4lsjCqG6AjX4CmhOF8BSm7LMTX8UnAu+pO48JGry6u+EknbBFqthu35
         YuLb16ZhBdCfECepHRAACWWL63o2gq9/l0HmXEWAx52uuTkb175nx9DfYQbNGbivylFg
         8GMxtUduFz/VbJuOBPg6gl76EqxGhi7nkt0UgtFWdUkfpx6l+jvy6+AFVLexMgR0OdmO
         pryO0K1ssC1Fditn9CU8HNxmis5RUgMd//HRjjv4ZORGSlZve6Vnh+dC0VqJy5/cx4Dr
         t2S6Z+tc1Q9scwxfvVnl+yfOEF2RgbKrDiwN4JCAZVwAN/G/P1W9vEGjkCcLFY0T0Rbx
         LJ7g==
In-Reply-To: <20230724113104.6994bd471fb926ceeaf46707-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Jul 24, 2023 at 11:31=E2=80=AFAM Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Wed, 19 Jul 2023 17:46:13 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wr=
ote:
>
> > Currently, memcg uses rstat to maintain hierarchical stats. The rstat
> > framework keeps track of which cgroups have updates on which cpus.
> >
> > For non-hierarchical stats, as memcg moved to rstat, they are no longer
> > readily available as counters. Instead, the percpu counters for a given
> > stat need to be summed to get the non-hierarchical stat value. This
> > causes a performance regression when reading non-hierarchical stats on
> > kernels where memcg moved to using rstat. This is especially visible
> > when reading memory.stat on cgroup v1. There are also some code paths
> > internal to the kernel that read such non-hierarchical stats.
> >
> > It is inefficient to iterate and sum counters in all cpus when the rsta=
t
> > framework knows exactly when a percpu counter has an update. Instead,
> > maintain cpu-aggregated non-hierarchical counters for each stat. During
> > an rstat flush, keep those updated as well. When reading
> > non-hierarchical stats, we no longer need to iterate cpus, we just need
> > to read the maintainer counters, similar to hierarchical stats.
> >
> > A caveat is that we now a stats flush before reading
> > local/non-hierarchical stats through {memcg/lruvec}_page_state_local()
> > or memcg_events_local(), where we previously only needed a flush to
> > read hierarchical stats. Most contexts reading non-hierarchical stats
> > are already doing a flush, add a flush to the only missing context in
> > count_shadow_nodes().
> >
> > With this patch, reading memory.stat from 1000 memcgs is 3x faster on a
> > machine with 256 cpus on cgroup v1:
> >  # for i in $(seq 1000); do mkdir /sys/fs/cgroup/memory/cg$i; done
> >  # time cat /dev/cgroup/memory/cg*/memory.stat > /dev/null
> >  real  0m0.125s
> >  user  0m0.005s
> >  sys   0m0.120s
> >
> > After:
> >  real  0m0.032s
> >  user  0m0.005s
> >  sys   0m0.027s
> >
>
> I'll queue this for some testing, pending reviewer input, please.

Thanks Andrew!

I am doing extra testing of my own as well as of now. Will report back
if anything interesting pops up.
