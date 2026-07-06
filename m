Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171A63A8747
	for <cgroups@vger.kernel.org>; Mon,  6 Jul 2026 02:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.139.111.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783305735; cv=none; b=sZuk0nClV/Y22mz72XmAswaHpQKckkkyA/q12vJom4HbYjQ9pCW5depE1GxZHlr2l0IpI77CY99jqCDtv13r26WNWVCbOUNXRo53xLT0aD3Y9To08NW1WQfIfCEoRzTa2iimwjXuGRJpGq+IChdV3nQnbAv6tANLAGO/0tknQvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783305735; c=relaxed/simple;
	bh=cyXYu3aLLYcNGDZfwocqOypp0kmJ76JY3NlJPrRR5xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=kEaHR3kpj4O+PbIXIrB7BaEjrSocRXBJPZ2avf1TA801ortsCTe+/PY+KmhxMpD7woMtfYMn0EFiXXcb3vmrdsMZcFo2X4nQoV5Fn4mptCBrcCybpU0QoSKYmNMkIeV93AnfaV0VmSdtkV7W1P/X5MZUif5PRmQu0Nto2YUJ1Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=205.139.111.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-__fnXQHrMXuLhogHRiZg7Q-1; Sun,
 05 Jul 2026 22:42:09 -0400
X-MC-Unique: __fnXQHrMXuLhogHRiZg7Q-1
X-Mimecast-MFC-AGG-ID: __fnXQHrMXuLhogHRiZg7Q_1783305727
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C01B51955F6F;
	Mon,  6 Jul 2026 02:42:07 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.13])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6D92A300070A;
	Mon,  6 Jul 2026 02:42:00 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	tj@kernel.org,
	christian.koenig@amd.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Waiman Long <longman@redhat.com>,
	simona@ffwll.ch,
	intel-xe@lists.freedesktop.org
Subject: [PATCH 04/10] ttm: add objcg pointer to bo and tt (v2)
Date: Mon,  6 Jul 2026 12:36:13 +1000
Message-ID: <20260706024122.853329-5-airlied@gmail.com>
In-Reply-To: <20260706024122.853329-1-airlied@gmail.com>
References: <20260706024122.853329-1-airlied@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _UKVa07WydAvdUj2NIzjn469WAL4pQ6dQq7ZxXwNgBM_1783305727
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true

From: Dave Airlie <airlied@redhat.com>

This just adds the obj cgroup pointer to the bo and tt structs,
and sets it between them.

Signed-off-by: Dave Airlie <airlied@redhat.com>

---
v2: add the put and a setter helper
---
 drivers/gpu/drm/ttm/ttm_bo.c |  2 ++
 drivers/gpu/drm/ttm/ttm_tt.c |  1 +
 include/drm/ttm/ttm_bo.h     | 20 ++++++++++++++++++++
 include/drm/ttm/ttm_tt.h     |  2 ++
 4 files changed, 25 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index cf4ab2b5521a..8e38c6c5c82e 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -48,6 +48,7 @@
 #include <linux/atomic.h>
 #include <linux/cgroup_dmem.h>
 #include <linux/dma-resv.h>
+#include <linux/memcontrol.h>
=20
 #include "ttm_module.h"
 #include "ttm_bo_internal.h"
@@ -315,6 +316,7 @@ static void ttm_bo_release(struct kref *kref)
 =09=09dma_resv_unlock(bo->base.resv);
 =09}
=20
+=09obj_cgroup_put(bo->objcg);
 =09atomic_dec(&ttm_glob.bo_count);
 =09bo->destroy(bo);
 }
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index aa0f17fca770..1f68a7dc41f2 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -164,6 +164,7 @@ static void ttm_tt_init_fields(struct ttm_tt *ttm,
 =09ttm->caching =3D caching;
 =09ttm->restore =3D NULL;
 =09ttm->backup =3D NULL;
+=09ttm->objcg =3D bo->objcg;
 }
=20
 int ttm_tt_init(struct ttm_tt *ttm, struct ttm_buffer_object *bo,
diff --git a/include/drm/ttm/ttm_bo.h b/include/drm/ttm/ttm_bo.h
index 535ba37aff88..bc3809676bb3 100644
--- a/include/drm/ttm/ttm_bo.h
+++ b/include/drm/ttm/ttm_bo.h
@@ -135,6 +135,12 @@ struct ttm_buffer_object {
 =09 * reservation lock.
 =09 */
 =09struct sg_table *sg;
+
+=09/**
+=09 * @objcg: object cgroup to charge this to if it ends up using system m=
emory.
+=09 * NULL means don't charge.
+=09 */
+=09struct obj_cgroup *objcg;
 };
=20
 #define TTM_BO_MAP_IOMEM_MASK 0x80
@@ -344,6 +350,20 @@ ttm_bo_move_to_lru_tail_unlocked(struct ttm_buffer_obj=
ect *bo)
 =09spin_unlock(&bo->bdev->lru_lock);
 }
=20
+/**
+ * ttm_bo_set_cgroup - assign a cgroup to a buffer object.
+ * @bo: The bo to set the cgroup for
+ * @objcg: the cgroup to set.
+ *
+ * This transfers the cgroup reference to the bo. From this
+ * point on the cgroup reference is owned by the ttm bo.
+ */
+static inline void ttm_bo_set_cgroup(struct ttm_buffer_object *bo,
+=09=09=09=09     struct obj_cgroup *objcg)
+{
+=09bo->objcg =3D objcg;
+}
+
 static inline void ttm_bo_assign_mem(struct ttm_buffer_object *bo,
 =09=09=09=09     struct ttm_resource *new_mem)
 {
diff --git a/include/drm/ttm/ttm_tt.h b/include/drm/ttm/ttm_tt.h
index 15d4019685f6..c13fea4c2915 100644
--- a/include/drm/ttm/ttm_tt.h
+++ b/include/drm/ttm/ttm_tt.h
@@ -126,6 +126,8 @@ struct ttm_tt {
 =09enum ttm_caching caching;
 =09/** @restore: Partial restoration from backup state. TTM private */
 =09struct ttm_pool_tt_restore *restore;
+=09/** @objcg: Object cgroup for this TT allocation */
+=09struct obj_cgroup *objcg;
 };
=20
 /**
--=20
2.54.0

