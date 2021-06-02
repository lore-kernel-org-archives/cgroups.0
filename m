From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/6] sched: Introduce task_is_running()
Date: Wed, 2 Jun 2021 18:46:16 +0200
Message-ID: <YLe12Ba4CrvhMhFI@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.334970485@infradead.org>
 <20210602145921.GB31179@willie-the-truck>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7tohifuv5JYW3E7Hk1sVQuIjPI/C8MKSY3MQl5vvB4s=; b=kdu4BwlchYINw3C+EcBocsHDUy
        a91P+WO2n/ztNAZpC4i1gw7tqOKUFzwWu58suQdLAjM2YXFikv/5/oaqPmf99JVYKCNj2WJKpDQ0i
        S0c8GI0OlAIisTgxakan8G10HFtH5HuNw7Hqdqi3RHiYYq3zdmBzXy5lsDnRzF3TJVEtdO68TnpgS
        8K25eJH4v8dAAo7rswaiwcEE8nXrQyqHEIrzfWlp7ORDwYUd2bEDZxmNSuwBFuW4xEFDNeWs3Yg6U
        o+Kb0+cIMahvxPwVt/nlQwL5AtLXT/J6J+qePZba4xfUkA84xt+DhB39swRCy3609n/Mv+E85Mgmt
        FcuTDgEw==;
Content-Disposition: inline
In-Reply-To: <20210602145921.GB31179@willie-the-truck>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Will Deacon <will@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <t>

On Wed, Jun 02, 2021 at 03:59:21PM +0100, Will Deacon wrote:
> On Wed, Jun 02, 2021 at 03:12:27PM +0200, Peter Zijlstra wrote:
> > Replace a bunch of 'p->state == TASK_RUNNING' with a new helper:
> > task_is_running(p).
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  arch/x86/kernel/process.c |    4 ++--
> >  block/blk-mq.c            |    2 +-
> >  include/linux/sched.h     |    2 ++
> >  kernel/locking/lockdep.c  |    2 +-
> >  kernel/rcu/tree_plugin.h  |    2 +-
> >  kernel/sched/core.c       |    6 +++---
> >  kernel/sched/stats.h      |    2 +-
> >  kernel/signal.c           |    2 +-
> >  kernel/softirq.c          |    3 +--
> >  mm/compaction.c           |    2 +-
> >  10 files changed, 14 insertions(+), 13 deletions(-)
> > 
> > --- a/arch/x86/kernel/process.c
> > +++ b/arch/x86/kernel/process.c
> > @@ -931,7 +931,7 @@ unsigned long get_wchan(struct task_stru
> >  	unsigned long start, bottom, top, sp, fp, ip, ret = 0;
> >  	int count = 0;
> >  
> > -	if (p == current || p->state == TASK_RUNNING)
> > +	if (p == current || task_is_running(p))
> 
> Looks like this one in get_wchan() has been cargo-culted across most of
> arch/ so they'll need fixing up before you rename the struct member.

Yeah, this was x86_64 allmodconfig driven, I've already got a bunch of
robot mail telling me other archs need help, I'll fix it iup.

> There's also a weird one in tools/bpf/runqslower/runqslower.bpf.c (!)

I'm tempted to let the bpf people sort their own gunk. This is not an
ABI. I so don't care breaking every script out there.
