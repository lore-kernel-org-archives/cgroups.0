From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/6] sched,perf,kvm: Fix preemption condition
Date: Wed, 2 Jun 2021 16:23:56 +0200
Message-ID: <YLeUfNEqKg27VwAB@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.398289363@infradead.org>
 <1524365960.5868.1622643316351.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FXtOoRkqKzh7kLJLNx1aUNoAKOt2OwhOUmVlEeFOV/k=; b=CHh50MAnwHptxKKeb98FX0zBM/
        hZGvhB4OgPfd+ch/7Q4Awrbwu4YMPhZZyT4MBL6ufwo9T1X3jzwrDiV2mV+NLG+uaGFtpk4wJW0Sl
        qULAlfcMVVVzXG+nvaGIKpuQWC7oHU4cD3sRPQLrMBkEqwZcdjHxvNg+me0S6xPh9OUSlXXgEDC6Z
        pzRSlZNULro6LWJusA97DADN/jHRNpmBokq3XpapoFAiUebSvq5DGMtNHHjHI7P94iuGqIHoF5IK5
        c9Cs6a/FvoaHXq4eeNZQEa+OSz+uu1jB7/A+OTqK1Log/LLFviNFlK2bXPZ1hwESu9YATeOjws0cR
        3OjnDBZg==;
Content-Disposition: inline
In-Reply-To: <1524365960.5868.1622643316351.JavaMail.zimbra@efficios.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, bristot <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <liz>

On Wed, Jun 02, 2021 at 10:15:16AM -0400, Mathieu Desnoyers wrote:
> ----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:
> [...]
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -8568,13 +8568,12 @@ static void perf_event_switch(struct tas
> > 		},
> > 	};
> > 
> > -	if (!sched_in && task->state == TASK_RUNNING)
> > +	if (!sched_in && current->on_rq) {
> > 		switch_event.event_id.header.misc |=
> > 				PERF_RECORD_MISC_SWITCH_OUT_PREEMPT;
> > +	}
> > 
> > -	perf_iterate_sb(perf_event_switch_output,
> > -		       &switch_event,
> > -		       NULL);
> > +	perf_iterate_sb(perf_event_switch_output, &switch_event, NULL);
> > }
> 
> There is a lot of code cleanup going on here which does not seem to belong
> to a "Fix" patch.

Maybe, but I so hate whitespace only patches :-/
