From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] Revert "mm: memcontrol: avoid workload stalls when
 lowering memory.high"
Date: Fri, 22 Jan 2021 12:57:26 -0800
Message-ID: <CALvZod5QWBgKzoKbAUgtwU4YwXAQtu1MS_=o_zhyFDCXam4yNA@mail.gmail.com>
References: <20210122184341.292461-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=raLUB36sAztka1/6R5PBGfhEeAA3qlJwdT1ML+wmZec=;
        b=RAEZ3z6s46P3K6log9ncGo5mPucJj4c+Pt0UwiwW5usuPVFmkT+WBnj4BRttVa0gtp
         ymlzxD4dKC/6WUWyuFs4iqMob6tcX649pXk4T/anBFDEwTuP7AgwhAErH/tWWtRvj914
         af0q/4zvYWlCDwB418HXJXh4cWpi/GCtxvc2cfZG9x13roRXjNRX+VAl4AwX9Ox5yw8N
         2KyKpdMfanRFromoDxJTVayLX5IYzlmMxbJVGgUtykfmS2A7xg0lTHI/VsiHtcn8dv6t
         vQ1npJMvhEAvBq/KzaJWYbd2pV1cIziwPWiuGuKtsIshMtqcArY2CDwzP3+YfTBOAdKH
         3UJw==
In-Reply-To: <20210122184341.292461-1-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Fri, Jan 22, 2021 at 10:43 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> This reverts commit 536d3bf261a2fc3b05b3e91e7eef7383443015cf, as it
> can cause writers to memory.high to get stuck in the kernel forever,
> performing page reclaim and consuming excessive amounts of CPU cycles.
>
> Before the patch, a write to memory.high would first put the new limit
> in place for the workload, and then reclaim the requested delta. After
> the patch, the kernel tries to reclaim the delta before putting the
> new limit into place, in order to not overwhelm the workload with a
> sudden, large excess over the limit. However, if reclaim is actively
> racing with new allocations from the uncurbed workload, it can keep
> the write() working inside the kernel indefinitely.
>
> This is causing problems in Facebook production. A privileged
> system-level daemon that adjusts memory.high for various workloads
> running on a host can get unexpectedly stuck in the kernel and
> essentially turn into a sort of involuntary kswapd for one of the
> workloads. We've observed that daemon busy-spin in a write() for
> minutes at a time, neglecting its other duties on the system, and
> expending privileged system resources on behalf of a workload.
>
> To remedy this, we have first considered changing the reclaim logic to
> break out after a couple of loops - whether the workload has converged
> to the new limit or not - and bound the write() call this way.
> However, the root cause that inspired the sequence change in the first
> place has been fixed through other means, and so a revert back to the
> proven limit-setting sequence, also used by memory.max, is preferable.
>
> The sequence was changed to avoid extreme latencies in the workload
> when the limit was lowered: the sudden, large excess created by the
> limit lowering would erroneously trigger the penalty sleeping code
> that is meant to throttle excessive growth from below. Allocating
> threads could end up sleeping long after the write() had already
> reclaimed the delta for which they were being punished.
>
> However, erroneous throttling also caused problems in other scenarios
> at around the same time. This resulted in commit b3ff92916af3 ("mm,
> memcg: reclaim more aggressively before high allocator throttling"),
> included in the same release as the offending commit. When allocating
> threads now encounter large excess caused by a racing write() to
> memory.high, instead of entering punitive sleeps, they will simply be
> tasked with helping reclaim down the excess, and will be held no
> longer than it takes to accomplish that. This is in line with regular
> limit enforcement - i.e. if the workload allocates up against or over
> an otherwise unchanged limit from below.
>
> With the patch breaking userspace, and the root cause addressed by
> other means already, revert it again.
>
> Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering memory.high")
> Cc: <stable@vger.kernel.org> # 5.8+
> Reported-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
