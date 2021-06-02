From: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 4/6] sched: Add get_current_state()
Date: Wed, 2 Jun 2021 16:02:11 +0100
Message-ID: <20210602150211.GC31179@willie-the-truck>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.461908001@infradead.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622646144;
        bh=iqy0WVYDEpl3OEqiwYR2vHlixZDZNAuGOuMgnWDXeR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O+pqG+GrEcw9WVS8/OW/fQfSxSijYrBV2XZxysaVScijAUnd0cVcWSF4nom6VYF7/
         Xyj4yQuXkrrTuHJnUpufQZyClixRruRrV6dddsrZRqOQc+UgpG4vsSCBUy91HBwhfj
         S4qt9rHniezYWqyJmpYVr3rEugD00r4pGxG9asyrSW0y4cnvEcyeHwtxVwtOD0WKZZ
         CxVeWNbOBJkHO0H7W+0s6rOxAZoTcR6qnwXcmM/nQ5icf4zBj8IsluJAeqSZ9roUcx
         S4+extTRu1FhJzpL0fTK8fMnTglu0lQMSa9EV3Tq/LcFiaa96LORrcAJlT/uJ7FgCX
         ZTIEp+h3YHIzg==
Content-Disposition: inline
In-Reply-To: <20210602133040.461908001@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <t>

On Wed, Jun 02, 2021 at 03:12:29PM +0200, Peter Zijlstra wrote:
> Remove yet another few p->state accesses.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  block/blk-mq.c        |    2 +-
>  include/linux/sched.h |    2 ++
>  kernel/freezer.c      |    2 +-
>  kernel/sched/core.c   |    6 +++---
>  4 files changed, 7 insertions(+), 5 deletions(-)

I think you can include kernel/kcsan/report.c here too.

With that:

Acked-by: Will Deacon <will@kernel.org>

Will
