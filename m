From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Wed, 29 Mar 2023 13:22:12 +0200
Message-ID: <ZCQfZJFufkJ10o01@dhcp22.suse.cz>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-5-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680088933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gebdMLUhhGELLLVSbQbSg6v4/rJOoLd9eRIXmlgXsio=;
        b=vXmcD7WVZBRtIF0QTHnyV0Rs4Utot99+8SQdPpEeQgdw9Nt9PPFDXEaDiGG07RKvkX9o4l
        lGXnaYncs8HwoSJ4MiI1vkPA5f/VJ3GJlKnBIUWk10zdR5ivx8u3vsRJi+RTJsPs0Xg3tS
        /x3S3AGVNCHDf2wdcfpAeE+BafyyrcY=
Content-Disposition: inline
In-Reply-To: <20230328221644.803272-5-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 28-03-23 22:16:39, Yosry Ahmed wrote:
> rstat flushing is too expensive to perform in irq context.
> The previous patch removed the only context that may invoke an rstat
> flush from irq context, add a WARN_ON_ONCE() to detect future
> violations, or those that we are not aware of.
> 
> Ideally, we wouldn't flush with irqs disabled either, but we have one
> context today that does so in mem_cgroup_usage(). Forbid callers from
> irq context for now, and hopefully we can also forbid callers with irqs
> disabled in the future when we can get rid of this callsite.

I am sorry to be late to the discussion. I wanted to follow up on
Johannes reply in the previous version but you are too fast ;)

I do agree that this looks rather arbitrary. You do not explain how the
warning actually helps. Is the intention to be really verbose to the
kernel log when somebody uses this interface from the IRQ context and
get bug reports? What about configurations with panic on warn? Do we
really want to crash their systems for something like that?

> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
>  
>  	for_each_possible_cpu(cpu) {
> -- 
> 2.40.0.348.gf938b09366-goog

-- 
Michal Hocko
SUSE Labs
