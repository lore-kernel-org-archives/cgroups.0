Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CF043F8A7;
	Wed,  9 Sep 2026 08:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788941334; cv=none; b=XuEDh7FSHC01PkAgAz2xtFlKVDWyZoWTxhGwWkFlMRKvl9jaYvk9Yf4nihqQycOef9QsbmUpI6E7zkPbIJZn3NC7B8vbCe8ougFjXAbPXf1ETADm2flSvlNxL8vSXU0paba4VH0u1RsX+hNiw8tYF9mjhO4QytIIonzILqMp4n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788941334; c=relaxed/simple;
	bh=bGStaMYU8yIvPfBkyTgjETA7IHiwhxaw5cb0hq+LHYU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AwpHgxXP74XR2pxwye8Z1997//FnNYmQicz+fPS0sHL7DGiWw2NZDZlGIR5DkKQCMcxgrnssxqFHWnSMDCDQugADoweaRMhoSFAxO0my+XX3q5aMiW+ZdHZnJqPC1qs3FkGBt/oKCs0XMOQQnlGqT1oxDz6gUn9pF3hfGARNbXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxMdyjOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxMdyjOD"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D460C2BCFB;
	Wed,  9 Sep 2026 08:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788941334;
	bh=bGStaMYU8yIvPfBkyTgjETA7IHiwhxaw5cb0hq+LHYU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IxMdyjODlodjPzETN0ZlTlWGQwo1BDrgoaRYlv+FQ6s3kEotmNPwNfdrAryO9JNFd
	 PmF3eUBC8xARPcWNJDdAK2WkIWwHzpHNjHMoCxIOrzwftFYbl0cBEdb/KhzeJgJRWB
	 YdWJjnmvsnMnbBhfYkWGO6eZPCi2GOQQA+2tp+bL4ptYoPHhDxCDuPzYE52re2tRPm
	 kGy2mFaZz6fvEoxKw5BtwZOQfReE/pDGCtNmrhciwJUGkY1hRfeNosMb1JxLEOZ4zz
	 no0sbkZF2Bh49F53Vb8ilWVud1xJM/L4xqR+TAsiIV8WruXvRLeos0QSsgUfNZbBla
	 XUdySNqJ60IXg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A84DC79FB8;
	Wed,  9 Sep 2026 08:08:54 +0000 (UTC)
From: linuszeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Wed, 09 Sep 2026 16:08:53 +0800
Subject: [PATCH 3/3] mm: page_counter: drop protection fields from struct
 page_counter
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-descriptive-name-v1-3-1828961cb01a@tencent.com>
References: <20260909-descriptive-name-v1-0-1828961cb01a@tencent.com>
In-Reply-To: <20260909-descriptive-name-v1-0-1828961cb01a@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788941332; l=1787;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=shz9WUAjddH3Alsemp6w1PbzeLYHyRzk5zeGNg7NEjM=;
 b=2xbTnqKMfvIkkyGThb5sZPBIowVjmF2rt6clRF6E2moyVUbPwRWuAbXWnddNr77RCDf9wUlxB
 Bi7dxyJ1ndxAb4B78hc5cPxuy0anDb/3ZihIS8QvYsge+PRe+X+8kCI
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

swap/memsw, kmem, tcpmem and hugetlb counters no longer carry this
unused state: on 64-bit the structure shrinks from three cache lines to
two, saving one cache line.
---
 include/linux/page_counter.h | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index b81f16702764..a4dd461523af 100644
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
@@ -73,6 +57,9 @@ struct page_counter {
 	 * support memory.min/memory.low (swap, memsw, kmem, tcpmem, ...).
 	 */
 	struct page_counter_protection *prot;
+
+	/* Keep all the read most fields in a separete cacheline. */
+	CACHELINE_PADDING(_pad2_);
 } ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32

-- 
2.43.7


