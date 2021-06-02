From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 1/6] sched: Unbreak wakeups
Date: Wed, 2 Jun 2021 12:43:59 -0700
Message-ID: <20210602194359.pxujd4rx4lxv2ldm@offworld>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.271625424@infradead.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20210602133040.271625424@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <t>

On Wed, 02 Jun 2021, Peter Zijlstra wrote:

>Remove broken task->state references and let wake_up_process() DTRT.
>
>The anti-pattern in these patches breaks the ordering of ->state vs
>COND as described in the comment near set_current_state() and can lead
>to missed wakeups:
>
>	(OoO load, observes RUNNING)<-.
>	for (;;) {                    |
>	  t->state = UNINTERRUPTIBLE; |
>	  smp_mb();          ,-----> ,' (OoO load, observed !COND)
>                             |       |
>	                     |       |	COND = 1;
>			     |	     `- if (t->state != RUNNING)
>                             |		  wake_up_process(t); // not done
>	  if (COND) ---------'
>	    break;
>	  schedule(); // forever waiting
>	}
>	t->state = TASK_RUNNING;
>
>Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
