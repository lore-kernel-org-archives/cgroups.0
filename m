From: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2] cpu/hotplug: wait for cpuset_hotplug_work to finish
 on cpu onlining
Date: Tue, 16 Feb 2021 18:29:25 +0000
Message-ID: <20210216182925.v2fe3foe6dgmiaj6@e107158-lin.cambridge.arm.com>
References: <20210212003032.2037750-1-aklimov@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210212003032.2037750-1-aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On 02/12/21 00:30, Alexey Klimov wrote:
> When a CPU offlined and onlined via device_offline() and device_online()
> the userspace gets uevent notification. If, after receiving "online" uevent,
> userspace executes sched_setaffinity() on some task trying to move it
> to a recently onlined CPU, then it often fails with -EINVAL. Userspace needs
> to wait around 5..30 ms before sched_setaffinity() will succeed for recently
> onlined CPU after receiving uevent.
> 
> If in_mask argument for sched_setaffinity() has only recently onlined CPU,
> it often fails with such flow:
> 
>   sched_setaffinity()
>     cpuset_cpus_allowed()
>       guarantee_online_cpus()   <-- cs->effective_cpus mask does not
>                                         contain recently onlined cpu
>     cpumask_and()               <-- final new_mask is empty
>     __set_cpus_allowed_ptr()
>       cpumask_any_and_distribute() <-- returns dest_cpu equal to nr_cpu_ids
>       returns -EINVAL
> 
> Cpusets used in guarantee_online_cpus() are updated using workqueue from
> cpuset_update_active_cpus() which in its turn is called from cpu hotplug callback
> sched_cpu_activate() hence it may not be observable by sched_setaffinity() if
> it is called immediately after uevent.

nit: newline

> Out of line uevent can be avoided if we will ensure that cpuset_hotplug_work
> has run to completion using cpuset_wait_for_hotplug() after onlining the
> cpu in cpu_device_up() and in cpuhp_smt_enable().
> 
> Co-analyzed-by: Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---

This looks good to me.

Reviewed-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>

Thanks
