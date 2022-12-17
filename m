From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 3/8] cpuset: Rebuild root domain deadline accounting
 information
Date: Fri, 16 Dec 2022 21:26:20 -0500
Message-ID: <af29b121-b1da-64f3-a739-1b233fa04002@redhat.com>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
 <20190719140000.31694-4-juri.lelli@redhat.com>
 <20221216233501.gh6m75e7s66dmjgo@airbuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671243985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ji+gytidbXOMWyPvLX4LLTm6QX/OlsVTfQzF/90xBXs=;
        b=MXI2utrq6URdh6bfTl9jqQNgccUlFLaPsw157Cflrqr3gTb4XGWRx2mzTVVjYbCXcZc9Ug
        6Z3ltm26By35qYCFACxEKzr2/ZNxGHvmBvJr7dWLqnDyfjHH+9cCL51SUZiwuhGTBEJj0a
        KzO3urTPvxj9o244UXmXMTI3+Oi9GdE=
Content-Language: en-US
In-Reply-To: <20221216233501.gh6m75e7s66dmjgo@airbuntu>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/16/22 18:35, Qais Yousef wrote:
> Hi
>
> On 07/19/19 15:59, Juri Lelli wrote:
>> When the topology of root domains is modified by CPUset or CPUhotplug
>> operations information about the current deadline bandwidth held in the
>> root domain is lost.
>>
>> This patch addresses the issue by recalculating the lost deadline
>> bandwidth information by circling through the deadline tasks held in
>> CPUsets and adding their current load to the root domain they are
>> associated with.
>>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
> We see that rebuild_root_domain() can take 10+ ms (I get a max of 20ms quite
> consistently) on suspend/resume.
>
> Do we actually need to rebuild_root_domain() if we're going through
> a suspend/resume cycle?
>
> ie: would something like the below make sense? We'd skip this logic if
> cpuhp_tasks_frozen is set which indicates it's not a real hotplug operation but
> we're suspending/resuming.
>
>
> Cheers
>
> --
> Qais Yousef
>
>
> --->8---
>
>
>  From 4cfd50960ad872c5eb810ad3038eaf840bab5182 Mon Sep 17 00:00:00 2001
> From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
> Date: Tue, 29 Nov 2022 19:01:52 +0000
> Subject: [PATCH] sched: cpuset: Don't rebuild sched domains on suspend-resume
>
> Commit f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
> enabled rebuilding sched domain on cpuset and hotplug operations to
> correct deadline accounting.
>
> Rebuilding sched domain is a slow operation and we see 10+ ms delays
> on suspend-resume because of that.
>
> Since nothing is expected to change on suspend-resume operation; skip
> rebuilding the sched domains to regain some of the time lost.
>
> Debugged-by: Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Qais Yousef (Google) <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c  | 6 ++++++
>   kernel/sched/deadline.c | 3 +++
>   2 files changed, 9 insertions(+)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b474289c15b8..2ff68d625b7b 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1067,6 +1067,9 @@ static void update_tasks_root_domain(struct cpuset *cs)
>   	struct css_task_iter it;
>   	struct task_struct *task;
>   
> +	if (cpuhp_tasks_frozen)
> +		return;
> +
>   	css_task_iter_start(&cs->css, 0, &it);
>   
>   	while ((task = css_task_iter_next(&it)))
> @@ -1084,6 +1087,9 @@ static void rebuild_root_domains(void)
>   	lockdep_assert_cpus_held();
>   	lockdep_assert_held(&sched_domains_mutex);
>   
> +	if (cpuhp_tasks_frozen)
> +		return;
> +
>   	rcu_read_lock();
>   
>   	/*

rebuild_root_domains() is the only caller of update_tasks_root_domain(). 
So the first hunk is redundant as update_tasks_root_domain() won't be 
called when cpuhp_tasks_frozen is set.

Cheers,
Longman

