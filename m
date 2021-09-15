From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] vmpressure: wake up work only when there is
 registration event
Date: Wed, 15 Sep 2021 14:42:03 +0200
Message-ID: <YUHqG0P6Ahs8FvN+@dhcp22.suse.cz>
References: <1631635551-8583-1-git-send-email-wang.yong12@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631709724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c8ppzFWYneNjhYnOY61IFfVXjIUkdpqvAGrP3jiPXNY=;
        b=BU4gFvgZPXkgGkeAZA8Isz6d5VIGuDlC1iEhdFHcFYBMvbzqGNNT/soHXwDsAwBQuBvjDf
        PaM78JTRR+b08B3QWTBdEVKo1cMHvWjhAZyhditBPCQ3KPHBFhxjSR300DGu5hNG6wKqn8
        zpVkPRYhrZ3HPkNYakZy/QOugYICdsw=
Content-Disposition: inline
In-Reply-To: <1631635551-8583-1-git-send-email-wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

On Tue 14-09-21 09:05:51, yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> 
> Use the global variable num_events to record the number of vmpressure
> events registered by the system, and wake up work only when there is
> registration event.
> Usually, the vmpressure event is not registered in the system, this patch
> can avoid waking up work and doing nothing.

I have asked in the previous version and this changelog doesn't that
explain again. Why don't you simply bail out early in vmpressure()
entry?

> Test with 5.14.0-rc5-next-20210813 on x86_64 4G ram.
> Consume cgroup memory until it is about to be reclaimed, then execute
> "perf stat -I 2000 malloc.out" command to trigger memory reclamation
> and get performance results.
> The context-switches is reduced by about 20 times.

Is this test somewhere available so that it can be reproduced by
others. Also while the number of context switches can be an interesting
it is not really clear from this evaluation whether that actually
matters or not. E.g. what does an increase of task-clock and twice as
many instructions recorded tell us?

> unpatched:
> Average of 10 test results
> 582.4674048	task-clock(msec)
> 19910.8		context-switches
> 0		cpu-migrations
> 1292.9		page-faults
> 414784733.1	cycles

> <not supported>	stalled-cycles-frontend
> <not supported>	stalled-cycles-backend

Why is this a part of the data?

> 580070698.4	instructions
> 125572244.7	branches
> 2073541.2	branch-misses
> 
> patched
> Average of 10 test results
> 973.6174796	task-clock(msec)
> 988.6		context-switches
> 0		cpu-migrations
> 1785.2		page-faults
> 772883602.4	cycles
> <not supported>	stalled-cycles-frontend
> <not supported>	stalled-cycles-backend
> 1360280911	instructions
> 290519434.9	branches
> 3378378.2	branch-misses
> 
> Tested-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> Signed-off-by: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> ---
> 
[...]
> @@ -272,6 +277,9 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
>  		return;
>  
>  	if (tree) {
> +		if (!static_branch_unlikely(&num_events))
> +			return;

We usually hide the change behind a static inline helper (e.g.
vmpressure_disabled()). I would also put it to the beginning of
vmpressure or put an explanation why it makes sense only in this branch.
-- 
Michal Hocko
SUSE Labs
