Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.105
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793959554;
	b=HmNd0ZRMhmwqcNmfTtJj20U6BXrNkEvOS4AR6kogPrx1ekasxKw1dwJdV2mvApEWXW+k
	 Q66iy4WaYYv6ZebtsrWfYylfHxmhFv64iQkfNh0u0RkSNnm1cBY8zq5+E/vP7CAzLcrs8
	 WO98C2uZfNOOZlpo65meTOWub942Q7rU2S34UqPNFsqDSjSoe2aa74yZxmiXSws4MOPdJ
	 HFDvq7Kh9z+3hSTpMrmKr9sYlNsfbzuyj9BtzsvcEZjKnKd8i035ANGhOOnt9H8Yq0Uuh
	 jndCvoZD1BP93fcTF5ugqONTiO9X9smTmo8pquK35xRSLXZW+J9M9O3bd/YK+bHWVog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959554;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=3ZdWxtf70irIWN0cdRiIhxuODBDNKO9FqOy4Rvd9tt8=;
	b=JrIwBcA5IhKssDk2gp7jzkC7MOOc+87K52t0V1Bx6NA6glzOQpAC/RUjPALNXXHUGivz
	 QQSu09dguEMEFUrWoL+fbxTZmC+L+NVaABW1vtX21FmTIqSh+aGQqbWuuNOIf9FbesSZI
	 pDEE+hFUzh+v2MvNOsrRtShqkGQ0G+jDd5a1oQoE5AIRfi7rYbwLd/iBTzrf56HrlE7ir
	 XpWDizUxWdZFDFKbHIIGhfT1ZDvbe9Ipr0WePYPlfWZ5iElYGRJ1PSnCe/ZF9OTuXxw90
	 PI6HZ4Hl9CkFpaH7tKQRv4EenoKJGSjhbtzL1E9TIb6AuukeaFuV5uGpdUH/gLmU+pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JotcG0YC;
	arc=none smtp.remote-ip=91.218.175.105
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1847B606A32C
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 10:05:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1847B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JotcG0YC
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=boaUt3lXNw1pWwnwHBSwxbjYyF1gcSAqeO7ntekMlU8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959552; v=1; x=1794564352;
 b=JotcG0YC6P7xRM8RJRgR6tDsE7QOdW9FcJ+0Y7vjDd/57cv9cnIuL+z5idChszYHwpI+RER/
 5DOws1g+8YLN1zF96yAZ3SeC472mkhz2z7XuzhKuFyQ2rZbiG5RZaRfUJjfv9AX6NpkRBBmXyuS
 ewJVy4F0M4FxAE2ritB163L0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5c9245ec463c574a;
	Fri, 06 Nov 2026 10:05:48 +0000
X-Mizu-Trace-ID: 5c9245ec463c574a
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
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 0/4] Subject: [PATCH v3 0/4] mm/hugetlb: Fix CMA parsing, flags and usage accounting
Date: Fri,  6 Nov 2026 18:05:17 +0800
Message-ID: <20261106100521.30099-1-kaitao.cheng@linux.dev>
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

From: Kaitao Cheng <chengkaitao@kylinos.cn>

This series fixes three independent HugeTLB issues reported by Sashiko
and includes a follow-up cleanup of NR_HUGETLB accounting.

Patch 1 rejects a global hugetlb_cma size following node-specific entries.
This prevents malformed input from overwriting valid per-node reservations
with an incorrectly parsed global size.

Patch 2 preserves persistent folio flags when a failed vmemmap restore
returns a folio to the pool. This retains CMA allocation tracking and
raw hardware poison information, while ensuring transient flags are
cleared before returning the folio.

Patch 3 retains the minimal NR_HUGETLB accounting fix, as suggested by
Muchun Song, to keep it straightforward to backport. It balances the
counter before freeing unused surplus folios during reservation
gathering or after a failed overcommit recheck.

Patch 4 moves NR_HUGETLB node accounting to the underlying folio state
transitions and separates it from memcg statistics. This cleans up
the accounting in the allocation and surplus cleanup paths.

Changes in v3:
- Retain patch 3/3 from v1.
- Fix code alignment.

Changes in v2:
- Patch 2: Preserve persistent flags, clear transient flags, and warn
  about unexpected flags.
- Patch 3: Account at folio state transitions and separate node and
  memcg statistics.

Link to v2:
https://lore.kernel.org/all/20261102024910.31486-1-kaitao.cheng@linux.dev/

Link to v1:
https://lore.kernel.org/all/20261028113319.38544-1-kaitao.cheng@linux.dev/

Kaitao Cheng (4):
  mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed
    input
  mm/hugetlb: Preserve persistent flags when returning folios to the
    pool
  mm/hugetlb: fix NR_HUGETLB accounting for unused surplus folios
  mm/hugetlb: Account NR_HUGETLB at folio state transitions

 mm/hugetlb.c     | 52 +++++++++++++++++++++++++++++++-----------------
 mm/hugetlb_cma.c |  3 +++
 mm/memcontrol.c  |  6 +-----
 3 files changed, 38 insertions(+), 23 deletions(-)

-- 
2.53.0

