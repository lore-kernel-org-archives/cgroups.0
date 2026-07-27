Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29AD40BCA4;
	Mon, 27 Jul 2026 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156882; cv=none; b=PrGZ2uBgVNdNZ91C9PschjmzNv0tRJ8qjK6BDE41X1SuBVs0nEWJHTkLy6d5ziaqdWFY9ghYQUS4qBHZ+4JrmBFWHnRkPDWVSe7L4nklUrx6TjUVQYNsDHchhz5Vr60G9AN912NBSEdQD1j0GHHBxmA1vXP1P1LvUTdpffO9ikk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156882; c=relaxed/simple;
	bh=r7EoM+tfw1iGXbH7zkbBZVN1K6kVqCQotbjeaxOgk+k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i0xWmJCtGC5QCwqP0Qp+6x0DTYbj1AlRWvniyif/BrMswKEqpehuttWjjA8FbIplDDuxz1VUlovrVUE82LfQrj1rI1H0hG8lGPrjph4uydd3BTg0oB0rZIKm1n3d+hvnNXhHFrvU2PhN4vTsT4o5e7ihxlOX9TkIM6S5F/oLc9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hd/UZFkT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hd/UZFkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AB21F000E9;
	Mon, 27 Jul 2026 12:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156880;
	bh=D1WQPDQMI+coFOVsQT9+cZjeHGlRR3MHadVGl/MWkds=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Hd/UZFkTORu5A/8m+idVWXvn54XwJLu8J+/rOTMonsv4JYpmrv1dZB3HPpzDCm9js
	 4LLvJH26fasYWcSufdp+u6dd2GXmNi4jpXJz5GQDe/FMWROQtWri4YJ0LeW9DlSY5I
	 2e3CnEQOqhGwrJSFDeDsaBOBS6VJAqZSr/ndJdoLMjxMrunvzaKSpajS+y/tlbvwzv
	 kLvoRRpc4+82Dwd2LmCgAZfJyMJjeT+cM6CwTVyztGJfjoYYPqVDSjdN4/9UyHepVS
	 bJKjXqOVQVRpqMe7bLYjO7TFL/SC1S3JzgMeTDdfJhRqIWjvmK0A0QTlnTT3FJJOI7
	 mqfr+eZqmIjbw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:04 +0200
Subject: [PATCH v3 10/13] mm/slab: reduce slabobj_ext memory with
 allocation profiling disabled
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-10-c29ef0f1f257@kernel.org>
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

When memory allocation profiling is compiled in but permanently disabled
on boot with (implicit or explicit) "never" parameter, stop allocating
(thus wasting) memory for the codetag_ref parts of slabobj_ext metadata.

Do this by using the new slab_obj_ext_has_codetag() helper in
cache_obj_ext_size().

Additionally add a slab_obj_ext_has_codetag() check in
handle_failed_objexts_alloc(). The function might get called with memory
allocation profiling disabled, when the obj_ext array is allocated for
objcg pointers only. Setting codetag refs as empty is unnecessary in
that case, and with them not allocated anymore would now result in
memory corruption.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 2 +-
 mm/slub.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slab.h b/mm/slab.h
index 8f352d9f4d91..f86d4ed3f2be 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -591,7 +591,7 @@ static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 	if (IS_ENABLED(CONFIG_MEMCG))
 		sz += 1;
 
-	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
+	if (slab_obj_ext_has_codetag())
 		sz += 1;
 
 	return sizeof(struct slabobj_ext) * sz;
diff --git a/mm/slub.c b/mm/slub.c
index 67958f2b3bab..6050fc08d8ee 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2099,6 +2099,9 @@ static inline void handle_failed_objexts_alloc(struct slab *slab,
 {
 	unsigned int stride;
 
+	if (!slab_obj_ext_has_codetag())
+		return;
+
 	/*
 	 * If vector previously failed to allocate then we have live
 	 * objects with no tag reference. Mark all references in this

-- 
2.55.0

