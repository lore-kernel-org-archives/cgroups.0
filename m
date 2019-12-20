From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH v2 0/3] mm: memcontrol: recursive memory protection
Date: Fri, 20 Dec 2019 04:29:23 +0000
Message-ID: <20191220042923.GA388018@chrisdown.name>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yRRnujDGn+DKixV01iK1kQ9R1Hb6ldjE0k/esoxvtVg=;
        b=A0aDjvyHIdJhLqDtp99NMEN/80Jxl6wvh+lvb7+lH/qp6guNY98LBPwD0tcfMsFfk6
         g6s7MAEi2vlSscOrVsRDLJm1UzTKiVag9IlTkT+joi/WQhHf0NJ5d4IHH/ekSVlZyili
         wBB35uFGXtDvGNNUvJK8qm8EHrv+BJC+5cCJs=
Content-Disposition: inline
In-Reply-To: <20191219200718.15696-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Johannes Weiner writes:
>Changes since v1:
>- improved Changelogs based on the discussion with Roman. Thanks!
>- fix div0 when recursive & fixed protection is combined
>- fix an unused compiler warning
>
>The current memory.low (and memory.min) semantics require protection
>to be assigned to a cgroup in an untinterrupted chain from the
>top-level cgroup all the way to the leaf.
>
>In practice, we want to protect entire cgroup subtrees from each other
>(system management software vs. workload), but we would like the VM to
>balance memory optimally *within* each subtree, without having to make
>explicit weight allocations among individual components. The current
>semantics make that impossible.
>
>This patch series extends memory.low/min such that the knobs apply
>recursively to the entire subtree. Users can still assign explicit
>protection to subgroups, but if they don't, the protection set by the
>parent cgroup will be distributed dynamically such that children
>compete freely - as if no memory control were enabled inside the
>subtree - but enjoy protection from neighboring trees.

Thanks, from experience working with these semantics in userspace, I agree that 
this design makes it easier to configure the protections in a way that is 
meaningful.

For the series:

Acked-by: Chris Down <chris@chrisdown.name>

>Patch #1 fixes an existing bug that can give a cgroup tree more
>protection than it should receive as per ancestor configuration.
>
>Patch #2 simplifies and documents the existing code to make it easier
>to reason about the changes in the next patch.
>
>Patch #3 finally implements recursive memory protection semantics.

Just as an off-topic aside, although I'm sure you already have it in mind, we 
should definitely make sure to clearly point this out to those in the container 
management tooling space who are in the process of moving to support/default to 
v2. For example, I wonder about CoreOS' systemwide strategy around memory 
management and whether it can benefit from this.
