From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH cgroup/for-5.5] cgroup: remove
 cgroup_enable_task_cg_lists() optimization
Date: Fri, 25 Oct 2019 16:13:25 +0200
Message-ID: <20191025141325.GB6020@redhat.com>
References: <0000000000003b1e8005956939f1@google.com>
 <20191021142111.GB1339@redhat.com>
 <20191024190351.GD3622521@devbig004.ftw2.facebook.com>
 <20191025125606.GI3622521@devbig004.ftw2.facebook.com>
 <20191025133358.pxpzxkhqc3mboi5x@wittgenstein>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572012817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NFKLs9tDQua90X4BBbVlmoEx/KurPRVIfH4NJ4epzNw=;
        b=LI1Nc8nVvRWsP2mYyLTDLKEf6bZYDY4w4qPdgDi8AMkUVDvvVmsEKMvcgVhBH4xujAkUCx
        TSDZLq14KS7biIOpioeEQOEfmo0QYLBAiDF4g3FWIJTKtwWFzIbfF0Gfyt3YWYvKz/xgaE
        fTLPaoMgFQaRo1V/uCwpfuvJL9OJIyY=
In-Reply-To: <20191025133358.pxpzxkhqc3mboi5x@wittgenstein>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Tejun Heo <tj@kernel.org>, dvyukov@google.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, arnd@arndb.de, deepa.kernel@gmail.com, ebiederm@xmission.com, elver@google.com, guro@fb.com, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, cgroups@vger.kernel.org, kernel-team@fb.com

On 10/25, Christian Brauner wrote:
>
> [+Dmitry]
>
> On Fri, Oct 25, 2019 at 05:56:06AM -0700, Tejun Heo wrote:
> > On Thu, Oct 24, 2019 at 12:03:51PM -0700, Tejun Heo wrote:
> > > cgroup_enable_task_cg_lists() is used to lazyily initialize task
> > > cgroup associations on the first use to reduce fork / exit overheads
> > > on systems which don't use cgroup.  Unfortunately, locking around it
> > > has never been actually correct and its value is dubious given how th=
e
> > > vast majority of systems use cgroup right away from boot.
> > >
> > > This patch removes the optimization.  For now, replace the cg_list
> > > based branches with WARN_ON_ONCE()'s to be on the safe side.  We can
> > > simplify the logic further in the future.
> > >
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Reported-by: Oleg Nesterov <oleg@redhat.com>
> >
> > Applying to cgroup/for-5.5.
>
> The code you removed was the only place where task->flags was set from
> !current.

No, that code doesn't modify task->flags. It checks PF_EXITING under sigloc=
k
but this makes no sense and can't avoid the race with cgroup_exit().

> So I think this fixes the syzbot data-race report in:
> https://lore.kernel.org/r/0000000000003b1e8005956939f1@google.com

No.

Almost every usage of task->flags (load or sore) can be reported as "data r=
ace".

Say, you do

=09if (task->flags & PF_KTHREAD)

while this task does

=09current->flags |=3D PF_FREEZER_SKIP;
=09schedule().

this is data race.

Oleg.

