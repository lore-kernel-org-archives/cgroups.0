Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527B4408022;
	Mon, 27 Jul 2026 12:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156859; cv=none; b=oHW5oIkWXEzOtWGra7irCHJNuxf/authb3du+2hn5HwDZv3oiUMdC3d7u6v0wDgaDD70FhvtBpwJQlBL6CUAavsDfxbEYyO0ySiY3Oms9gHBLqRp0m1o/9JJiLBK4Luv4XHTdS/MUWvBy9arjKEt64mMD5WhIkUILrbJku75iYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156859; c=relaxed/simple;
	bh=0d98r/1G+mLQ1VAmsZoe6ttdtJdJx4jPqT4BAZJFJuw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KP12kJCiXoRINC2uR3VYKXjCiPL0TXsfZNakROtPA1buksKTVFU2hd+if0fRjs+A66pW/I+l+KI1RFaA3mVNe2WsRBlMBFg2aju/drn3DMd7hUhuvro9F1sksrtzZMh4gkQbHbXRVpWEllgQxosQXESt4g/PpCJChADNrTnaB/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHMmF0xg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHMmF0xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9131F000E9;
	Mon, 27 Jul 2026 12:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156857;
	bh=48LV9viFkKhYFL94A+9rUOQ2qkMc0/qMJzE/2IbzWC4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZHMmF0xgouXrJCZqCSjp8IrOSG2g0miroP65AfHtkeC1t7YuULD2HKIy4Xc3rrOU/
	 +uCLL0B0xzM6lzIGwNX40iWUpCq40eXb+WbfggWDQQwl8VCqN9d6QXtPeSrY92NWc1
	 E+inLjGuJOwmWvPbu9fTyEH/4wx3JxJUt/NDG/bZa0LtVWmGYt32funyuCOqQMSPne
	 nD/ih6G8CtxMp2pCHAKRfMes/L0Wbj23NVnHRsD11Vm5bWUG29O0vfxvqgHTEbd2IF
	 af7ZQ9PP1XJMV3NE2iN6Gc6bxpkPzswDe07pnA+uANFVEuBHT8N4bPGfG38DjOsxrs
	 PTwH3kRBsXQbw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:57 +0200
Subject: [PATCH v3 03/13] mm: move struct slabobj_ext to mm/slab.h
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-3-c29ef0f1f257@kernel.org>
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

Users of include/linux/memcontrol.h don't need to see this internal
structure. Further changes to the struct will reduce recompiling.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/memcontrol.h | 13 -------------
 mm/slab.h                  | 13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..93869cc35c25 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1440,19 +1440,6 @@ static inline void mem_cgroup_flush_workqueue(void) { }
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
-/*
- * Extended information for slab objects stored as an array in page->memcg_data
- * if MEMCG_DATA_OBJEXTS is set.
- */
-struct slabobj_ext {
-#ifdef CONFIG_MEMCG
-	struct obj_cgroup *objcg;
-#endif
-#ifdef CONFIG_MEM_ALLOC_PROFILING
-	union codetag_ref ref;
-#endif
-} __aligned(8);
-
 static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/slab.h b/mm/slab.h
index 01535e1e2d3c..7bd361447c54 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -549,6 +549,19 @@ static inline bool need_kmalloc_no_objext(void)
 	return false;
 }
 
+/*
+ * Extended information for slab objects stored as an array in page->memcg_data
+ * if MEMCG_DATA_OBJEXTS is set.
+ */
+struct slabobj_ext {
+#ifdef CONFIG_MEMCG
+	struct obj_cgroup *objcg;
+#endif
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+	union codetag_ref ref;
+#endif
+} __aligned(8);
+
 #ifdef CONFIG_SLAB_OBJ_EXT
 
 /*

-- 
2.55.0

