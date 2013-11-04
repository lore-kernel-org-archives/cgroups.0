From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 4 Nov 2013 20:29:32 +0800
Message-ID: <5277932C.40400@huawei.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de> <5257F7CE.90702@huawei.com> <CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com> <5258E584.70500@huawei.com> <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com> <525CB337.8050105@huawei.com> <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com> <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com> <5270BFE7.4000602@huawei.com> <alpine.LNX.2.00.1310301606080.2333@eggly.anvils> <20131031130647.0ff6f2c7@gandalf.local.home> <alpine.LNX.2.00.1310311442030.2633@eggly.anvils> <20131031192732.2dbb14b3@gandalf.local.home> <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/11/4 19:00, Markus Blank-Burian wrote:
> I am sorry, but kdump crash files are difficult to obtain on our
> systems, since we are using nfsroot on diskless clients. Is there any
> possibility to see, why "synchronize_rcu" is actually waiting? I tried
> looking through the code but did not get very far. In any case, I am
> appending current stack dumps from kernel 3.11.6. With lockdep
> enabled, there were also no additional warnings in the kernel log.
> 
> The thread with "mem_cgroup_reparent_charges" is hanging at synchronize_rcu:
> 

synchronize_rcu() is a block operation and can keep us waiting for
a long period, so instead it's possible that usage never goes down
to 0 and we are in a dead loop.

As we don't have a clue, it's helpful to narrow down the cause.
Could you add a trace_print like this?

		...
                usage = res_counter_read_u64(&memcg->res, RES_USAGE) -
                        res_counter_read_u64(&memcg->kmem, RES_USAGE);
		trace_printk("usage: %llu\n", usage);
        } while (usage > 0);

When you hit the bug, see the output of trace_printk:

	cat /sys/kernel/debug/tracing/trace

I think tomorrow I'll try to manually revert percpu ref patch, and then
you can test if it fixes the bug.

> crash> bt -t 1200
> PID: 1200   TASK: ffff883ff9db9770  CPU: 56  COMMAND: "kworker/56:0"
>               START: __schedule at ffffffff813bb12c
>   [ffff883ef84ffbd8] schedule at ffffffff813bb2cc
>   [ffff883ef84ffbe8] schedule_timeout at ffffffff813b9234
>   [ffff883ef84ffbf8] __wake_up_common at ffffffff8104a8bd
>   [ffff883ef84ffc30] _raw_spin_unlock_irqrestore at ffffffff813bc55b
>   [ffff883ef84ffc60] __wait_for_common at ffffffff813bab7f
>   [ffff883ef84ffc68] schedule_timeout at ffffffff813b9200
>   [ffff883ef84ffc80] default_wake_function at ffffffff8104eec3
>   [ffff883ef84ffc98] call_rcu at ffffffff810937ff
>   [ffff883ef84ffcc8] wait_for_completion at ffffffff813bac1b
>   [ffff883ef84ffcd8] wait_rcu_gp at ffffffff81041ea6
>   [ffff883ef84ffce8] wakeme_after_rcu at ffffffff81041e51
>   [ffff883ef84ffd20] synchronize_rcu at ffffffff81092333
>   [ffff883ef84ffd30] mem_cgroup_reparent_charges at ffffffff810e3962
>   [ffff883ef84ffdc0] mem_cgroup_css_offline at ffffffff810e3d6e
>   [ffff883ef84ffdf0] offline_css at ffffffff8107a872
>   [ffff883ef84ffe10] cgroup_offline_fn at ffffffff8107c55f
>   [ffff883ef84ffe50] process_one_work at ffffffff8103f26f
>   [ffff883ef84ffe90] worker_thread at ffffffff8103f711
>   [ffff883ef84ffeb0] worker_thread at ffffffff8103f5cd
>   [ffff883ef84ffec8] kthread at ffffffff810441a4
>   [ffff883ef84fff28] kthread at ffffffff8104411c
>   [ffff883ef84fff50] ret_from_fork at ffffffff813bd02c
>   [ffff883ef84fff80] kthread at ffffffff8104411c
> 
