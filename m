From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Fwd: Re: RFC: cgroups aware proc
Date: Mon, 13 Jan 2014 18:12:38 +0100
Message-ID: <20140113171238.GS31570@twins.programming.kicks-ass.net>
References: <52D35CD0.9070602@huawei.com>
 <52D41316.5080508@yuhu.biz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52D41316.5080508@yuhu.biz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marian Marinov <mm@yuhu.biz>
Cc: lxc-devel@lists.linuxcontainers.org, cgroups@vger.kernel.org, "Daniel P. Berrange" <berrange@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 06:23:50PM +0200, Marian Marinov wrote:
> Hello Peter,
> 
> I need help with the scheduler.
> 
> I'm currently trying to patch the /proc/loadavg to show the load that is
> only related to the processes from the current cgroup.
> 
> I looked trough the code and I was hoping that tsk->sched_task_group->cfs_rq
> struct will give me the needed information, but unfortunately for me, it did
> not.
> 
> Can you advise me, how to approach this problem?

Yeah, don't :-) Really, loadavg is a stupid metric.

> I'm totally new to the scheduler code.

Luckily you won't actually have to touch much of it. Most of the actual
loadavg code lives in the first ~400 lines of kernel/sched/proc.c, read
and weep. Its one of the best documented bits around.

Your proposition however is extremely expensive, you turn something
that's already expensive O(nr_cpus) into something O(nr_cpus *
nr_cgroups).

I'm fairly sure people will not like that, esp. for something of such
questionable use as the loadavg -- its really only a pretty number that
doesn't mean all that much.

> -------- Original Message --------
> From: Li Zefan <lizefan@huawei.com>
>
> Then you should add Peter, Ingo and LKML to your Cc list. :)

You failed that, let me fix that.
