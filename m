Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8FC42B315;
	Mon, 20 Jul 2026 14:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556996; cv=none; b=EQPpupTkV0d40V6KqiFdsCF7NBqVXGY/Ms6p7mmK2m34jJ6PIS7yiThQ+wVswGXRr1cx1nXtGATaTTdP/25NP+nCTV9AeNfd539aI6MHG/3toeks6eg8jcsZNUzCke8NU7/Xk9cwCyKtJpZjXetmi+rTIYDB9zyFWn1n5RJ0pxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556996; c=relaxed/simple;
	bh=363oFxB2g1Jj/iW1/4CC4M+twglrj+8VmFQSOEIh1eM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tqpsUKVEGGYUS1VTux+Z1AhEOzeeosxRmMQpXv9IwbDyR7e0bEgq2BL1aKzDv9M7J18FubzFM9Jr5kOI2SpWvn2smJWUW9IT5hXTC+/zaroKNhb+wiTp1IcKYkk3IPBix5SfzfYddXXQalj8vgP7I3VVjtd/mXp9mXpCiEDqjrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVbvJRN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVbvJRN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509CB1F000E9;
	Mon, 20 Jul 2026 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784556994;
	bh=UPQckxndCEJ7gON+eXBCmL7lkfNrS7vyJZGPPaJdfGA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UVbvJRN9/886lD9oa0A2+WveR2vmD3E/+I7suSHl/DV4hQsc6R14wqnSnmUXna/XP
	 g4+9TLjdZkn0KgzM3fJk4FOFQYSzTCvLZ2g3HRl/XRsTPUNv26iNFsYwdAstYntqsW
	 PtkYejuJ/aC86tPbd3vYKnUl1TjnWaBbjn2FP+6v1i6yOCYWzMcFzpRw20by+R60CT
	 6uQGdpGO72JeOTRBAPYtmXobECi96RNQPviEKAYUYAZr/hdjmT9NRWOxTR+18lz63+
	 y2vZJdk/9DPTUN3G/CsCRA8V/4/0YYSfsb50D1VeODZQuyOmaa7q88kSHZxXU4tBhC
	 bggomyliIG0bA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:16 +0200
Subject: [PATCH v2 02/13] mm/slub: skip handle_failed_objexts_alloc() with
 profiling disabled
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

The function might get called with memory allocation profiling disabled,
when the obj_ext array is allocated for objcg pointers only. The
handling is however unnecessary in that case, so skip it.

This would otherwise become a real bug later, as pointed out by sashiko.
For now it's just an optimization.

Link: https://sashiko.dev/#/patchset/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org?part=10
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 76acb78f2655..95fa6fbad11a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2101,15 +2101,16 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 			struct slabobj_ext *vec, unsigned int objects)
 {
+	if (!mem_alloc_profiling_enabled())
+		return;
+
 	/*
 	 * If vector previously failed to allocate then we have live
 	 * objects with no tag reference. Mark all references in this
 	 * vector as empty to avoid warnings later on.
 	 */
 	if (obj_exts == OBJEXTS_ALLOC_FAIL) {
-		unsigned int i;
-
-		for (i = 0; i < objects; i++)
+		for (unsigned int i = 0; i < objects; i++)
 			set_codetag_empty(&vec[i].ref);
 	}
 }

-- 
2.55.0

