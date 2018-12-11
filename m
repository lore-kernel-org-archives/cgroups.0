From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v5 4/7] cgroup: cgroup v2 freezer
Date: Tue, 11 Dec 2018 17:26:32 +0100
Message-ID: <20181211162632.GB8504@redhat.com>
References: <20181207201531.1665-1-guro@fb.com>
 <20181207201531.1665-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181207201531.1665-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On 12/07, Roman Gushchin wrote:
>
> Cgroup v2 freezer tries to put tasks into a state similar to jobctl
> stop. This means that tasks can be killed, ptraced (using
> PTRACE_SEIZE*), and interrupted. It is possible to attach to
> a frozen task, get some information (e.g. read registers) and detach.

I fail to understand how this all supposed to work.

> @@ -368,6 +369,8 @@ static inline int signal_pending_state(long state, struct task_struct *p)
>  		return 0;
>  	if (!signal_pending(p))
>  		return 0;
> +	if (unlikely(cgroup_task_frozen(p) && p->jobctl == JOBCTL_TRAP_FREEZE))
> +		return __fatal_signal_pending(p);

I think I will never agree with this change ;) and I don't think it actually helps.

> +void cgroup_enter_frozen(void)
> +{
> +	if (!current->frozen) {
> +		spin_lock_irq(&css_set_lock);
> +		current->frozen = true;
> +		cgroup_inc_frozen_cnt(task_dfl_cgroup(current), false, true);
> +		spin_unlock_irq(&css_set_lock);
> +	}
> +
> +	__set_current_state(TASK_INTERRUPTIBLE);
> +	schedule();

So once again, suppose it races with PTRACE_INTERRUPT, or SIGSTOP, or something
else which should be handled by get_signal() before do_freezer_trap().

If (say) PTRACE_INTERRUPT comes before schedule it will be lost. Otherwise
the frozen task will react. This can't be right. Or I am totally confused.

Perhaps you can split this patch? start with cgroup_enter_frozen() using
TASK_KILLABLE, then teach it to handle ptrace/stop/etc? I think this way it
would be simpler to discuss the necessary changes and document what exactly
are you trying to do.

and btw.... what about suspend? try_to_freeze_tasks() will obviously fail
if there is a ->frozen thread?

Oleg.

