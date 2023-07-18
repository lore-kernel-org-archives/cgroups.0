From: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/rstat: record the cumulative
 per-cpu time of cgroup and its descendants
Date: Tue, 18 Jul 2023 18:08:50 +0800
Message-ID: <2655026d-6ae4-c14c-95b0-4177eefa434f@bytedance.com>
References: <20230717093612.40846-1-jiahao.os@bytedance.com>
 <ZLWb-LsBD041hMvr@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689674937; x=1692266937;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/5gRpkxT+kOgGiftiK7jx1s41nMMWH8tu708xIUfYw=;
        b=e29uBYrQhBw4fVZyXQO7maKHrmGmHqN+r7Pfwwyw8qN9L6QCG6qasmVYpauU/7y7NX
         V1X4gAJCY8eMMHCZ6WctiEW3goRs8B6TcI3b+mYc0KIKrLxLOeTJRRMitQXRYx9PU0hU
         xSSWULc1KTRrdRMIQwft32MH3hqNk315E3+JLhLH/sXfdIbL3x+zsjwNwqs3Hk1HUWMb
         F7eLpqoe+75AjdzbXqk512b2wDlLhX0JV6O3mp4qSguIX3Rfwn2jkEyijkJgyjFqNUrL
         G9HD9+OO++W4mpIMQzFx1HP9oFlTa1ZHh7Dx9dO57Y3PiP7cdWJWnBfe6/QfwZk2S2a9
         joaw==
In-Reply-To: <ZLWb-LsBD041hMvr-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hello,
On 2023/7/18 Tejun Heo wrote:

> On Mon, Jul 17, 2023 at 05:36:12PM +0800, Hao Jia wrote:
>> Now the member variable bstat of the structure cgroup_rstat_cpu
> 
> You said "now" indicating that the behavior has changed recently but I don't
> see what changed there. Can you elaborate?

Thank you for your review, sorry for confusing you with my expression, 
it is true that it has not changed, bstat has always recorded the 
per-cpu time of cgroup itself.

> 
>> records the per-cpu time of the cgroup itself, but does not
>> include the per-cpu time of its descendants. The per-cpu time
> 
> It does. The per-cpu delta is added to its parent and then that will in turn
> be used to propagate to its parent.
>Yes, so only cgrp->bstat contains the cpu time of the cgroup and its 
descendants. rstatc->bstat only records the per-cpu time of cgroup itself.

> 
> I think you're misunderstanding how the code works. Can you please double
> check?

--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -361,11 +361,15 @@ static void cgroup_base_stat_flush(struct cgroup 
*cgrp, int cpu)
  	cgroup_base_stat_sub(&delta, &rstatc->last_bstat);
  	cgroup_base_stat_add(&cgrp->bstat, &delta);
  	cgroup_base_stat_add(&rstatc->last_bstat, &delta);

We add the current cgroup's per-cpu delta to its per-cpu variable 
(cumul_bstat).

+	cgroup_base_stat_add(&rstatc->cumul_bstat, &delta);

  	/* propagate global delta to parent (unless that's root) */
  	if (cgroup_parent(parent)) {
  		delta = cgrp->bstat;
+		rstatc = cgroup_rstat_cpu(parent, cpu);
+
  		cgroup_base_stat_sub(&delta, &cgrp->last_bstat);

Since we hold the global cgroup_rstat_lock and disable interrupts in 
cgroup_base_stat_flush() and we only update cgrp->bstat here.
So the global delta at this time is equal to the increment of this 
cgroup and its descendants on this cpu (unless root cgroup), so we can 
add the global delta to the cumul_bstat of its parent and propagate it 
upward.

+		cgroup_base_stat_add(&rstatc->cumul_bstat, &delta);
  		cgroup_base_stat_add(&parent->bstat, &delta);
  		cgroup_base_stat_add(&cgrp->last_bstat, &delta);
  	}


I wrote a kernel module to verify and test the above kernel code,
The kernel module adds a cpu.stat_percpu_all file for each cgroup, which 
can output the per-cpu time information of the cgroup and its 
descendants calculated in two ways:
1. Cumulatively add the per-cpu bstat of cgroup and each of its descendants.
2. Directly output @cumul_bstat read in the kernel (patch has been applied).
When the child cgroup is not removed, the results calculated by the two 
methods should be equal.

NOTE: We need to flush the data before "cat cpu.stat_percpu_all", such 
as "cat cpu.stat".

Code link:
https://github.com/jiaozhouxiaojia/cgv2-stat-percpu_test/tree/main

The testing procedure is in README.

I installed the 6.5.0-rc1 kernel on my machine (an Intel Xeon(R) 
Platinum 8260 machine 96 CPUs in total.) and did some tests.
So far I haven't found anything unusual, if I'm wrong, please point it 
out, it's very helpful to me, thanks again!

Thanks,
Hao
