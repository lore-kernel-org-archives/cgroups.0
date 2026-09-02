Received: from mta1.migadu.com (out-250.mta1.migadu.com [95.215.58.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FB1361DC0
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363734; cv=none; b=tTbNvQQlH5+oMtQzOlC9oGwTU3ijd9RqRHsDp0nzuAJdtaN03poQUTKSVZHI1sCZjXcdzizxw+S5IE2LKjHwR0jjItvfaLCY6+18ReF3qu4JYMBUQfUp8YDemaMri1R0F5Wr5ilK9xWeaOy/Zeeg/2AUzbqX9Y8gVnuLPKfj54U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363734; c=relaxed/simple;
	bh=oQAtHMDdxLMd+IseQsUdtJ1A0k1c1Qwn3qdXWbS3Pqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2PokPTeoAKT+wqsVXRBjvPpQCN2t2Fvdi0mHlo4iEInOUH020ah8kG5mlFTG2zcx9wz3Kn/nz8WJGiFAbCXCK7fEeV1sF+iu+8FuEWK7VLmt1nRmWLzTIarNewLWKvWdRqn6HyXwJIjK2P9wHKDoEnShsZiCA4JvnG9ZN5P6qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SlqLN419; arc=none smtp.client-ip=95.215.58.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SlqLN419"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oQAtHMDdxLMd+IseQsUdtJ1A0k1c1Qwn3qdXWbS3Pqk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363729; v=1; x=1788968529;
 b=SlqLN419V7SAOO7h/q10ToEfqiyIKMDWnOdnKgt3nykFlWoPEYGDqVyh4B7NVSjDZhVuzjxu
 GGZfg8V5A83a+Q9rMQOsxZ0bDoWFk9AsIM53ZWjLZb0z8k04ReVb0nMTHbJQ8ewdSbSv0dVI4bA
 r+5lGc0xunNsHGxrMj6Tf6o8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6b5cc0fcc14a6291;
	Wed, 02 Sep 2026 15:42:09 +0000
X-Mizu-Trace-ID: 6b5cc0fcc14a6291
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:42:07 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 1/6] mm/memcontrol: move the lru_zone_size sanity
 check to the reader side
Message-ID: <aphDtvu4xDCW3cOK@linux.dev>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
 <20260902-mglru-flags-cleanup-v5-1-9db761d779ef@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902-mglru-flags-cleanup-v5-1-9db761d779ef@tencent.com>

On Wed, Sep 02, 2026 at 05:50:54PM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of using an unsigned long and checking the counter value at
> the updater side, turn the counter into a signed long and check at the
> reader side. This reduces overhead and simplifies the code.
> 
> commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> added a sanity check for memcg counter underflow: lru_zone_size is
> unsigned, so an underflow wraps it around and returns an enormously
> large number, then the memcg shrinker loops almost forever as the
> calculated number of folios to shrink is huge. It also checked if a
> zero value matches the empty LRU list, so the positive and negative
> deltas had to be handled separately. However that emptiness check was
> already removed by commit b4536f0c829c ("mm, memcg: fix the active list
> aging for lowmem requests when memcg is enabled"), so handling the
> deltas separately is no longer needed.
> 
> The remaining update-side check is costly and cannot really catch the
> leak it is after anyway. It runs on every LRU folio, and if a folio was
> removed without updating the counter while other folios remain on the
> LRU, the WARN only triggers much later, from a likely innocent
> callsite. While readers are much rarer than writers, only the reclaim
> and reparenting paths read it, once per batch.
> 
> Checking at the reader side instead leaves the update path a plain
> addition, and puts the warning where the value is actually consumed.
> 
> Note this changes the behavior on underflow: the correction is removed
> and a negative value is kept. A massive leak of the LRU size counter
> would indicate that something else has gone very wrong, and one should
> fix that leaking site instead. Besides, the original behavior might
> cause false positives, or make things worse if the accounting happens
> after the actual insertion: the value is not leaked, just delayed, so
> force-fixing it would cause a bigger problem. The warning now only kicks
> in when a consumer actually uses it, in which case the reader gets zero.
> 
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
