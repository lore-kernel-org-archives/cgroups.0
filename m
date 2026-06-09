Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E719554652;
	Tue,  9 Jun 2026 07:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780990773; cv=none; b=jZw0B2XkL9yBtUwkCI2CIs/9vuQr8SYasq1XPqZqm2hxTVK2zMVQLWMQ7B812QNsXro5lljPvPdJkPQDwaN1jf+fgmuiWrx2PJzSPywW3kVeroNLfM42XVDx8z507aDC+W9PeJZibvLnd31TYA9SP+dTMU+rokdLkJePZGTkNwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780990773; c=relaxed/simple;
	bh=cLxguymAz6IjaUBEOQ16eoN7SAhxUMoVezRgw5jAddM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DsBib7MM+x3NhWTyXhqWAXHAjAkB+jkigXrlpNlfN0RWVgOgvYcui1VVE4HzoUUDOq/AoT4mNVT5lNQ/zT7ipGCF1hRweYkog4EbIIk533pMbpAObobij6zCRI+nWlb2q4yq2WDyec84NUr8HOup5Cbe5klhhmw4ojuVyI3L+eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DubfFkfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DubfFkfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0AB1F00893;
	Tue,  9 Jun 2026 07:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780990772;
	bh=sQE1t/ieDrjC1fAAwsFvxI4Fd5+P0C6DgKtKpe3mY6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DubfFkfRDUFI7ViPOVaV3zGVwPvjnb2X9+HHYLnScWee309w/Y1qf8KisJqvb9RFR
	 fOWBy1xomYW3gCMTp9chlAshCO8Z/KEaOIZNymsVZ88qcfF/NqnxM29fEJTdsI/Rq2
	 hdX1HFB0AdJBLw32uj16c/9v/DRRbKQ/YDIyVwG1U/BGVPTgUqwQvPRNPf6FRWuxeD
	 QxPB+bjsbLchgy8IJx7d6Tos3u/9mgmI+Hiu7hNx59goqMhCoJ48xSQYHA+t3H3HGl
	 W1digrZq3ae6gBDy6N42Z39GC5OyLZ0YoeqTC4x8yTNO3cMuMIAx4ouTeBzc5w0Vim
	 Rk0bzwZ9bW0kw==
Date: Tue, 9 Jun 2026 08:39:22 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@meta.com, 
	longman@redhat.com, chenridong@huaweicloud.com, akpm@linux-foundation.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, rientjes@google.com, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and
 alloc_context nodemask
Message-ID: <aifC9s9X6hLWdKkd@lucifer>
References: <20260609002919.3967782-1-gourry@gourry.net>
 <8C4E5377-F5CF-458E-BA49-3D962CB75477@nvidia.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8C4E5377-F5CF-458E-BA49-3D962CB75477@nvidia.com>

On Mon, Jun 08, 2026 at 09:44:42PM -0400, Zi Yan wrote:
> On 8 Jun 2026, at 20:29, Gregory Price wrote:
>
> > The nodemasks in these structures may come from a variety of sources,
> > including tasks and cpusets - and should never be modified by any code
> > when being passed around inside another context.
> >
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> > ---
> >  include/linux/cpuset.h | 4 ++--
> >  include/linux/mm.h     | 4 ++--
> >  include/linux/mmzone.h | 6 +++---
> >  include/linux/oom.h    | 2 +-
> >  include/linux/swap.h   | 2 +-
> >  kernel/cgroup/cpuset.c | 2 +-
> >  mm/internal.h          | 2 +-
> >  mm/mmzone.c            | 5 +++--
> >  mm/page_alloc.c        | 6 +++---
> >  mm/show_mem.c          | 9 ++++++---
> >  mm/vmscan.c            | 6 +++---
> >  11 files changed, 26 insertions(+), 22 deletions(-)
> >
>
> LGTM and it compiles. As long as Sashiko does not complain, feel free to
> add:

I would add caveats of:

- Complains legitimately
- And it's about this actual patch not something unrelated

:P

(Not speaking for Zi of course, but I mean just in general I feel these caveats
should be implicit :))

>
> Acked-by: Zi Yan <ziy@nvidia.com>
>
> Best Regards,
> Yan, Zi

Cheers, Lorenzo
