Received: from mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69473390CBA
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 02:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789525882; cv=none; b=NGxrTS+uBJB7vomzNNe/4IJIK9ycWranWd04jQd96pv13VmXiyq6usSu1xvT94yfk4r1PzjqrXDi1fzWxeq48HkVGXmdJrdAwPZfC9Vu8Ct3CS4n32hu4N5k7lZLK8N/CEVM3yPJDcYHn3YSZerAcQD7pKzVGnu0Fqn0jQOHpmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789525882; c=relaxed/simple;
	bh=aDUjRGX3cNyAfEzDUTqJDrpKeLfR1gBoMctSlKhWMck=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=HzoLxXqxZKnKcTJ7OqNIr1ONl+7y4gTNSNPvxh2fzZltbKA65eO2F1ldZ8vM27FnqezY3cnzyIi8QHjh78EEsbG+C4l628UBzGXOoiU1+fphUVSS52I/LDumfnck+BTmt5yKEO4ZhL1sssEvmKYJkcmXq3K2G4OThlJsr2JPiFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MyZjqqw+; arc=none smtp.client-ip=91.218.175.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MyZjqqw+"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aDUjRGX3cNyAfEzDUTqJDrpKeLfR1gBoMctSlKhWMck=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789525876; v=1; x=1790130676;
 b=MyZjqqw+t6Gu10wdaEf6J6Msmlccn2DAudItCnZwg+7lFGWQmTCQ08uSyOJeFjsf1K9aUc9P
 yZzs2IvCaWC80nzAk+/kbiSgVMKrvem///GpaFispRdQTGWbWgKei68DI+rPvxck9oUBHQoSrYO
 2+4v3tN5DiLBSPBMtyAgCddI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 1cf33dfc7e28f54a;
	Wed, 16 Sep 2026 02:31:16 +0000
X-Mizu-Trace-ID: 1cf33dfc7e28f54a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 03/11] mm: memcontrol: constify the lruvec helpers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-3-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:30:55 +0800
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
Message-Id: <3509BF39-2110-4705-B7D1-D333AF54BF0F@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-3-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> The lruvec lookup helpers only read from the memcg, folio, or lruvec
> they are given. Constify them, along with lruvec_pgdat() and the folio
> argument of the folio_lruvec_relock_irq() helpers. mem_cgroup_lruvec()
> may update lruvec->pgdat for a newly onlined node, but that lives in
> the per-node structure, not the memcg. Similarly, lruvec_pgdat() still
> returns a non-const pgdat and does not use container_of_const().
> 
> Use container_of_const() in lruvec_memcg() and
> mem_cgroup_get_zone_lru_size(), so the const isn't silently cast away.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks
