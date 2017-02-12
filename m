From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Sun, 12 Feb 2017 14:05:44 +0900
Message-ID: <20170212050544.GJ29323@mtj.duckdns.org>
References: <20170202200632.13992-1-tj@kernel.org>
 <20170203202048.GD6515@twins.programming.kicks-ass.net>
 <20170203205955.GA9886@mtj.duckdns.org>
 <20170206124943.GJ6515@twins.programming.kicks-ass.net>
 <20170208230819.GD25826@htj.duckdns.org>
 <20170209102909.GC6515@twins.programming.kicks-ass.net>
 <20170210154508.GA16097@mtj.duckdns.org>
 <20170210175145.GJ6515@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Lhh9JoGqdVEo9Rqnp8/Pb7NuQsg1GB0XEm9MVDpmllI=;
        b=CLUHkhDA+3OKUhYGGQm2h4x18V/hG7sSxLgpWKtn3Gax2as5Ki/6cFiVdoQo4OJuDu
         kzkdEvTPafERqJWozD5pxiWx/c9VmOZ3SQ6J1z//AtatLCSV48LsA/fCiE1oalTyvd8A
         GznbTgX9/uGDvctyC9jcI/yirIbhvGjX3ip8esh4OxN1arPMevoI84Dc8G5wJMCgKT1d
         8vz0nXknAJZtOTExGUL2keoX72rqOmXleNGH5IePNHvVAfQjg4YXQmzXeG1eeOjvR4Kx
         0WSQiKQzf9umDVnZ2UIB9dojHiL3l8AxDpEalzWkKdKnK+1AdPPKd+ijBAtKzG6oOvHj
         oEGA==
Content-Disposition: inline
In-Reply-To: <20170210175145.GJ6515-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Fri, Feb 10, 2017 at 06:51:45PM +0100, Peter Zijlstra wrote:
> Sure, we're past that. This isn't about what memcg can or cannot do.
> Previous discussions established that controllers come in two shapes:
> 
>  - task based controllers; these are build on per task properties and
>    groups are aggregates over sets of tasks. Since per definition inter
>    task competition is already defined on individual tasks, its fairly
>    trivial to extend the same rules to sets of tasks etc..
> 
>    Examples: cpu, cpuset, cpuacct, perf, pid, (freezer)
>
>  - system controllers; instead of building from tasks upwards, they
>    split what previously would be machine wide / global state. For these
>    there is no natural competition rule vs tasks, and hence your
>    no-internal-task rule.
> 
>    Examples: memcg, io, hugetlb

This is a bit of delta but as I wrote before, at least cpu (and
accordingly cpuacct) won't stay purely task-based as we should account
for resource consumptions which aren't tied to specific tasks to the
matching domain (e.g. CPU consumption during writeback, disk
encryption or CPU cycles spent to receive packets).

> > And here's another point, currently, all controllers are enabled
> > consecutively from root.  If we have leaf thread subtrees, this still
> > works fine.  Resource domain controllers won't be enabled into thread
> > subtrees.  If we allow switching back and forth, what do we do in the
> > middle while we're in the thread part?
> 
> From what I understand you cannot re-enable a controller once its been
> disabled, right? If you disable it, its dead for the entire subtree.

cgroups on creation don't enable controllers by default and users can
enable and disable controllers dynamically as long as the conditions
are met.  So, they can be disable and re-enabled.

> > No matter what we do, it's
> > gonna be more confusing and we lose basic invariants like "parent
> > always has superset of control knobs that its child has".
> 
> No, exactly that. I don't think I ever proposed something different.
>
> The "resource domain" flag I proposed violates the no-internal-processes
> thing, but it doesn't violate that rule afaict.

If we go to thread mode and back to domain mode, the control knobs for
domain controllers don't make sense on the thread part of the tree and
they won't have cgroup_subsys_state to correspond to either.  For
example,

 A - T - B

B's memcg knobs would control memory distribution from A and cgroups
in T can't have memcg knobs.  It'd be weird to indicate that memcg is
enabled in those cgroups too.

We can make it work somehow.  It's just weird-ass interface.

> > As for the runtime overhead, if you get affected by adding a top-level
> > cgroup in any measureable way, we need to fix that.  That's not a
> > valid argument for messing up the interface.
> 
> I think cgroup tree depth is a more significant issue; because of
> hierarchy we often do tree walks (uo-to-root or down-to-task).
> 
> So creating elaborate trees is something I try not to do.

So, as long as the depth stays reasonable (single digit or lower),
what we try to do is keeping tree traversal operations aggregated or
located on slow paths.  There still are places that this overhead
shows up (e.g. the block controllers aren't too optimized) but it
isn't particularly difficult to make a handful of layers not matter at
all.  memcg batches the charging operations and it's impossible to
measure the overhead of several levels of hierarchy.

In general, I think it's important to ensure that this in general is
the case so that users can use the logical layouts matching the actual
resource hierarchy rather than having to twist the layout for
optimization.

> > Even if we allow switching back and forth, we can't make the same
> > cgroup both resource domain && thread root.  Not in a sane way at
> > least.
> 
> The back and forth thing yes, but even with a single level, the one
> resource domain you tag will be both resource domain and thread root.

Ah, you're right.

Thanks.

-- 
tejun
