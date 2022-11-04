From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 3/3] blk-cgroup: Flush stats at blkgs destruction path
Date: Fri, 4 Nov 2022 10:00:46 -1000
Message-ID: <Y2VvboMSxgF0pYpX@slm.duckdns.org>
References: <20221104182050.342908-1-longman@redhat.com>
 <20221104182050.342908-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j5nCsQYl2chg/EUS/wN4WOUjHzC3DOYQXdNArjUPqD4=;
        b=h8ZfTZCn8t/w57ArpiD8nVNzrVfQicce6WQcDTZNCIwJQOnFJL3OUnRUi2+MwApRMd
         3o5jeFfSHLVGXoygB8+U2CENqI3roIwnH9x9M+K2E/Tg/u+JXQlVUC9YJwxmtjs0rV08
         929KkcjhLFCHh81gh6aTz1xYYED+Jp4yARUKiTMhci2ead4XxLs1LIf+1di0OF2l9lVf
         7TP5i7ZEHNCcsthnGt4ci5d06V/5W1xfe3R0E22f+H1Y/rnaovTEh+t2SAM8g5ZS4ZEG
         pAXjiXrZ64Zami+gBtIgonYUaGv6RrZjlKWThMv/1TXdTBaRSolUN7NWcTEV6FVaux6L
         opbA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221104182050.342908-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>

On Fri, Nov 04, 2022 at 02:20:50PM -0400, Waiman Long wrote:
> +/**
> + * cgroup_rstat_css_flush - flush stats for the given css and cpu
> + * @css: target css to be flush
> + * @cpu: the cpu that holds the stats to be flush
> + *
> + * A lightweight rstat flush operation for a given css and cpu.
> + * Only the cpu_lock is being held for mutual exclusion, the cgroup_rstat_lock
> + * isn't used.
> + */
> +void cgroup_rstat_css_flush(struct cgroup_subsys_state *css, int cpu)
> +{
> +	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
> +
> +	raw_spin_lock_irq(cpu_lock);
> +	rcu_read_lock();
> +	css->ss->css_rstat_flush(css, cpu);
> +	rcu_read_unlock();
> +	raw_spin_unlock_irq(cpu_lock);
> +}

Would it make sense to itereate CPUs within the helper rather than asking
the caller to do it? Also, in terms of patch sequencing, this introduces a
bug and then fixes it. Prolly better to not introduce the bug in the first
place.

Thanks.

-- 
tejun
