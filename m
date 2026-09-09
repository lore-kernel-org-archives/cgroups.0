Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7853AD522;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788947063; cv=none; b=Eg+7a3Pd2h1ZL8cBgeuPDi9EHI4FdfVzBM4izRxp8ulPz9E07nrmXZrqpcDV2iOvoIVFsZZ/nbw/gNhDDGgPFY6tF0EYhYkP9m6tJsSEkMerhV7Qybzz3GBAJSTdRSmrp6KhlNSAlCKxv8Vjv4uzLrF+FlFPhh/+S+Dp03/wvO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788947063; c=relaxed/simple;
	bh=Ad5PxfNFH0KjUpTuLE+nETx4q7cGEdziN7xPAPqWwOw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c3qUccrUb/E8lPj+WLkf7nyLudwbTZGDzAuv1WRyXk0VbAmMw0gO3LDCcUKrJCrDM2awyoidnLkqqyofZv7t7RQFg8wBMp84Uj0uGDu/7vv6N9LFF6OIM8rdPmb8f2IDcGFn1WlcojgLGBt6bpX5UMeCFmBSxMksAxhUR3gHhIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IXM1iDLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IXM1iDLR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B63EBC2BD04;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788947062;
	bh=Ad5PxfNFH0KjUpTuLE+nETx4q7cGEdziN7xPAPqWwOw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IXM1iDLR+2q7Qj4UZE1d1OdKRnk1SWc6Th/SW9s7EtMl9ukUkzwFJuXlchIh0ZG7V
	 kXMbB4b1c6/O/PP2klrteeuRTIuJqi2PoU0vgOhuvXMAyCemST3VLF0BvP5z9c6fVZ
	 y+4TMX5lsYxOPQiaNVERUL+X5SPpA0gat5nSgRwKCHry0y9mZ8ujjEc6eHMpkVHgfs
	 zACqQPA6A4gpxAlCKvKDS9dB/TaADmeL+QK6k9Y6aZYyHi7S1FqPaO9yGFT/phq03M
	 LW3lmhU0IHCcxGH6bpffE+uzcLe0vH9Ypl9fvpONY/EC+o6Ol3W1/sKLT9X0l1669x
	 pvSSIYNs+XIjA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF87C79FB9;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
From: linuszeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Wed, 09 Sep 2026 17:44:21 +0800
Subject: [PATCH v2 3/3] mm: page_counter: drop protection fields from
 struct page_counter
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-descriptive-name-v2-3-d7dd7c099049@tencent.com>
References: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>
In-Reply-To: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Jingxiang Zeng <jingxiangzeng.cas@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linuszeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788947061; l=1664;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=Ty2hOT3RbwUGz3En7B5H9g1JCCLU1A+cfCkKn52iXOE=;
 b=DabIe6gyrzCaIlUMZ+sK5yF+k8V1AXEAlJEyfeNhNSOm4taa8h7olgRc3rZRs1NDNlh3wZvec
 6uuVi36nj8mDzWloXIy3VsJaBD8D3LXRVtrsGSlLIRQ9LQUXjqdvkPm
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: linuszeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com

From: linuszeng <linuszeng@tencent.com>

The protection state now lives in struct page_counter_protection, so
remove the emin/min_usage/children_min_usage, elow/low_usage/
children_low_usage, min, low and protection_support fields from struct
page_counter.

Also drop the now-orphaned _pad2_ padding and its comment: with the
protection fields gone it no longer separates the read-mostly fields
from anything, and the structure's cacheline alignment already pads the
tail out.

swap/memsw, kmem, tcpmem and hugetlb counters no longer carry this
unused state: on 64-bit the structure shrinks from three cache lines to
two, saving one cache line.
---
 include/linux/page_counter.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index b81f16702764..0007960ba5a4 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -43,27 +43,11 @@ struct page_counter {
 
 	CACHELINE_PADDING(_pad1_);
 
-	/* effective memory.min and memory.min usage tracking */
-	unsigned long emin;
-	atomic_long_t min_usage;
-	atomic_long_t children_min_usage;
-
-	/* effective memory.low and memory.low usage tracking */
-	unsigned long elow;
-	atomic_long_t low_usage;
-	atomic_long_t children_low_usage;
-
 	unsigned long watermark;
 	/* Latest cg2 reset watermark */
 	unsigned long local_watermark;
 
-	/* Keep all the read most fields in a separete cacheline. */
-	CACHELINE_PADDING(_pad2_);
-
-	bool protection_support;
 	bool track_failcnt;
-	unsigned long min;
-	unsigned long low;
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;

-- 
2.43.7


