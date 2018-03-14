From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm v3 1/3] mm, memcg: introduce per-memcg oom policy
 tunable
Date: Wed, 14 Mar 2018 13:58:59 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803141341180.163553@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803121757080.192200@chino.kir.corp.google.com> <20180314123851.GB20850@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=f0gUUPWBiLIFdHC9X8Z70eJel51tyGNxJAnEEirvShk=;
        b=bJgkXmybGzrznu+Kh5Eue1s5/oZ0EmTwKy41LFvadTEOjrdEPTUyrZQ/oAf/iO1Ayz
         o4s2bW4IY0aiV74C8zYBOVupa+bUBSoNPccGgVQ0yMubjIN0fGajQ9aMZRYm6lAifZ/q
         OA29VPjxwnHN7BB3vFm+LBK9WyuNfYSAsFne3NUsms6rpqYT4YdqoSYbbY1vFD5p7Lcu
         X2xo/chYusEMA/mRk9SXGVuOY0l2De+NbRd5FzinQUZzbgrDcugR4YdoszGGn8ZgeoHJ
         ucEew9q11so3yNOpNW8loXZfYpKAYNg6/yxSBjVm5RIe3eo+1OT2mJrVBVuBNttJoqsC
         0L/A==
In-Reply-To: <20180314123851.GB20850@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed, 14 Mar 2018, Roman Gushchin wrote:

> > The cgroup aware oom killer is needlessly enforced for the entire system
> > by a mount option.  It's unnecessary to force the system into a single
> > oom policy: either cgroup aware, or the traditional process aware.
> 
> Can you, please, provide a real-life example, when using per-process
> and cgroup-aware OOM killer depending on OOM scope is beneficial?
> 

Hi Roman,

This question is only about per-process vs cgroup-aware, not about the 
need for individual cgroup vs hierarchical subtree, so I'll only focus on 
that.

Three reasons:

 - Does not lock the entire system into a single methodology.  Users
   working in a subtree can default to what they are used to: per-process
   oom selection even though their subtree might be targeted by a system
   policy level decision at the root.  This allow them flexibility to
   organize their subtree intuitively for use with other controllers in a
   single hierarchy.

   The real-world example is a user who currently organizes their subtree
   for this purpose and has defined oom_score_adj appropriately and now
   regresses if the admin mounts with the needless "groupoom" option.

 - Allows changing the oom policy at runtime without remounting the entire
   cgroup fs.  Depending on how cgroups are going to be used, per-process 
   vs cgroup-aware may be mandated separately.  This is a trait only of
   the mem cgroup controller, the root level oom policy is no different
   from the subtree and depends directly on how the subtree is organized.
   If other controllers are already being used, requiring a remount to
   change the system-wide oom policy is an unnecessary burden.

   The real-world example is systems software that either supports user
   subtrees or strictly subtrees that it maintains itself.  While other
   controllers are used, the mem cgroup oom policy can be changed at
   runtime rather than requiring a remount and reorganizing other
   controllers exactly as before.

 - Can be extended to cgroup v1 if necessary.  There is no need for a
   new cgroup v1 mount option and mem cgroup oom selection is not
   dependant on any functionality provided by cgroup v2.  The policies
   introduced here work exactly the same if used with cgroup v1.

   The real-world example is a cgroup configuration that hasn't had
   the ability to move to cgroup v2 yet and still would like to use
   cgroup-aware oom selection with a very trivial change to add the
   memory.oom_policy file to the cgroup v1 filesystem.

> It might be quite confusing, depending on configuration.
> From inside a container you can have different types of OOMs,
> depending on parent's cgroup configuration, which is not even
> accessible for reading from inside.
> 

Right, and the oom is the result of the parent's limit that is outside the 
control of the user.  That limit, and now oom policy, is defined by the 
user controlling the ancestor of the subtree.  The user need not be 
concerned that it was singled out for oom kill: that policy decision is 
outside hiso or her control.  memory.oom_group can certainly be delegated 
to the user, but the targeting cannot be changed or evaded.

However, this patchset also provides them with the ability to define their 
own oom policy for subcontainers that they create themselves.

> Also, it's probably good to have an interface to show which policies
> are available.
> 

This comes back to the user interface question.  I'm very happy to address 
any way that the interface can be made better, even though I think what is 
currently proposed is satisfactory.  I think your comment eludes to thp 
like enabling where we have "[always] madvise never"?  I'm speculating 
that you may be happier with memory.oom_policy becoming 
"[none] cgroup tree" and extended for additional policies later?  
Otherwise the user would need to try the write and test the return value, 
which purely depends on whether the policy is available or not.  I'm 
rather indifferent to either interface, but if you would prefer the
"[none] cgroup tree" appearance, I'll change to that.
