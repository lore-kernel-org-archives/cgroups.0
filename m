From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 10:41:04 -0400
Message-ID: <20150505144104.GS1971@htj.duckdns.org>
References: <5546C34C.7050202@huawei.com>
 <1430709236.3129.42.camel@gmail.com>
 <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=sFbgGRoRANTNlibpZMpKsIuDwwo6iSjRuDAbRTdKVDA=;
        b=UhHZh0dvnJrkx//5YjT+zs7rWsLgwo+VREdp67HwCuYtw8gIe1hrvAOwvbXrijLjK1
         4KUlDMyf65f7Z3V7f+JR0KNhlGBFI1PNV6jSSs796bt58dzZ/k22ktpWP8aVJqdvQ4Q8
         pQOxbBreAGrItM/7hd4S5QIFKU+k63xnQsWngM+2bBt9xOINy5jEuiG/ijT+f0cxaGQS
         TBoV1wZLHyNZDsSqBKoKgLLtL8JI5SakVBV8AVvqXsSA3SokfX2/kQ6metWwgpggpdUj
         7gTTkEXwxAG2NNnxbO3Lq4G3ihEd1A/OXoaHz9vzjV27labttsqxJwAzkZDxKLQuAFHd
         2IDA==
Content-Disposition: inline
In-Reply-To: <20150504123738.GZ21418@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hello, Peter.

On Mon, May 04, 2015 at 02:37:38PM +0200, Peter Zijlstra wrote:
> > I just realized we allow removing/adding controllers from/to cgroups
> > while there are tasks in them, which isn't safe unless we eliminate all
> > can_attach callbacks. We've done so for some cgroup subsystems, but
> > there are still a few of them...
> 
> You can't remove can_attach(), we must be able to disallow joining a
> cgroup.
> 
> If that results in you not being able to change the cgroup setup with
> tasks in, so be it -- that seems like a sane restriction anyhow.

This is really an interface policy issue.  For all other controllers,
it's almost trivial to let organizational operations (setting up
hierarchies, moving processes around) overrule controller
configurations.  The main benefit of doing this is that this decouples
organizational operations from resource control.  Users can depend on
the fact that allowed organizational operations won't fail due to
specific controller configuration issues.

This also works well with controllers accepting target configurations
regardless of the current state and enforcing rules to converge to the
configured state instead.  e.g. if you set max memory lower than the
currently used, the config will be accepted and the controller will
keep trying to make the current state converge to the target state.
This is important as rejecting configuration can lead to chasing game
between configuration attempts and run-away resource consumption.

Now, RR slices are the special case here because it's inherently
different from every other resource cgroup is concerned with.  It
simply doesn't fit into the same model that other resources follow.
There are several options we can try.

1. Decouple RR slices from cpu controller.  This would be the best
   route to follow.  RR slices need a hard allocator no matter what we
   do.  There isn't much point in imposing hierarchical structure on
   top of it.

2. Implement special case behavior so that it can follow the same
   model.  e.g. resetting RR scheduling config when the effective cpu
   cgroup changes or carrying the amount of slice being consumed with
   the process being moved.  No matter how this is done, it's gonna be
   a clear compromise as we're forcing this into the model which
   doesn't quite fit it.  That said, given how RR slices are a special
   case to begin with, I think this can be acceptable.

3. Take compromise in the other direction - add exceptions to
   organizational operations but clearly limit the failure modes.  We
   prolly want to structure code in a way to enforce this.

4. If #1 can be done in time but not right now, simply disallow any
   RR/FIFO in !root cgroups on the unified hierarchy for now.

What do you think?

Thanks.

-- 
tejun
