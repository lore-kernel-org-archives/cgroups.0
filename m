From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 4/7] cgroup: cgroup v2 freezer
Date: Wed, 20 Feb 2019 15:42:02 +0100
Message-ID: <20190220144202.GB9477@redhat.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190219220252.4906-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190219220252.4906-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On 02/19, Roman Gushchin wrote:
>
> @@ -2065,6 +2066,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, kernel_siginfo_t
>  		preempt_disable();
>  		read_unlock(&tasklist_lock);
>  		preempt_enable_no_resched();
> +		cgroup_enter_stopped();
>  		freezable_schedule();
>  	} else {
>  		/*
> @@ -2243,6 +2245,7 @@ static bool do_signal_stop(int signr)
>  		}
>  
>  		/* Now we don't run again until woken by SIGCONT or SIGKILL */
> +		cgroup_enter_stopped();
>  		freezable_schedule();
>  		return true;

Please see my reply to 0/7.

> @@ -2280,7 +2286,8 @@ static void do_jobctl_trap(void)
>  		    !(signal->flags & SIGNAL_STOP_STOPPED))
>  			signr = SIGTRAP;
>  		WARN_ON_ONCE(!signr);
> -		ptrace_do_notify(signr, signr | (PTRACE_EVENT_STOP << 8),
> +		ptrace_do_notify(signr,
> +				 signr | (PTRACE_EVENT_STOP << 8),
>  				 CLD_STOPPED);

white-space cleanup?

> @@ -2363,7 +2419,8 @@ bool get_signal(struct ksignal *ksig)
>  	 * we should notify the parent, prepare_signal(SIGCONT) encodes
>  	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
>  	 */
> -	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
> +	if (unlikely(signal->flags & SIGNAL_CLD_MASK) &
> +	    !(current->jobctl & JOBCTL_TRAP_FREEZE)) {

Hmm, why?

Oleg.

