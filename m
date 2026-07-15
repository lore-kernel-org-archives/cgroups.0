Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A28C43B6E5;
	Wed, 15 Jul 2026 10:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784110252; cv=none; b=S5vTsF+qEYGi+8Yx+8264PDPeDK7gDbIRv5U0bmDAIm4PicHfFj5SVC00/yHMHPtKYpT24H09ezHLAzn7bo2w+BOjYaT1GAB9RiOQ0gbFCXo0Tao2AoYfi+cCtXQE6KGLeu+q2eDEQpMa+uUNfIF9/kANtGqCs4QvNqH9D9YVT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784110252; c=relaxed/simple;
	bh=qrvBi037NaDO5Ac9ofIMepjLFwbLj4Xq6ZZHsuekDEQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ikn17uTBFDdNNsmJl0TkaWeYzZSVXvgdnRYGT6eyqIT9obdRb1VXEYtaSGosnMDlKdGLlEM1SrUwOGfbUiHyvv5FeVS+dCxDBC71C9tk+E1U8HZIQatdcb49vs2r/udxRpTrqzzvCN7Drh9KesztOGfaI9/V7DRCHE3745eYN2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrmWcN1z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrmWcN1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE2F1F000E9;
	Wed, 15 Jul 2026 10:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784110250;
	bh=j/MNUihFnJ5m2LB0LV8GlcwqRsbdT05/VOgE/B2r1H8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RrmWcN1zFUQL1nATXeEdG5TTLgpmKdOGfLgt4DJn3a2jKiMPGqNcTxonnc7uopQua
	 SX5xTyAFXfths7sBj+EG8Bw3uI05RRsRknVthAW5YiEzYKpajVnvd5POJcPO8HjcKk
	 gOYmeN1kdT8L3irY4goVANf7kkv8Pvnypzm0sLrbQiiW3javGplxXqCnnAsvMS1gSZ
	 NAs92/Kw46cHjkeCe6/8a1yqIA4Rj51qCtlTX0aH+uxvTeuVUm9EP0VD2glJQKEkDg
	 5a0cfcP25m0gj45nBITGhc3Sn+R+QYrRr0dYmt08vFRBldJS1dKr/YqJCwSFa73ySf
	 kIuo/G8jpo8fg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 15 Jul 2026 12:10:41 +0200
Subject: [PATCH RFC 01/12] mm/slab: skip kfence objects in allocation
 profiling
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260715-b4-objext_split-v1-1-9a49c4ccf4c3@kernel.org>
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

struct kfence_metadata only has obj_exts with CONFIG_MEMCG. If it's
enabled, it does also work for allocation profiling, but there's little
value recording tags for KFENCE objects. Furthermore it would complicate
the upcoming changes, so just skip them in the slab hooks.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 0337e60db5ac..a4be70d080fb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2352,6 +2352,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return;
 
+	if (is_kfence_address(object))
+		return;
+
 	slab = virt_to_slab(object);
 	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
 	/*
@@ -2399,6 +2402,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 	for (i = 0; i < objects; i++) {
 		unsigned int off = obj_to_index(s, slab, p[i]);
 
+		if (is_kfence_address(p[i]))
+			continue;
+
 		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
 	}
 	put_slab_obj_exts(obj_exts);

-- 
2.55.0

