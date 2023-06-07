From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Reinit blkg_iostat_set after clearing in
 blkcg_reset_stats()
Date: Wed, 7 Jun 2023 09:28:08 +0800
Message-ID: <ZH/dKFnTIHZqsjQa@ovpn-8-23.pek2.redhat.com>
References: <20230606180724.2455066-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686101300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1h0nXm4obQWr/nMN17xlxThI6u2crQzlPISlM1jWir0=;
        b=XaAwKWI8M34st32pDbwA7SxRgVZ813Ujx0f0R6yXS5VQ3Nb/7TkkY2TtQ9OB1A5Bs7rTZg
        H1JeEA47bkMUCZuN0+OPdGJM1FFV8I46CgFBDrApLt8ESwg4YkskKGzssqp5yISTiVLyA3
        KTx/yUieOnRU3OVXpzVqDqye3iMwh5Y=
Content-Disposition: inline
In-Reply-To: <20230606180724.2455066-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 06, 2023 at 02:07:24PM -0400, Waiman Long wrote:
> When blkg_alloc() is called to allocate a blkcg_gq structure
> with the associated blkg_iostat_set's, there are 2 fields within
> blkg_iostat_set that requires proper initialization - blkg & sync.
> The former field was introduced by commit 3b8cc6298724 ("blk-cgroup:
> Optimize blkcg_rstat_flush()") while the later one was introduced by
> commit f73316482977 ("blk-cgroup: reimplement basic IO stats using
> cgroup rstat").
> 
> Unfortunately those fields in the blkg_iostat_set's are not properly
> re-initialized when they are cleared in v1's blkcg_reset_stats(). This
> can lead to a kernel panic due to NULL pointer access of the blkg
> pointer. The missing initialization of sync is less problematic and
> can be a problem in a debug kernel due to missing lockdep initialization.
> 
> Fix these problems by re-initializing them after memory clearing.
> 
> Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
> Fixes: f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-cgroup.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 90c2efc3767f..48084321e3e0 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -636,8 +636,13 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
>  			struct blkg_iostat_set *bis =
>  				per_cpu_ptr(blkg->iostat_cpu, cpu);
>  			memset(bis, 0, sizeof(*bis));
> +
> +			/* Re-initialize the cleared blkg_iostat_set */
> +			u64_stats_init(&bis->sync);
> +			bis->blkg = blkg;
>  		}
>  		memset(&blkg->iostat, 0, sizeof(blkg->iostat));
> +		u64_stats_init(&blkg->iostat.sync);
>  
>  		for (i = 0; i < BLKCG_MAX_POLS; i++) {
>  			struct blkcg_policy *pol = blkcg_policy[i];

Looks fine,

Reviewed-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


Thanks,
Ming

