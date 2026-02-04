Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD64244694
	for <cgroups@vger.kernel.org>; Wed,  4 Feb 2026 01:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770167532; cv=none; b=Ob0dNGjtKZVsktz6l+cvnUrLB3R2sJAA0zjOyxebTcqBOijTexcko4v9ZFPnAlRh8gDASbq3wJn5OqVC/Lb9KOSQunMXrM5RRmm6T6i5Ep3ZNVtPy9v4RzAuganBh4RJyLUzNtX3KjMUr1Qlkgmj8Cp4indDDMrG9EkQ9rf97uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770167532; c=relaxed/simple;
	bh=okEvMS4+F38RGvkQSjQkSGMKTwwreNqalPT5OmUTUGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QhNevyXzX5WVCdDo7C4HY55CBH0LVI+5LKlArEh78mLCXMQV+XBfX054rOC4aB5uKTXUylp7Y6qtmplpBuXvGCuX6ERWPKWZ6Dg4LqIs4bxYiqa3vvbaffZRdhu7Zex+HkuwsL5kzne/KnYU87cqQ5br7EEUefwNecUpGkf3A3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 4 Feb 2026 10:12:00 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 4 Feb 2026 10:11:59 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, youngjun.park@lge.com
Subject: Re: [RFC PATCH v3 3/5] mm: memcontrol: add interface for swap tier
 selection
Message-ID: <aYKc3yFmlZzKG3wr@yjaykim-PowerEdge-T330>
References: <20260131125454.3187546-1-youngjun.park@lge.com>
 <20260131125454.3187546-4-youngjun.park@lge.com>
 <ixlef27mi6vm5pek775kyddai7rkzls6mjo434rvwwp5gulcp5@n3uzy35ta7me>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ixlef27mi6vm5pek775kyddai7rkzls6mjo434rvwwp5gulcp5@n3uzy35ta7me>

On Tue, Feb 03, 2026 at 11:54:41AM +0100, Michal Koutný wrote:
> Hi.
> 
> This is merely the API feedback.
> 
> (Feedback to the propsed form, I'm not sure whether/how this should
> interact with memory.swap.max (formally cf io.weight).)
> 
> On Sat, Jan 31, 2026 at 09:54:52PM +0900, Youngjun Park <youngjun.park@lge.com> wrote:
> > This patch integrates the swap tier infrastructure with cgroup,
> > enabling the selection of specific swap devices per cgroup by
> > configuring allowed swap tiers.
> > 
> > The new `memory.swap.tiers` interface controls allowed swap tiers via a mask.
> > By default, the mask is set to include all tiers, allowing specific tiers to
> > be excluded or restored. Note that effective tiers are calculated separately
> > using a dedicated mask to respect the cgroup hierarchy. Consequently,
> > configured tiers may differ from effective ones, as they must be a subset
> > of the parent's.
> > 
> > Note that cgroups do not pin swap tiers. This is similar to the
> > `cpuset` controller, which does not prevent CPU hotplug. This
> > approach ensures flexibility by allowing tier configuration changes
> > regardless of cgroup usage.
> > 
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 27 ++++++++
> >  include/linux/memcontrol.h              |  3 +-
> >  mm/memcontrol.c                         | 85 +++++++++++++++++++++++
> >  mm/swap_state.c                         |  6 +-
> >  mm/swap_tier.c                          | 89 ++++++++++++++++++++++++-
> >  mm/swap_tier.h                          | 39 ++++++++++-
> >  mm/swapfile.c                           |  4 ++
> >  7 files changed, 246 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 7f5b59d95fce..776a908ce1b9 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1848,6 +1848,33 @@ The following nested keys are defined.
> >  	Swap usage hard limit.  If a cgroup's swap usage reaches this
> >  	limit, anonymous memory of the cgroup will not be swapped out.
> >  
> > +  memory.swap.tiers
> > +        A read-write nested-keyed file which exists on non-root
> 
> "nested-keyed" format is something else in this document's lingo, see
> e.g. io.stat.
> 
> I think you wanted to make this resemble cgroup.subtree_control (which
> is fine).

You are right, I used the wrong expression. 
Simply describing it as a "file" seems sufficient.

> 
> > +        cgroups. The default is to enable all tiers.
> > +
> > +        This interface allows selecting which swap tiers a cgroup can
> > +        use for swapping out memory.
> > +
> > +        The effective tiers are inherited from the parent. Only tiers
> > +        effective in the parent can be effective in the child. However,
> > +        the child can explicitly disable tiers allowed by the parent.
> > +
> > +        When read, the file shows two lines:
> > +          - The first line shows the operation string that was
> > +            written to this file.
> > +          - The second line shows the effective operation after
> > +            merging with parent settings.
> 
> The convention (in cpuset) is to split it in two files like
> memory.swap.tiers and memory.swap.tiers.effective.

I will separate the two according to the convention. 
Thanks for correction.

> > +
> > +        When writing, the format is:
> > +          (+/-)(TIER_NAME) (+/-)(TIER_NAME) ...
> > +
> > +        Valid tier names are those configured in
> > +        /sys/kernel/mm/swap/tiers.
> > +
> > +        Each tier can be prefixed with:
> > +          +    Enable this tier
> > +          -    Disable this tier
> > +
> 
> I believe these are only superficial adjustments not affecting the
> implementation.
> 
> Thanks,
> Michal

Thanks for the review, Michal.
Youngjun Park
