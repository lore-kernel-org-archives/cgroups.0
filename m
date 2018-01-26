From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch -mm v2 2/3] mm, memcg: replace cgroup aware oom killer
 mount option with tunable
Date: Fri, 26 Jan 2018 14:39:50 -0800
Message-ID: <20180126143950.719912507bd993d92188877f@linux-foundation.org>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
        <alpine.DEB.2.10.1801251552320.161808@chino.kir.corp.google.com>
        <alpine.DEB.2.10.1801251553030.161808@chino.kir.corp.google.com>
        <20180125160016.30e019e546125bb13b5b6b4f@linux-foundation.org>
        <alpine.DEB.2.10.1801261415090.15318@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1801261415090.15318@chino.kir.corp.google.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Fri, 26 Jan 2018 14:20:24 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> On Thu, 25 Jan 2018, Andrew Morton wrote:
> 
> > > Now that each mem cgroup on the system has a memory.oom_policy tunable to
> > > specify oom kill selection behavior, remove the needless "groupoom" mount
> > > option that requires (1) the entire system to be forced, perhaps
> > > unnecessarily, perhaps unexpectedly, into a single oom policy that
> > > differs from the traditional per process selection, and (2) a remount to
> > > change.
> > > 
> > > Instead of enabling the cgroup aware oom killer with the "groupoom" mount
> > > option, set the mem cgroup subtree's memory.oom_policy to "cgroup".
> > 
> > Can we retain the groupoom mount option and use its setting to set the
> > initial value of every memory.oom_policy?  That way the mount option
> > remains somewhat useful and we're back-compatible?
> > 
> 
> -ECONFUSED.  We want to have a mount option that has the sole purpose of 
> doing echo cgroup > /mnt/cgroup/memory.oom_policy?

Approximately.  Let me put it another way: can we modify your patchset
so that the mount option remains, and continues to have a sufficiently
same effect?  For backward compatibility.

> This, and fixes to fairly compare the root mem cgroup with leaf mem 
> cgroups, are essential before the feature is merged otherwise it yields 
> wildly unpredictable (and unexpected, since its interaction with 
> oom_score_adj isn't documented) results as I already demonstrated where 
> cgroups with 1GB of usage are killed instead of 6GB workers outside of 
> that subtree.

OK, so Roman's new feature is incomplete: it satisfies some use cases
but not others.  And we kinda have a plan to address the other use
cases in the future.

There's nothing wrong with that!  As long as we don't break existing
setups while evolving the feature.  How do we do that?


