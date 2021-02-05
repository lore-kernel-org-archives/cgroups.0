From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH] cpu/hotplug: wait for cpuset_hotplug_work to finish on
 cpu onlining
Date: Thu, 04 Feb 2021 20:35:34 -0500
Message-ID: <87blczz47t.fsf@oracle.com>
References: <20210204010157.1823669-1-aklimov@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9mUzFjaVs74qLb6Q14lutmjVoiosGF/lazrQY9m+wPc=;
 b=mAicFptooX7xaprci6Ni+42tLGgnB2YY14g0ePdwRTQpQZNqBFbiQ0j4V3OqtoCn5evr
 gy4kW7sZrtGWVkO9zGW3MPfIuUbNw9ankbH3CXQMG3LFWgThVHrEFPsWsGfZzY+fUVOw
 LSZbk3z4j1czSwLIiREKi9sfkTza4jJQ3arliQ0/4xBg2vcFdtm9iNM2VmY1Cp2gw+h2
 vFE1qLOpME/Vpn+YU5KfacOT3FBHcXz0XqiOBi6Izv68HhJDaajf0lwtfmOqnX2RDyjh
 whF0/22uQIlYIefDIRxqzns+ojZdGqoxjeK9dmzPVz3dgVvrlzzP7djdVRH8H1/IIzUK Sw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mUzFjaVs74qLb6Q14lutmjVoiosGF/lazrQY9m+wPc=;
 b=tOnD3hvCR8JpbPq1XO5OQ+8tsoUHc9lJKiK6qzaMJT7xdTZrO/5TsDnMYioAboVjk1Lna+8e6ssr/nKKVn+pnfrPIkLSAU4s95PKm0qirDKlGO49Yc0uyG+Ad8yGhAZk2ZY8stYy1yz44w+SFNuU2tv68x425/Z7HMbor7Dbu2Q=
In-Reply-To: <20210204010157.1823669-1-aklimov@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov@redhat.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: peterz@infradead.org, yury.norov@gmail.com, tglx@linutronix.de, jobaker@redhat.com, audralmitchel@gmail.com, arnd@arndb.de, gregkh@linuxfoundation.org, rafael@kernel.org, tj@kernel.org, lizefan@huawei.com, qais.yousef@arm.com, hannes@cmpxchg.org, klimov.linux@gmail.com

Alexey Klimov <aklimov@redhat.com> writes:

> When a CPU offlined and onlined via device_offline() and device_online()
> the userspace gets uevent notification. If, after receiving "online" uevent,
> userspace executes sched_setaffinity() on some task trying to move it
> to a recently onlined CPU, then it often fails with -EINVAL. Userspace needs
> to wait around 5..30 ms before sched_setaffinity() will succeed for the recently
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
> Out of line uevent can be avoided if we will ensure that cpuset_hotplug_work
> has run to completion using cpuset_wait_for_hotplug() after onlining the
> cpu in cpu_up() and in cpuhp_smt_enable().

Nice writeup.  I just have some nits, patch looks ok otherwise.

> @@ -1281,6 +1282,11 @@ static int cpu_up(unsigned int cpu, enum cpuhp_state target)
>  	err = _cpu_up(cpu, 0, target);
>  out:
>  	cpu_maps_update_done();
> +
> +	/* To avoid out of line uevent */

Not sure this will make sense out of context.  Maybe,

        /*
         * Wait for cpuset updates to cpumasks to finish.  Later on this path
         * may generate uevents whose consumers rely on the updates.
         */

> @@ -2062,8 +2068,6 @@ static void cpuhp_offline_cpu_device(unsigned int cpu)
>  	struct device *dev = get_cpu_device(cpu);
>  
>  	dev->offline = true;
>  }
>  
> @@ -2071,14 +2075,18 @@ static void cpuhp_online_cpu_device(unsigned int cpu)
>  	struct device *dev = get_cpu_device(cpu);
>  
>  	dev->offline = false;
>  }

You could get rid of these functions and just put the few remaining bits
in the callers.  They each have only one.
