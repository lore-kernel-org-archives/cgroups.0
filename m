From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 3/6] sched,perf,kvm: Fix preemption condition
Date: Wed, 2 Jun 2021 09:59:07 -0400 (EDT)
Message-ID: <1873020549.5854.1622642347895.JavaMail.zimbra@efficios.com>
References: <20210602131225.336600299@infradead.org> <20210602133040.398289363@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 2A108302BA9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1622642348;
        bh=3NQkpeJ7B+hKtKJgR6oI37w8WcTETaBafQ5/DPMEWwI=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=ZlLvrNpb7FSQdBC5tIEKb93seCOYMQlGgXqNDCt4mx931pzNw8PkQPGTIAknvIKON
         NpDSBJXZebM5bdDBEXJUhkVKv214RxCfD9cnMAu+E9jlJUbxCT0sSH9pfYpV4sduq4
         x3/Ha4HOzhfJ5u6uVpyJg0D3SZEpnzu++L3CaXS5k4TUIGuZ+VTcOcX9C3+gYxGHL4
         vP87muDZtj763iw70P68DkCsJf/o77PvwVPhmezDZ6qbVfVNe7D4w95pMohMEmylCc
         wLPLpR4HOsL54+3PlAjOEK3N1Uw5WtMxdLnoo8ef/7RMfiFuOK3kBtQodyzCCa6QyK
         u+WAXvtkoLOCw==
In-Reply-To: <20210602133040.398289363@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, bristot <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <liz>

----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:

> When ran from the sched-out path (preempt_notifier or perf_event),
> p->state is irrelevant to determine preemption. You can get preempted
> with !task_is_running() just fine.
> 
> The right indicator for preemption is if the task is still on the
> runqueue in the sched-out path.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
> kernel/events/core.c |    7 +++----
> virt/kvm/kvm_main.c  |    2 +-
> 2 files changed, 4 insertions(+), 5 deletions(-)
> 
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -8568,13 +8568,12 @@ static void perf_event_switch(struct tas
> 		},
> 	};
> 
> -	if (!sched_in && task->state == TASK_RUNNING)
> +	if (!sched_in && current->on_rq) {

This changes from checking task->state to current->on_rq, but this change
from "task" to "current" is not described in the commit message, which is odd.

Are we really sure that task == current here ?

Thanks,

Mathieu

> 		switch_event.event_id.header.misc |=
> 				PERF_RECORD_MISC_SWITCH_OUT_PREEMPT;
> +	}
> 
> -	perf_iterate_sb(perf_event_switch_output,
> -		       &switch_event,
> -		       NULL);
> +	perf_iterate_sb(perf_event_switch_output, &switch_event, NULL);
> }
> 
> /*
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4869,7 +4869,7 @@ static void kvm_sched_out(struct preempt
> {
> 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
> 
> -	if (current->state == TASK_RUNNING) {
> +	if (current->on_rq) {
> 		WRITE_ONCE(vcpu->preempted, true);
> 		WRITE_ONCE(vcpu->ready, true);
>  	}

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
