From: David Rientjes <rientjes@google.com>
Subject: Re: [patch v3 -mm 3/6] mm, memcg: add hierarchical usage oom
 policy
Date: Mon, 23 Jul 2018 16:22:06 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1807231614530.196032@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803151351140.55261@chino.kir.corp.google.com> <alpine.DEB.2.20.1803161405410.209509@chino.kir.corp.google.com> <alpine.DEB.2.20.1803221451370.17056@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1807131604560.217600@chino.kir.corp.google.com> <alpine.DEB.2.21.1807131605590.217600@chino.kir.corp.google.com> <20180716181613.GA28327@castle> <alpine.DEB.2.21.1807162101170.157949@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1807231331510.105582@chino.kir.corp.google.com> <20180723212855.GA25062@castle>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=54Ue/XfEnu8lGpzmGDRsShB9nSz4Ha2CkuH2Vg11PhA=;
        b=UF9Og/j9Y+tPmUMSIE2n6jH/9doiUNHZmaNsK5YTf5EujLtH5DWOygQsEVhXTaP3NG
         2wwuHOpfeDXgBKAqzxScYiZNVX9C+olwmI+UDjC4S9Q9dc5l3IiZOBIxGpH0zIsbO6Ze
         b3YTfwu6sdc6QEfe8EQqHVyWBoXzgTAM2BP5O9EXHpRHC+lsF7d865mR+i0p7rIjePQw
         pO+kb+efp7R/b3jjMJ+AY9+QS8bDl7qlpSrllaeyKttkrgW/ZklJubs/EVKuHGAXlRse
         6wVHeATh3q6+8J+8ZgK8c9A0Ldbmgyv5fM184yz7WPtlxofJVX+iHPia0SbHmn8FS8pH
         9Xsg==
In-Reply-To: <20180723212855.GA25062@castle>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Mon, 23 Jul 2018, Roman Gushchin wrote:

> > Roman, I'm trying to make progress so that the cgroup aware oom killer is 
> > in a state that it can be merged.  Would you prefer a second tunable here 
> > to specify a cgroup's points includes memory from its subtree?
> 
> Hi, David!
> 
> It's hard to tell, because I don't have a clear picture of what you're
> suggesting now.

Each patch specifies what it does rather elaborately.  If there's 
confusion on what this patch, or any of the patches in this patchset, is 
motivated by or addresses, please call it out specifically.

> My biggest concern about your last version was that it's hard
> to tell what oom_policy really defines. Each value has it's own application
> rules, which is a bit messy (some values are meaningful for OOMing cgroup only,
> other are reading on hierarchy traversal).
> If you know how to make it clear and non-contradictory,
> please, describe the proposed interface.
> 

As my initial response stated, "tree" has cgroup aware properties but it 
considers the subtree usage as its own.  I do not know of any usecase, 
today or in the future, that would want subtree usage accounted to its own 
when being considered as a single indivisible memory consumer yet still 
want per-process oom kill selection.

If you do not prefer that overloading, I can break the two out from one 
another such that one tunable defines cgroup vs process, and another 
defines subtree usage being considered or not.  That's a perfectly fine 
suggestion and I have no problem implementing it.  The only reason I did 
not was because I do not know of any user that would want process && 
subtree and that would reduce the number of files for mem cgroup by one.

If you'd like me to separate these out by adding another tunable, please 
let me know.  We will already have another tunable later, but is not 
required for this to be merged as the cover letter states, to allow the 
user to adjust the calculation for a subtree such that it may protect 
important cgroups that are allowed to use more memory than others.

> > It would be helpful if you would also review the rest of the patchset.
> 
> I think, that we should focus on interface semantics right now.
> If we can't agree on how the things should work, it makes no sense
> to discuss the implementation.
> 

Yes, I have urged that we consider the interface in both the 
memory.oom_group discussion as well as the discussion here, which is why 
this patchset removes the mount option, does not lock down the entire 
hierarchy into a single policy, and is extensible to be generally useful 
outside of very special usecases.
