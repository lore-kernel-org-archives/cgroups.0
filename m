Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A6A352034
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 12:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786538969; cv=none; b=QnK/s9L50Prg/EW9pa9vommnVfpZD9U17WC3WNcaFBbsv8TzHuPRjr/PEXHlAuh7EJhgDDi9mQTJ97PmiVo/x/7yVvQ2B7o9ViCFDx3UA7D57czVc83BKiTpoqRyp19WSjEe2L/lSaaQlOa0KNDedykX31uwXPd/lfkCurnl9GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786538969; c=relaxed/simple;
	bh=T3euLRUWi5X4en4gbGyeNy19X/iP7P5qMnlk87Y3JzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lxKOHWDzdp0ADFaTNOcyWv/SYe8hxZnKKy8cBTikKhv9h7GkU+nrjLpX+TcHR0l2l55sFYghs2cjDQkx8ai3AjEASokm9uahZP2ovnzjqjQ10lPEDjdsqtsPc7Fbv1C/Dz7FBV3wUOAukT/oymudhVoQpLRaiyiDOvBNf+eV6iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cJNpiUxz; arc=none smtp.client-ip=91.218.175.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cJNpiUxz"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=T3euLRUWi5X4en4gbGyeNy19X/iP7P5qMnlk87Y3JzU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786538964; v=1; x=1787143764;
 b=cJNpiUxzrSq3A5+7llRRqpKNporOSA/pwvc1DR13ALr/S8ODWk4sPhxaZZcRbcOF1Ei77mXs
 B3cz5tpS/xMHsuU/KDq9JJRCMenH/g2Wm1gJ6QV6H9IzYfJNEk4I0cdy9ITvZd61uV6ZXuPiOJt
 0HPYQymNIgyqjGHzVvO6wmIE=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (240a:4280:d800:21e:3f98:c0ba:a57d:551c)
	by smtp.migadu.com with ESMTPS id 8d02885b92efdee5;
	Wed, 12 Aug 2026 12:49:14 +0000
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Harry Yoo <harry@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: [PATCH] mm: memcg: fix slab over-accounting for in-object objcg metadata
Date: Wed, 12 Aug 2026 20:48:58 +0800
Message-ID: <20260812124858.73487-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

obj_full_size() adds the size of an obj_cgroup pointer to s->size to
account for slabobj_ext storage, which normally resides outside the
object.

Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata in
unused space within s->size"), slabobj_ext can reside in object padding
already covered by s->size. The extra charge then accounts for the same
memory twice.

The per-slab obj_exts_in_object bit introduced by commit b5bc35ace2c5
("mm/slab: replace slab.stride with obj_exts_in_object") identifies this
layout. Use it to omit the extra charge only for in-object metadata.
Unlike in-object metadata, slab-leftover and separately allocated metadata
are not covered by the per-object s->size charge, so retain the existing
charge for those cases.

Reported-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Link: https://lore.kernel.org/all/20260310113804.245647-1-ranxiaokai627@163.com/
Fixes: a77d6d338685 ("mm/slab: place slabobj_ext metadata in unused space within s->size")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d1312441a02b..aef480f46891 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3526,12 +3526,16 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 	refill_obj_stock(objcg, size, true);
 }
 
-static inline size_t obj_full_size(struct kmem_cache *s)
+static inline size_t obj_full_size(struct kmem_cache *s, struct slab *slab)
 {
 	/*
 	 * For each accounted object there is an extra space which is used
-	 * to store obj_cgroup membership. Charge it too.
+	 * to store obj_cgroup membership. Charge it too, unless it is stored
+	 * in object padding already covered by s->size.
 	 */
+	if (obj_exts_in_object(slab))
+		return s->size;
+
 	return s->size + sizeof(struct obj_cgroup *);
 }
 
@@ -3539,7 +3543,6 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 				  gfp_t flags, unsigned int slab_alloc_flags,
 				  size_t size, void **p)
 {
-	size_t obj_size = obj_full_size(s);
 	struct obj_cgroup *objcg;
 	struct slab *slab;
 	size_t i;
@@ -3580,6 +3583,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		unsigned long obj_exts;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
+		size_t obj_size;
 
 		slab = virt_to_slab(p[i]);
 
@@ -3590,6 +3594,8 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 				continue;
 		}
 
+		obj_size = obj_full_size(s, slab);
+
 		/*
 		 * if we fail and size is 1, memcg_alloc_abort_single() will
 		 * just free the object, which is ok as we have not assigned
@@ -3632,7 +3638,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 			    void **p, int objects, unsigned long obj_exts)
 {
-	size_t obj_size = obj_full_size(s);
+	size_t obj_size = obj_full_size(s, slab);
 
 	for (int i = 0; i < objects; i++) {
 		struct obj_cgroup *objcg;

base-commit: e7f630142df2afccce90555e4972e60008222311
-- 
2.43.0

