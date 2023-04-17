From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm-unstable RFC 0/5] cgroup: eliminate atomic rstat
Date: Mon, 17 Apr 2023 04:54:52 -0700
Message-ID: <CAJD7tkZjoWMXFSgBwAtXao35f3Gmmp9cEordvFAPX_EegC_o1A@mail.gmail.com>
References: <20230403220337.443510-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681732535; x=1684324535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAfhUM23NLqVvA/6Hxfd6Xgc8oePCVqguK6TK2m4xx0=;
        b=YOBGao3Gh4rsypVOuHoE1ytvu3v+zzuIisiDjA+pAPLUyn2lc4W2y580wM0QGqDuBK
         t2E4fbgVIhzJkdNrXON9Fk4ppV/G0uJJY87Mggs8FmMDwvTtrBjmQayh9K/oWmrRXfDT
         w3OPKIPguHHmcs76WPPVys//oHx3UrhionPHUQHviOENI+JaZF1M/wpgoGXe0OqwfSVJ
         amMjGmlYHvk2HrrkdEj7F2j2V2hoSumB9UuA9pw4ITvpp7IPm19MV3XM8v0gk3ZoHHlA
         4y71YZlBrpzkXhBU69R8xFtV1gn1I/z2Ufb4CZ7Dh1rW6T7kjFc6InE6Cpgq/99EkcVp
         jAwg==
In-Reply-To: <20230403220337.443510-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Apr 3, 2023 at 3:03=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> A previous patch series ([1] currently in mm-unstable) changed most
> atomic rstat flushing contexts to become non-atomic. This was done to
> avoid an expensive operation that scales with # cgroups and # cpus to
> happen with irqs disabled and scheduling not permitted. There were two
> remaining atomic flushing contexts after that series. This series tries
> to eliminate them as well, eliminating atomic rstat flushing completely.
>
> The two remaining atomic flushing contexts are:
> (a) wb_over_bg_thresh()->mem_cgroup_wb_stats()
> (b) mem_cgroup_threshold()->mem_cgroup_usage()
>
> For (a), flushing needs to be atomic as wb_writeback() calls
> wb_over_bg_thresh() with a spinlock held. However, it seems like the
> call to wb_over_bg_thresh() doesn't need to be protected by that
> spinlock, so this series proposes a refactoring that moves the call
> outside the lock criticial section and makes the stats flushing
> in mem_cgroup_wb_stats() non-atomic.
>
> For (b), flushing needs to be atomic as mem_cgroup_threshold() is called
> with irqs disabled. We only flush the stats when calculating the root
> usage, as it is approximated as the sum of some memcg stats (file, anon,
> and optionally swap) instead of the conventional page counter. This
> series proposes changing this calculation to use the global stats
> instead, eliminating the need for a memcg stat flush.
>
> After these 2 contexts are eliminated, we no longer need
> mem_cgroup_flush_stats_atomic() or cgroup_rstat_flush_atomic(). We can
> remove them and simplify the code.
>
> Yosry Ahmed (5):
>   writeback: move wb_over_bg_thresh() call outside lock section
>   memcg: flush stats non-atomically in mem_cgroup_wb_stats()
>   memcg: calculate root usage from global state
>   memcg: remove mem_cgroup_flush_stats_atomic()
>   cgroup: remove cgroup_rstat_flush_atomic()
>
>  fs/fs-writeback.c          | 16 +++++++----
>  include/linux/cgroup.h     |  1 -
>  include/linux/memcontrol.h |  5 ----
>  kernel/cgroup/rstat.c      | 26 ++++--------------
>  mm/memcontrol.c            | 54 ++++++++------------------------------
>  5 files changed, 27 insertions(+), 75 deletions(-)
>
> --
> 2.40.0.348.gf938b09366-goog
>

Any thoughts on this series, anyone? :)
