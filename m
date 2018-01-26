From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm v2 2/3] mm, memcg: replace cgroup aware oom killer
 mount option with tunable
Date: Fri, 26 Jan 2018 14:20:24 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1801261415090.15318@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com> <alpine.DEB.2.10.1801251552320.161808@chino.kir.corp.google.com> <alpine.DEB.2.10.1801251553030.161808@chino.kir.corp.google.com>
 <20180125160016.30e019e546125bb13b5b6b4f@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=THloCuCWF6Cbi88W4QzKu+8PLTls7eSLfGfee97GoAA=;
        b=Faia0L6JAc+Y0RfWdC7t2mzrDGqh20dV44XmWyHx62ZSa9+lSzEhjxev/6Wxn6TYBd
         IH1JPZ/Pfq9ENd3isYXCKwfdz/odIkSuRn6ZG6D5P2Z8aW+clR+Bbm7VJ7lc5Gbwb8YI
         FEkDVtLCKATnWtTxhxp5dfL68zLWWfD6CHDzLaOT10RoYsqKeeRXlJ30QX5z9w8hZAH5
         Y/lghw7k3Mtukeed2JFiS27tPQIvsXwrg+TgvFk0Q2b8NCZC1SjTM+YQw1+zeKcGZMno
         wICfgT/CSwRHYWqlHSipwnZ1sZZCTheryMBlnNYPl+TPqL2FDviIVk/xoBUQSqB0YgLR
         l4Cg==
In-Reply-To: <20180125160016.30e019e546125bb13b5b6b4f@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu, 25 Jan 2018, Andrew Morton wrote:

> > Now that each mem cgroup on the system has a memory.oom_policy tunable to
> > specify oom kill selection behavior, remove the needless "groupoom" mount
> > option that requires (1) the entire system to be forced, perhaps
> > unnecessarily, perhaps unexpectedly, into a single oom policy that
> > differs from the traditional per process selection, and (2) a remount to
> > change.
> > 
> > Instead of enabling the cgroup aware oom killer with the "groupoom" mount
> > option, set the mem cgroup subtree's memory.oom_policy to "cgroup".
> 
> Can we retain the groupoom mount option and use its setting to set the
> initial value of every memory.oom_policy?  That way the mount option
> remains somewhat useful and we're back-compatible?
> 

-ECONFUSED.  We want to have a mount option that has the sole purpose of 
doing echo cgroup > /mnt/cgroup/memory.oom_policy?

Please note that this patchset is not only to remove a mount option, it is 
to allow oom policies to be configured per subtree such that users whom 
you delegate those subtrees to cannot evade the oom policy that is set at 
a higher level.  The goal is to prevent the user from needing to organize 
their hierarchy is a specific way to work around this constraint and use 
things like limiting the number of child cgroups that user is allowed to 
create only to work around the oom policy.  With a cgroup v2 single 
hierarchy it severely limits the amount of control the user has over their 
processes because they are locked into a very specific hierarchy 
configuration solely to not allow the user to evade oom kill.

This, and fixes to fairly compare the root mem cgroup with leaf mem 
cgroups, are essential before the feature is merged otherwise it yields 
wildly unpredictable (and unexpected, since its interaction with 
oom_score_adj isn't documented) results as I already demonstrated where 
cgroups with 1GB of usage are killed instead of 6GB workers outside of 
that subtree.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
