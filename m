From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/12] cgroup: rstat: Make cgroup_rstat_cpu_lock name
 readable
Date: Wed, 9 Feb 2022 15:20:42 -0500
Message-ID: <4b58c74d-6ad6-3658-30fb-1957a7b212dc@redhat.com>
References: <20220208194324.85333-1-namhyung@kernel.org>
 <20220208194324.85333-3-namhyung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644438051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NifY2jezbBUetwsmzUwyvhafuJf4MPduuqMq0ll2twA=;
        b=LECQVvBRSXSKJqF2ca0hDy3MtXON62aIOLaJf4AU6uOWtIoVBqM8PZR+jEIp1AW1MC7iHD
        2IAAjKLe/wBIT+AOwDi6t+SusYVXADj8koRdR9mzRq8fGOZUhKRF7o8Ce7ziJ6efHt43Dq
        sPWFPyAfKQcZ38JJBl0HsaReodJgkdg=
Content-Language: en-US
In-Reply-To: <20220208194324.85333-3-namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 2/8/22 14:43, Namhyung Kim wrote:
> The raw_spin_lock_init() uses the argument to name its lockdep map.
> But passing per_cpu_ptr() macro directly makes it a very very long
> name as it expanded like below:
>
>    ({ do { const void *__vpp_verify = (typeof((&cgroup_rstat_cpu_lock) ...
>
> Let's fix it by passing a local variable instead.  With this change,
> the name now looks like:
>
>    cgrp_rstat_cpu_lock
>
> Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>   kernel/cgroup/rstat.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index 9d331ba44870..371f54a59c38 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -286,9 +286,17 @@ void cgroup_rstat_exit(struct cgroup *cgrp)
>   void __init cgroup_rstat_boot(void)
>   {
>   	int cpu;
> +	raw_spinlock_t *cgrp_rstat_cpu_lock;
>   
> -	for_each_possible_cpu(cpu)
> -		raw_spin_lock_init(per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu));
> +	for_each_possible_cpu(cpu) {
> +		/*
> +		 * raw_spin_lock_init() uses the argument to name the lock in
> +		 * lockdep results.  Passing per_cpu_ptr() directly created a
> +		 * cryptic name as the macro was expanded before stringified.
> +		 */
> +		cgrp_rstat_cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
> +		raw_spin_lock_init(cgrp_rstat_cpu_lock);
> +	}
>   }
>   
>   /*

That is a standalone fix. Maybe Tejun can take it directly into the 
cgroup tree.

Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

