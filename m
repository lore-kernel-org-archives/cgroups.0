Received: from mta0.migadu.com (out-167.mta0.migadu.com [91.218.175.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016DE399346
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 02:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789526071; cv=none; b=HXhPABv3umE9i+oRJhmEm/A0+PKNrdZ9pBpEX9vtH5ymkHEJqvCd3jmRB0Cpes4/FkP1IJVS+yBnax/iqVVvMFIzSm0B5by1V4+ZJ9MMuGhCFamZG5CWdUDc/rwE6GPvrHhaTcw2OzYsTF2IA5BJp+kHRrYeZa6EGEH4TSSfIv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789526071; c=relaxed/simple;
	bh=Hs8628BmLtIotljSK0JYWBNuNJKKbRI+x10DyPysmnY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=NDR7MxKfHre8ypJzThdYka2I10XzpoCdVgu31P/pVdKhjSaC4QX5jo9H56NynAgSPH0LXJuTur6cjLW0usMsR8mFn9kAXTnwmsWl/kQN8V4bGxBUhmht7vZDPcVw1GgENvKw/qJFhpShoB9bKlNGXN2kxA34by+gjivt0wPxzQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X0uDq3ty; arc=none smtp.client-ip=91.218.175.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X0uDq3ty"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Hs8628BmLtIotljSK0JYWBNuNJKKbRI+x10DyPysmnY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789526063; v=1; x=1790130863;
 b=X0uDq3tyjfjcc6QfQvDcr/90SRBbfV6B7yyrcc4ytPZ9mAf3gftiAh16p+3YlCMQQ0jBsyBM
 HpMGKYzggI2IjROZPTD/PPoxQpmyYWjSQ62AH6r4QXRYfdk5Rqvz7QyyA73ANw1KFSaHLrImX4v
 QqIYnwuUCChWksYraqJeyRqo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 4843396426b2392f;
	Wed, 16 Sep 2026 02:34:22 +0000
X-Mizu-Trace-ID: 4843396426b2392f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 07/11] mm: memcontrol: constify the reclaim protection
 helpers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-7-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:34:02 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <6770F941-463A-486A-990B-BF4533823434@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-7-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> mem_cgroup_protection(), mem_cgroup_unprotected(),
> mem_cgroup_below_low(), and mem_cgroup_below_min() only read the
> protection state. Constify them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

