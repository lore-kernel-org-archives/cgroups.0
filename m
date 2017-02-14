From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Tue, 14 Feb 2017 11:35:41 +0100
Message-ID: <20170214103541.GS6515@twins.programming.kicks-ass.net>
References: <20170202200632.13992-1-tj@kernel.org>
 <20170203202048.GD6515@twins.programming.kicks-ass.net>
 <20170203205955.GA9886@mtj.duckdns.org>
 <20170206124943.GJ6515@twins.programming.kicks-ass.net>
 <20170208230819.GD25826@htj.duckdns.org>
 <20170209102909.GC6515@twins.programming.kicks-ass.net>
 <20170210154508.GA16097@mtj.duckdns.org>
 <20170210175145.GJ6515@twins.programming.kicks-ass.net>
 <20170212050544.GJ29323@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mj4CJjzsIanQ9dP5+Hvy+vkoH2eQPY8Ldw5+rO0PrDo=; b=E6kJTihIU3E3A/PT6eiCX0JHy
        9R4RsvZVY8KWffZBvTqAbnY2wXXDI5nIf6QlHCvB8ZDqHEr8OLLXqujrDeRA7JsUhcX0ixCcDfiFo
        otsPk+4Cyj4NTp9qi8fQNkl6WpUdD4mNfTYqt3tLpem8t0p66oDRskVDW4nT5V8oLz18UkLTmtCPB
        66WoSWCOrNa9I93o3ocEK6dVmEx5LuxXnfuLfSW0FG1WNXQ9bXErTmqL3SYLwARr3czo8CyEWkEdM
        gfL9uuwalsm3BYOA3xIcDOLRqeAovKj8DuoRoEyTkg2KuxADzNZ35JQCT6uISjoXrbGlAstL863XO
    
Content-Disposition: inline
In-Reply-To: <20170212050544.GJ29323@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, lvenanci@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Sun, Feb 12, 2017 at 02:05:44PM +0900, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 10, 2017 at 06:51:45PM +0100, Peter Zijlstra wrote:
> > Sure, we're past that. This isn't about what memcg can or cannot do.
> > Previous discussions established that controllers come in two shapes:
> > 
> >  - task based controllers; these are build on per task properties and
> >    groups are aggregates over sets of tasks. Since per definition inter
> >    task competition is already defined on individual tasks, its fairly
> >    trivial to extend the same rules to sets of tasks etc..
> > 
> >    Examples: cpu, cpuset, cpuacct, perf, pid, (freezer)
> >
> >  - system controllers; instead of building from tasks upwards, they
> >    split what previously would be machine wide / global state. For these
> >    there is no natural competition rule vs tasks, and hence your
> >    no-internal-task rule.
> > 
> >    Examples: memcg, io, hugetlb
> 
> This is a bit of delta but as I wrote before, at least cpu (and
> accordingly cpuacct) won't stay purely task-based as we should account
> for resource consumptions which aren't tied to specific tasks to the
> matching domain (e.g. CPU consumption during writeback, disk
> encryption or CPU cycles spent to receive packets).

We should probably do that in another thread, but I'd probably insist on
separate controllers that co-operate to get that done.

> > > And here's another point, currently, all controllers are enabled
> > > consecutively from root.  If we have leaf thread subtrees, this still
> > > works fine.  Resource domain controllers won't be enabled into thread
> > > subtrees.  If we allow switching back and forth, what do we do in the
> > > middle while we're in the thread part?
> > 
> > From what I understand you cannot re-enable a controller once its been
> > disabled, right? If you disable it, its dead for the entire subtree.
> 
> cgroups on creation don't enable controllers by default and users can
> enable and disable controllers dynamically as long as the conditions
> are met.  So, they can be disable and re-enabled.

I was talking in a hierarchical sense, your section 2-4-2. Top-Down
constraint seems to state similar things to what I meant.

Once you disable a controller it cannot be re-enabled in a subtree.

> > > No matter what we do, it's
> > > gonna be more confusing and we lose basic invariants like "parent
> > > always has superset of control knobs that its child has".
> > 
> > No, exactly that. I don't think I ever proposed something different.
> >
> > The "resource domain" flag I proposed violates the no-internal-processes
> > thing, but it doesn't violate that rule afaict.
> 
> If we go to thread mode and back to domain mode, the control knobs for
> domain controllers don't make sense on the thread part of the tree and
> they won't have cgroup_subsys_state to correspond to either.  For
> example,
> 
>  A - T - B
> 
> B's memcg knobs would control memory distribution from A and cgroups
> in T can't have memcg knobs.  It'd be weird to indicate that memcg is
> enabled in those cgroups too.

But memcg _is_ enabled for T. All the tasks are mapped onto A for
purpose of the system controller (memcg) and are subject to its
constraints.

> We can make it work somehow.  It's just weird-ass interface.

You could make these control files (read-only?) symlinks back to A's
actual control files. To more explicitly show this.

> > > As for the runtime overhead, if you get affected by adding a top-level
> > > cgroup in any measureable way, we need to fix that.  That's not a
> > > valid argument for messing up the interface.
> > 
> > I think cgroup tree depth is a more significant issue; because of
> > hierarchy we often do tree walks (uo-to-root or down-to-task).
> > 
> > So creating elaborate trees is something I try not to do.
> 
> So, as long as the depth stays reasonable (single digit or lower),
> what we try to do is keeping tree traversal operations aggregated or
> located on slow paths. 

While at the same time you allowed that BPF cgroup thing to not be
hierarchical because iterating the tree was too expensive; or did I
misunderstand?

Also, I think Mike showed you the pain and hurt are quite visible for
even a few levels.

Batching is tricky, you need to somehow bound the error function in
order to not become too big a factor on behaviour. Esp. for cpu, cpuacct
obviously doesn't care much as it doesn't enforce anything.

> In general, I think it's important to ensure that this in general is
> the case so that users can use the logical layouts matching the actual
> resource hierarchy rather than having to twist the layout for
> optimization.

One does what one can.. But it is important to understand the
constraints, nothing comes for free.

> > > Even if we allow switching back and forth, we can't make the same
> > > cgroup both resource domain && thread root.  Not in a sane way at
> > > least.
> > 
> > The back and forth thing yes, but even with a single level, the one
> > resource domain you tag will be both resource domain and thread root.
> 
> Ah, you're right.

Also, there is the one giant wart in v2 wrt no-internal-processes;
namely the root group is allowed to have them.

Now I understand why this is so; so don't feel compelled to explain that
again, but it does make the model very ugly and has a real problem, see
below. OTOH, since it is there, I would very much like to make use of
this 'feature' and allow a thread-group on the root group.

And since you then _can_ have nested thread groups, it again becomes
very important to be able to find the resource domains, which brings me
back to my proposal; albeit with an addition constraint.

Now on to the problem of the no-internal-processes wart; how does
cgroup-v2 currently implement the whole container invariant? Because by
that invariant, a container's 'root' group must also allow
internal-processes.

