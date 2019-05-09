From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] cgroup: never call do_group_exit() with task->frozen bit
 set
Date: Thu, 9 May 2019 15:54:51 +0200
Message-ID: <20190509135450.GA24526@redhat.com>
References: <20190508203420.580163-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190508203420.580163-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>

On 05/08, Roman Gushchin wrote:
>
> To resolve this problem, let's move cgroup_leave_frozen(true) call to
> just after the fatal label. If the task is going to die, the frozen
> bit must be cleared no matter how we get into this point.

OK, agreed, better than nothing.

but please see my previous email. enter_frozen() in ptrace_stop() is not safe
anyway. In fact somehow I thought it does leave_frozen(), iirc this was true
in the earlier versions...

> 
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Reported-by: Qian Cai <cai@lca.pw>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---
>  kernel/signal.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 16b72f4f14df..8607b11ff936 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2483,10 +2483,6 @@ bool get_signal(struct ksignal *ksig)
>  		ksig->info.si_signo = signr = SIGKILL;
>  		sigdelset(&current->pending.signal, SIGKILL);
>  		recalc_sigpending();
> -		current->jobctl &= ~JOBCTL_TRAP_FREEZE;
> -		spin_unlock_irq(&sighand->siglock);
> -		if (unlikely(cgroup_task_frozen(current)))
> -			cgroup_leave_frozen(true);
>  		goto fatal;
>  	}
>  
> @@ -2608,8 +2604,10 @@ bool get_signal(struct ksignal *ksig)
>  			continue;
>  		}
>  
> -		spin_unlock_irq(&sighand->siglock);
>  	fatal:
> +		spin_unlock_irq(&sighand->siglock);
> +		if (unlikely(cgroup_task_frozen(current)))
> +			cgroup_leave_frozen(true);
>  
>  		/*
>  		 * Anything else is fatal, maybe with a core dump.
> -- 
> 2.20.1
> 

