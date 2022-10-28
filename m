From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH v2 04/31] timers: block: Use del_timer_shutdown()
 before freeing timer
Date: Fri, 28 Oct 2022 10:30:28 -0400
Message-ID: <20221028103028.636072e3@gandalf.local.home>
References: <20221027150525.753064657@goodmis.org>
        <20221027150925.819019339@goodmis.org>
        <20221027111944.39b3a80c@gandalf.local.home>
        <Y1uSG/7VXWLNlxlt@infradead.org>
        <20221028062414.7859f787@gandalf.local.home>
        <60b91c39-1e54-ac8b-5e9e-db7e46ca2d60@kernel.dk>
        <20221028100656.00a4d537@gandalf.local.home>
        <9bb423f8-5910-494d-2522-2fcf8e41c2e4@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <9bb423f8-5910-494d-2522-2fcf8e41c2e4@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Christoph =?UTF-8?B?QsO2aG13YWxk?= =?UTF-8?B?ZXI=?= <christoph.boehmwalder@linbit.com>, drbd-dev@lists.linbit.com, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org

On Fri, 28 Oct 2022 08:11:27 -0600
Jens Axboe <axboe@kernel.dk> wrote:

> This is pretty common for tree wide changes. The relevant lists need
> to see the full context, patch 4/31 by itself is useless and may as well
> not be sent at this point then.

Ah, I didn't think about just including the mailing lists. The Cc lists
were auto-generated, and I didn't think about just taking out the lists.

Will do that for v2.

Thanks,

-- Steve
