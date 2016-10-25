From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: do not recurse in direct reclaim
Date: Tue, 25 Oct 2016 11:01:42 -0400
Message-ID: <20161025150142.GA31081@cmpxchg.org>
References: <20161024203005.5547-1-hannes@cmpxchg.org>
 <20161025090747.GD31137@dhcp22.suse.cz>
 <20161025141050.GA13019@cmpxchg.org>
 <20161025144543.GL31137@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JHoIQACTHSHQlbX4nxTZsUOSGWWIsYt+aDi8Pr4zFR4=; b=X9mh937ME3f+aq9+1BDcSI0wRG
        uvN3NXIPjA4oPQGqrvbBIYTn5J1S+te2hDnWlDSKMA3YnGnVL8EGB+hGp9f33nUqGb3FHlS8aOfxv
        TOYAbj64Ami3iZ3YhXMJDND+TB//1m5UBj6ro0SI6Fly2xFbIxONLaT9pN5BjuAYA9/w=;
Content-Disposition: inline
In-Reply-To: <20161025144543.GL31137@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Oct 25, 2016 at 04:45:44PM +0200, Michal Hocko wrote:
> On Tue 25-10-16 10:10:50, Johannes Weiner wrote:
> > Like other direct reclaimers, mark tasks in memcg reclaim PF_MEMALLOC
> > to avoid recursing into any other form of direct reclaim. Then let
> > recursive charges from PF_MEMALLOC contexts bypass the cgroup limit.
> 
> Should we mark this for stable (up to 4.5) which changed the out-out to
> opt-in?

Yes, good point.

Internally, we're pulling it into our 4.6 tree as well. The commit
that fixes the particular bug we encountered in btrfs is a9bb7e620efd
("memcg: only account kmem allocations marked as __GFP_ACCOUNT") in
4.5+, so you could argue that we don't need the backport in kernels
with this commit. And I'm not aware of other manifestations of this
problem. But the unbounded recursion hole is still there, technically,
so we might just want to put it into all stable kernels and be safe.

So either

Cc: <stable@vger.kernel.org>	# up to and including 4.5

or, and I'm leaning toward that, simply

Cc: <stable@vger.kernel.org>
