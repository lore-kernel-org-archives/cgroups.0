From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on
 suspend-resume
Date: Wed, 8 Mar 2023 11:19:06 +0100
Message-ID: <ZAhhGi55BkYkc3ss@localhost.localdomain>
References: <20230206221428.2125324-1-qyousef@layalina.io>
 <20230223153859.37tqoqk33oc6tv7o@airbuntu>
 <5f087dd8-3e39-ce83-fe24-afa5179c05d9@arm.com>
 <20230227205725.dipvh3i7dvyrv4tv@airbuntu>
 <5a1e58bf-7eb2-bd7a-7e19-7864428a2b83@arm.com>
 <20230228174627.vja5aejq27dsta2u@airbuntu>
 <Y/7/SLzvK8LfB29z@localhost.localdomain>
 <20230301122852.zgzreby42lh2zf6w@airbuntu>
 <Y/9gmDRlGOChIwpf@localhost.localdomain>
 <20230301170322.xthlso7jfkixlyex@airbuntu>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678270754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oj8X+oVpalTPTCAltQyKK/P/y4ZD06O85L5kpsJEEdg=;
        b=KywT+M53Y7Hxkgahi8VlEHIvh9MiJheCT1wqaplCWA+wRBbbNKLqkmNlRgouIullRKcpDP
        spWpCWJRVhTVXLEyBz+MCqCkdwbF4Yy+tjByILRBWFOjjpo7byUmQP7Xg1p89KpmBNZ8GS
        UW+j3jpH7LKJmqtMlPgMF1Z6JOMtQw0=
Content-Disposition: inline
In-Reply-To: <20230301170322.xthlso7jfkixlyex@airbuntu>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Cc: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86@kerne

On 01/03/23 17:03, Qais Yousef wrote:
> On 03/01/23 15:26, Juri Lelli wrote:
> > On 01/03/23 12:28, Qais Yousef wrote:
> > > On 03/01/23 08:31, Juri Lelli wrote:
> > 
> > ...
> > 
> > > > Not ignoring you guys here, but it turns out I'm quite bogged down with
> > > > other stuff at the moment. :/ So, apologies and I'll try to get to this
> > > > asap. Thanks a lot for all your efforts and time reviewing so far!
> > > 
> > > Np, I can feel you :-)
> > 
> > Eh. :/
> 
> I hope I did not offend. That was meant as no pressure, I understand.

No offence at all! I meant "we are all on the same boat it seems". :)

> > BTW, do you have a repro script of some sort handy I might play with?
> 
> Sorry no. You'll just need to suspend to ram. I had a simple patch to measure
> the time around the call and trace_printk'ed the result.
> 
> I was working on a android phone which just suspends to ram if you turn the
> screen off and disconnect the usb.

Looks like I could come up with the following

https://github.com/jlelli/linux.git deadline/rework-cpusets
https://github.com/jlelli/linux/tree/deadline/rework-cpusets

which I don't think it's at a point that I feel comfortable to propose
as an RFC (not even sure if it actually makes sense), but it survived my
very light testing.

Could you please take a look and, if it makes some sense in theory, give
it a try on your end?

Thanks!
Juri

