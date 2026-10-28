Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793222811;
	b=GaAos89tkmAIUgIbqDAjM/b0yF/BfZxIlaULi+MItuDXioKZ6nPBOV7i3Nql8q4b21kP
	 3RDrv1LtDnx3GPtFKlIGGHQC27lo0+DZ9TXKdvy05I5xGX4AVmXqqhRt4JHpJO0vGpmLZ
	 tBAO1aWOZplNG7Eks3jdf/RzJk77IjeqGUyOG0f7cgeT0t/SIsMw8fXGH1kT6gv18UnNM
	 JNxdGgj7kQ0ROIZiKTFo7txHt3ccCFhNIOYpuxEB2w4Fy+Q74KE4mYW71WPkM00Dj4o9g
	 VNBD97GffPFvTuGDY5XNYsJHVby07hntKXDWstsYwH5UOb4zh32EKWnmcEuJs1nezTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793222811;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/J9wEIeLE4ZJ7O0wWIXrxQmkBuEUQ1rOLWQcVC/fFww=;
	b=Un3vgczhz3cUucZBpv/JxZG4z6NTgPGPXRwZb57GI9dFvGnm7mAhVthJjAr5x5fLObZa
	 DfW6tKQFNpOPLEqzXqDWVJg6e49NPbZoF0P7jcpdNNrdJdBfp0uW3vDR/72Rm5dd6WjDl
	 k3pYKbDHfveuNPcQfugZVncHfw2b5k8oTQQHGNcbJq6TL25oRtB1xI6Fk/LMUHgz9EGBF
	 +P0vxA4OgjiedQlRPw6S+qXRMZPB9go4LqlEpp88aIGiSf8TancF79JP0GCE+GvugGCby
	 tBOwHFCyTZx2CS3RmnDkFAKUVRRw4PiiXBfjsQwpx2EXslJ3hv4kUK+tgHO4Bf8lXQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CUHClqeC;
	arc=none smtp.remote-ip=95.215.58.74
Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE582606A31E
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 21:26:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE582606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CUHClqeC
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8F0gRoTDGoVFu8bo3a+K8rm9Kp6TB1BB/3NGjQEiZs0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793222808; v=1; x=1793827608;
 b=CUHClqeCl2ph+QIaksafxl5S7tzkKFduDKLeExLRvd+TF8/tkIChg9pDw/JPanybKhFT8QmX
 qOYoNvUN71OXWlKDZUq/OY4ayjvG5fkpmeIvbYiNLOeNvM8kS3GNG4YZXl7wfCAMV0onoJVoXF6
 3YqRVtK0Yd4QsLNWJzz9bQVU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dbab2fe7e9187359;
	Wed, 28 Oct 2026 21:26:48 +0000
X-Mizu-Trace-ID: dbab2fe7e9187359
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 14:26:47 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online()
 checks
Message-ID: <auJofiDEyRXOzcf5@linux.dev>
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-2-tjmercier@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028010611.3929937-2-tjmercier@google.com>

On Tue, Oct 27, 2026 at 06:06:05PM -0700, T.J. Mercier wrote:
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> move LRU size accounting on reparenting instead of copying it"),
> mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> afterwards. A folio that is off the LRU during reparenting looks up its
> lruvec through its objcg, which now points to the parent so it is put
> back on the parent's LRU.
> 
> As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> when !mem_cgroup_online(memcg) is true, making the offlined memcg special
> cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> code. Remove them.
> 
> With the get_nr_to_scan() special case removed, an offlined memcg that
> still has stale effective protection now has
> apply_proportional_protection() applied like get_scan_count() does, so
> the MGLRU and traditional LRU behavior is now the same.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
