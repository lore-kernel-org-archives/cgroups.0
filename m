From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] sched: cpuset: Don't rebuild sched domains on
 suspend-resume
Date: Fri, 20 Jan 2023 17:16:55 -0500
Message-ID: <c4c2dec6-a72b-d675-fb42-be40e384ea2c@redhat.com>
References: <20230120194822.962958-1-qyousef@layalina.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674253020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PymHzUQySveMLAeF0IwXdw52bO+MwC9kbQnHrMu8WUY=;
        b=CW6Ozsn7//fTUgxjZQSr5IOxvgVYkfJdQ7448gAJZN/FAouMSRAZJ2Vf3oZlasD6qydlCk
        5ppD7tIKWvAcuHBKJ3Kt+uoTmp3vR/5sFL1gis3uH8jgATu+OhZn98mCV5UhwWnsZh9S8X
        DqQTIpAVpXTDCU5ussFdjn7DkgIw39M=
Content-Language: en-US
In-Reply-To: <20230120194822.962958-1-qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


On 1/20/23 14:48, Qais Yousef wrote:
> Commit f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
> enabled rebuilding sched domain on cpuset and hotplug operations to
> correct deadline accounting.
>
> Rebuilding sched domain is a slow operation and we see 10+ ms delay on
> suspend-resume because of that.
>
> Since nothing is expected to change on suspend-resume operation; skip
> rebuilding the sched domains to regain the time lost.
>
> Debugged-by: Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Qais Yousef (Google) <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
> ---
>
>      Changes in v2:
>      
>      	* Remove redundant check in update_tasks_root_domain() (Thanks Waiman)
>      
>      v1 link:
>      
>      	https://lore.kernel.org/lkml/20221216233501.gh6m75e7s66dmjgo@airbuntu/
>
>   kernel/cgroup/cpuset.c  | 3 +++
>   kernel/sched/deadline.c | 3 +++
>   2 files changed, 6 insertions(+)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index a29c0b13706b..9a45f083459c 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1088,6 +1088,9 @@ static void rebuild_root_domains(void)
>   	lockdep_assert_cpus_held();
>   	lockdep_assert_held(&sched_domains_mutex);
>   
> +	if (cpuhp_tasks_frozen)
> +		return;
> +
>   	rcu_read_lock();
>   
>   	/*
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 0d97d54276cc..42c1143a3956 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -2575,6 +2575,9 @@ void dl_clear_root_domain(struct root_domain *rd)
>   {
>   	unsigned long flags;
>   
> +	if (cpuhp_tasks_frozen)
> +		return;
> +
>   	raw_spin_lock_irqsave(&rd->dl_bw.lock, flags);
>   	rd->dl_bw.total_bw = 0;
>   	raw_spin_unlock_irqrestore(&rd->dl_bw.lock, flags);

cpuhp_tasks_frozen is set when thaw_secondary_cpus() or 
freeze_secondary_cpus() is called. I don't know the exact suspend/resume 
calling sequences, will cpuhp_tasks_frozen be cleared at the end of 
resume sequence? Maybe we should make sure that rebuild_root_domain() is 
called at least once at the end of resume operation.

Cheers,
Longman

