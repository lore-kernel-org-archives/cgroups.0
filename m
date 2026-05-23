Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD2E1C68F;
	Sat, 23 May 2026 04:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779508833; cv=none; b=R2cM5G9xXrk9282MBHDYJC2BLc0NnIn06eakBqMaXXDQx5hpkJNdCeKlFRRG6rUBS+p5czJXDJyOLfhCFwFlwUPMhnfSQnlgYd2FnFzy3bg46DoLnCGTImVq9n1y0HgCC36Pl7eOgt9ZEJWjQYGu2Q5qL5CQi/VFsOJZK29izPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779508833; c=relaxed/simple;
	bh=treRULed3wqe/7eJRDx7sDZeYMM3wyTc2R9/1DhowoI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=VB48mEAaKBFfwLdx8XWYtUB2dw54aQdtXXj70BO3Y8Jq8eHDukj9r3d/gHJILgqRJX5AHU2u2GfEjy9GcHkwYMB20/jb5Z+BCUNNJfG9/PYW5LjT0aAEhxC9JTXWFfEgIHzTw2IuTIRd2JMY7TWhcp7XufJxKrjw+miRhmCkqyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d5rQFnOt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d5rQFnOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0BC1F000E9;
	Sat, 23 May 2026 04:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779508832;
	bh=SYfwlBoIkTxQjX6100mlVLUtbaP2TS53vxqnbDjhphY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d5rQFnOt2PYBgehQp1D+DGRsxE2mUjtNAGKuoMDItY0hFrfkpoTt1ESyftEqFaZlu
	 V43rgjDi9XRHoxPOx4eqWq+ypyojU4p+HepHhYGlz8qSeiZVTTl/mMOupYC2S333H2
	 D38MBJN0SNuuf8BRQaEwN3T414GnXFADbKVH0b+s=
Date: Fri, 22 May 2026 21:00:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/7 v2] mm/memcontrol, page_counter: move stock from
 mem_cgroup to page_counter
Message-Id: <20260522210031.6d5e0debd687b39b87c87501@linux-foundation.org>
In-Reply-To: <20260523025051.170871-1-joshua.hahnjy@gmail.com>
References: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
	<20260523025051.170871-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 22 May 2026 19:50:50 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Fri, 22 May 2026 15:06:18 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> > allocations, allowing small allocations to avoid walking the expensive
> > mem_cgroup hierarchy traversal and atomic operations on each charge.
> > This design introduces a fastpath, but there is room for improvement:
> 
> This iteration was developed and tested on top of mm-stable.
> I'm seeing now that Sashiko cannot apply this patch, and I think it expects
> it to have been built on top of mm-new.
> 
> Reviewers -- would it make sense to rebase this on top of mm-new and
> re-send this as a v3, or should I wait for feedback on this cycle
> before sending out a new version?
> 
> In any case, this could have been avoided if I just developed on top of
> mm-new. I'll be mindful to do that in the future.

Sashiko does attempt various branches, including mm-stable so I'm not
sure what went wrong here.

It's a bit of a crapshoot at this time, as mm-new is still growing like
a weed (19 patches yesterday, 24 so far today).  Slowing way down soon!
I'll be pushing mm-new later this evening and after that it shouldn't change
much for several days because we all take weekends off, don't we?

Convention appears to say "wait a week before resending" but IMO
there's value in parallelizing Sashiko review with human review.  And
it's understandable if some humans aren't very motivated to review
until the AI thing has had a shot at it, because that might result in
alterations.  So I'd say that a resend-for-Sashiko is appropriate.
