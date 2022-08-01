From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] sched: Use user_cpus_ptr for saving user provided
 cpumask in sched_setaffinity()
Date: Mon, 1 Aug 2022 17:45:46 +0100
Message-ID: <20220801164545.GA26471@willie-the-truck>
References: <20220801154124.2011987-1-longman@redhat.com>
 <20220801154124.2011987-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659372353;
        bh=pX7cVWCOiiHtMKCUYXRUfASuBYlxu+7/tdxAAuxjyrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hdGerin0vW2Af6UTgL4kPaMf6DXvN2ZyQDVQ/IenI4l39Fuk/vw/ujcKfhKWYW8OI
         6sPS++jA3O9B7yfUmMwJyPPSqddw/f3OJaQgkuGQE68hjOyO8QPvQGaep5J0LSwjZT
         dImiZrwlvdyunL1/LC1hrzv9bYVg/h5FqYkMuBJEQxpee/pmI2/SPevhFkvuBQI6Ac
         c+m29F74WH2tlqm0sZuEWYiDVx9BC5HqZiLjKtQ4igf78uUeCF4cBTFtLxPCfhLrhU
         qjkPql3Us+MkWcTNMAzOCG5kZsdOFhhy+jfhUHe60vZf3TabasmrqEPcex/fcRjHN8
         mD1qRNntbXufQ==
Content-Disposition: inline
In-Reply-To: <20220801154124.2011987-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 01, 2022 at 11:41:23AM -0400, Waiman Long wrote:
> The user_cpus_ptr field is added by commit b90ca8badbd1 ("sched:
> Introduce task_struct::user_cpus_ptr to track requested affinity"). It
> is currently used only by arm64 arch due to possible asymmetric cpu
> setup. This patch extends its usage to save user provided cpumask when
> sched_setaffinity() is called for all arches.
> 
> To preserve the existing arm64 use case, a new cpus_affinity_set flag is
> added to differentiate if user_cpus_ptr is set up by sched_setaffinity()
> or by force_compatible_cpus_allowed_ptr(). user_cpus_ptr
> set by sched_setaffinity() has priority and won't be
> overwritten by force_compatible_cpus_allowed_ptr() or
> relax_compatible_cpus_allowed_ptr().
> 
> As a call to sched_setaffinity() will no longer clear user_cpus_ptr
> but set it instead, the SCA_USER flag is no longer necessary and can
> be removed.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/sched.h |  1 +
>  kernel/sched/core.c   | 71 +++++++++++++++++++++++++++++++------------
>  kernel/sched/sched.h  |  1 -
>  3 files changed, 52 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c46f3a63b758..60ae022fa842 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -815,6 +815,7 @@ struct task_struct {
>  
>  	unsigned int			policy;
>  	int				nr_cpus_allowed;
> +	int				cpus_affinity_set;
>  	const cpumask_t			*cpus_ptr;
>  	cpumask_t			*user_cpus_ptr;
>  	cpumask_t			cpus_mask;
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index da0bf6fe9ecd..7757828c7422 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2607,6 +2607,7 @@ int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src,
>  		return -ENOMEM;
>  
>  	cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
> +	dst->cpus_affinity_set = src->cpus_affinity_set;

I haven't been through this thorougly, but it looks a bit suspicious to me
to inherit this field directly across fork(). If a 64-bit task with this
flag set forks and then exec's a 32-bit program, arm64 will be in trouble if
we're not able to override the affinity forcefully.

Will
