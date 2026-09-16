Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2853AEF51
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 02:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789526281; cv=none; b=QaPD1gdBto9ORf/MEvRfCvXgLTxIvf4Wy08zXK8xFlJ3vJRnrEcvDUUjRnL1D1fYf8/3uzKKtZKS6+0yUs9h3W19U/GsRHW3DBggw1y7ea+qUYBUqcwwxZtz8qK9dOzRv3uczu5CX+PPRkDELiwvZENfNlos5POEDqW8dTKuYZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789526281; c=relaxed/simple;
	bh=RqoHRKP5MPir8EDPZ+oY2qrhh/YX3EBSGht0Wmlx5f4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=I1IDNjzE4agyFGPTp+kB/booVPF/0JdlheP95UDt4FcheD8Q9JInfPXiPSmUl/4Z2TELG+I3GSw2U83Cc/W7N+u/Dha5rl3zOLG1yV+BiIgZlc2OtlQu2hsy8hjgI7VtcDLwqX7vsF3I4xhoBgyOKxCge6u15bPBrssq/XKAIuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SSaXPIOr; arc=none smtp.client-ip=91.218.175.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SSaXPIOr"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=RqoHRKP5MPir8EDPZ+oY2qrhh/YX3EBSGht0Wmlx5f4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789526272; v=1; x=1790131072;
 b=SSaXPIOrvtPax9vphAbdOQthbz/mUYwUfjp5GPZuikFO7patGgOVZnmIslkLwOFz2Kz9K1m7
 TA8NTFgxNl26Tg1YOQbngMFj6Hh/0T0ImgXNbAZK7bm5WCPRcj9dJEeMTj9tItwkTmAwLsJwNOC
 5+RIMKAncjN1KsqpE6kawZ7o=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 0076e13c0c48a507;
	Wed, 16 Sep 2026 02:37:52 +0000
X-Mizu-Trace-ID: 0076e13c0c48a507
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 11/11] mm: memcontrol: constify the zswap and socket
 pressure helpers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-11-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:37:30 +0800
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
Message-Id: <1BA7E514-82AC-416F-A795-9D12152BDE87@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-11-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> mem_cgroup_zswap_writeback_enabled() only reads the zswap_writeback
> flags, and mem_cgroup_get_socket_pressure() only reads the socket
> pressure timestamp. Constify them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

