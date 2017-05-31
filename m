From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 5/6] mm: memcontrol: per-lruvec stats infrastructure
Date: Thu, 1 Jun 2017 08:03:40 +1000
Message-ID: <20170601080340.3abea4e9@canb.auug.org.au>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
	<20170530181724.27197-6-hannes@cmpxchg.org>
	<20170531171450.GA10481@cmpxchg.org>
	<20170531111821.14ebeee4a4181583fe6fac46@linux-foundation.org>
	<20170531190209.GK3730@atomide.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
	s=201702; t=1496268221;
	bh=rPnj0T+JqV1h3IPUbQA76hPZq0w9YkJGfIUE358FYYE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FVdn7phsx5fKZOAIuzDVARZwmDgkven3asyHnvSkk0ROo1sTBSXx6qxKa55YvPLtP
	 UnmhA2giPDpBQ46tuf3rhhbd4XYW/cK1/bns8QgxO7H5XXE5n/+QT+RClZVs+civt+
	 8FjH0halVuVzVMKpNTjquif+M0OQYcON6izn4v4Csos43radk6AwYdyW2OEa0E8EbB
	 4LXSLUCW6Oene2MJp0rSYeWWvl4WAmOaP33Sb1TOl1V+HBnMbgYDbpWFMgYZF3PjhD
	 V+r80aE0JYUiudyDIderM8EkfvfbxX0YHCaUQsgOzc5cqmyBwntz03nGrI6dUv6eng
	 hgRkUOB9+NnsQ==
In-Reply-To: <20170531190209.GK3730@atomide.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tony Lindgren <tony@atomide.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Russell King <rmk@armlinux.org.uk>, Yury Norov <ynorov@caviumnetworks.com>

Hi Tony, Andrew,

On Wed, 31 May 2017 12:02:10 -0700 Tony Lindgren <tony@atomide.com> wrote:
>
> * Andrew Morton <akpm@linux-foundation.org> [170531 11:21]:
> > On Wed, 31 May 2017 13:14:50 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> >   
> > > Andrew, the 0day tester found a crash with this when special pages get
> > > faulted. They're not charged to any cgroup and we'll deref NULL.
> > > 
> > > Can you include the following fix on top of this patch please? Thanks!  
> > 
> > OK.  But this won't fix the init ordering crash which the arm folks are
> > seeing?  
> 
> That's correct, the ordering crash is a separate problem.
> 
> > I'm wondering if we should ask Stephen to drop
> > 
> > mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
> > mm-memcontrol-use-the-node-native-slab-memory-counters.patch
> > mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
> > mm-memcontrol-per-lruvec-stats-infrastructure.patch
> > mm-memcontrol-account-slab-stats-per-lruvec.patch
> > 
> > until that is sorted?  
> 
> Seems like a good idea.

OK, I have removed them.

-- 
Cheers,
Stephen Rothwell

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
