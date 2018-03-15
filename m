From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm v3 1/3] mm, memcg: introduce per-memcg oom policy
 tunable
Date: Thu, 15 Mar 2018 13:16:53 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803151301480.44030@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803121757080.192200@chino.kir.corp.google.com> <20180314123851.GB20850@castle.DHCP.thefacebook.com> <alpine.DEB.2.20.1803141341180.163553@chino.kir.corp.google.com>
 <20180315171039.GB1853@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=ZEQ7zb8oPJO1VnWyjccXN2Sd3s83Gtw3Gt2i7hwSBk4=;
        b=e2kPVs8TN5RyO4KNLm+ceyjd2MQkw7I/st4JqI9pIObmCYrWq4Mw9SF2nuLkEtzNHB
         bt6EnEQo8TggoSsG3mO0akB8hWZG1MyKLxRUpqziQpi26wPZBt4lU7TMwRIsc2J9bswC
         torkTZIF3sOdN7Fal1qZEfWbRSsNNvfSYbI2vuE9e1DanFf8vwUZUxWDWsqkb73tLkVq
         xeBQr2MrYF/1668rgLWHGwHa/NoQ/7tlYxeRgiEhOp+2CZUxl1qQErwjruHL/BG/Ro5U
         Ba3XU0OT9Sj1i4QbOp3jCYrl3rxJfW8i2WvhblDzh1Dv2qrqVqtB2CjUI1Mana72z4E2
         ovhg==
In-Reply-To: <20180315171039.GB1853@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu, 15 Mar 2018, Roman Gushchin wrote:

> >  - Does not lock the entire system into a single methodology.  Users
> >    working in a subtree can default to what they are used to: per-process
> >    oom selection even though their subtree might be targeted by a system
> >    policy level decision at the root.  This allow them flexibility to
> >    organize their subtree intuitively for use with other controllers in a
> >    single hierarchy.
> > 
> >    The real-world example is a user who currently organizes their subtree
> >    for this purpose and has defined oom_score_adj appropriately and now
> >    regresses if the admin mounts with the needless "groupoom" option.
> 
> I find this extremely confusing.
> 
> The problem is that OOM policy defines independently how the OOM
> of the corresponding scope is handled, not like how it prefers
> to handle OOMs from above.
> 
> As I've said, if you're inside a container, you can have OOMs
> of different types, depending on settings, which you don't even know about.
> Sometimes oom_score_adj works, sometimes not.
> Sometimes all processes are killed, sometimes not.
> IMO, this adds nothing but mess.
> 

There are many additional problems with the cgroup aware oom killer in 
-mm, yes, the fact that memory.oom_group is factored into the selection 
logic is another problem.  Users who prefer to account their subtree for 
comparison (the only way to avoid allowing users to evade the oom killer 
completely) should use the memory.oom_policy of "tree" introduced later.  
memory.oom_group needs to be completely separated from the policy of 
selecting a victim, it shall only be a mechanism that defines if a single 
process is oom killed or all processes attached to the victim mem cgroup 
as a property of the workload.

> The mount option (which I'm not a big fan of too) was added only
> to provide a 100% backward compatibility, what was forced by Michal.
> But I doubt that mixing per-process and per-cgroup approach
> makes any sense.
> 

It makes absolute sense and has real users who can immediately use this if 
it's merged.  There is nothing wrong with a user preferring to kill the 
largest process from their subtree on mem cgroup oom.  It's what they've 
always experienced, with cgroup v1 and v2.  It's the difference between 
users in a subtree being able to use /proc/pid/oom_score_adj or not.  
Without it, their oom_score_adj values become entirely irrelevant.  We 
have users who tune their oom_score_adj and are running in a subtree they 
control.

If an overcomitted ancestor is oom, which is up to the admin to define in 
the organization of the hierarchy and imposing limits, the user does not 
control which process or group of processes is oom killed.  That's a 
decision for the ancestor which controls all descendant cgroups, including 
limits and oom policies.

> > 
> >  - Allows changing the oom policy at runtime without remounting the entire
> >    cgroup fs.  Depending on how cgroups are going to be used, per-process 
> >    vs cgroup-aware may be mandated separately.  This is a trait only of
> >    the mem cgroup controller, the root level oom policy is no different
> >    from the subtree and depends directly on how the subtree is organized.
> >    If other controllers are already being used, requiring a remount to
> >    change the system-wide oom policy is an unnecessary burden.
> > 
> >    The real-world example is systems software that either supports user
> >    subtrees or strictly subtrees that it maintains itself.  While other
> >    controllers are used, the mem cgroup oom policy can be changed at
> >    runtime rather than requiring a remount and reorganizing other
> >    controllers exactly as before.
> 
> Btw, what the problem with remounting? You don't have to re-create cgroups,
> or something like this; the operation is as trivial as adding a flag.
> 

Remounting is for the entire mem cgroup hierarchy.  The point of this 
entire patchset is that different subtrees will have different policies, 
it cannot be locked into a single selection logic.

This completely avoids users being able to evade the cgroup-aware oom 
killer by creating subcontainers.

Obviously I've been focused on users controlling subtrees in a lot of my 
examples.  Those users may already prefer oom killing the largest process 
on the system (or their subtree).  They can still do that with this patch 
and opt out of cgroup awareness for their subtree.

It also provides all the functionality that the current implementation in 
-mm provides.

> > 
> >  - Can be extended to cgroup v1 if necessary.  There is no need for a
> >    new cgroup v1 mount option and mem cgroup oom selection is not
> >    dependant on any functionality provided by cgroup v2.  The policies
> >    introduced here work exactly the same if used with cgroup v1.
> > 
> >    The real-world example is a cgroup configuration that hasn't had
> >    the ability to move to cgroup v2 yet and still would like to use
> >    cgroup-aware oom selection with a very trivial change to add the
> >    memory.oom_policy file to the cgroup v1 filesystem.
> 
> I assume that v1 interface is frozen.
> 

It requires adding the memory.oom_policy file to the cgroup v1 fs, that's 
it.  No other support is needed.  If that's allowed upstream, great; if 
not, it's a very simple patch to carry for a distribution.
