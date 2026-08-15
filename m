Received: from mta1.migadu.com (out-165.mta1.migadu.com [95.215.58.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6D41E5B9A
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 00:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786754934; cv=none; b=R1emT0oW9U8UUeh0V6bm+cSbiPGq9507R4IVzDD2vqhHiSbev0LG9ILNXuy20sITLWmC88WHqU79UA11pSXn6PV66fKBc2VyUa41F4lJ/e78vjaqxsuQitBw0O2jEx3o5mqWdUAi+khWwUQPj8H5TuyfzRPZHhxdahVgBzW3+5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786754934; c=relaxed/simple;
	bh=D2tHr41vvRZOGh8CfotiS63LZpn9WEESIso0qi3hUnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gzSzWj9ddi5YT6IgPu1dRtoU6vb72rw2M+pacx1TmN4yLbDCqqQ76cESai0nW5Vrj08H4q1za3hqLLVlqTsOc3X5X7pTgi+TZMIIAkUWKteGKDdXW9abB+2QJozm0iwI4dotsJLFnl3+NpPLToodDR/nlpjDPgaP+1Bv/zvWjC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M/iz1KRZ; arc=none smtp.client-ip=95.215.58.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M/iz1KRZ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=D2tHr41vvRZOGh8CfotiS63LZpn9WEESIso0qi3hUnc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786754928; v=1; x=1787359728;
 b=M/iz1KRZ0lTqKQZPuHWE8x3SeGdOLunKWprCkF0Dgj/TsGb/fkncKsgqGHuMZGCmzFBiyPnL
 cT21e0jdaxqQPpW59MxViYonn4zSWPT7iufa4AqAiBX7/jlJZR9VmmN7AJgK46C5NETt0zUn2Ny
 9VpinGuAWToyq70d7paTn19U=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:12::)
	by smtp.migadu.com with ESMTPS id f2405bb7f12b9bff;
	Sat, 15 Aug 2026 00:48:48 +0000
X-Migadu-Flow: FLOW_OUT
Date: Fri, 14 Aug 2026 17:48:47 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Message-ID: <an-3Ssc22Gm4J_Mb@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <an2HYmJ57BCY_Zwt@lucifer>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an2HYmJ57BCY_Zwt@lucifer>

On Thu, Aug 13, 2026 at 10:27:09AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 11, 2026 at 01:31:54PM -0700, Shakeel Butt wrote:
> > Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
> > reclaim is the only thing that runs shrink_lruvec() from kswapd with a
> > target memcg set, and thus the only way kswapd can reach
> > lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
> > mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
> > reclaim. Do not reuse for anything else." comment and a priority hack,
> > and it simply never got taught about MGLRU.
> >
> > Rather than teach it, let's delete it. The v1 soft limit was deprecated
> > in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
> > soft limit"). Nobody has reported depending on it in the ~21 months
> > since, and v2 has covered the same ground for a long time with
> > memory.low and memory.min.
> >
> > Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]
> >
> > Shakeel Butt (9):
> >   memcg: make the v1 soft limit knob inert
> >   memcg: remove v1 soft limit reclaim
> >   memcg: remove mem_cgroup_shrink_node()
> >   memcg: remove the soft limit reclaim tracepoints
> >   memcg: remove the soft limit rbtree
> >   memcg: remove lru_gen_soft_reclaim()
> >   memcg: remove the per-node soft limit tree fields
> >   memcg: remove mem_cgroup->soft_limit
> >   memcg: simplify v1 event ratelimiting
> >
> >  .../admin-guide/cgroup-v1/memory.rst          |  49 +-
> >  include/linux/memcontrol.h                    |  27 --
> >  include/linux/mmzone.h                        |  30 +-
> >  include/trace/events/vmscan.h                 |  14 -
> >  mm/internal.h                                 |   4 -
> >  mm/memcontrol-v1.c                            | 435 ++----------------
> >  mm/memcontrol-v1.h                            |  12 +-
> >  mm/memcontrol.c                               |   7 +-
> >  mm/vmscan.c                                   |  96 +---
> >  9 files changed, 66 insertions(+), 608 deletions(-)
> 
> This is a gorgeous diffstat :)
> 
> Obviously not my area but looking over it, all LGTM so feel free to add:
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> To the whole series!

Thanks for the review.
