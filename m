From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on
 suspend-resume
Date: Sat, 11 Mar 2023 18:51:50 +0000
Message-ID: <20230311185150.stvtcbdkoofgn3wd@airbuntu>
References: <5a1e58bf-7eb2-bd7a-7e19-7864428a2b83@arm.com>
 <20230228174627.vja5aejq27dsta2u@airbuntu>
 <Y/7/SLzvK8LfB29z@localhost.localdomain>
 <20230301122852.zgzreby42lh2zf6w@airbuntu>
 <Y/9gmDRlGOChIwpf@localhost.localdomain>
 <20230301170322.xthlso7jfkixlyex@airbuntu>
 <ZAhhGi55BkYkc3ss@localhost.localdomain>
 <CA+khW7hmE0tECG2qfKW1HN9yLVOLUn5Zzx4Rz-wHYDtSUPYotw@mail.gmail.com>
 <ZAmCzJQZl7j/m2oN@localhost.localdomain>
 <CA+khW7iAeTALH5b6upHXs1RotFBohVeZCcAp5H+r-=L05kqnww@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678560714;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5TpXwoEx5AlyR5GZdAmslzpMD8vQRifjw8ocaQpaF/4=;
        b=CW+OPwvwyfTxNY/pcQrP+cGAwnYEd5jEHqDHl2YlkltlMd4287g2yayTiVNq9JxDbC
         i1MUNa1WhPIuZLxy1lMoyWF4dAKpktLPOkJcnSlkJlW7ZjDsepnv6h316oNEoUNSa0ZE
         Xu1iE6B4txsHxHgTOHKTGHhPBmbEI5s/WepxUwnyXo99NPURvmmSReZZpuZWhOnQPDLq
         a8v/cvpgeADqoOAj/fsRZMl2P3sijEAKAUvZbvdxLEAVo4oKSYqwagYl53+A79SjrMRs
         v0tKjSe4V04Gs8umC8RTjW9kzzGugmKbluFKLutxh9+GjklJTl6wIScs2qL5QpNEYReN
         990g==
Content-Disposition: inline
In-Reply-To: <CA+khW7iAeTALH5b6upHXs1RotFBohVeZCcAp5H+r-=L05kqnww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, l

On 03/09/23 14:23, Hao Luo wrote:
> On Wed, Mar 8, 2023 at 10:55 PM Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On 08/03/23 10:01, Hao Luo wrote:
> > > On Wed, Mar 8, 2023 at 2:20 AM Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > >
> > > > On 01/03/23 17:03, Qais Yousef wrote:
> > > > > On 03/01/23 15:26, Juri Lelli wrote:
> > > <...>
> > > > > > BTW, do you have a repro script of some sort handy I might play with?
> > > > >
> > > > > Sorry no. You'll just need to suspend to ram. I had a simple patch to measure
> > > > > the time around the call and trace_printk'ed the result.
> > > > >
> > > > > I was working on a android phone which just suspends to ram if you turn the
> > > > > screen off and disconnect the usb.
> > > >
> > > > Looks like I could come up with the following
> > > >
> > > > https://github.com/jlelli/linux.git deadline/rework-cpusets
> > > > https://github.com/jlelli/linux/tree/deadline/rework-cpusets
> > > >
> > > > which I don't think it's at a point that I feel comfortable to propose
> > > > as an RFC (not even sure if it actually makes sense), but it survived my
> > > > very light testing.
> > > >
> > > > Could you please take a look and, if it makes some sense in theory, give
> > > > it a try on your end?
> > > >
> > >
> > > Hi Juri,
> > >
> > > Thanks for coming up with the RFC. I can test your changes in the
> > > server environment. I observed the same issue on my side and I can
> > > reproduce.
> > >
> > > I sync'ed up with Qais offline earlier yesterday, and was preparing a
> > > couple of patches that optimize the cpuset.cpus writes. Tracking dl
> > > tasks in cpusets is one of them. But I am happy to take your patches
> > > and do the testing. Note that I won't be able to test the dl part of
> > > the patch, only the latency impact on rebuild_root_domains(), as we
> > > don't have dl tasks in our system.
> > >
> > > The other patch is fixing cpuset_rwsem. I see you switched it back to
> > > mutex. I did observe performance issues with cpuset_rwsem. Basically,
> > > using percpu_rwsem generates very very long latency tails for writers,
> > > but mutex doesn't. After some debugging, I found it was because
> > > percpu_rwsem requires every writer to call a synchronize_rcu() for
> > > acquiring the lock. So in my patches, I disabled the fastpath of
> > > readers for cpuset_rwsem. This has been done before[1]. But mutex also
> > > worked.
> > >
> > > Anyway, I'm happy to test your patches and ack once they are sent out.
> >
> > Do you strictly need a proper RFC or could you please test the above for
> > now? If you could please do the latter, and if tests look ok, I could
> > then put together proper changelogs etc. and propose an RFC (it would
> > save me some time not to do that if the above doesn't work, apologies
> > for not going the proper route from the start). Guess this question
> > applies to Qais as well. Hummm, or maybe you are actually saying that
> > you are indeed going to test them already, just wanted to make sure
> > then. :)
> 
> Juri, I ported your patches to a 5.10 kernel, because my workload can
> only run on 5.10. But unfortunately the kernel crashed at
> cpuset_can_attach(). I'll put a few comments in your github branch.

Yeah I am working on 5.10 too (this will need to be backported to 5.10 and 5.15
ultimately) and had the same crash because task is NULL.

Fixed it this way which I think what you intended to do Juri? It moves the
check for dl_task(task) inside cgroup_taskset_for_each() loop.

	diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
	index 83a8943467fb..06d6bb68d86b 100644
	--- a/kernel/cgroup/cpuset.c
	+++ b/kernel/cgroup/cpuset.c
	@@ -2495,11 +2495,11 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
			ret = security_task_setscheduler(task);
			if (ret)
				goto out_unlock;
	-       }
	 
	-       if (dl_task(task)) {
	-               cs->deadline_tasks++;
	-               cpuset_attach_old_cs->deadline_tasks--;
	+               if (dl_task(task)) {
	+                       cs->deadline_tasks++;
	+                       cpuset_attach_old_cs->deadline_tasks--;
	+               }
		}
	 
		/*

Like Hao I don't have any deadline tasks in the system. With the fix above
I don't notice the delay on suspend resume using your patches.

If you want any debug; please feel free to add them into your branch so I can
run with that and give you the log.


Thanks!
