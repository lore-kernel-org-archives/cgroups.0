From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Mon, 04 May 2015 14:08:33 +0200
Message-ID: <1430741313.3096.71.camel@gmail.com>
References: <5546C34C.7050202@huawei.com>
	 <1430709236.3129.42.camel@gmail.com> <5546F80B.3070802@huawei.com>
	 <1430716247.3129.44.camel@gmail.com> <1430717964.3129.62.camel@gmail.com>
	 <554737AE.5040402@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=TFzwu9XeftOrtg7vryMgj3TYU7yNWrwXPRRrvD6vqJo=;
        b=umKKdwmLyCcfc3p0AdPd4iCRgASdwPJo2B1mr292PIdVj5iblxX5WNkF0eydkXezrU
         MZVQAPqoSIIbNC+1aGAyIOgfB1S8cW6lV/tCtfMx9jHBuJjfZ98Lvw0COmZOFOfnLq6y
         p7DpvY/eHshhbHiWipUwsmJFzH4IZfyBK/E5dDhHyynWJFzFGVChOwPdMY70YH2OgOE3
         /BijT54c5Qhtz3z4mgJIB3EeXPpkaYcv/Cdzdg2oZb+2/8F96eXvDfzWnZg8qCpT5omP
         K9CJLiTsX5qqTUBZ5lGtpzyboJgDKvrf9i9Sru14UdxZLUyw09rH4glpPD4hGsi+FCvZ
         zlgA==
In-Reply-To: <554737AE.5040402-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, 2015-05-04 at 17:11 +0800, Zefan Li wrote:
> >>> Some degree of flexibility is provided so that you may disable some controllers
> >>> in a subtree. For example:
> >>>
> >>> root                  ---> child1
> >>> (cpuset,memory,cpu)        (cpuset,memory)
> >>>                       \
> >>>                        \-> child2
> >>>                            (cpu)
> >>
> >> Whew, that's a relief.  Thanks.
> > 
> > But somehow I'm not feeling a whole lot better.
> > 
> > "May" means if you don't explicitly take some action to disable group
> > scheduling, you get it (I don't care if I have an off button), but that
> > would also seemingly mean that we would then have rt tasks in taskgroups
> > with no bandwidth allocated, ie you have to make group scheduling for rt
> > tasks meaningless until a bandwidth appeared, and to make bandwidth
> > appear, you'd have to stop the world, distribute, continue, no?
> > 
> > The current "just say no" seems a lot more sensible.
> > 
> 
> I just realized we allow removing/adding controllers from/to cgroups
> while there are tasks in them, which isn't safe unless we eliminate all
> can_attach callbacks. We've done so for some cgroup subsystems, but
> there are still a few of them...

I was pondering the future (or so I thought), but seems it turned into
the past while I wasn't looking.  Oh well, you found a bug anyway.

	-Mike
