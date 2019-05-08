From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: ptrace warning due to "cgroup: get rid of
 cgroup_freezer_frozen_exit()"
Date: Wed, 8 May 2019 17:25:36 +0200
Message-ID: <20190508152536.GA17058@redhat.com>
References: <1557259462.6132.20.camel@lca.pw>
 <20190507213752.GA24308@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190507213752.GA24308@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Qian Cai <cai@lca.pw>, "tj@kernel.org" <tj@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 05/07, Roman Gushchin wrote:
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2484,9 +2484,6 @@ bool get_signal(struct ksignal *ksig)
>                 sigdelset(&current->pending.signal, SIGKILL);
>                 recalc_sigpending();
>                 current->jobctl &= ~JOBCTL_TRAP_FREEZE;

just noticed... perhaps it makes more sense to clear JOBCTL_TRAP_FREEZE
before recalc_sigpending(). Or simply not clear it at all, see below.

> -               spin_unlock_irq(&sighand->siglock);
> -               if (unlikely(cgroup_task_frozen(current)))
> -                       cgroup_leave_frozen(true);
>                 goto fatal;
>         }
>  
> @@ -2608,8 +2605,10 @@ bool get_signal(struct ksignal *ksig)
>                         continue;
>                 }
>  
> -               spin_unlock_irq(&sighand->siglock);
>         fatal:
> +               spin_unlock_irq(&sighand->siglock);
> +               if (unlikely(cgroup_task_frozen(current)))
> +                       cgroup_leave_frozen(true);

Yes, ptrace_signal() can return a fatal signal... and in this case we do not
clear JOBCTL_TRAP_FREEZE. This doesn't look consistent with the code above.



I can only repeat that somehow we need to cleanup/improve the whole logic.

Say, a traced task reports syscall-enter. ptrace_stop() does enter_frozen().
The cgroup can become CGRP_FROZEN after that. Now the debugger does PTRACE_CONT,
the frozen task actually starts the syscall. Obviously not good.

Heh, and if this syscall is sys_exit or sys_exit_group we can hit the same
warning.

Oleg.

