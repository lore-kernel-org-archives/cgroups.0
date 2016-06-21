From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] cgroup: Add pids controller event when fork fails
 because of pid limit
Date: Tue, 21 Jun 2016 00:44:29 -0400
Message-ID: <20160621044429.GA19501@cmpxchg.org>
References: <1466478562-1997086-1-git-send-email-kennyyu@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466478562-1997086-1-git-send-email-kennyyu@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Yu <kennyyu@fb.com>
Cc: tj@kernel.org, lizefan@huawei.com, cyphar@cyphar.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, Jun 20, 2016 at 08:09:22PM -0700, Kenny Yu wrote:
> Summary:
> This patch adds more visibility into the pids controller when the controller
> rejects a fork request. Whenever fork fails because the limit on the number of
> pids in the cgroup is reached, the controller will log this and also notify the
> newly added cgroups events file. The `max` key in the events file represents
> the number of times fork failed because of the pids controller.
> 
> This change also adds an atomic boolean to prevent logging too much (e.g. a fork
> bomb). The message is logged once per cgroup until the next time the pids limit
> changes.
> 
> Signed-off-by: Kenny Yu <kennyyu@fb.com>

This makes sense to me. Hitting the cgroup PID limit right now is
somewhat ominous. A little more visibility would help.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

One comment below, but mostly a matter of preference:

> @@ -205,6 +219,17 @@ static void pids_cancel_attach(struct cgroup_taskset *tset)
>  	}
>  }
>  
> +static void pids_fork_failed_event(struct pids_cgroup *pids)
> +{
> +	atomic64_inc(&pids->events_limit);
> +	cgroup_file_notify(&pids->events_file);
> +	if (!atomic_xchg(&pids->events_limit_logged, 1)) {
> +		pr_info("cgroup: fork rejected by pids controller in ");
> +		pr_cont_cgroup_path(task_cgroup(current, pids_cgrp_id));
> +		pr_cont("\n");
> +	}
> +}
> +
>  /*
>   * task_css_check(true) in pids_can_fork() and pids_cancel_fork() relies
>   * on threadgroup_change_begin() held by the copy_process().
> @@ -213,10 +238,14 @@ static int pids_can_fork(struct task_struct *task)
>  {
>  	struct cgroup_subsys_state *css;
>  	struct pids_cgroup *pids;
> +	int err;
>  
>  	css = task_css_check(current, pids_cgrp_id, true);
>  	pids = css_pids(css);
> -	return pids_try_charge(pids, 1);
> +	err = pids_try_charge(pids, 1);
> +	if (err)
> +		pids_fork_failed_event(pids);

That function call/name seems somewhat clunky. Maybe it would be
better to inline its body directly into pids_try_charge() before
return -EAGAIN?
