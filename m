From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC][PATCH v2 04/31] timers: block: Use del_timer_shutdown()
 before freeing timer
Date: Fri, 28 Oct 2022 06:24:14 -0400
Message-ID: <20221028062414.7859f787@gandalf.local.home>
References: <20221027150525.753064657@goodmis.org>
        <20221027150925.819019339@goodmis.org>
        <20221027111944.39b3a80c@gandalf.local.home>
        <Y1uSG/7VXWLNlxlt@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y1uSG/7VXWLNlxlt-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Christoph =?UTF-8?B?QsO2aG13YWxkZXI=?= <christoph.boehmwalder-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 28 Oct 2022 01:26:03 -0700
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> This is just a single patch out of apparently 31, which claims that
> something that doesn't even exist in mainline must be used without any
> explanation.  How do you expect anyone to be able to review it?

  https://lore.kernel.org/all/20221027150525.753064657-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org/

Only the first patch is relevant to you. I guess the Cc list would have
been too big to Cc everyone that was Cc'd in the series.

It not being in mainline is the reason I marked it RFC. As it's more of an
FYI than a pull it in request.

-- Steve
