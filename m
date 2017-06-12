From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Mon, 12 Jun 2017 14:31:50 +0200
Message-ID: <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
References: <20170610140351.10703-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=z8vXwMgBdwIRGNllsexOKrcEn/RzIpfiVDB4lWwwR1M=; b=jID/SHtYqbQWCF9gqN3+0cdyr
        dRp/4+TPUZrBCw+FMivtEnGcstpwySiNzXr6HW/W6wHFC2iuDapuH3LD/QoncGKW1Rxo+qG/ecv+i
        YEabW1fLXK7kFP7nMODH3HKExlPSwpcsy3NmsaICoAHsD1gWTGZgGpiG8hYcsmBdHlcJp7hHVn6ea
        U76gQwctkxRXXRzvA0rMpycsAeQ1IAQ85mkQJhodePIMo7JutjbUcL6OazLBkRrOb24N+K8wjnyI0
        yBM8zELhfr7bUwHcL+KoR9ETsZwRmyl+qIVLCJbGHbl7Ja75jGeTtz7Q0gsryl/W88uZT+Qvao9ZW
      
Content-Disposition: inline
In-Reply-To: <20170610140351.10703-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org


Please don't rush this; also, I might not be around much the coming
weeks due to taking some leave 'soon' (kid #3 is imminent).

And I really need more time to look at this (and re-read the old
discussions, because I've forgot most everything again).

On Sat, Jun 10, 2017 at 10:03:41AM -0400, Tejun Heo wrote:

> * Thread mode is explicitly enabled on a cgroup by writing "enable"
>   into "cgroup.threads" file.  The cgroup shouldn't have any child
>   cgroups or enabled controllers.
> 
> * Once enabled, arbitrary sub-hierarchy can be created and threads can
>   be put anywhere in the subtree by writing TIDs into "cgroup.threads"
>   file.  Process granularity and no-internal-process constraint don't
>   apply in a threaded subtree.
> 
> * To be used in a threaded subtree, controllers should explicitly
>   declare thread mode support and should be able to handle internal
>   competition in some way.
> 
> * The root of a threaded subtree serves as the resource domain for the
>   whole subtree.  This is where all the controllers are guaranteed to
>   have a common ground and resource consumptions in the threaded
>   subtree which aren't tied to a specific thread are charged.
>   Non-threaded controllers never see beyond thread root and can assume
>   that all controllers will follow the same rules upto that point.
> 
> * Root cgroup can enable thread mode anytime and a first level child
>   can opt-in to that thread subtree anchored at root by writing "join"
>   to "cgroup.threads" files, start its own thread subtree or just be a
>   normal cgroup.

Yuck... this again is a consequence of tagging the 'wrong' thing. Again,
the primary construct is the resource domain.

If you use that as a tag, you don't need this weird join crap. Because
as soon as you clear the 'resource domain' flag on a group, it instantly
becomes a thread group and 'obviously' connects to the first parent that
is a resource domain.

And, as per the last time, this threaded marker isn't uniquely
identifying things, so it hard prohibits from ever extending the model
to allow resource domains nested in a thread subtree. Now I understand
why you don't implement that now -- you were struggling with the views
API, but that is no excuse to create an API that permanently disables
that feature.

I cannot at this time remember if there was a strong use-case for that
scenario -- like said, I really need to re-read the email threads, but I
might not have enough time to do so now.

Again, please don't rush this.

> This allows threaded controllers to implement thread granular resource
> control without getting in the way of system level resource
> partitioning.
> 
> This patchset contains the following ten patches.  For more details on
> the interface and behavior, please refer to 0007.
> 
>  0001-cgroup-separate-out-cgroup_has_tasks.patch
>  0002-cgroup-reorganize-cgroup.procs-task-write-path.patch
>  0003-cgroup-Fix-reference-counting-bug-in-cgroup_procs_wr.patch
>  0004-cgroup-add-flags-to-css_task_iter_start-and-implemen.patch
>  0005-cgroup-introduce-cgroup-proc_cgrp-and-threaded-css_s.patch
>  0006-cgroup-implement-CSS_TASK_ITER_THREADED.patch
>  0007-cgroup-implement-cgroup-v2-thread-support.patch
>  0008-sched-Misc-preps-for-cgroup-unified-hierarchy-interf.patch
>  0009-sched-Implement-interface-for-cgroup-unified-hierarc.patch
>  0010-sched-Make-cpu-cpuacct-threaded-controllers.patch
> 
> 0001-0007 implement cgroup2 thread mode.  0008-0010 enable CPU
> controller on cgroup2 and mark them as supporting thread mode.
> 0008-0010 are included for reference.

So I really regret the 'shares' interface; we really should have done a
nice thing.

  https://lkml.kernel.org/r/20170410073622.2y6tnpcd2ssuoztz-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org

So I would like to change to that instead of the weird 100 thing.

As for the RT thing, the runtime/period thing is not a MAX but a MIN
limit (conceptually -- in practise its both).

Also, we need cpuset to be a thread controller.
