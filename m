Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C115C3876BE;
	Fri, 27 Mar 2026 06:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592527; cv=none; b=oZv3GRaUEqv5XVPQye5LhOkGp6bMZPJayacdOpt1Ti04enS72LdgdMrtLVdhOR015baHjjRCU6v2bMbw9fKnsdlesMyNNGKhyb/zflkGeMNdkvTDtPcrovOgD6PGuhaIYwOVtCMSAzcbNfqsRgeLjNbQATfb8uvFoQ/RdB3crD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592527; c=relaxed/simple;
	bh=aeNmQfb/c67hDWg4rtLcLfHH+y4dTvZgyPlO0jG+7ZE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=bydk6/z5AkXG82exbQpNyZDp+ixvkmK2QJIV5RTlSjZzHWteGtKkIZBIa2v+C3UyVW/FcrxsnQDYbU6yyCc9O2UxAAXg35ErAfwLHLyPqqOqjczzyZrEFrVb2wYqXxHcgqhq9FHxYFBqYYMu86KHYABBbt1OpusXn8lCZgLcJRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HuKG1FNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HuKG1FNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52B8C19423;
	Fri, 27 Mar 2026 06:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774592527;
	bh=aeNmQfb/c67hDWg4rtLcLfHH+y4dTvZgyPlO0jG+7ZE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HuKG1FNmfcGzUE3o6IaHiNv0KbKQCxTODzf5MuiGNIIPwVwUBUWIsr24i4gr9Vqmi
	 tzDviZvVuLQN75ror3J5dROFKbHzbND3QRc78tr+09+oiIna2RMZFuFfK+LJlZ4xi/
	 6oCxcLVz10zVeGX1RAxhfYWs3VG/0RbAgN+9N3ek=
Date: Thu, 26 Mar 2026 23:22:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 teawater <zhuhui@kylinos.cn>
Subject: Re: [PATCH mm-unstable v2] mm/memcontrol: batch memcg charging in
 __memcg_slab_post_alloc_hook
Message-Id: <20260326232206.4a8a16461527d16ef8c2e8a5@linux-foundation.org>
In-Reply-To: <20260320020745.833792-1-hui.zhu@linux.dev>
References: <20260320020745.833792-1-hui.zhu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Mar 2026 10:07:45 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: teawater <zhuhui@kylinos.cn>

We do prefer real names in Linux commits, please.  Can I rewrite this
patch as From: Hui Zhu <hui.zhu@linux.dev>?

> When kmem_cache_alloc_bulk() allocates multiple objects, the post-alloc
> hook __memcg_slab_post_alloc_hook() previously charged memcg one object
> at a time, even though consecutive objects may reside on slabs backed by
> the same pgdat node.
> 
> Batch the memcg charging by scanning ahead from the current position to
> find a contiguous run of objects whose slabs share the same pgdat, then
> issue a single __obj_cgroup_charge() / __consume_obj_stock() call for
> the entire run. The per-object obj_ext assignment loop is preserved as-is
> since it cannot be further collapsed.
> 
> This implements the TODO comment left in commit bc730030f956 ("memcg:
> combine slab obj stock charging and accounting").
> 
> The existing error-recovery contract is unchanged: if size == 1 then
> memcg_alloc_abort_single() will free the sole object, and for larger
> bulk allocations kmem_cache_free_bulk() will uncharge any objects that
> were already charged before the failure.
> 
> Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
> (iters=100000):
> 
>   bulk=32  before: 215 ns/object   after: 174 ns/object  (-19%)
>   bulk=1   before: 344 ns/object   after: 335 ns/object  (  ~)
> 
> No measurable regression for bulk=1, as expected.

Could memcg maintainers please review this?

Thanks.
