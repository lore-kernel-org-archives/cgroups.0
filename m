From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [RFC v2 0/5] cgroup-aware unbound workqueues
Date: Wed, 5 Jun 2019 11:32:29 -0400
Message-ID: <20190605153229.nvxr6j7tdzffwkgj@ca-dmjordan1.us.oracle.com>
References: <20190605133650.28545-1-daniel.m.jordan@oracle.com>
 <20190605135319.GK374014@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=OZ1kDdTgN4wvLaPyCNbaBt4ZZAol0O1Af0n8ppQn/zU=;
 b=SlyLnGBXh3+Z/kVO/l6MtBnlb/hL9gKjC3CliEvgg9yYkyraDbOZv+xE+6/BydM6W02j
 8MXGwY8TYLi9z4jDghyFakXxGwlgaO/5kJ8bM0ljtmVE5iNv+yMVB/XAftSP04CwlxCC
 8m65gs3Ntc74ibhVNhve9meTwuBtHY8lwgRfnhEe978fwYosu2Eak5nBKaQbFqjbwddC
 +49tb1GrtXJ0gZJ8J362dwJw6BoCfGDK+bw0HVfdk2ZHuWWbThgQUwUoO1llvAB8Mjys
 D6PbUMcQj+WDcrplRbfyv4etIOFyiBLU7D4hfEO6EoR6Ovny60qaCVxHjA7EUq4pg0fV Pg== 
Content-Disposition: inline
In-Reply-To: <20190605135319.GK374014@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>, hannes@cmpxchg.org, jiangshanlai@gmail.com, lizefan@huawei.com, bsd@redhat.com, dan.j.williams@intel.com, dave.hansen@intel.com, juri.lelli@redhat.com, mhocko@kernel.org, peterz@infradead.org, steven.sistare@oracle.com, tglx@linutronix.de, tom.hromatka@oracle.com, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, shakeelb@google.com

Hi Tejun,

On Wed, Jun 05, 2019 at 06:53:19AM -0700, Tejun Heo wrote:
> On Wed, Jun 05, 2019 at 09:36:45AM -0400, Daniel Jordan wrote:
> > My use case for this work is kernel multithreading, the series formerly known
> > as ktask[2] that I'm now trying to combine with padata according to feedback
> > from the last post.  Helper threads in a multithreaded job may consume lots of
> > resources that aren't properly accounted to the cgroup of the task that started
> > the job.
> 
> Can you please go into more details on the use cases?

Sure, quoting from the last ktask post:

  A single CPU can spend an excessive amount of time in the kernel operating
  on large amounts of data.  Often these situations arise during initialization-
  and destruction-related tasks, where the data involved scales with system size.
  These long-running jobs can slow startup and shutdown of applications and the
  system itself while extra CPUs sit idle.
      
  To ensure that applications and the kernel continue to perform well as core
  counts and memory sizes increase, harness these idle CPUs to complete such jobs
  more quickly.
      
  ktask is a generic framework for parallelizing CPU-intensive work in the
  kernel.  The API is generic enough to add concurrency to many different kinds
  of tasks--for example, zeroing a range of pages or evicting a list of
  inodes--and aims to save its clients the trouble of splitting up the work,
  choosing the number of threads to use, maintaining an efficient concurrency
  level, starting these threads, and load balancing the work between them.

So far the users of the framework primarily consume CPU and memory.

> For memory and io, we're generally going for remote charging, where a
> kthread explicitly says who the specific io or allocation is for,
> combined with selective back-charging, where the resource is charged
> and consumed unconditionally even if that would put the usage above
> the current limits temporarily.  From what I've been seeing recently,
> combination of the two give us really good control quality without
> being too invasive across the stack.

Yes, for memory I actually use remote charging.  In patch 3 the worker's
current->active_memcg field is changed to match that of the cgroup associated
with the work.

Cc Shakeel, since we're talking about it.

> CPU doesn't have a backcharging mechanism yet and depending on the use
> case, we *might* need to put kthreads in different cgroups.  However,
> such use cases might not be that abundant and there may be gotaches
> which require them to be force-executed and back-charged (e.g. fs
> compression from global reclaim).

The CPU-intensiveness of these works is one of the reasons for actually putting
the workers through the migration path.  I don't know of a way to get the
workers to respect the cpu controller (and even cpuset for that matter) without
doing that.

Thanks for the quick feedback.

Daniel
