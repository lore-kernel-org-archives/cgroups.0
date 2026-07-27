Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCF6408034;
	Mon, 27 Jul 2026 12:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156854; cv=none; b=jwYz6PzqfqeEVPzEalT+QzniGg6zUxB+LhP5J2sGCg96l3Cz/bP4978iS3ac/mgQT7yRpA+oNovstO1FVMts3qVQpmFAugtjyoprIyVOa6l/ZeDX0O6IlMkn/UWjdjEOB4msajdmz8XkszHhnCgWFe68l7SW1OdF7/AMN45IltY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156854; c=relaxed/simple;
	bh=iXUz+z/RDOS7wGu05fpf/vjIx49I2ooYbaPNUIFlaKg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cVBGT9sf7gr7n0Kw/awPUOQsEvYguCHKRTs55ZjFPeqzrPZ1Toa98ga7Uc7XX/DTU81o6XXi1Hzb8CMuCQF9bdWkozxeR0Vi9EvC0YCWx6z8YYwpdqp8esYifHRQTQNAw2eK5QmQNxukNJrC318d9SmVV8Nld6+OuhP/pr9kQiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B47qnmcg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B47qnmcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939171F000E9;
	Mon, 27 Jul 2026 12:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156851;
	bh=O/vImmk4nZ0kFMnvMNBhkco3GaYwW1/WU6MdK9cUjwU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B47qnmcgwRsFsMJxuSxk0f5mzdJZ+5GeKmwROVitFo0a9eMIXuTQYWq7XouWASSY5
	 hRR5MbmSJFAj6MOsQApHxDUZJY8Cf55wzD7358Pg3C8Z2LDwSUPWa9pfMuUgoPSWGY
	 ZK2JxlFppOqODg9RfawieUFDbfyGM9CqxK9CUuloqeioD4cFi+E50xOckjTdOXRa8b
	 V798UEHVLhAH9eIVX1wr6/GqPRm3TifGFU4tMWI0+uIK3XJKvTg6VzkQvb02673Cg6
	 6uwCCrDl7zT394Q8MQeKjy+JyHxCr+c7yhR/LzdnTqsZcPQnqmr/omHZl5+hGHirgx
	 MhtojOWuoe8+w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:55 +0200
Subject: [PATCH v3 01/13] mm/slab: skip kfence objects in allocation
 profiling
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-1-c29ef0f1f257@kernel.org>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
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
 Documentation/mm/allocation-profiling.rst | 7 +++++++
 mm/slub.c                                 | 9 +++++++++
 2 files changed, 16 insertions(+)

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
index 0337e60db5ac..d702d273253c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2067,6 +2067,9 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	struct slab *obj_slab;
 	unsigned long slab_exts;
 
+	if (is_kfence_address(obj))
+		return;
+
 	obj_slab = virt_to_slab(obj);
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
@@ -2352,6 +2355,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return;
 
+	if (is_kfence_address(object))
+		return;
+
 	slab = virt_to_slab(object);
 	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
 	/*
@@ -2399,6 +2405,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
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

