From: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/6] sched: Introduce task_is_running()
Date: Wed, 2 Jun 2021 15:59:21 +0100
Message-ID: <20210602145921.GB31179@willie-the-truck>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.334970485@infradead.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622645976;
        bh=lULBTNw8ShimVVrtBYDbb5vhV5dQ9U6lx3o98b0hW5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQiBvXalcmFDhP4VUJkLfFfjUL+AdCowcIIHtwCBDEqTOBmz1OdBU6rrODvuN+9rD
         mOLZKyuSS6i9EOd55gn+hVr2qB4URf3FK/46utTh8Mh1nd3yfAS9gC2T8qY5RT3IQY
         b4rlXGea5BqIi+sm9FltOrrnryu0LA5VhApDTgyH63PLiPiZ2y0qibL1ECCDe/bn4n
         SELGuhZLGN0WPbHVxREPrkTVpEWesEuUbZ+F7OzJ3FIIUPCtX92osJVk5KljY297eg
         yycYme0OjJHY2hdQ/MWGMhjJv0YWgp66DxbyRygrcbb6F9I+DfNX1xA1IgwfjJU0xb
         xfBJRIrGQb7lw==
Content-Disposition: inline
In-Reply-To: <20210602133040.334970485@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <t>

On Wed, Jun 02, 2021 at 03:12:27PM +0200, Peter Zijlstra wrote:
> Replace a bunch of 'p->state == TASK_RUNNING' with a new helper:
> task_is_running(p).
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/kernel/process.c |    4 ++--
>  block/blk-mq.c            |    2 +-
>  include/linux/sched.h     |    2 ++
>  kernel/locking/lockdep.c  |    2 +-
>  kernel/rcu/tree_plugin.h  |    2 +-
>  kernel/sched/core.c       |    6 +++---
>  kernel/sched/stats.h      |    2 +-
>  kernel/signal.c           |    2 +-
>  kernel/softirq.c          |    3 +--
>  mm/compaction.c           |    2 +-
>  10 files changed, 14 insertions(+), 13 deletions(-)
> 
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -931,7 +931,7 @@ unsigned long get_wchan(struct task_stru
>  	unsigned long start, bottom, top, sp, fp, ip, ret = 0;
>  	int count = 0;
>  
> -	if (p == current || p->state == TASK_RUNNING)
> +	if (p == current || task_is_running(p))

Looks like this one in get_wchan() has been cargo-culted across most of
arch/ so they'll need fixing up before you rename the struct member.

There's also a weird one in tools/bpf/runqslower/runqslower.bpf.c (!)

Will
