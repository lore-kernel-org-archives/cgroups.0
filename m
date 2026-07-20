Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7222142E000;
	Mon, 20 Jul 2026 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557014; cv=none; b=Qh6obx2i3i8k1xKeCxsNwRV06K7oPp4sSQjORl38vD2HemQluWPNkiJFkfGwmCX1noBFJbLoOyLPoKMJivexHDMib70rigCSTav8NrCkmEOeH5sT/d7HOfuanYOFL5AKcXNtj+sCXfelZTdvfubFl5hegVBYS700I6GqQcb8j34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557014; c=relaxed/simple;
	bh=IC8TBEVEEa/sYw89rJKxlnP8ISZPRsKSX/WVJLgMsMs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D+lTttE1EwkSo+Kiwhxyf7UysViolP4em5pEt28cFkqwrWrRkZN1k2plpQXXuX2pDqTUFU4KgyhjH4lEKWw5KHU9ZGHHO95AqkT84mjUPXrfC3kYZp6c8r58Dyg0FV6mLd4zI2toohpDm8Hsmm42U9AcPrTWwIaBzP12L74A2zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ag50PqQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ag50PqQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3781F00A3A;
	Mon, 20 Jul 2026 14:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557013;
	bh=JVOSCtSkIl9pvKhPgb17Vi/B/0DgmPSgipmixRu4V7k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ag50PqQ6TBFMx9wWb1CwjdwNFiyxlVEDAPuNyVJCmp8SwKzPz5D9IqsjkzT+S9uGD
	 Hlzi0EUj39Xvc5J7KPXJBla6yj3isEcuaTB7t/1DeIqCayEkPnHzJrmJ4h4f4sk75e
	 RRFsr8pvtcasjhBMcLv16O03pV5WL0NSGBK1x0Gx8I7Kzdhs1RRs0Icy+RKfVRa4+w
	 Fcju+cDSZ4tIiRVTsAF5qwVLku11Ti1SuPJ2ZFLDz/uOhrgFgUux8lWGUmsSq5DwfF
	 fKWy6RFbyFJOIqqoAGGXwECI65DtUOeO7h/jOOAFXHnYG3FUxT+lsHzvvV0zDyKF7l
	 BRN6jR9J5stbQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:22 +0200
Subject: [PATCH v2 08/13] mm/slab: replace slab.stride with
 obj_exts_in_object
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-8-2fa7c6f60dbe@kernel.org>
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

The stride field is used to convert object index to an slabobj_ext so
both compact arrays (kmalloc() or in-slab-leftover) and spread
in-object-padding obj_ext layouts are supported.

In practice thus the stride is always sizeof(slabobj_ext) or s->size.

This simplifies the calculations, but with the upcoming slabobj_ext
handling changes, it will be easier to stop storing the stride and
instead just have a flag whether obj_ext is in the object padding.
obj_exts_in_object() can then rely on this flag and slab_obj_ext()
can use that to determine the stride.

No functional change intended. Performance impact TBD, hopefully
in the noise.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 44 +++++++++++++++++++++++++-------------------
 mm/slub.c | 42 ++++++++++++++++--------------------------
 2 files changed, 41 insertions(+), 45 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 62d6366d7d79..e586798e4f16 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -81,10 +81,10 @@ struct freelist_counters {
 #ifdef CONFIG_64BIT
 					/*
 					 * Some optimizations use free bits in 'counters' field
-					 * to save memory. In case ->stride field is not available,
+					 * to save memory. If these free bits are not available,
 					 * such optimizations are disabled.
 					 */
-					unsigned int stride;
+					unsigned obj_exts_in_object:1;
 #endif
 				};
 			};
@@ -617,22 +617,20 @@ static inline void put_slab_obj_exts(unsigned long obj_exts)
 }
 
 #ifdef CONFIG_64BIT
-static inline void slab_set_stride(struct slab *slab, unsigned int stride)
+static inline bool obj_exts_in_object(struct slab *slab)
 {
-	slab->stride = stride;
-}
-static inline unsigned int slab_get_stride(struct slab *slab)
-{
-	return slab->stride;
+	/*
+	 * Note we cannot rely on the SLAB_OBJ_EXT_IN_OBJ flag here and need to
+	 * check the per-slab bit. A cache can have SLAB_OBJ_EXT_IN_OBJ set, but
+	 * allocations within_slab_leftover are preferred. And those may be
+	 * possible or not depending on the particular slab's size.
+	 */
+	return slab->obj_exts_in_object;
 }
 #else
-static inline void slab_set_stride(struct slab *slab, unsigned int stride)
+static inline bool obj_exts_in_object(struct slab *slab)
 {
-	VM_WARN_ON_ONCE(stride != sizeof(struct slabobj_ext));
-}
-static inline unsigned int slab_get_stride(struct slab *slab)
-{
-	return sizeof(struct slabobj_ext);
+	return false;
 }
 #endif
 
