Received: from mta1.migadu.com (out-146.mta1.migadu.com [95.215.58.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB3049DBB5
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 18:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788287705; cv=none; b=h501ignv4jREgilM+t3uqtPOlzqtpJcbJw5mtrr5BlQ/e4VUhxt2ZPjmkU8GcEXHIc7aKMhltqGec6TX/+m/SeJVFqVCvv/qMlFrV99V4qoJ84wr6G7t0sxvt35BGjiKA8RIYKiACejzysjMRA7rAfoB8s3QYHrtiTsghtkVdLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788287705; c=relaxed/simple;
	bh=i8KGEh8F0loJtG5JjmD9+5HBTb4SrwJLAbH39rt2vZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHnQaFQwvt0rLWqzLOWksfsKA5iYF3k+3ERO7NoRX8GIEpZuce8jT0ItevPBGGauLo2m0MdoT4rIIPaySaK08NvjpUeVIDtIWmroIXshEWWnWAg4EGF0si1Td+Y2z9/xVO0249R8w0peEaybzlG8Xb0JJu36RN50q3RKCUT68BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cy7i1zEI; arc=none smtp.client-ip=95.215.58.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cy7i1zEI"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=i8KGEh8F0loJtG5JjmD9+5HBTb4SrwJLAbH39rt2vZY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788287701; v=1; x=1788892501;
 b=Cy7i1zEIMVnzaVqzWW6qmtVOgPqsgZlClyYBP2+BJ1seIqQKQiRGJrrSZhbl5F8jdfQ2PMuh
 VmEP75rKmw4e85r2XsidFuLN337hC+2nf35AFfNVWanRydKID+F5DbUoXW4SuDWkLIAK7UM8l/Y
 +Lcw+9eghOKpQLTmTUAdpg30=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 031645a98e7cbdab;
	Tue, 01 Sep 2026 18:34:51 +0000
X-Mizu-Trace-ID: 031645a98e7cbdab
X-Migadu-Flow: FLOW_OUT
Date: Tue, 1 Sep 2026 11:34:50 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
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
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
Message-ID: <apcalL6-QoWVVdhv@linux.dev>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com>
 <apZVe8UHZ1CNo4r1@linux.dev>
 <CAMgjq7D6V4eTZJ1Q1Xf2J6yTCq=JjvzT-W-HHX6EnMfzm3BK1g@mail.gmail.com>
 <apcJgcFLHKZfI40m@linux.dev>
 <CAMgjq7C=k_nzwiM_MTcjVjWMTGf=s8oRaUBY00dCvLbP4EiHnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7C=k_nzwiM_MTcjVjWMTGf=s8oRaUBY00dCvLbP4EiHnQ@mail.gmail.com>

On Wed, Sep 02, 2026 at 02:11:24AM +0800, Kairui Song wrote:
[...]
> >
> > Another question: why is this patch part of this series? Just some orthogonal
> > cleanups or are they related?
> >
> 
> These were all part of the MGLRU-FG prerequisite, so I sent them
> together. I can split it out.

Nah, this is fine, no need to split.
