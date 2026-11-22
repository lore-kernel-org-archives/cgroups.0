Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.214
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795315692;
	b=Cth0NQyO0UmcTwWVE3/KCuPoueF6k6EwuZf0tdC/5zcO4abg6I0vOGwRVG1NcEaJglvR
	 vLB6rO1eBvG0tYW9F4GRoFJOEVhUyzLva5bmD3QF0XyeykwWuM0CSBuB6+9G44ssMq8J7
	 cJm6xcxqxdd03UXTFYmcS/bwT/sV6yMROgCKOluwsMGYHZJSz/7gG1HSBorLHDaH0/FqY
	 XRzPBhxMQu/6akhEt/CguuJe7uXIK+YPvrWaThkpJowLj0MUrvvmPh1zZ2khn0IJwluyN
	 m+eB0afusXwRTIIN/WC7pOikYOuqvd+Czlj5H33XY7nXScqAe2CxjvBzlps8u7+SALA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795315692;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kAE5NOdIS0At3Jh5k02AXwppwZhtnhWNnu4TdJThSWc=;
	b=coGfmYc1s6nak/6oDrjP+GuEbIkCHRdKtz23mIQuMD8pyHOEbQ68vrPalSYVMCE70Bfv
	 gBQFskQO1qnknxGvVd4p9aGHV/xZ/UtdizvrZWh+dY21b2hnGjgORqbgcvjr+hP3A2akp
	 WnfBszM5xwPYBXRZ+dxHu4KNLGQolM/E2aCCK/sZMu5Akv7ACd8jpK70r6JTyRvk+SZwr
	 /WUXmq2ndAYdgEBXgaNagaBIx5s091vRzSt+zxGcAlm4VgvhCc+AUK1DEd37mT3JSo5ow
	 24ArUF3AyOplY6znb8k5mlZxd6xSWwB8ZaARhZ4XdYFChO2OUch+tYMFYPJFQkNtzDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IVKicsEJ;
	arc=none smtp.remote-ip=91.218.175.214
Received: from mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706BA606A32A
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 02:48:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 706BA606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IVKicsEJ
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rf+KgpXOB1eGgKM+XYvnpxenhFFTGz2oUtU9DXBh1Sk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315689; v=1; x=1795920489;
 b=IVKicsEJXNAKfxno/Kp7uAN9lKaGVXM31V/OlAcTkNUiqcInsY9HcohqbaruKBNUi59YoWv6
 zIOyfH+lX2pgNiAwJAGNPhTPpqhisrnSDlyGT1D3S1ZquOINWJW5B00/nY10cB+fXoN0GrAuF50
 swEwHjvAR5ChboOv1dFubP9o=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0558d52f41647cbc;
	Sun, 22 Nov 2026 02:48:09 +0000
X-Mizu-Trace-ID: 0558d52f41647cbc
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/7] mm/khugepaged: handle memory.high overage in MADV_COLLAPSE
Date: Sat, 21 Nov 2026 18:47:35 -0800
Message-ID: <20261122024737.2741569-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
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

MADV_COLLAPSE doesn't limit empty PTEs, so it can turn a PMD range with
one resident page into a 2MiB THP. Over a large sparse range, one
madvise() call can charge far more than the range used before. Today
the charge path throttles it for memory.high.

A later patch stops enforcing memory.high in the charge path, where
the task may hold locks other tasks need. Handle the overage right
after each collapse that dropped mmap_lock instead:
collapse_single_pmd() drops it to allocate and charge the THP. This
also covers the last PMD of each call, so madvise() over many small
VMAs, or a process_madvise() vector of small ranges, is throttled too.

process_madvise() on another process charges that process's cgroup.
If the caller is in that cgroup or below it, the caller handles the
overage here. Otherwise high_work reclaims it and no task is
throttled, as before.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2dc4245814df..1ede7d30853d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3306,6 +3306,14 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
 
+		/*
+		 * collapse_single_pmd() drops mmap_lock to allocate and charge
+		 * a THP. Handle memory.high overage before taking it again,
+		 * including after the last PMD.
+		 */
+		if (mmap_unlocked)
+			mem_cgroup_over_high_throttle(GFP_KERNEL);
+
 		switch (result) {
 		case SCAN_SUCCEED:
 		case SCAN_PMD_MAPPED:
-- 
2.53.1-Meta