@@ -657,8 +655,15 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
 	index = obj_to_index(s, slab, obj);
-	obj_ext = (struct slabobj_ext *)(obj_exts +
-					 slab_get_stride(slab) * index);
+
+	if (!obj_exts_in_object(slab)) {
+		obj_ext = ((struct slabobj_ext *)obj_exts) + index;
+	} else {
+		unsigned int stride = s->size;
+
+		obj_ext = (struct slabobj_ext *)(obj_exts + index * stride);
+	}
+
 	return kasan_reset_tag(obj_ext);
 }
 
@@ -700,9 +705,10 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 	return NULL;
 }
 
-static inline void slab_set_stride(struct slab *slab, unsigned int stride) { }
-static inline unsigned int slab_get_stride(struct slab *slab) { return 0; }
-
+static inline bool obj_exts_in_object(struct slab *slab)
+{
+	return false;
+}
 
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
diff --git a/mm/slub.c b/mm/slub.c
index cf999cbe75d1..f5b3eb44cb8a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -870,18 +870,6 @@ static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
 #endif
 
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
-static bool obj_exts_in_object(struct kmem_cache *s, struct slab *slab)
-{
-	/*
-	 * Note we cannot rely on the SLAB_OBJ_EXT_IN_OBJ flag here and need to
-	 * check the stride. A cache can have SLAB_OBJ_EXT_IN_OBJ set, but
-	 * allocations within_slab_leftover are preferred. And those may be
-	 * possible or not depending on the particular slab's size.
-	 */
-	return obj_exts_in_slab(s, slab) &&
-	       (slab_get_stride(slab) == s->size);
-}
-
 static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
 {
 	unsigned int offset = get_info_end(s);
@@ -896,16 +884,20 @@ static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
 
 	return offset;
 }
-#else
-static inline bool obj_exts_in_object(struct kmem_cache *s, struct slab *slab)
+
+static inline void slab_set_obj_exts_in_object(struct slab *slab)
 {
-	return false;
+	slab->obj_exts_in_object = 1;
 }
-
+#else
 static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
 {
 	return 0;
 }
+
+static inline void slab_set_obj_exts_in_object(struct slab *slab)
+{
+}
 #endif
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -1206,7 +1198,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 
 	off += kasan_metadata_size(s, false);
 
-	if (obj_exts_in_object(s, slab))
+	if (obj_exts_in_object(slab))
 		off += sizeof(struct slabobj_ext);
 
 	if (off != size_from_object(s))
@@ -1411,7 +1403,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 
 	off += kasan_metadata_size(s, false);
 
-	if (obj_exts_in_object(s, slab))
+	if (obj_exts_in_object(slab))
 		off += sizeof(struct slabobj_ext);
 
 	if (size_from_object(s) == off)
@@ -1439,7 +1431,7 @@ slab_pad_check(struct kmem_cache *s, struct slab *slab)
 	length = slab_size(slab);
 	end = start + length;
 
-	if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(s, slab)) {
+	if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(slab)) {
 		remainder = length;
 		remainder -= obj_exts_offset_in_slab(s, slab);
 		remainder -= obj_exts_size_in_slab(slab);
@@ -2261,9 +2253,6 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 	void *addr;
 	unsigned long obj_exts;
 
-	/* Initialize stride early to avoid memory ordering issues */
-	slab_set_stride(slab, sizeof(struct slabobj_ext));
-
 	if (!need_slab_obj_exts(s))
 		return;
 
@@ -2297,7 +2286,7 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 		obj_exts |= MEMCG_DATA_OBJEXTS;
 #endif
 		slab->obj_exts = obj_exts;
-		slab_set_stride(slab, s->size);
+		slab_set_obj_exts_in_object(slab);
 	}
 }
 
@@ -3410,9 +3399,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
 		stat(s, ORDER_FALLBACK);
 	}
 
+	/* Initializes frozen, inuse, and any extra 64bit-only flags */
+	slab->counters = 0;
+
 	slab->objects = oo_objects(oo);
-	slab->inuse = 0;
-	slab->frozen = 0;
 
 	slab->slab_cache = s;
 
@@ -6545,7 +6535,7 @@ static inline size_t slab_ksize(struct slab *slab)
 	 */
 	if (s->flags & (SLAB_TYPESAFE_BY_RCU | SLAB_STORE_USER))
 		return s->inuse;
-	else if (obj_exts_in_object(s, slab))
+	else if (obj_exts_in_object(slab))
 		return s->inuse;
 	/*
 	 * Else we can use all the padding etc for the allocation

-- 
2.55.0

