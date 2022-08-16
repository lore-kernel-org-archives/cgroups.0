From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 3/3] cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 16 Aug 2022 07:20:25 -1000
Message-ID: <YvvR2Sa6LxZLwXsJ@slm.duckdns.org>
References: <20220816151119.29534-1-longman@redhat.com>
 <20220816151119.29534-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=r91jzjWZhlEdAsAG7xnJCiSvfb9cchZedVFaXE4bjp4=;
        b=TvooP6Vs8oiEoPmqq4G62BVNWO56dW0DcKJ15qUCu0ZE9ECb409mZosxkdMVDSOj0a
         y2m0JwIDYAGdwXcSZXXK/5oOGh+IA6tmHPZpqSfdQaIm5M/Z2/Zy88MwZI0G6GHRbeXC
         mugphGGr+otsfCPJd58BcMJt3dzuyWsZ7gfLWkHWjakj1FEsFu+WTYyckNYIeWpTvJZ6
         NPMH6pk+NbDQSwtXJ6Y1Zjz3GF/ADed8ASD9bVoJukmUOgmtqTef2oNq7vSsrLPp9tRr
         YLrZjaVXBRmFC8uQstb8aaxgDfv+hYWb9Gy2+jdVAx/K8GTo8LBoA2D+wwyU5yTHh+/D
         uWxA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220816151119.29534-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

So, overall I think this is the right direction.

> +static int cpuset_set_cpus_allowed_ptr(struct task_struct *p,
> +				       const struct cpumask *mask)
> +{
> +	if (p->user_cpus_ptr) {
> +		cpumask_var_t new_mask;
> +
> +		if (alloc_cpumask_var(&new_mask, GFP_KERNEL) &&
> +		    copy_user_cpus_mask(p, new_mask) &&
> +		    cpumask_and(new_mask, new_mask, mask)) {
> +			int ret = set_cpus_allowed_ptr(p, new_mask);
> +
> +			free_cpumask_var(new_mask);
> +			return ret;
> +		}
> +		free_cpumask_var(new_mask);
> +	}
> +
> +	return set_cpus_allowed_ptr(p, mask);
> +}

But this seems racy to me. Let's say attach and setaffinity race. The
expectation should be that we'd end up with the same eventual mask no matter
what the operation order may be. The above code wouldn't do that, right?
There's nothing synchronizing the two and if setaffinity takes place between
the user_cpus_ptr test and set_cpus_allowed_ptr(), it'd get ignored.

This gotta be more integrated. There is what the user requested and there
are restrictions from CPU hotplug state and cpuset. All three should be
synchronized so that there is one synchronzied way to obtain and apply the
current effective mask.

Thanks.

-- 
tejun
