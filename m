From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Mon, 10 Jul 2017 10:32:00 +0200
Message-ID: <20170710083200.poevcjo7x47hy5ni@hirez.programming.kicks-ass.net>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
 <20170612212753.GN19206@htj.duckdns.org>
 <20170627070143.GB4114@worktop>
 <20170630132324.GA18669@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZzAkyrdVP0Wdlh+yzO0tHdos6U2/le7xSmltMBDDfkM=; b=D/AqLGXzWMK5ZVpB/7kcH3noA
        QcgULpy41nsnwK8R2e++d0yu+nQxYK0R7N3FuLy2JTtqQB03WnCSBkfFfPhyG03lXxqJ50iMJOH1j
        8YnZXKHo0Ey+iMs+u46WxV4/hvz4GtaE//jvjdWRpjLw/97yEAFWXgt8W+Iti5gRriAcdBdZygrtA
        +/YcOz9xdkJQb7BFrCoO3JYecnQet+vuCehohfF/OoF/sZJPA11fmjrQdWUclRAe/Sy7aTIjv3R+C
        VdJlyOOKypSbTBFABJEZTTuTIlXlCFDdpdCpau3usHJXKMQMDPVqPS4wj2/xMLYgmgRxBCWVM6NrL
    
Content-Disposition: inline
In-Reply-To: <20170630132324.GA18669@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, hannes@cmpxchg.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org

On Fri, Jun 30, 2017 at 09:23:24AM -0400, Tejun Heo wrote:
> On Tue, Jun 27, 2017 at 09:01:43AM +0200, Peter Zijlstra wrote:
> > On Mon, Jun 12, 2017 at 05:27:53PM -0400, Tejun Heo wrote:

> > IIRC the problem with the 'threaded' marker is that it doesn't clearly
> > capture what a resource domain is.
> > 
> > That is, assuming that a thread root is always a resource domain, we get
> > the following problem:
> > 
> > If we set 'threaded' on the root group in order to create a thread
> > (sub)group. If we then want to create another domain group, we'd have to
> > clear 'threaded' on that.
> > 
> > 	R (t=1)
> >        / \
> > (t=1) T   D (t=0)
> > 
> > So far so good. However, now we want to create another thread group
> > under our domain group D, so we have to set its 'threaded' marker again:
> > 
> > 	R (t=1)
> >        / \
> > (t=1) T   D (t=1)
> >          /
> > 	T (t=1)
> > 
> > And we can no longer identify D as a resource domain. If OTOH we mark
> > 'domain' we get:
> > 
> > 	R (d=1)
> >        / \
> > (d=0) T   D (d=1)
> >          /
> > 	T (d=0)
> > 
> > Which clearly identifies the domains and the thread only groups.
> 
> So, the difference between the two interfaces is that the one I
> proposed is marking the thread root which makes all its descendants
> threaded while the above is marking each individual cgroup as being
> whether a resource domain or threaded.

You start by marking the thread root, but then continue to mark all
'threaded' (including root). This then leads to the problem described
above where you cannot (easily) (re)discover what the actual root is.

My proposal differs in that we retain a clear difference between
resource domain / root and threaded (sub)trees.

> > Your objections to doing this were representing the resource controllers
> > in the intermediate thread-only groups like:
> > 
> >    R
> >     \
> >      T  -- what to do with eg. memcg here?
> >       \
> >        D
> >         \
> > 	     T
> 
> And that's a perfectly valid point and as you pointed out the downside
> of marking each node separately is that the interface would allow
> configurations which aren't supported (at least for now) and that
> there's just more to configure - the user has to set the mode on each
> node after creation which is just the natural cost of being able to
> express more.

I'm not sure my proposal results in _more_ configuration per-se. Yes
there are some differences, but they go both ways, with the threaded tag
its easier to create multiple threaded subgroups, but with the domain
tag its easier to create multiple domain subgroups.

And I think the bias for the domain tag -- easier to create more domains
-- is the right one. The whole threaded thing is fairly special purpose.

In any case; I'm fine with initially not supporting domains nested under
thread groups -- although I do think there's valid use-cases for doing
so.

> > I suggested having all resource controllers represented with a soft-link
> > back into the (thread-root) resource domain. But you were not convinced
> > and worried people were going to be confused.
> 
> There's more to it than just confusion because resource interface
> files belong to the parent cgroup rather than the cgroup which hosts
> the files.  This becomes clear when thinking about which files a
> container should be granted write access to when delegating a cgroup
> subtree to it.  I'm sure we can get around it some way but we need to
> be careful here.

I would suggest having all the back-links be RO. That way you can never
grant write permission, can never actually change things that don't make
'sense', but get a really good clue where you need to go.

> > By having both in nice units, its both conceptually clear that they're
> > the same kind of weight and easier to match weights.

> But, it doesn't have to be this or that.  We can easily support both
> units by simply allowing, say, "-5n" to be written to cpu.weight file
> and interpret that as the nice value and exposing the closest nice
> value in the cpu.stat file.
> 
> Does that sound workable?

Not sure; reading the value would become somewhat awkward I suppose. But
maybe we can simply do two files, whichever is written to last takes
precedence. And when a !nice weight is written, the nice file returns
-EINVAL or something.

Not particularly pretty though...
