From: David Rientjes <rientjes@google.com>
Subject: Re: [patch v3 -mm 3/6] mm, memcg: add hierarchical usage oom
 policy
Date: Mon, 16 Jul 2018 21:06:30 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1807162101170.157949@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803151351140.55261@chino.kir.corp.google.com> <alpine.DEB.2.20.1803161405410.209509@chino.kir.corp.google.com> <alpine.DEB.2.20.1803221451370.17056@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1807131604560.217600@chino.kir.corp.google.com> <alpine.DEB.2.21.1807131605590.217600@chino.kir.corp.google.com> <20180716181613.GA28327@castle>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=XXRaf6b1Z7QH2G5n/zGzvWHa4onHyZTEv5o26QMKEGg=;
        b=EkxQsrXEkLQM5BKFqWURcpdb3Z9lLUTS2/Qsm+hIycrLi8KHjDvuD0HqeTUeTOWMks
         3fz+gA6JRLMM+BJUIS0zBULelglH2bL/rEAizZZWm9A9JkcSjENjTCfQOYNl11ir4Zt0
         uGWM2OJExwE5OM5pABnF9DpVumpFCPEOzEvaWJv5URzg8Gp4Cu4XR/cHxEUw1w6f+lK5
         jkOlKmSpd+2JnzI0jWoLUKbF53uiTiglfp365G5DdRq849O5SeLyHZOeKqbB3QlCYvph
         lch2QT4k3nuNidffA3jPtF1Xx20fyZomXEb3v6gL2HxBZ+CRCN2Fe7+Yla2HAJFJM2m4
         H+Dw==
In-Reply-To: <20180716181613.GA28327@castle>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Mon, 16 Jul 2018, Roman Gushchin wrote:

> Hello, David!
> 
> I think that there is an inconsistency in the memory.oom_policy definition.
> "none" and "cgroup" policies defining how the OOM scoped to this particular
> memory cgroup (or system, if set on root) is handled. And all sub-tree
> settings do not matter at all, right? Also, if a memory cgroup has no
> memory.max set, there is no meaning in setting memory.oom_policy.
> 

Hi Roman,

The effective oom policy is based on the mem cgroup that is oom.  That can 
occur when memory.max is set, yes.

If a mem cgroup does not become oom itself, its oom policy doesn't do 
anything until, well, it's oom :)

> And "tree" is different. It actually changes how the selection algorithm works,
> and sub-tree settings do matter in this case.
> 

"Tree" is considering the entity as a single indivisible memory consumer, 
it is compared with siblings based on its hierarhical usage.  It has 
cgroup oom policy.

It would be possible to separate this out, if you'd prefer, to account 
an intermediate cgroup as the largest descendant or the sum of all 
descendants.  I hadn't found a usecase for that, however, but it doesn't 
mean there isn't one.  If you'd like, I can introduce another tunable.
