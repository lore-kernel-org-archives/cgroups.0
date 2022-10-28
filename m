From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC][PATCH v2 04/31] timers: block: Use del_timer_shutdown()
 before freeing timer
Date: Fri, 28 Oct 2022 10:06:56 -0400
Message-ID: <20221028100656.00a4d537@gandalf.local.home>
References: <20221027150525.753064657@goodmis.org>
        <20221027150925.819019339@goodmis.org>
        <20221027111944.39b3a80c@gandalf.local.home>
        <Y1uSG/7VXWLNlxlt@infradead.org>
        <20221028062414.7859f787@gandalf.local.home>
        <60b91c39-1e54-ac8b-5e9e-db7e46ca2d60@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <60b91c39-1e54-ac8b-5e9e-db7e46ca2d60-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Christoph =?UTF-8?B?QsO2aG13YWxk?= =?UTF-8?B?ZXI=?= <christoph.boehmwalder-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 28 Oct 2022 07:56:50 -0600
Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:

> On 10/28/22 4:24 AM, Steven Rostedt wrote:
> > On Fri, 28 Oct 2022 01:26:03 -0700
> > Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >   
> >> This is just a single patch out of apparently 31, which claims that
> >> something that doesn't even exist in mainline must be used without any
> >> explanation.  How do you expect anyone to be able to review it?  
> > 
> >   https://lore.kernel.org/all/20221027150525.753064657-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org/
> > 
> > Only the first patch is relevant to you. I guess the Cc list would have
> > been too big to Cc everyone that was Cc'd in the series.  
> 
> No it's not, because how on earth would anyone know what the change does
> if you only see the simple s/name/newname change? The patch is useless
> by itself.
> 

I meant this as the first patch:

  https://lore.kernel.org/all/20221027150925.248421571-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org/

Which was what the link above was suppose to point to.

It's the only patch relevant to the rest of the series, as the rest is just
converting over to the shutdown API, and the last patch changes
DEBUG_OBJECTS_TIMERS to catch if this was done properly.

That is, patch 01/31 and the patch you were Cc'd on is relevant, and for
those that want to look deeper, see patch 31 as well.

But if I included the Cc list for patch 01 for all those Cc'd in the
entire series, it would be a huge Cc list, so I avoided doing so.

Also, this is still RFC as the changes may still change. That is, this
patch set is a heads up to what is to come. Ideally, I'd like to get just
the API possibly in the kernel before the merge window without anyone using
it. Then I can ask all the sub systems to pull in these individual patches
as well.

-- Steve
