From: David Rientjes <rientjes@google.com>
Subject: Re: [patch v3 -mm 3/6] mm, memcg: add hierarchical usage oom
 policy
Date: Mon, 23 Jul 2018 13:33:19 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1807231331510.105582@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803151351140.55261@chino.kir.corp.google.com> <alpine.DEB.2.20.1803161405410.209509@chino.kir.corp.google.com> <alpine.DEB.2.20.1803221451370.17056@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1807131604560.217600@chino.kir.corp.google.com> <alpine.DEB.2.21.1807131605590.217600@chino.kir.corp.google.com> <20180716181613.GA28327@castle> <alpine.DEB.2.21.1807162101170.157949@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=yGbLnZFJA6I0Ic94Ezv3ensUtPYygDmSuOZCeDVO0mw=;
        b=oxLjg5buWfC5lY0MP4QEexzMyzT7/3auEi6ZXL2vv7Dlk7kWdcE6TMIM9cVmrCVMvw
         BK31MZtGUg/nISgd64gQ5ZnjTuqzhnQqq7gKdcFwfsz/P5/N1SEgLWO502PThbZFYI5t
         C95njTz3xBhxzoKMlTC0pqOoO/pLrl8z/GB7tIvVX8tgzxKK8T+eokHPns6PuIaoIZI7
         cjA3IswRrkH+u0wSYphsn7iaNzsA7Jg7MrB/Gyk6/59Ck15suuL/o6BohMQlmC91IN4B
         nrQT1nh9JrkfitRcrcoRPmaQjzS57XO0HdwXljyXU6Mwecxlp/oBuUTy1X1j2BRoZ5zE
         e2fg==
In-Reply-To: <alpine.DEB.2.21.1807162101170.157949@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Mon, 16 Jul 2018, David Rientjes wrote:

> > And "tree" is different. It actually changes how the selection algorithm works,
> > and sub-tree settings do matter in this case.
> > 
> 
> "Tree" is considering the entity as a single indivisible memory consumer, 
> it is compared with siblings based on its hierarhical usage.  It has 
> cgroup oom policy.
> 
> It would be possible to separate this out, if you'd prefer, to account 
> an intermediate cgroup as the largest descendant or the sum of all 
> descendants.  I hadn't found a usecase for that, however, but it doesn't 
> mean there isn't one.  If you'd like, I can introduce another tunable.
> 

Roman, I'm trying to make progress so that the cgroup aware oom killer is 
in a state that it can be merged.  Would you prefer a second tunable here 
to specify a cgroup's points includes memory from its subtree?

It would be helpful if you would also review the rest of the patchset.
