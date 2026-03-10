Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4960D38757B;
	Tue, 10 Mar 2026 11:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142755; cv=none; b=fwPho7+p3TLxilARCmRseH5ZGtQH9r2vTLygx5Sd5jgiFb3E7lH/EUqqFIj6aAcCxx8kcN0XKc8R95ghpAdwmlyg5sUOGKxoOOFVXgnbofeSTGfqAM9bYRwBYgZYUqo+PIhd7A4+ehx2NNTlEPp2+eslNtm7R9RUZblTPfqw1Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142755; c=relaxed/simple;
	bh=fDPANPc1RHb0PzbHZCQSQYpJpxCv/08U1buIRDxUimU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJRwLhKXh07BXK2jgqY9iYu5M3lW+xWRYYMzDgWl0tG+VCQs8JMkW+lq1FYWb+2xrgNMmNcUQBfIZ4wpS+3i/GGE1AGOpFD2EWd+0ugxBtVaIF4B4omLPZ7XiMH+La2tWBLnwbpXuDrKPnAVVM/TtR82+FPzDMwJgCxkSjeuFQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=FH/3u5FI; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="FH/3u5FI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=fd
	vSAzoo6YoHXW8kKXpbNqTJIz++VEopwb6mVs5rsKU=; b=FH/3u5FIhRb7GWs2B0
	GQ/iKMBFiJHemM7v5rQQnuH/+tN3x5HvfMScgYCBdpL806IiSXHHOn+OARoRQ4Dm
	PXrEwwzMMaHH/H3Gr/puXqMR/pxe9rReHnBNqnp8p6yfrwbwB90d1JLh9e0irkNV
	mI7Kg/kt8a6cIPEPSXk3mHdUQ=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wAXvQ+eArBpwhXAAA--.11763S3;
	Tue, 10 Mar 2026 19:38:09 +0800 (CST)
From: ranxiaokai627@163.com
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	harry.yoo@oracle.com,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 1/2] mm/slab: move obj_exts_in_slab() definition to slab.h
Date: Tue, 10 Mar 2026 11:38:03 +0000
Message-ID: <20260310113804.245647-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310113804.245647-1-ranxiaokai627@163.com>
References: <20260310113804.245647-1-ranxiaokai627@163.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXvQ+eArBpwhXAAA--.11763S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxWF4DCr4xXw1DGw15Cw17Wrg_yoW5Gr18pF
	yrG3ZrtrWvvry2grW7Jr48G34Yv34ftry8JrWxKwnYqa4Fvw4DtF10qry0vF98uas2gFnx
	Xws5KFy8Ww4jvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRkR6wUUUUU=
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxgEve2mwAqFlcwAA3-

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Move the definition of obj_exts_in_slab() to slab.h. This is in
preparation for the next patch, which needs to access this helper
from memcontrol.c.

No functional change intended.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/slab.h | 19 +++++++++++++++++++
 mm/slub.c | 19 -------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 77242024e7d5..8354d5669ee7 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -597,6 +597,21 @@ static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
 	return kasan_reset_tag(obj_ext);
 }
 
+static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
+{
+	unsigned long obj_exts;
+	unsigned long start;
+	unsigned long end;
+
+	obj_exts = slab_obj_exts(slab);
+	if (!obj_exts)
+		return false;
+
+	start = (unsigned long)slab_address(slab);
+	end = start + slab_size(slab);
+	return (obj_exts >= start) && (obj_exts < end);
+}
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
                         gfp_t gfp, bool new_slab);
 
@@ -617,6 +632,10 @@ static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
 static inline void slab_set_stride(struct slab *slab, unsigned int stride) { }
 static inline unsigned int slab_get_stride(struct slab *slab) { return 0; }
 
+static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
+{
+	return false;
+}
 
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
diff --git a/mm/slub.c b/mm/slub.c
index 1871c5ef354a..845a67736688 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -808,20 +808,6 @@ static inline bool obj_exts_fit_within_slab_leftover(struct kmem_cache *s,
 	return objext_offset + objext_size <= slab_size(slab);
 }
 
-static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
-{
-	unsigned long obj_exts;
-	unsigned long start;
-	unsigned long end;
-
-	obj_exts = slab_obj_exts(slab);
-	if (!obj_exts)
-		return false;
-
-	start = (unsigned long)slab_address(slab);
-	end = start + slab_size(slab);
-	return (obj_exts >= start) && (obj_exts < end);
-}
 #else
 static inline bool need_slab_obj_exts(struct kmem_cache *s)
 {
@@ -845,11 +831,6 @@ static inline bool obj_exts_fit_within_slab_leftover(struct kmem_cache *s,
 	return false;
 }
 
-static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
-{
-	return false;
-}
-
 #endif
 
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
-- 
2.25.1


