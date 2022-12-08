From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH-block 3/3] blk-cgroup: Flush stats at blkgs destruction
 path
Date: Thu, 8 Dec 2022 16:00:10 -0700
Message-ID: <e8a09f5d-afce-608f-220b-6b32b3ae37b9@kernel.dk>
References: <20221208220141.2625775-1-longman@redhat.com>
 <20221208220141.2625775-4-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qA/8x3qQdNdaodHCr0eE0GAtxigSH4TPjOKKEAO/Bfs=;
        b=yTcgxVv5xnN6FJi+ORQzlz6vau8+1mowWfm4xWV7+tRilP8R1pp7r2blxMovsaU9dw
         G7q08tOeuCHieA88tqcVOI664eu6JoUcCuS2RCS0+daHrqOPLD+bgYd3PItoWq4xE1LQ
         HSnyEcrB7QcC2PJ3x+50gqo1BJBqtGSWrsSg2WjFOINYgGtsyH6RQ5K6bLaPz9g8XqPs
         6SEvntKD+/SZl3BgcbEQZTwX+oKOzqcoBInz7tR9w4xOTLS1ho+ZRpDNpLxqN30vbeBj
         l4EMgdll5K3roSPmsGNkvpLTCyIvwNzA4gVTQhsn7YZV++H1Jiz7C0hDFw6XjnMFCpRa
         j6Vg==
Content-Language: en-US
In-Reply-To: <20221208220141.2625775-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 12/8/22 3:01?PM, Waiman Long wrote:
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index 793ecff29038..910e633869b0 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -281,6 +281,26 @@ void cgroup_rstat_flush_release(void)
>  	spin_unlock_irq(&cgroup_rstat_lock);
>  }
>  
> +/**
> + * cgroup_rstat_css_cpu_flush - flush stats for the given css and cpu
> + * @css: target css to be flush
> + * @cpu: the cpu that holds the stats to be flush
> + *
> + * A lightweight rstat flush operation for a given css and cpu.
> + * Only the cpu_lock is being held for mutual exclusion, the cgroup_rstat_lock
> + * isn't used.
> + */
> +void cgroup_rstat_css_cpu_flush(struct cgroup_subsys_state *css, int cpu)
> +{
> +	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
> +
> +	raw_spin_lock_irq(cpu_lock);
> +	rcu_read_lock();
> +	css->ss->css_rstat_flush(css, cpu);
> +	rcu_read_unlock();
> +	raw_spin_unlock_irq(cpu_lock);
> +}
> +
>  int cgroup_rstat_init(struct cgroup *cgrp)
>  {
>  	int cpu;

As I mentioned last time, raw_spin_lock_irq() will be equivalent to an
RCU protected section anyway, so you don't need to do both. Just add a
comment on why rcu_read_lock()/rcu_read_unlock() isn't needed inside the
raw irq safe lock.

-- 
Jens Axboe

