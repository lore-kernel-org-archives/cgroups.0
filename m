Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3866242A166;
	Mon, 20 Jul 2026 14:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556993; cv=none; b=US3d4lxCL8zCeFGqLDsyDA4rr8w+ZONapIRvpcIJljGzrgmWfkRTRDSKNR4NczATd2Q4xAr62dXHXjG20qpfrz2xhERFHYuLqwjLSX0VpD/o+JqK/gF+kx4B0cj1VwtOJvlaO4/ahbHkn31rr9WZRi4mItgXBFWI7vBUeh9d+uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556993; c=relaxed/simple;
	bh=ucImc0OiTptNhcepKrASGUox+8GSyWO/1rGFJyynGdY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cHRJmmbAztLm4wv9G3MUFJi5beTkYNaG7E8pmZ4YiaVTtveOiQEXbcimszaPJw3rxSMlX0I+fbnCQcnOhttz+i1BZr2Y2fe8Oj4p6gbFrJtl2vcugwbZpyMuyEssVR1hqUg75HjuUz2ek/YrtC5Hqbzix0Y97VN3o92fXQMrbig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9l2/0LE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9l2/0LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FBC1F00AC4;
	Mon, 20 Jul 2026 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784556991;
	bh=bOrfQ3lYA2720DIdcg2lgwZAAppgr0gM7i8Eaojwjq8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M9l2/0LEB2GWQY1CtKBsbLdSJT/yAB7qZ29jms3ke7nnXI9Iv69tyJTQCnwDEuF2I
	 BrW0Kie0BuwlqXg1NPRo2fO2PmnXhLHzLW1YjNPp4qxsIgQZiYT7T8nuwr6GrFaxvb
	 IYlx8TawcJvWfkOd+jwUZCT5WS6xKpXWeZlK0nqMu5Zn+FN9AgyK+ep+18QhB/gGrV
	 fq62Fo2D0oYsmXHTwrbNXOPeQWKL6T7CbmLqc0UNhSnyB8LpAs+ir0nrunWZwNMdAU
	 aSUS9frX+xSXA5CsOg2JOpYPRvk0WyqAhdcBM0oWXGkyeXC8FtkybA6hvS3RNONaUk
	 3V2kLT6dZW8jQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:15 +0200
Subject: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
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

struct kfence_metadata only contains struct slabobj_ext with
CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
If CONFIG_MEMCG is enabled, the struct can also end up used for memory
allocation profiling. If CONFIG_MEMCG is disabled but profiling is
enabled, it will end up allocating its obj_exts via
prepare_slab_obj_exts_hook() and assigning them to the fake struct slab.
These will probably then never be freed.

So things sorta work, but not always in the intended and optimal way.
The upcoming changes to slabobj_ext layout would additionally need a
proper refactoring to keep working.

However, there's little benefit in accounting KFENCE objects. KFENCE
allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
(default to 255) outstanding ones at any time. For any callsite
prominent enough in the memory allocation profiling stats, allocations
served from KFENCE will be lost in the noise.

Thus let's not complicate things and simply stop accounting KFENCE
objects in allocation profiling and skip them in the related slab hooks.

We also need to skip kfence objects in mark_obj_codetag_empty() in case
a sheaf is allocated from kfence, per earlier sashiko review.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 Documentation/mm/allocation-profiling.rst |  7 +++++++
 mm/slub.c                                 | 11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index 5389d241176a..d02eb54ee8f2 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -112,3 +112,10 @@ break it out by rhashtable type.
 
 - Then, use the following form for your allocations:
   alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
+
+Notes
+=====
+
+- When a slab object is allocated from KFENCE, its accounting is skipped.
+  KFENCE allocations are rare and limited to a small number, so this omission
+  is negligible.
diff --git a/mm/slub.c b/mm/slub.c
index 0337e60db5ac..76acb78f2655 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2076,6 +2076,11 @@ static inline void mark_obj_codetag_empty(const void *obj)
 		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
 						       slab_exts, offs);
 
+		if (is_kfence_address(obj)) {
+			put_slab_obj_exts(slab_exts);
+			return;
+		}
+
 		if (unlikely(is_codetag_empty(&ext->ref))) {
 			put_slab_obj_exts(slab_exts);
 			return;
@@ -2352,6 +2357,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return;
 
+	if (is_kfence_address(object))
+		return;
+
 	slab = virt_to_slab(object);
 	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
 	/*
@@ -2399,6 +2407,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
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

