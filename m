From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/6] sched: Unbreak wakeups
Date: Wed, 2 Jun 2021 15:58:04 +0200
Message-ID: <YLeObHTKKDGd3pdA@kroah.com>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.271625424@infradead.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622642287;
        bh=dHpSABRDz/ACjiNwYplGY79xrERr0Xgmy3y4+S1hSB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DyLYFBMg9k5l89eFjJpIxjBnu2FGj82B4XdXYxhPkhiK5M5yuGrI9d91r/PWv2LiV
         K/2h7mAR3azlB6I5M5ciHb74VYjP7zKuJQjACzKPP/OA2ba9LiDUk+xvlBhBE/gp12
         vi5CNlvHSLUJYVKuxJf36nLKhtJxH/zOZTChLuKQ=
Content-Disposition: inline
In-Reply-To: <20210602133040.271625424@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>

On Wed, Jun 02, 2021 at 03:12:26PM +0200, Peter Zijlstra wrote:
> Remove broken task->state references and let wake_up_process() DTRT.
> 
> The anti-pattern in these patches breaks the ordering of ->state vs
> COND as described in the comment near set_current_state() and can lead
> to missed wakeups:
> 
> 	(OoO load, observes RUNNING)<-.
> 	for (;;) {                    |
> 	  t->state = UNINTERRUPTIBLE; |
> 	  smp_mb();          ,-----> ,' (OoO load, observed !COND)
>                              |       |
> 	                     |       |	COND = 1;
> 			     |	     `- if (t->state != RUNNING)
>                              |		  wake_up_process(t); // not done
> 	  if (COND) ---------'
> 	    break;
> 	  schedule(); // forever waiting
> 	}
> 	t->state = TASK_RUNNING;
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  drivers/net/ethernet/qualcomm/qca_spi.c |    6 ++----
>  drivers/usb/gadget/udc/max3420_udc.c    |   15 +++++----------
>  drivers/usb/host/max3421-hcd.c          |    3 +--
>  kernel/softirq.c                        |    2 +-
>  4 files changed, 9 insertions(+), 17 deletions(-)

For USB stuff:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
