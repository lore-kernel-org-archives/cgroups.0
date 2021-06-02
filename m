From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 5/6] sched,timer: Use __set_current_state()
Date: Wed, 2 Jun 2021 12:54:58 -0700
Message-ID: <20210602195458.uj3rsci4suz4mufj@offworld>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.524487671@infradead.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20210602133040.524487671@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <t>

On Wed, 02 Jun 2021, Peter Zijlstra wrote:

-ENOCHANGELONG

But yeah, I thought we had gotten rid of all these.

>
>Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
