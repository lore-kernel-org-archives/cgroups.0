From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on
 suspend-resume
Date: Wed, 1 Mar 2023 17:03:22 +0000
Message-ID: <20230301170322.xthlso7jfkixlyex@airbuntu>
References: <20230206221428.2125324-1-qyousef@layalina.io>
 <20230223153859.37tqoqk33oc6tv7o@airbuntu>
 <5f087dd8-3e39-ce83-fe24-afa5179c05d9@arm.com>
 <20230227205725.dipvh3i7dvyrv4tv@airbuntu>
 <5a1e58bf-7eb2-bd7a-7e19-7864428a2b83@arm.com>
 <20230228174627.vja5aejq27dsta2u@airbuntu>
 <Y/7/SLzvK8LfB29z@localhost.localdomain>
 <20230301122852.zgzreby42lh2zf6w@airbuntu>
 <Y/9gmDRlGOChIwpf@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qUHKTRcQh3URDtHGlGaA089RX+46wq6JZY7f9xT1DBI=;
        b=2O6UAvj6zfjZ/qTx+DC1jnzc4oofYRirSDiuT9o8rhJ/6BEiPA4+rcBx4atFEYGEIo
         QVdj2yopC3IIfoL06yzTsC3ziAmJYMHVp28B/iZfCAryxbSMgsa3kgv/phahYvjdTBzb
         Z/2osNzuFnLNlGTIvz/JMmEPzwLmZAOY13uQsvapEDGujowt6lWX6AE8hfelFeGUxisa
         CJNyd0S6acdvftMLIIDqsimJ3mYWYm9fdb/HVEiQhLot1fGCgY3NO75b80K0cta4Mx61
         J5BxMt3zLEk/F+OPrB+G6242679o0jxvLR4EnQao/I7ez0xvSyFY5dK4MelBSfYqGIyZ
         x/vw==
Content-Disposition: inline
In-Reply-To: <Y/9gmDRlGOChIwpf-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86@kerne

On 03/01/23 15:26, Juri Lelli wrote:
> On 01/03/23 12:28, Qais Yousef wrote:
> > On 03/01/23 08:31, Juri Lelli wrote:
> 
> ...
> 
> > > Not ignoring you guys here, but it turns out I'm quite bogged down with
> > > other stuff at the moment. :/ So, apologies and I'll try to get to this
> > > asap. Thanks a lot for all your efforts and time reviewing so far!
> > 
> > Np, I can feel you :-)
> 
> Eh. :/

I hope I did not offend. That was meant as no pressure, I understand.

> 
> BTW, do you have a repro script of some sort handy I might play with?

Sorry no. You'll just need to suspend to ram. I had a simple patch to measure
the time around the call and trace_printk'ed the result.

I was working on a android phone which just suspends to ram if you turn the
screen off and disconnect the usb.

I think you can use rtcwake in normal desktop environment. Something like

	sudo rtcwake -u -s 5 -m mem


Thanks!
