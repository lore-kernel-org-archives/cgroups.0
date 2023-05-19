From: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH] cgroup: rstat: Simplified cgroup_base_stat_flush() update
 last_bstat logic
Date: Fri, 19 May 2023 12:15:57 +0800
Message-ID: <f39b9229-e59c-2b1c-7f3f-1aeedfad44dc@bytedance.com>
References: <20230518124142.57644-1-jiahao.os@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684469763; x=1687061763;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+1GUC3Yam0K9EDsvFQ9GSyTFpfzCRIN9846sNrHODE=;
        b=inMXzVIm8okKpiM3pIDom7XfUcukiWakU2TIFKWCt3gTHbS5lgLvn0BVw60XvNf3GV
         AbBKNivSG6q8fOuiPhcQx/4p3n4J13fyXSkOroeEYGfIekVdFwv1+BHuKnbYpqjckORo
         RRS1lpUrmuwoiCgUFa7Lcm2wzUB+q2ooRYahH9YQ4/6CsYdT1BQomzPU0U8O7Nh2drz7
         P0Q1ginbXEFw8sG4JlQHX7H8xEmT+889zwzYW0OKYc47Hpmz2U185ceInUt3pKjWpdY9
         GNZdTF1DKBm3Fh6vXTWXInGVVpJ1wxjJLRoDTCb2Juf36QsudV1iwBvLqtUFhvr+zMCM
         HVFg==
In-Reply-To: <20230518124142.57644-1-jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2023/5/18 Hao Jia wrote:
> In cgroup_base_stat_flush() function, {rstatc, cgrp}->last_bstat
> needs to be updated to the current {rstatc, cgrp}->bstat, directly
> assigning values instead of adding the last value to delta.
> 
> Signed-off-by: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>   kernel/cgroup/rstat.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index 9c4c55228567..3e5c4c1c92c6 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -376,14 +376,14 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
>   	/* propagate percpu delta to global */
>   	cgroup_base_stat_sub(&delta, &rstatc->last_bstat);  *(1)*
>   	cgroup_base_stat_add(&cgrp->bstat, &delta);
> -	cgroup_base_stat_add(&rstatc->last_bstat, &delta);
> +	rstatc->last_bstat = rstatc->bstat;		    *(2)*

Some things are wrong, the value of rstatc->bstat at (1) and (2) may not 
be the same, rstatc->bstat may be updated on other cpu. Sorry for the noise.

>   
>   	/* propagate global delta to parent (unless that's root) */
>   	if (cgroup_parent(parent)) {
>   		delta = cgrp->bstat;
>   		cgroup_base_stat_sub(&delta, &cgrp->last_bstat);
>   		cgroup_base_stat_add(&parent->bstat, &delta);
> -		cgroup_base_stat_add(&cgrp->last_bstat, &delta);
> +		cgrp->last_bstat = cgrp->bstat;
>   	}
>   }
>   

Maybe something like this?


In cgroup_base_stat_flush() function, {rstatc, cgrp}->last_bstat
needs to be updated to the current {rstatc, cgrp}->bstat after the
calculation.

For the rstatc->last_bstat case, rstatc->bstat may be updated on other
cpus during our calculation, resulting in inconsistent rstatc->bstat
statistics for the two reads. So we use the temporary variable @cur to
record the read statc->bstat statistics, and use @cur to update
rstatc->last_bstat.

For the cgrp->last_bstat case, we already hold cgroup_rstat_lock, so
cgrp->bstat will not change during the calculation process, and it can
be directly used to update cgrp->last_bstat.

It is better for us to assign directly instead of using
cgroup_base_stat_add() to update {rstatc, cgrp}->last_bstat.

Signed-off-by: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
  kernel/cgroup/rstat.c | 9 +++++----
  1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 9c4c55228567..17a6a1fcc2d4 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -360,7 +360,7 @@ static void cgroup_base_stat_flush(struct cgroup 
*cgrp, int cpu)
  {
  	struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
  	struct cgroup *parent = cgroup_parent(cgrp);
-	struct cgroup_base_stat delta;
+	struct cgroup_base_stat delta, cur;
  	unsigned seq;

  	/* Root-level stats are sourced from system-wide CPU stats */
@@ -370,20 +370,21 @@ static void cgroup_base_stat_flush(struct cgroup 
*cgrp, int cpu)
  	/* fetch the current per-cpu values */
  	do {
  		seq = __u64_stats_fetch_begin(&rstatc->bsync);
-		delta = rstatc->bstat;
+		cur = rstatc->bstat;
  	} while (__u64_stats_fetch_retry(&rstatc->bsync, seq));

  	/* propagate percpu delta to global */
+	delta = cur;
  	cgroup_base_stat_sub(&delta, &rstatc->last_bstat);
  	cgroup_base_stat_add(&cgrp->bstat, &delta);
-	cgroup_base_stat_add(&rstatc->last_bstat, &delta);
+	rstatc->last_bstat = cur;

  	/* propagate global delta to parent (unless that's root) */
  	if (cgroup_parent(parent)) {
  		delta = cgrp->bstat;
  		cgroup_base_stat_sub(&delta, &cgrp->last_bstat);
  		cgroup_base_stat_add(&parent->bstat, &delta);
-		cgroup_base_stat_add(&cgrp->last_bstat, &delta);
+		cgrp->last_bstat = cgrp->bstat;
  	}
  }

