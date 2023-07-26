From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg: use rstat for non-hierarchical stats
Date: Tue, 25 Jul 2023 19:20:02 -0700
Message-ID: <CAJD7tkZDpni+VM61i-jUgvn=TkZ5CySotTmUAFQPwMSjDfOEWQ@mail.gmail.com>
References: <20230726002904.655377-1-yosryahmed@google.com>
 <20230726002904.655377-2-yosryahmed@google.com> <ZMCBzUH7qIdc3Y2X@P9FQF9L96D>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690338039; x=1690942839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q8i3sOYpsPz/5z4EGZvbSWnvU6I/qPCguplntjXR3Gg=;
        b=zX/ucMGvp64UIN2TBRjHmtg4M1ZyQus/V7XJMJabp2TI34u8ATIOzuXKNEbYJ4Kq/U
         BAKXhx0djH/AEVYojD9/E4xeO9cMvEt4Q7FJdKvT/iBZvjqMfcCHxyLLyXzoN1kfmn4y
         +WGwrX73lXIInJs01RyhmihamNPtRWXfO6l/9EqNC7Bn9C7HpLP6V0FecaFlvFhFMg1G
         TwvkTuXVRcGhPlxOZWecmoB+yoxr1xdd3xW1gu0iQ7xZm8D4YKSmaEReUGBk8cK4mHc9
         zFsF57XxKoiFxStRGmlWBI1QeUWI0d0uElU3pVrr/lweOwaFdKbRTCg0PV9S8jpXHqy/
         wbSw==
In-Reply-To: <ZMCBzUH7qIdc3Y2X@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jul 25, 2023 at 7:15=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> On Wed, Jul 26, 2023 at 12:29:04AM +0000, Yosry Ahmed wrote:
> > Currently, memcg uses rstat to maintain hierarchical stats. Counters ar=
e
> > maintained for hierarchical stats at each memcg. Rstat tracks which
> > cgroups have updates on which cpus to keep those counters fresh on the
> > read-side.
> >
> > For non-hierarchical stats, we do not maintain counters. Instead, the
>                                                 global?

Do you mean "we do not maintain global counters"? I think "global" is
confusing, because it can be thought of as all cpus or as including
the subtree (as opposed to local for non-hierarchical stats).

> > percpu counters for a given stat need to be summed to get the
> > non-hierarchical stat value. The original implementation did the same.
> > At some point before rstat, non-hierarchical counters were introduced b=
y
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
> > A caveat is that we now a stats flush before reading
>                          need?

Ah yes. I am hoping Andrew can amend this but I am happy to send a v3 as we=
ll.

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
> > [1]https://lore.kernel.org/lkml/20230725201811.GA1231514-druUgvl0LCNAfugRpC6u6w@public.gmane.org/
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks!

>
> Thank you!
