Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792583292;
	b=NxVz8VriLtfKLZqK4klEiQm+xCVDBpqs/CM+wCRtUVlWoKQWHDTvU4OF/zHDII5e0yrt
	 xldDPlFE86jXNPjGQbUMOVrGdvhkqwl6ybAQGyqbELtT1aAzX0fKWtwK+mtKWX3jrf/BI
	 VMqyRscyxK2kVfyIC2dAlBO+c3z391WWK+U7ANSw61DSBPr5sXRFYsSmXpgORyVXpiOaE
	 bhR5BSZg/NixH5AJkGD161wuEy+OTxB2iXXpYEnVSFQ8lQ8WxHkAFA7IYU29B44v5WMe9
	 6Aj2FQa/5WXnH0wUsLZiiJhs4slteSip+dlr+HsvYB1n/6b0QqgjuLbWbMl+xxKysCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792583292;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=NxQm9Utiw9ju7W33QEdNT3UP6e3902Yp5TQgdUDZVi8=;
	b=Sq2d93gnEZrmF1u1gPxuTMxhs3sow68l+w0v3vkUtMU1wQjYsjqHBGhnogNUtN/yM1U1
	 jmkwjJwmh/7eGAMzqpTp+RVk9XUD0WH89do48rqwfgdMghWP1WgCOMjJOPLXNKd0mVnut
	 +CIkkuNyBG7v2fV4dcjPosoPp5S9H+rFIYm6ZWubp5f6XLR4COFjm8dwarWEiZMJYmB+E
	 MGi7R8ixgOZYjGp4CLrkdd4YQzhVMh/xqIs85IijvIwYs/xNfDrw1jFeojwkY7omARL3R
	 0Iqg6ij40hTJiT4diQT+J8ZKhyHmzCcZeBAJcTxKbrxw7CYv9QWfzuNPZO5Mrj8kLBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GGZ+kJM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916C060A4AC1;
	Wed, 21 Oct 2026 11:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GGZ+kJM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AFE1F000C4;
	Wed, 21 Oct 2026 11:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583292;
	bh=NxQm9Utiw9ju7W33QEdNT3UP6e3902Yp5TQgdUDZVi8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GGZ+kJM08hfM1lBWxUrfgYvioC+cAsdaU4flddHkzp5af345rxmboRfwbl7SUH4BX
	 K7GUNWtrEE5gFO+BovByE7aty+pTU2V6Y1U38UZfiYkRLfI6obMLkUsUY00sgbiBXK
	 hpddfh9CqA5lIi3KL0aJP5rDARidSBM9GLkniGYNanacj4u04n8rVd7t83JlMfdPrK
	 MGbSiuyweLdTv/vpHmO4gJJx6kj88deUP3hsBmbCivvLOqNfCetcBevHh6WXLU2l9z
	 WK7tO/ui30o9cuuzrCQftec27SuvHwDbERUM2Mm8LqUOa9T3KXnYnkaQRHhoL5x4r8
	 ww9uDCQNeC8EQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:54 +0100
Subject: [PATCH slab/for-next 13/14] mm/memcontrol: do not allow charging
 objects without SLAB_MAY_ACCOUNT
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-13-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, cgroups@vger.kernel.org
X-Mailer: b4 0.16.0

Objects of a cache without SLAB_MAY_ACCOUNT cannot store the objcg
pointer once slabobj_ext space is no longer reserved for every cache.
Skip charging when __GFP_ACCOUNT hits such a cache, and warn once under
CONFIG_DEBUG_VM to catch callers that did not opt in.

Refusing the charge here is sufficient for correctness: an object that
is never charged does not access the objcg slot again, and the free
path already skips such caches via slab_needs_objcg().

Assisted-by: LLM # Changelog
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..9f996206592f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3622,6 +3622,12 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	if (unlikely(*p == NULL))
 		return true;
 
+	/* Do not allow __GFP_ACCOUNT without SLAB_MAY_ACCOUNT */
+	if (unlikely(!cache_needs_objcg(s))) {
+		VM_WARN_ON_ONCE(1);
+		return true;
+	}
+
 	flags &= gfp_allowed_mask;
 
 	if (lru) {

-- 
2.54.0

