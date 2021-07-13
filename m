From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: infrastructure to flush memcg stats
Date: Tue, 13 Jul 2021 13:27:02 -0700
Message-ID: <CALvZod74cj6TOm3sXsnSOXnQeCfKonf=+DQFj92QhKq49ppr8w@mail.gmail.com>
References: <20210713202412.248252-1-shakeelb@google.com> <20210713202412.248252-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDVcnWUCmKFgFt42Z0BstCmPPXwwhSiEhiVvSxMjimA=;
        b=gGWUKJ1/QgenvRKNsFA/kuTLwkZmnjUbKvkHw6Hb9aeF/y3rC4CapuK/JdpFMuw1Sf
         XwIJHgrRUcz4hL+muJYuC3WCP0VSU+GXiTlRPCy5233n4lTzBS3lJlade5HnVy8531og
         6Xi/Rol5DVgx2NaHFulwZjPFeEg0g3fYptl7fVMy3GOodBuVsSiHGD/dkf8T4whLLNYp
         D36hGi7QmxKTb2QbtBHjvrSKG80CZ5YDP0gEMBEpfHn0DoSxKXmOrVtm9RlojlL13t+v
         16SMl0zfZLA5lkfGEOFqPlgfe6R1pe5k2jYAqVXM0YwJiEIDPfNuLt3mLwmIIMxRQ8IE
         QB4Q==
In-Reply-To: <20210713202412.248252-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jul 13, 2021 at 1:24 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> At the moment memcg stats are read in four contexts:
>
> 1. memcg stat user interfaces
> 2. dirty throttling
> 3. page fault
> 4. memory reclaim
>
> Currently the kernel flushes the stats for first two cases. Flushing the
> stats for remaining two casese may have performance impact. Always
> flushing the memcg stats on the page fault code path may negatively
> impacts the performance of the applications. In addition flushing in the
> memory reclaim code path, though treated as slowpath, can become the
> source of contention for the global lock taken for stat flushing because
> when system or memcg is under memory pressure, many tasks may enter the
> reclaim path.
>
> This patch uses following mechanisms to solve these challenges:
>
> 1. Periodically flush the stats from root memcg every 2 seconds. This
> will time limit the out of sync stats.
>
> 2. Asynchronously flush the stats after fixed number of stat updates.
> In the worst case the stat can be out of sync by O(nr_cpus * BATCH) for
> 2 seconds.
>
> 3. For avoiding thundering herd to flush the stats particularly from the
> memory reclaim context, introduce memcg local spinlock and let only one
> flusher active at a time. This could have been done through
> cgroup_rstat_lock lock but that lock is used by other subsystem and for
> userspace reading memcg stats. So, it is better to keep flushers
> introduced by this patch decoupled from cgroup_rstat_lock.
> ---
> Changes since v2:
> - Changed the subject of the patch
> - Added mechanism to bound errors to nr_cpus instead of nr_cgroups
> - memcg local lock to let one active flusher
>
> Changes since v1:
> - use system_unbound_wq for flushing the memcg stats
>

Forgot to add v3 in the subject for this patch.
