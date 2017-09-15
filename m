From: Roman Gushchin <guro@fb.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Fri, 15 Sep 2017 08:23:01 -0700
Message-ID: <20170915152301.GA29379@castle>
References: <20170911131742.16482-1-guro@fb.com>
 <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
 <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
 <20170913215607.GA19259@castle>
 <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz>
 <20170914160548.GA30441@castle>
 <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=djLZ5N++hyrDqHi8vQ9Eo5f3UKBa/IXPNquppLuZ45c=;
 b=FZF11rFZhpYyjUVp3skrwMRP84qBrQAfZo9eD9qTgCten19jR9uk55qTAKR9RNc/asH5
 o/oy4+WzTkdynyH4mznNLZkOBx3kHPZESIZUHDGpTnK4jGwuFOuJs1TfvrhenSivCQ0o
 wL08R4CxD0+E8ioCoUXzfDyo5SenDvMw4rs= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=djLZ5N++hyrDqHi8vQ9Eo5f3UKBa/IXPNquppLuZ45c=;
 b=AOiKG4EKg0HVj5pCBlDx5nwrJOWnKjDw61N/khsnMTT+PdE7eAJDEcxIvCatYsnCx0hpVHuQ2kZYI/NHpDaMqb1nref1KLyPJbJXI3deIDccA92eTC8KwzpyFSWfQtau2SenEc0uGCQx1OYy2ukvJMwI4VDt20oQlLhsu9WEOxA=
Content-Disposition: inline
In-Reply-To: <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Sep 15, 2017 at 12:58:26PM +0200, Michal Hocko wrote:
> On Thu 14-09-17 09:05:48, Roman Gushchin wrote:
> > On Thu, Sep 14, 2017 at 03:40:14PM +0200, Michal Hocko wrote:
> > > On Wed 13-09-17 14:56:07, Roman Gushchin wrote:
> > > > On Wed, Sep 13, 2017 at 02:29:14PM +0200, Michal Hocko wrote:
> > > [...]
> > > > > I strongly believe that comparing only leaf memcgs
> > > > > is more straightforward and it doesn't lead to unexpected results as
> > > > > mentioned before (kill a small memcg which is a part of the larger
> > > > > sub-hierarchy).
> > > > 
> > > > One of two main goals of this patchset is to introduce cgroup-level
> > > > fairness: bigger cgroups should be affected more than smaller,
> > > > despite the size of tasks inside. I believe the same principle
> > > > should be used for cgroups.
> > > 
> > > Yes bigger cgroups should be preferred but I fail to see why bigger
> > > hierarchies should be considered as well if they are not kill-all. And
> > > whether non-leaf memcgs should allow kill-all is not entirely clear to
> > > me. What would be the usecase?
> > 
> > We definitely want to support kill-all for non-leaf cgroups.
> > A workload can consist of several cgroups and we want to clean up
> > the whole thing on OOM.
> 
> Could you be more specific about such a workload? E.g. how can be such a
> hierarchy handled consistently when its sub-tree gets killed due to
> internal memory pressure?

Or just system-wide OOM.

> Or do you expect that none of the subtree will
> have hard limit configured?

And this can also be a case: the whole workload may have hard limit
configured, while internal memcgs have only memory.low set for "soft"
prioritization.

> 
> But then you just enforce a structural restriction on your configuration
> because
> 	root
>         /  \
>        A    D
>       /\   
>      B  C
> 
> is a different thing than
> 	root
>         / | \
>        B  C  D
>

I actually don't have a strong argument against an approach to select
largest leaf or kill-all-set memcg. I think, in practice there will be
no much difference.

The only real concern I have is that then we have to do the same with
oom_priorities (select largest priority tree-wide), and this will limit
an ability to enforce the priority by parent cgroup.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
