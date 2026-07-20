Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78345429817;
	Mon, 20 Jul 2026 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557002; cv=none; b=F1m0p4nlQs2e8CeJeVvdAxbMl2/y2zd+aYTZfT5ENWMCxffRNqNq0kctG5Q2sr9CeQjPKNcpNFcTmAyqtda78zUJEL7NFhRVAlMl46LsRfzxsPOZZmLZ6SXDI5VS/gRp2xGsB57W4PotLuaEVgwS2LTIlm8wRLyu+1wXfI+ya9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557002; c=relaxed/simple;
	bh=uHuYlHIOrdo1xX2LkYws7+vgVsQOzkWSaSyhmIiiH7w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ka1gza8C/27ITXFzrSrY/VPMSjXIGQT6Cl2tio3z7Oa9JMqdYPboUXjpuv8pRJbykmCmicosVJ4/j+t5UwIdz9F8Orlb+rY+FRcs7OYa7zBtrcMrmX6aogVZGsqNc2NaYiGTczIHXQQu5uAZ4Os26XHgrPo3bAygEos9wlobsTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Br9XN6gJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Br9XN6gJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F65F1F00A3D;
	Mon, 20 Jul 2026 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557001;
	bh=hv2b9QbG8twJiZU//bTGb/DtRCdO7wG1c5Bfg2/CoNc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Br9XN6gJBq/DAksxVIjEvSqV/kxRrhJt2BSaai2pXAV2SyQ7+cQXYzdab7C2/MCPJ
	 JKtpQdpnXaCdJCszSsNOW0vBJPwlcHu7/iWNjSKih5PMsSBIkpYTBA1NG9GZZnl3GI
	 blHRKJHQGHn+Mvd5XEVY/UOjfiH9pk86iC+dxMGqDwfkBOgumDn61cPSf5pcP0ST/4
	 dec2G+CiZ0/pzr+0gjXsDyA0evWXgEecu7thWpvgReWZ/CqiuQtGBaQ/6lCaym1GfC
	 ST2Ly5/crNwdUWH5LzWME1ybTIm6HUJ1/RSjLBMOo76MObVqqqvhbjQ+pvk3TatY4r
	 LXCtocsX3g0/g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:18 +0200
Subject: [PATCH v2 04/13] mm: move struct slabobj_ext to mm/slab.h
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
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

Users of include/linux/memcontrol.h don't need to see this internal
structure. Further changes to the struct will reduce recompiling.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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

