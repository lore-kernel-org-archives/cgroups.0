From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] cpu/hotplug: wait for cpuset_hotplug_work to finish
 on cpu onlining
Date: Thu, 18 Mar 2021 15:28:09 -0400
Message-ID: <877dm4uura.fsf@oracle.com>
References: <20210317003616.2817418-1-aklimov@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=uOQfgSt7DnQHzU9CkYe3OcxfQ5H3Z/rsIPYYFJiCANs=;
 b=QJH9dy+su5JGPKj1DYwDoSiq3eVLBtHQ/Q1NqpXZTK/YXViWnsNsSnZ+4l1k2CvUFrzX
 GOhecQRvRfk3rZZWPZvKRu3Tby3c4Sf8stkcR6ueU3zPqsuznNaHX7IgwcWvK0R8I3oS
 rWY9mF8C4Uwi6DIeH/V1d/WWCWb8vWxM7yq0LidQINkzdnAfZb8chj11vBhcw6D5CEhB
 ALwJ/tvdhdEY3ILNNviss+a39QtEp+jhLRz4GiFDGnQ8JhBxwLRtzkNN4tXu+SpzsUuq
 uXkKnCwWuG31WQbCMhbmdScfUkGXVQnJMCLGMVaRxcUEE0L9tG3YfCc0RYD77ElkXPf3 /A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOQfgSt7DnQHzU9CkYe3OcxfQ5H3Z/rsIPYYFJiCANs=;
 b=JstB/y8hptP2LlfLQBpvfgrlbZ483A2DKvjGkP/egrrAV7A0keULTYrNCsM9jda338ytDlplXK+LNpPJVHzGgPScAb9635N7PWzz2JCjqLJd5FzSGi2K7e2dpahMBziShrvWa24fBofOB4IvHDHKhOgs5I0iz6U6JUmXQAyzAnE=
In-Reply-To: <20210317003616.2817418-1-aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qais.yousef-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> When a CPU offlined and onlined via device_offline() and device_online()
> the userspace gets uevent notification. If, after receiving "online" uevent,
> userspace executes sched_setaffinity() on some task trying to move it
> to a recently onlined CPU, then it sometimes fails with -EINVAL. Userspace
> needs to wait around 5..30 ms before sched_setaffinity() will succeed for
> recently onlined CPU after receiving uevent.
>
> If in_mask argument for sched_setaffinity() has only recently onlined CPU,
> it could fail with such flow:
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
>
> Out of line uevent can be avoided if we will ensure that cpuset_hotplug_work
> has run to completion using cpuset_wait_for_hotplug() after onlining the
> cpu in cpu_device_up() and in cpuhp_smt_enable().
>
> Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
> Co-analyzed-by: Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks good to me.

Reviewed-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
