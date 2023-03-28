From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v1 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Tue, 28 Mar 2023 13:49:02 -0400
Message-ID: <ZCMojk50vjiK6mBe@cmpxchg.org>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-5-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1680025744;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AqbE7OnUHsZ2+LRH4fu/PmF89EsJRI5zjHe+XmQVCDs=;
        b=AcESMi6Tg2n/wTojpHFGYu2mc0254BMahR7WXFU2zVr1NcQ+s53BTljFpeIkztOPZD
         0aHsoJ3G5s4OycOCAjAOMGekHiqgs0q7mySZxqSKuAcwdT7mTALbB9ifAfB9AIpBTQxZ
         77SxzXW8rSToW0hJofZQ49zOI3KVuRDag5eKqxw/f9AQ2AyaATGPm/ubHWEm4d3LnrDu
         fmDW6ShKYODDJ9EAe7FHBCkCMZ6PLv4Mtdar6MuRkkvF2TJWSME4HUKVL3vitSqOkEGg
         Xi9dKsgKvexVMivDuoNUUzIf/XqWuhItchnt1+Aw4oTYjjFOsgTI7bUhs1PnVw6AykQW
         emjw==
Content-Disposition: inline
In-Reply-To: <20230328061638.203420-5-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Tue, Mar 28, 2023 at 06:16:33AM +0000, Yosry Ahmed wrote:
> rstat flushing is too expensive to perform in irq context.
> The previous patch removed the only context that may invoke an rstat
> flush from irq context, add a WARN_ON_ONCE() to detect future
> violations, or those that we are not aware of.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  kernel/cgroup/rstat.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index d3252b0416b6..c2571939139f 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -176,6 +176,8 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
>  {
>  	int cpu;
>  
> +	/* rstat flushing is too expensive for irq context */
> +	WARN_ON_ONCE(!in_task());
>  	lockdep_assert_held(&cgroup_rstat_lock);

This seems a bit arbitrary. Why is an irq caller forbidden, but an
irq-disabled, non-preemptible section caller is allowed? The latency
impact on the system would be the same, right?
