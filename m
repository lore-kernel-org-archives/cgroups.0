From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] mm: memcg: use rstat for non-hierarchical stats
Date: Tue, 1 Aug 2023 09:39:36 -0700
Message-ID: <CAJD7tkbb8AWR-duWb+at-S9MMz48b0JqnM+b5ok83TzvXvPb+A@mail.gmail.com>
References: <20230726153223.821757-1-yosryahmed@google.com>
 <20230726153223.821757-2-yosryahmed@google.com> <ZMkXDuwD8RFRKnNQ@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690908013; x=1691512813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qjFUw6+lEzkCCKqkbY3T91pufwJOps9NprX6UVn+h8=;
        b=p6fiXJVO6VAT7ddDlyeNeKo0u9g75XBshHTDYQkWpxGEUOGoOVAa7lHgsGvQZ5v/+W
         OL8o5krg+sbCk3k/ILPv5kJcGtc7Hl7e/Ptk68GNbUYDFS1ZLOXSdMFbtMgISIwiBvXM
         xA5PCRA4fUyBY1hNJB6x57RpX4pHwvLO70MzF7vtOTGutOLMa2G02e6PwMjrWoV32oEH
         b6YlMDU2PYjQiFSB63POIJeR3bgDccie71bMuCrG1M0DF1oPPZLzqfczUjMBmkdzgXbl
         zrQDN3zGYffW49VbgVfFPFSdFMhkF99msYQ0hnralZcPwwvzI8CmOTzVDqdh+UFOFJjq
         Lm5Q==
In-Reply-To: <ZMkXDuwD8RFRKnNQ-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Aug 1, 2023 at 7:30=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> On Wed 26-07-23 15:32:23, Yosry Ahmed wrote:
> > Currently, memcg uses rstat to maintain aggregated hierarchical stats.
> > Counters are maintained for hierarchical stats at each memcg. Rstat
> > tracks which cgroups have updates on which cpus to keep those counters
> > fresh on the read-side.
> >
> > Non-hierarchical stats are currently not covered by rstat. Their
> > per-cpu counters are summed up on every read, which is expensive.
> > The original implementation did the same. At some point before rstat,
> > non-hierarchical aggregated counters were introduced by
> > commit a983b5ebee57 ("mm: memcontrol: fix excessive complexity in
> > memory.stat reporting"). However, those counters were updated on the
> > performance critical write-side, which caused regressions, so they were
> > later removed by commit 815744d75152 ("mm: memcontrol: don't batch
> > updates of local VM stats and events"). See [1] for more detailed
> > history.
> >
> > Kernel versions in between a983b5ebee57 & 815744d75152 (a year and a
> > half) enjoyed cheap reads of non-hierarchical stats, specifically on
> > cgroup v1. When moving to more recent kernels, a performance regression
> > for reading non-hierarchical stats is observed.
> >
> > Now that we have rstat, we know exactly which percpu counters have
> > updates for each stat. We can maintain non-hierarchical counters again,
> > making reads much more efficient, without affecting the performance
> > critical write-side. Hence, add non-hierarchical (i.e local) counters
> > for the stats, and extend rstat flushing to keep those up-to-date.
> >
> > A caveat is that we now need a stats flush before reading
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
>
> Have you measured any potential regression for cgroup v2 which collects
> all this data without ever using it (AFAICS)?

I did not. I did not expect noticeable regressions given that all the
extra work is done during flushing, which should mostly be done by the
asynchronous worker, but can also happen in the stats reading context.
Let me run the same script on cgroup v2 just in case and report back.

> --
> Michal Hocko
> SUSE Labs
