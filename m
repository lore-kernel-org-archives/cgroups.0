From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm v2 2/3] mm, memcg: replace cgroup aware oom killer
 mount option with tunable
Date: Fri, 26 Jan 2018 14:52:59 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1801261441340.20954@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com> <alpine.DEB.2.10.1801251552320.161808@chino.kir.corp.google.com> <alpine.DEB.2.10.1801251553030.161808@chino.kir.corp.google.com> <20180125160016.30e019e546125bb13b5b6b4f@linux-foundation.org>
 <alpine.DEB.2.10.1801261415090.15318@chino.kir.corp.google.com> <20180126143950.719912507bd993d92188877f@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=YsMh1dYg2XOia6t8+Lq0kimSv9ADDKsfx9pJlAjb2E8=;
        b=ltpdRcxYopBDTX2XzVJAySnvu0ycrGuC6IEGSuxK2zAZjP9LSsDrnjahxfqFwZTgKZ
         lHpOVCjemgSuVv+Tp6I5ffuNvphO0smwxhQ7Jc0P2Pnk1+kcJnpO92snBrPWyaW7L/BV
         ouHMXWAbLt1iK55oSwKB29TXcoayhhIzOEkhMqylpH/RnY9H3tuSORUKmgTkhUgnZRzx
         9yHJWklrYAhRLzIU1DXt7XGgBU9JeVSk8rc1EpRE+ZHcO2zfAEJPRQTFGLBWVo71oevz
         X2tPY5veugfOINnAmse2ziGSbRPgATS2qSrr8rRCgzRghOPZb8+u9wYfZ8veeVUdTiHI
         zFsQ==
In-Reply-To: <20180126143950.719912507bd993d92188877f@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Fri, 26 Jan 2018, Andrew Morton wrote:

> > -ECONFUSED.  We want to have a mount option that has the sole purpose of 
> > doing echo cgroup > /mnt/cgroup/memory.oom_policy?
> 
> Approximately.  Let me put it another way: can we modify your patchset
> so that the mount option remains, and continues to have a sufficiently
> same effect?  For backward compatibility.
> 

The mount option would exist solely to set the oom policy of the root mem 
cgroup, it would lose its effect of mandating that policy for any subtree 
since it would become configurable by the user if delegated.

Let me put it another way: if the cgroup aware oom killer is merged for 
4.16 without this patchset, userspace can reasonably infer the oom policy 
from checking how cgroups were mounted.  If my followup patchset were 
merged for 4.17, that's invalid and it becomes dependent on kernel 
version: it could have the "groupoom" mount option but configured through 
the root mem cgroup's memory.oom_policy to not be cgroup aware at all.

That inconsistency, to me, is unfair to burden userspace with.

> > This, and fixes to fairly compare the root mem cgroup with leaf mem 
> > cgroups, are essential before the feature is merged otherwise it yields 
> > wildly unpredictable (and unexpected, since its interaction with 
> > oom_score_adj isn't documented) results as I already demonstrated where 
> > cgroups with 1GB of usage are killed instead of 6GB workers outside of 
> > that subtree.
> 
> OK, so Roman's new feature is incomplete: it satisfies some use cases
> but not others.  And we kinda have a plan to address the other use
> cases in the future.
> 

Those use cases are also undocumented such that the user doesn't know the 
behavior they are opting into.  Nowhere in the patchset does it mention 
anything about oom_score_adj other than being oom disabled.  It doesn't 
mention that a per-process tunable now depends strictly on whether it is 
attached to root or not.  It specifies a fair comparison between the root 
mem cgroup and leaf mem cgroups, which is obviously incorrect by the 
implementation itself.  So I'm not sure the user would know which use 
cases it is valid for, which is why I've been trying to make it generally 
purposeful and documented.

> There's nothing wrong with that!  As long as we don't break existing
> setups while evolving the feature.  How do we do that?
> 

We'd break the setups that actually configure their cgroups and processes 
to abide by the current implementation since we'd need to discount 
oom_score_adj from the the root mem cgroup usage to fix it.

There hasn't been any feedback on v2 of my patchset that would suggest 
changes are needed.  I think we all recognize the shortcoming that it is 
addressing.  The only feedback on v1, the need for memory.oom_group as a 
separate tunable, has been addressed in v2.  What are we waiting for?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
