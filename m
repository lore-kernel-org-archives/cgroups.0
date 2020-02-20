From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 1/3] loop: Use worker per cgroup instead of kworker
Date: Thu, 20 Feb 2020 12:50:02 -0500
Message-ID: <20200220175002.GJ54486@cmpxchg.org>
References: <cover.1582216294.git.schatzberg.dan@gmail.com>
 <118a1bd99d12f1980c7fc01ab732b40ffd8f0537.1582216294.git.schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9LcvSEumTmXyuKFplLOO57e96BKQQeEk4RY39TL+hio=;
        b=VHirKNJDDO682guKBEd7Lh4Sdhh51LWyOruN25/r3aHd6uttqamXF0Y2SA7SURFcGF
         9L68VvTMCycQxV8a8PVSRKwVlrRBX6dROpPZI2+TYVXxntJtO4mJrARFdxtJn8K2f0LX
         7jmviilTZKEOD7cXwUqgwwYTXTAlVCWI4H8HphGY1AyOS0JkzhcsRMoHBwScPbu+Eghl
         lr3mqrpjO/hI6Mqqpdz1bwAZpagS8xbsNMtYg/gVu4+EkG2nZ7e+seyK7JK9UOIIsSbW
         iktcaKz88wwRW8q1+2Iz7hLBH+IFUEheTfhVWoJQBx196zKDvstwAtnve1heQWmWVFey
         OZHA==
Content-Disposition: inline
In-Reply-To: <118a1bd99d12f1980c7fc01ab732b40ffd8f0537.1582216294.git.schatzberg.dan@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

Hello Dan,

On Thu, Feb 20, 2020 at 11:51:51AM -0500, Dan Schatzberg wrote:
> +static void loop_process_work(struct loop_worker *worker,
> +			struct list_head *cmd_list, struct loop_device *lo)
> +{
> +	int orig_flags = current->flags;
> +	struct loop_cmd *cmd;
> +
> +	current->flags |= PF_LESS_THROTTLE | PF_MEMALLOC_NOIO;
> +	while (1) {
> +		spin_lock_irq(&lo->lo_lock);
> +		if (list_empty(cmd_list))
> +			break;
> +
> +		cmd = container_of(
> +			cmd_list->next, struct loop_cmd, list_entry);
> +		list_del(cmd_list->next);
> +		spin_unlock_irq(&lo->lo_lock);
> +		loop_handle_cmd(cmd);
> +		cond_resched();
> +	}

The loop structure tripped me up, because it's not immediately obvious
that the lock will be held coming out. How about the following to make
the lock section stand out visually?

	spin_lock_irq(&lo->lo_lock);
	while (!list_empty(cmd_list)) {
		cmd = container_of(cmd_list->next, struct loop_cmd, list_entry);
		list_del(&cmd->list_entry);
		spin_unlock_irq(&lo->lo_lock);		

		loop_handle_cmd(cmd);
		cond_resched();

		spin_lock_irq(&lo->lo_lock);
	}

> -	loop_handle_cmd(cmd);
> +	/*
> +	 * We only add to the idle list if there are no pending cmds
> +	 * *and* the worker will not run again which ensures that it
> +	 * is safe to free any worker on the idle list
> +	 */
> +	if (worker && !work_pending(&worker->work)) {
> +		worker->last_ran_at = jiffies;
> +		list_add_tail(&worker->idle_list, &lo->idle_worker_list);
> +		loop_set_timer(lo);
> +	}
> +	spin_unlock_irq(&lo->lo_lock);
> +	current->flags = orig_flags;
