From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 6/7] cgroup/cpuset: Protect DL BW data against parallel
 cpuset_attach()
Date: Thu, 30 Mar 2023 15:34:02 +0200
Message-ID: <67eeb47c-ae23-1389-bb52-f9cfb3206741@arm.com>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329160240.2093277-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <20230329160240.2093277-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>

On 29/03/2023 18:02, Waiman Long wrote:
> It is possible to have parallel attach operations to the same cpuset in
> progress. To avoid possible corruption of single set of DL BW data in
> the cpuset structure, we have to disallow parallel attach operations if
> DL tasks are present. Attach operations can still proceed in parallel
> as long as no DL tasks are involved.
> 
> This patch also stores the CPU where DL BW is allocated and free that BW
> back to the same CPU in case cpuset_can_attach() is called.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cpuset.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 05c0a1255218..555a6b1a2b76 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -199,6 +199,7 @@ struct cpuset {
>  	 */
>  	int nr_deadline_tasks;
>  	int nr_migrate_dl_tasks;
> +	int dl_bw_cpu;

Like I mentioned in
https://lkml.kernel.org/r/cdede77a-5dc5-8933-a444-a2046b074b12-5wv7dgnIgG8@public.gmane.org
IMHO any CPU of the cpuset is fine since exclusive cpuset and related
root_domain (as the container for DL BW accounting data) are congruent
in terms of cpumask.

>  	u64 sum_migrate_dl_bw;
>  
>  	/* Invalid partition error code, not lock protected */
> @@ -2502,6 +2503,16 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>  	if (cpumask_empty(cs->effective_cpus))
>  		goto out_unlock;
>  
> +	/*
> +	 * If there is another parallel attach operations in progress for
> +	 * the same cpuset, the single set of DL data there may get
> +	 * incorrectly overwritten. So parallel operations are not allowed
> +	 * if DL tasks are present.
> +	 */
> +	ret = -EBUSY;
> +	if (cs->nr_migrate_dl_tasks)
> +		goto out_unlock;

(1)

>  	cgroup_taskset_for_each(task, css, tset) {
>  		ret = task_can_attach(task);
>  		if (ret)
> @@ -2511,6 +2522,9 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>  			goto out_unlock;
>  
>  		if (dl_task(task)) {
> +			if (cs->attach_in_progress)
> +				goto out_unlock;

(2)

Just to check if I get this right, 2 bail-out conditions are necessary
because:

(1) is to prevent any new cs attach if there is already a DL cs attach
and (2) is to prevent a new DL cs attach if there is already a non-DL cs
attach.

>  			cs->nr_migrate_dl_tasks++;
>  			cs->sum_migrate_dl_bw += task->dl.dl_bw;
>  		}

[...]

