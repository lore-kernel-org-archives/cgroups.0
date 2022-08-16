From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 3/3] cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 16 Aug 2022 10:15:36 -1000
Message-ID: <Yvv66EWygCwHUCqy@slm.duckdns.org>
References: <20220816192734.67115-1-longman@redhat.com>
 <20220816192734.67115-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=zU1X1POINU9AFqquPUG2+wIDvwycYABzLVLgeZNxxE0=;
        b=e3Ei/n53VysaXj/X8x6hxVU3orxvP+NRLitVxM6miL6Z2bplRXrj59msWPDEv+TpZ0
         2yl6HS2NFS2NRG56vvkbWtxmHmtoPAWCYx2/I5NaQT20scQ8a/Du/5ipfD0JHD6EIThU
         b5LAgm7F2nRktClrucEeVGHdY2V48Ab3VWlkIfVCOAAmrL8c9PA/2N6l5fzSwQoWHrd0
         jGWz1XJ3OIkjLF1qqX1ue8vcvlPz1ljf5KX7n4xKC1MTXYaIpmO7xyf0jq93o0CqGe3M
         w1I3TKlJyXv9XsUfC+G6xivbZCl63jTICYtJVH8CizE3buHBcH3s8XiMU7BN16NA5zap
         pq8w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220816192734.67115-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Aug 16, 2022 at 03:27:34PM -0400, Waiman Long wrote:
> +static int cpuset_set_cpus_allowed_ptr(struct task_struct *p,
> +				       const struct cpumask *mask)
> +{
> +	cpumask_var_t new_mask;
> +	int ret;
> +
> +	if (!READ_ONCE(p->user_cpus_ptr)) {
> +		ret = set_cpus_allowed_ptr(p, mask);
> +		/*
> +		 * If user_cpus_ptr becomes set now, we are racing with
> +		 * a concurrent sched_setaffinity(). So use the newly
> +		 * set user_cpus_ptr and retry again.
> +		 *
> +		 * TODO: We cannot detect change in the cpumask pointed to
> +		 * by user_cpus_ptr. We will have to add a sequence number
> +		 * if such a race needs to be addressed.
> +		 */

This is too ugly and obviously broken. Let's please do it properly.

Thanks.

-- 
tejun
