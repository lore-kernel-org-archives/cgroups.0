From: Qais Yousef <qyousef@layalina.io>
Subject: Re: [PATCH 1/6] cgroup/cpuset: Rename functions dealing with
 DEADLINE accounting
Date: Tue, 4 Apr 2023 21:05:37 +0100
Message-ID: <20230404200537.l57oqyixbneuvxis@airbuntu>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329125558.255239-2-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1680638739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qFPo6vLpdwROFw5FNiJbZtKSQ4a0CmbJfxVbod1mMGg=;
        b=fno1tiY9rBhhOuM2df2ewT0wd3fPnGEDZeT7u2R/9NgBGXE4sBFyZUoEsTJj552o2G
         eBw3h3aQX+R2r9UFRTstZ3pkQO5kG0ZydD18fzZyFwrCk4k58DtKBcFm+oQlRZVOUyQS
         ZZWycYR/GLxiimAq/G77KpUhr6DTOdqsvnzWPxHUlvEX79eQBcT8oGHsBFhRdV9SyTup
         +mRJLBiyBqEMcRF9eqs+Oot7YfHVyg/56WeCk1+tSak91mLav/Dc2dbjkPnFskA0mswW
         a9Nyp3WBw0lFRQ9Zr2n+/g2+B/3US2I7YsD6dQOyfe3swaIM5sH1VtuUdg3c7sZ6P5hw
         zQlA==
Content-Disposition: inline
In-Reply-To: <20230329125558.255239-2-juri.lelli@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.c>

On 03/29/23 14:55, Juri Lelli wrote:
> rebuild_root_domains() and update_tasks_root_domain() have neutral
> names, but actually deal with DEADLINE bandwidth accounting.
> 
> Rename them to use 'dl_' prefix so that intent is more clear.
> 
> No functional change.
> 
> Suggested-by: Qais Yousef <qyousef@layalina.io>
> Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
> ---

Reviewed-by: Qais Yousef <qyousef@layalina.io>
Tested-by: Qais Yousef <qyousef@layalina.io>


Thanks!

--
Qais Yousef

>  kernel/cgroup/cpuset.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 636f1c682ac0..501913bc2805 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1066,7 +1066,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
>  	return ndoms;
>  }
>  
> -static void update_tasks_root_domain(struct cpuset *cs)
> +static void dl_update_tasks_root_domain(struct cpuset *cs)
>  {
>  	struct css_task_iter it;
>  	struct task_struct *task;
> @@ -1079,7 +1079,7 @@ static void update_tasks_root_domain(struct cpuset *cs)
>  	css_task_iter_end(&it);
>  }
>  
> -static void rebuild_root_domains(void)
> +static void dl_rebuild_rd_accounting(void)
>  {
>  	struct cpuset *cs = NULL;
>  	struct cgroup_subsys_state *pos_css;
> @@ -1107,7 +1107,7 @@ static void rebuild_root_domains(void)
>  
>  		rcu_read_unlock();
>  
> -		update_tasks_root_domain(cs);
> +		dl_update_tasks_root_domain(cs);
>  
>  		rcu_read_lock();
>  		css_put(&cs->css);
> @@ -1121,7 +1121,7 @@ partition_and_rebuild_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
>  {
>  	mutex_lock(&sched_domains_mutex);
>  	partition_sched_domains_locked(ndoms_new, doms_new, dattr_new);
> -	rebuild_root_domains();
> +	dl_rebuild_rd_accounting();
>  	mutex_unlock(&sched_domains_mutex);
>  }
>  
> -- 
> 2.39.2
> 
