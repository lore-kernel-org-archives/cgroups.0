From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/6] sched: Unbreak wakeups
Date: Wed, 2 Jun 2021 15:47:55 +0100
Message-ID: <20210602144755.GA31179@willie-the-truck>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.271625424@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622645288;
        bh=ytbkft451AVHu/sv9O+1yHxWE5QaUUcYpHinzQWGilY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oFaPf/EGcp1bqCNSfbPd9OF2xa7o2Ntfin1h55YHUCHihLqUhuRWFALcsjyJqVvu3
         Y91bwUZOIsEFC/tL7PsAT3NW2pmuCMMri5f6mMQdOP0nuAVKe9SwYQcmWW9WbZ/XpA
         PoIpRGydGKIhIKVtHhzVu6FV2kTgGYhx9VOZ08mm/nHsF72YOGlYy3Wo5rD1Ycl6VO
         iEfCLUY4hdvzrtVG3Pt7BekNhlDuUClohcALpyQQ1KVISUxk8dSk+DozQEt+xxMpvZ
         6oRLbg4A4VBWbNLsQ8t27gcIkpn2wcsBwsMswN4j9Vrag6G0GPb4whAagnddnPqQmz
         nNoYUZ6ZDqJdQ==
Content-Disposition: inline
In-Reply-To: <20210602133040.271625424-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <t>

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
> Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  drivers/net/ethernet/qualcomm/qca_spi.c |    6 ++----
>  drivers/usb/gadget/udc/max3420_udc.c    |   15 +++++----------
>  drivers/usb/host/max3421-hcd.c          |    3 +--
>  kernel/softirq.c                        |    2 +-
>  4 files changed, 9 insertions(+), 17 deletions(-)

Acked-by: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I couldn't spot any others.

Will
