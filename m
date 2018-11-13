From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Tue, 13 Nov 2018 16:48:25 +0100
Message-ID: <20181113154825.GC30990@redhat.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181112230422.5911-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On 11/12, Roman Gushchin wrote:
>
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -83,7 +83,8 @@ struct task_group;
>  #define TASK_WAKING			0x0200
>  #define TASK_NOLOAD			0x0400
>  #define TASK_NEW			0x0800
> -#define TASK_STATE_MAX			0x1000
> +#define TASK_FROZEN			0x1000
> +#define TASK_STATE_MAX			0x2000

Just noticed the new task state... Why? Can't we avoid it?

...

> +void cgroup_freezer_enter(void)
> +{
> +	long state = current->state;

Why? it must be TASK_RUNNING?

If not set_current_state() at the end is simply wrong... Yes, __refrigerator()
does this, but at least it has a reason although it is wrong too.

> +	struct cgroup *cgrp;
> +
> +	if (!current->frozen) {
> +		spin_lock_irq(&css_set_lock);
> +		current->frozen = true;
> +		cgrp = task_dfl_cgroup(current);
> +		cgrp->freezer.nr_frozen_tasks++;
> +
> +		WARN_ON_ONCE(cgrp->freezer.nr_tasks_to_freeze <
> +			     cgrp->freezer.nr_frozen_tasks);
> +
> +		if (cgrp->freezer.nr_tasks_to_freeze ==
> +		    cgrp->freezer.nr_frozen_tasks)
> +			cgroup_queue_notify_frozen(cgrp);
> +		spin_unlock_irq(&css_set_lock);
> +	}
> +
> +	/* refrigerator */
> +	set_current_state(TASK_WAKEKILL | TASK_INTERRUPTIBLE | TASK_FROZEN);

Why not __set_current_state() ?

If ->state include TASK_INTERRUPTIBLE, why do we need TASK_WAKEKILL?

And again, why TASK_FROZEN?

> +	clear_thread_flag(TIF_SIGPENDING);
> +	schedule();
> +	recalc_sigpending();

I simply can't understand these 3 lines above but I bet this is not correct ;)

if nothing else recalc_sigpending() without ->siglock is wrong, it can race
with signal_wakeup/etc.

> +	set_current_state(state);

see above...

Oleg.

