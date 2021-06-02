From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/6] sched: Introduce task_is_running()
Date: Wed, 2 Jun 2021 16:15:42 -0700
Message-ID: <20210602231542.ejrjbilfggq4whg7@offworld>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.334970485@infradead.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20210602133040.334970485@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <t>

On Wed, 02 Jun 2021, Peter Zijlstra wrote:

>Replace a bunch of 'p->state == TASK_RUNNING' with a new helper:
>task_is_running(p).
>
>Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Acked-by: Davidlohr Bueso

But afaict ....

>---
> arch/x86/kernel/process.c |    4 ++--
> block/blk-mq.c            |    2 +-
> include/linux/sched.h     |    2 ++
> kernel/locking/lockdep.c  |    2 +-
> kernel/rcu/tree_plugin.h  |    2 +-
> kernel/sched/core.c       |    6 +++---
> kernel/sched/stats.h      |    2 +-
> kernel/signal.c           |    2 +-
> kernel/softirq.c          |    3 +--
> mm/compaction.c           |    2 +-
> 10 files changed, 14 insertions(+), 13 deletions(-)

there are also (on top of the already mentioned arch/):

kernel/kcsan/report.c:  const bool is_running = current->state == TASK_RUNNING;
kernel/locking/lockdep.c:       if (p->state == TASK_RUNNING && p != current)
