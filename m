From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 09/11] sched: record per-cgroup number of context
 switches
Date: Thu, 6 Jun 2013 17:04:52 -0700
Message-ID: <20130607000452.GS5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-10-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Utd1C4tlHlz9Zvrit81Bp43+aFCLhYAd8kBF2R/sFHY=;
        b=I3GqFSTNce+UBKD0gMMSTTQkYvfGjr6C7x2SDhcthP3w1UBi4MI0vQtjxQIGJW9XJF
         2YboOIrDE6Vc8tVZoyjTDls8QmW0ST1YKfRr2d9EhMubJ1i/dZA86FyiMxueUih89Xz0
         RbSaybCpq6EAo8MuF3gDMBIIlZNJTFMv8FOnrUcfagfdXvX+ZJTRJfPccHCxYHySUNXe
         Lus4ivMd84ur1zDP7Yr9fHpYrre1G42DCWS2BmQqiXHlYs22HaheuOKw9RwLb+Bx+0O0
         WoWUtJK+0ANhRgiOg6DGffJ6XzFvUFx1Zkn+hkVdX5VxFW4w25n0XbofYaiZDqkJsimi
         5BSw==
Content-Disposition: inline
In-Reply-To: <1369825402-31046-10-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Hello,

Maybe we should break off addition of switch stats to a separate set?
They are two separate things.

On Wed, May 29, 2013 at 03:03:20PM +0400, Glauber Costa wrote:
> @@ -3642,6 +3642,8 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
>  		prev->sched_class->put_prev_task(rq, prev);
>  
>  	do {
> +		if (likely(prev))
> +			cfs_rq->nr_switches++;
>  		se = pick_next_entity(cfs_rq);
>  		set_next_entity(cfs_rq, se);
>  		cfs_rq = group_cfs_rq(se);
> @@ -3651,6 +3653,22 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
>  	if (hrtick_enabled(rq))
>  		hrtick_start_fair(rq, p);
>  
> +	/*
> +	 * This condition is extremely unlikely, and most of the time will just
> +	 * consist of this unlikely branch, which is extremely cheap. But we
> +	 * still need to have it, because when we first loop through cfs_rq's,
> +	 * we can't possibly know which task we will pick. The call to
> +	 * set_next_entity above is not meant to mess up the tree in this case,
> +	 * so this should give us the same chain, in the same order.
> +	 */
> +	if (unlikely(p == prev)) {
> +		se = &p->se;
> +		for_each_sched_entity(se) {
> +			cfs_rq = cfs_rq_of(se);
> +			cfs_rq->nr_switches--;
> +		}
> +	}
> +

This concern may be fringe but the above breaks the monotonically
increasing property of the stat.  Depending on the timing, a very
unlucky consumer of the stat may see the counter going backward which
can lead to nasty things.  I'm not sure whether the fact that it'd be
very difficult to trigger is a pro or con.

Thanks.

-- 
tejun
