Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461F336EABE
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 03:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789530816; cv=none; b=psDW7cfLdY8C7Vt7uGEvCnhOHqORgoUcZt9fW9LbUhp6UA7vcY4EZlXanYofx/YZBjBpoqHm9htP+1NBgDslCv9wIg9nAO3eDHYixsO9wYkKAzUc5tGR4ssLnGgzS9oRPCjc0ssocq0gc8NZ0lkVbf4Bb28ZF/lCz4ixqdbbL54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789530816; c=relaxed/simple;
	bh=iD1Zr44c3eJx/67Yiq6Q4RmBQIq6pGG8QPAJW2oa024=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSp/s69WYAGoGTVUIsXoqaVXNpjxLox7EhrrmrsaoSauh45gxYdPUJ28HdKSVzNW83dSNgiSqsDtsGJhWhKwy4b/0BeGHIVRz7YZo44L+eJRcU8IzdoM8iNNg6LA3fpfwNR64mC41F5UIMS9DLvzsxjaAksnvuqJMXmmsbeBkj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iNoxY8Sx; arc=none smtp.client-ip=91.218.175.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iNoxY8Sx"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iD1Zr44c3eJx/67Yiq6Q4RmBQIq6pGG8QPAJW2oa024=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789530812; v=1; x=1790135612;
 b=iNoxY8SxpHy695fXnlSdZY6m3si2qLDQzkUoY4LsdXf+VN88/8n+kAvbC/0HgodAP7Nn1WT4
 SznAK2yX64pLIqtA/FWch8Cpw0WJ5MT6iqqaD2lhyFs5kjQcuKTUStykIxtH3nTWU58bqN4vBs2
 ArcWkfD98iASnqZZ6eYA0Ga0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0948599592bf7fd6;
	Wed, 16 Sep 2026 03:53:22 +0000
X-Mizu-Trace-ID: 0948599592bf7fd6
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 20:53:10 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] mm: memcontrol: constify the read side of the
 memcg API
Message-ID: <20260916035222.GA19557@shakeel.butt@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>

On Tue, Sep 15, 2026 at 07:20:04PM -0400, Tal Zussman wrote:
> The memcg accessors, lruvec helpers, and stat readers only read from
> the memcg, folio, or lruvec they are given, but take non-const
> pointers. Constify them, along with the page_counter readers and the
> swap I/O blkg helpers along the way.
> 
> This started as a follow-up to [1] that quickly grew in proportions :)
> 
> [1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/

For the whole series:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
