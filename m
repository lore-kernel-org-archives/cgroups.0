From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: Implement cgroup2 basic CPU usage accounting
Date: Tue, 29 Aug 2017 08:24:27 -0700
Message-ID: <20170829152426.GL491396@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
 <20170829143252.6zoes63bwfflukjy@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+ils+PLuz4eiDEqYWAznI5EO/mAOlhEBlHJlasqFpTo=;
        b=olZgk+dPg+Oe6Qb+i/HPgyjbg9RWXXD9MdJciZ6GU7c0wphVEzQOBT8IC+ZJuc/5tt
         t3w6zn5ozAa7IGIfoTFhj+ixAAqMAocDPxZREPJWfQvp5MhoW5UsgG1qrcOgvbh1B7K2
         LgYY/rg5GHQVeaDP1nsZWSynfc/DFRa5UgWMXc4SrFI04TW1mys2uv78Hu5kQ5RWGJH8
         /wTsaLuCceoqposyguiXkjVM7RnURCLaGGLaHAIpHTcQhvBAtH2xXoICN3vEqnEmnYVR
         5r8n//resvXdiFrdcfXDWB0el73ffs8vlDCBA/TxpUizPF0R6LS+0A6wq6nTE+gxIn/t
         JjUw==
Content-Disposition: inline
In-Reply-To: <20170829143252.6zoes63bwfflukjy-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello, Peter.

On Tue, Aug 29, 2017 at 04:32:52PM +0200, Peter Zijlstra wrote:
> So I mostly like. On accounting it only adds to the immediate cgroup (if
> it has a parent, aka !root).
> 
> On update it does a DFS of all sub-groups and propagates the deltas up
> to the requested group.
...
> What I don't get is why you need cgroup_cpu_stat_updated(). That is, I
> see you use it to keep the keep the DFS 'stack' up-to-date, but what I
> don't see is why you'd need that.

That is to make reading stats O(number of descendants which have been
active since last read) instad of O(number of all descendants) as
there can be a lot of not-too-active cgroups in a system.  Stat
reading can be frequent, so the combination can get really bad.  By
keeping the updated list separate, increasing read frequency decreases
the cost of each read.

Also, please note that a system may end up with a lot of cgroups
without the user intending to.  memcg drains removed cgroups lazily
and the number of draining cgroups can reach very high numbers if the
system isn't under memory pressure.  The plan is to add basic stats
for other resources too and keeping it scalable w.r.t. idle cgroups
allows using the same mechanism for all resources.

> Have a look at walk_tg_tree_from(), I think we can do something like
> that on struct cgroup_subsys_state, it has that children list and the
> parent pointer.
> 
> And yes, walk_tg_tree_from() is tricky, it always takes a fair while to
> remember how it works.

We can propagate "updated" flag up the tree (we need to, otherwise we
can't tell which subtree to descend into) and prune the iteration on
subtrees which haven't been updated; however, this can still become
very costly depending on the topology as it can't jump over the
siblings which haven't been updated.

Thanks.

-- 
tejun
