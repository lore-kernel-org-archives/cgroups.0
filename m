From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [RFC v2 0/5] cgroup-aware unbound workqueues
Date: Wed, 12 Jun 2019 18:29:34 -0400
Message-ID: <20190612222934.y74wxy3aju6eqs4r@ca-dmjordan1.us.oracle.com>
References: <20190605133650.28545-1-daniel.m.jordan@oracle.com>
 <20190605135319.GK374014@devbig004.ftw2.facebook.com>
 <20190605153229.nvxr6j7tdzffwkgj@ca-dmjordan1.us.oracle.com>
 <20190611195549.GL3341036@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=SOIVm550t2juiTj4vnRQ5BaJ/KWVoCF7DZnOrZI0vno=;
 b=lhk5qU4z4GwfZqTKR5mbk79cDQzaoJ563ewToos4HaKC4mOW42ZuJj4rIKQuuXEL39VM
 tp4ZtszcjEpWB2WzalUsZvkf7EoQ4QcnxIQ2Qft1s6ZYSRtjhbym4uydGIVYMvhQvAHw
 fRHwYoG8GoVcSmHkzJ6QvWx2AS/Jpc3PwZV8EssJZG84yCzFBaQYH11ADbuo9e/H9WzV
 gBEoPFk2imAOKNWZH8Ol5/pQ2PTjvdP/f1tgifVJKX2HZGYVJYPuqPyaHLVwju+kvqVN
 3IYSt5eHrO4z++6UFpnrsjBUDs0k5Ev4rGF32Mx66rhmqD9/GhvxdpAvARzyeKXqVnkG 1A== 
Content-Disposition: inline
In-Reply-To: <20190611195549.GL3341036@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>, hannes@cmpxchg.org, jiangshanlai@gmail.com, lizefan@huawei.com, bsd@redhat.com, dan.j.williams@intel.com, dave.hansen@intel.com, juri.lelli@redhat.com, mhocko@kernel.org, peterz@infradead.org, steven.sistare@oracle.com, tglx@linutronix.de, tom.hromatka@oracle.com, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, shakeelb@google.com

On Tue, Jun 11, 2019 at 12:55:49PM -0700, Tejun Heo wrote:
> > > CPU doesn't have a backcharging mechanism yet and depending on the use
> > > case, we *might* need to put kthreads in different cgroups.  However,
> > > such use cases might not be that abundant and there may be gotaches
> > > which require them to be force-executed and back-charged (e.g. fs
> > > compression from global reclaim).
> > 
> > The CPU-intensiveness of these works is one of the reasons for actually putting
> > the workers through the migration path.  I don't know of a way to get the
> > workers to respect the cpu controller (and even cpuset for that matter) without
> > doing that.
> 
> So, I still think it'd likely be better to go back-charging route than
> actually putting kworkers in non-root cgroups.  That's gonna be way
> cheaper, simpler and makes avoiding inadvertent priority inversions
> trivial.

Ok, I'll experiment with backcharging in the cpu controller.  Initial plan is
to smooth out resource usage by backcharging after each chunk of work that each
helper thread does rather than do one giant backcharge after the multithreaded
job is over.  May turn out better performance-wise to do it less often than
this.

I'll also experiment with getting workqueue workers to respect cpuset without
migrating.  Seems to make sense to use the intersection of an unbound worker's
cpumask and the cpuset's cpumask, and make some compromises if the result is
empty.

Daniel
