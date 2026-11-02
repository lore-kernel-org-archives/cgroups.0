Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.29
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793587777;
	b=evSwbWM/zRwfIz9wkuHI6JwEduiUwSU2WktXsQtoY6ykGj9uyAx7iH6uIjqmqkjRv3px
	 0Gadj1bcyX337qf7yoeQdbCr+XhzoLL9V75hGssBxzVIl/3eCmH6OD8p8ABR9E3RMc2wk
	 Xi9+SbPX3rSA5arVlatCNRa5iC9NLIT8ehsRB1Uh5tqqnw1pW7Fto0zLB+98eZb8Yh7KF
	 2rCdmf+79yNuiuLQ0+aiMzSzE10e/87nNEfb9E5O5IYXzO2Q6A04qnzpqUHtJaPuM1lRt
	 vudZcgAiLZbZhH4ISyo+h+YVcDHdRxs++HVXBPzeNaDFiJ8K71oqHtxa6x0KgqszEPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793587777;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=K2Pl66GiCtSnRt14sAo6wYdJhq6b9lHCX2PYrIZzXQc=;
	b=EdqwFuV2SeHd6STjoM6f6+kszRxKzfQniGx79LR3mDeO1iEFtf5cqgdGJUuWAdoT9Qxp
	 23zAu/HxjwalN8as4IJ3L/969JPEOc5o8h/DkGYc1go5MvI5WlhSbnt8FYCtK9Rwr06ci
	 haJ+JkXaB4NF7XsO2TPmL6Sf5p6ENENKzwdxGjEwgAv1HZwzZPN1Za3uGduuNU8FudPJ2
	 TwWQsgH0EFl+FAbQvuPygp4+fP9pSJeDeDAO89zzbrx/6KAQ8go993Yn1gujXQjB6W3MF
	 IsbwyJSR2OBQzFBCS7o0bQfGNeqsQed6PO65STdn8J2Yc4nmsIV/mNWBGGAH0Yph/lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Y7NMm/hy";
	arc=none smtp.remote-ip=91.218.175.29
Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBDF606A324
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 02:49:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDBDF606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y7NMm/hy
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iz3xRoZLABnzuJqgORKF3hs5vSDtn7j2yh2I+RtFt4k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793587772; v=1; x=1794192572;
 b=Y7NMm/hy6+FZSncn4IkWDmJKlBOJCTZruBIb9D5QQKe3qNhZwkkYwzfjAJnZfT/VIpnvXClF
 Efda/uTm5JGWk1GKAvG3oK0pon11f5l2ni1rEO48LiKR/+XXOwRzv7vJ6Qj1wwKCjx9bZaBGJpA
 c1A6HCkXed0az8kA2oukQ7MA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 544bc17d499f049c;
	Mon, 02 Nov 2026 02:49:32 +0000
X-Mizu-Trace-ID: 544bc17d499f049c
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <kaitao.cheng@linux.dev>
Subject: [PATCH v2 0/3] mm/hugetlb: Fix CMA parsing, flags and usage accounting
Date: Mon,  2 Nov 2026 10:49:07 +0800
Message-ID: <20261102024910.31486-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes three independent HugeTLB issues reported by Sashiko,
covering CMA parameter parsing, persistent folio flags, and NR_HUGETLB
accounting on allocation rollback.

Patch 1 rejects a global hugetlb_cma size following node-specific entries.
This prevents malformed input from overwriting valid per-node reservations
with an incorrectly parsed global size.

Patch 2 preserves persistent folio flags when a failed vmemmap restore
returns a folio to the pool. This retains CMA allocation tracking and
raw hardware poison information, while ensuring transient flags are
cleared before returning the folio.

Patch 3 moves NR_HUGETLB node accounting to the underlying folio state
transitions and separates it from memcg statistics. This keeps the
counter balanced when surplus folios are freed during reservation
gathering or after a failed overcommit recheck.


Changes in v2:
- Patch 2: Preserve persistent flags, clear transient flags, and warn
  about unexpected flags.
- Patch 3: Account at folio state transitions and separate node and
  memcg statistics.

Link to v1:
https://lore.kernel.org/all/20261028113319.38544-1-kaitao.cheng@linux.dev/

Kaitao Cheng (3):
  mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed
    input
  mm/hugetlb: Preserve persistent flags when returning folios to the
    pool
  mm/hugetlb: Fix NR_HUGETLB accounting for surplus folios

 mm/hugetlb.c     | 52 +++++++++++++++++++++++++++++++-----------------
 mm/hugetlb_cma.c |  3 +++
 mm/memcontrol.c  |  6 +-----
 3 files changed, 38 insertions(+), 23 deletions(-)

-- 
2.54.0 (Apple Git-157)

