From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on
 suspend-resume
Date: Thu, 9 Mar 2023 07:55:08 +0100
Message-ID: <ZAmCzJQZl7j/m2oN@localhost.localdomain>
References: <5f087dd8-3e39-ce83-fe24-afa5179c05d9@arm.com>
 <20230227205725.dipvh3i7dvyrv4tv@airbuntu>
 <5a1e58bf-7eb2-bd7a-7e19-7864428a2b83@arm.com>
 <20230228174627.vja5aejq27dsta2u@airbuntu>
 <Y/7/SLzvK8LfB29z@localhost.localdomain>
 <20230301122852.zgzreby42lh2zf6w@airbuntu>
 <Y/9gmDRlGOChIwpf@localhost.localdomain>
 <20230301170322.xthlso7jfkixlyex@airbuntu>
 <ZAhhGi55BkYkc3ss@localhost.localdomain>
 <CA+khW7hmE0tECG2qfKW1HN9yLVOLUn5Zzx4Rz-wHYDtSUPYotw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678344915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uIczmgYoQYTCvZV52CjGLXblPTYkMmmzjpWwwvoi3OY=;
        b=dbGBIa2NmuuoSeSist94fb9+az/UCm1LgaJXXXkNwKeR28C3tRkcA7wsrt4kaMq8bZEJWf
        vn+tm8d4VnUJlpZo2o3b50M69aoNQzZmvOp7KLTAhHRQJ6DdWeeplwnh6+ckbnUWdCsXVL
        agrOs54m3NGBQcm/tdxnR7KfxkWDegU=
Content-Disposition: inline
In-Reply-To: <CA+khW7hmE0tECG2qfKW1HN9yLVOLUn5Zzx4Rz-wHYDtSUPYotw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, li

Hi Hao,

On 08/03/23 10:01, Hao Luo wrote:
> On Wed, Mar 8, 2023 at 2:20=E2=80=AFAM Juri Lelli <juri.lelli-H+wXaHxf7aL=
QT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On 01/03/23 17:03, Qais Yousef wrote:
> > > On 03/01/23 15:26, Juri Lelli wrote:
> <...>
> > > > BTW, do you have a repro script of some sort handy I might play wit=
h?
> > >
> > > Sorry no. You'll just need to suspend to ram. I had a simple patch to=
 measure
> > > the time around the call and trace_printk'ed the result.
> > >
> > > I was working on a android phone which just suspends to ram if you tu=
rn the
> > > screen off and disconnect the usb.
> >
> > Looks like I could come up with the following
> >
> > https://github.com/jlelli/linux.git deadline/rework-cpusets
> > https://github.com/jlelli/linux/tree/deadline/rework-cpusets
> >
> > which I don't think it's at a point that I feel comfortable to propose
> > as an RFC (not even sure if it actually makes sense), but it survived my
> > very light testing.
> >
> > Could you please take a look and, if it makes some sense in theory, give
> > it a try on your end?
> >
>=20
> Hi Juri,
>=20
> Thanks for coming up with the RFC. I can test your changes in the
> server environment. I observed the same issue on my side and I can
> reproduce.
>=20
> I sync'ed up with Qais offline earlier yesterday, and was preparing a
> couple of patches that optimize the cpuset.cpus writes. Tracking dl
> tasks in cpusets is one of them. But I am happy to take your patches
> and do the testing. Note that I won't be able to test the dl part of
> the patch, only the latency impact on rebuild_root_domains(), as we
> don't have dl tasks in our system.
>=20
> The other patch is fixing cpuset_rwsem. I see you switched it back to
> mutex. I did observe performance issues with cpuset_rwsem. Basically,
> using percpu_rwsem generates very very long latency tails for writers,
> but mutex doesn't. After some debugging, I found it was because
> percpu_rwsem requires every writer to call a synchronize_rcu() for
> acquiring the lock. So in my patches, I disabled the fastpath of
> readers for cpuset_rwsem. This has been done before[1]. But mutex also
> worked.
>=20
> Anyway, I'm happy to test your patches and ack once they are sent out.

Do you strictly need a proper RFC or could you please test the above for
now? If you could please do the latter, and if tests look ok, I could
then put together proper changelogs etc. and propose an RFC (it would
save me some time not to do that if the above doesn't work, apologies
for not going the proper route from the start). Guess this question
applies to Qais as well. Hummm, or maybe you are actually saying that
you are indeed going to test them already, just wanted to make sure
then. :)

Thanks!
Juri

