Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09F13A9618
	for <cgroups@vger.kernel.org>; Mon,  6 Jul 2026 02:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.139.111.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783305751; cv=none; b=UklFfBeA7/d0+mscxhJByGTZqjsgfHqKbWPZtCy7vmxuTusjEBrxpTSzMm2k2yd7lsXfpUV6TqKfhQwuAcnhtblmrZHp8Qj/kRkM8Im5nahFfXJsmPCsgYRQm3wxsaOTaJq2RrgRUh1yNCe2/bVrXaewYJugMNo1+FeAuGB2vhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783305751; c=relaxed/simple;
	bh=hyYlY796OXoUnj3EjU0W0+fNPhkNumXCKPQ3TaOD2LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=cBR75/qwvYcTgwdK8ZmNsjlvTyolwRmE47fYsgwQkuBxgy9uwky7GzVArIUQ61aqw0Chf/tuSfO4TnJz96+R6IlHNbIev2I+RIeerKQymi60ugTpo+y0Y9fgLNLF9XmRoq2UpXmiJutZSTNGfv3UmJLW6ACzD+UcK3yYeTaiFu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=205.139.111.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-416-88lZRkJ4Ovqn0o2uvIzJ8A-1; Sun,
 05 Jul 2026 22:42:24 -0400
X-MC-Unique: 88lZRkJ4Ovqn0o2uvIzJ8A-1
X-Mimecast-MFC-AGG-ID: 88lZRkJ4Ovqn0o2uvIzJ8A_1783305742
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3D951955F70;
	Mon,  6 Jul 2026 02:42:22 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.13])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1DE87300070A;
	Mon,  6 Jul 2026 02:42:15 +0000 (UTC)
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
Subject: [PATCH 06/10] ttm: hook up memcg placement flags.
Date: Mon,  6 Jul 2026 12:36:15 +1000
Message-ID: <20260706024122.853329-7-airlied@gmail.com>
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
X-Mimecast-MFC-PROC-ID: 8O8-FEa2Wt-hphf2qpT0rAwfYAYneg-0kDF-14a3oTA_1783305742
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true

From: Dave Airlie <airlied@redhat.com>

This adds a placement flag that requests that any bo with this
placement flag set gets accounted for memcg if it's a system memory
allocation.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c      | 4 ++--
 drivers/gpu/drm/ttm/ttm_bo_util.c | 6 +++---
 drivers/gpu/drm/ttm/ttm_bo_vm.c   | 2 +-
 drivers/gpu/drm/xe/xe_bo.c        | 2 +-
 include/drm/ttm/ttm_placement.h   | 3 +++
 5 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 8e38c6c5c82e..54ee9d4e7a13 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -146,7 +146,7 @@ static int ttm_bo_handle_move_mem(struct ttm_buffer_obj=
ect *bo,
 =09=09=09goto out_err;
=20
 =09=09if (mem->mem_type !=3D TTM_PL_SYSTEM) {
-=09=09=09ret =3D ttm_bo_populate(bo, false, ctx);
+=09=09=09ret =3D ttm_bo_populate(bo, mem->placement & TTM_PL_FLAG_MEMCG, c=
tx);
 =09=09=09if (ret)
 =09=09=09=09goto out_err;
 =09=09}
@@ -1296,7 +1296,7 @@ int ttm_bo_setup_export(struct ttm_buffer_object *bo,
 =09if (ret !=3D 0)
 =09=09return ret;
=20
-=09ret =3D ttm_bo_populate(bo, false, ctx);
+=09ret =3D ttm_bo_populate(bo, bo->resource->placement & TTM_PL_FLAG_MEMCG=
, ctx);
 =09ttm_bo_unreserve(bo);
 =09return ret;
 }
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo=
_util.c
index 62dad6c05dff..f473ea829a00 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -167,7 +167,7 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
 =09src_man =3D ttm_manager_type(bdev, src_mem->mem_type);
 =09if (ttm && ((ttm->page_flags & TTM_TT_FLAG_SWAPPED) ||
 =09=09    dst_man->use_tt)) {
-=09=09ret =3D ttm_bo_populate(bo, false, ctx);
+=09=09ret =3D ttm_bo_populate(bo, dst_mem->placement & TTM_PL_FLAG_MEMCG, =
ctx);
 =09=09if (ret)
 =09=09=09return ret;
 =09}
@@ -352,7 +352,7 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo=
,
=20
 =09BUG_ON(!ttm);
=20
-=09ret =3D ttm_bo_populate(bo, false, &ctx);
+=09ret =3D ttm_bo_populate(bo, mem->placement & TTM_PL_FLAG_MEMCG, &ctx);
 =09if (ret)
 =09=09return ret;
=20
@@ -533,7 +533,7 @@ int ttm_bo_vmap(struct ttm_buffer_object *bo, struct io=
sys_map *map)
 =09=09pgprot_t prot;
 =09=09void *vaddr;
=20
-=09=09ret =3D ttm_bo_populate(bo, false, &ctx);
+=09=09ret =3D ttm_bo_populate(bo, mem->placement & TTM_PL_FLAG_MEMCG, &ctx=
);
 =09=09if (ret)
 =09=09=09return ret;
=20
diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_v=
m.c
index 2e59836b6085..98cf8f83220f 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -225,7 +225,7 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vm=
f,
=20
 =09=09ttm =3D bo->ttm;
 =09=09err =3D ttm_bo_populate(bo,
-=09=09=09=09      false,
+=09=09=09=09      bo->resource->placement & TTM_PL_FLAG_MEMCG,
 =09=09=09=09      &ctx);
 =09=09if (err) {
 =09=09=09if (err =3D=3D -EINTR || err =3D=3D -ERESTARTSYS ||
diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 20a10a174d1d..62f1da04ca2b 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1927,7 +1927,7 @@ static int xe_bo_fault_migrate(struct xe_bo *bo, stru=
ct ttm_operation_ctx *ctx,
 =09if (ttm_manager_type(tbo->bdev, tbo->resource->mem_type)->use_tt) {
 =09=09err =3D xe_bo_wait_usage_kernel(bo, ctx);
 =09=09if (!err)
-=09=09=09err =3D ttm_bo_populate(&bo->ttm, false, ctx);
+=09=09=09err =3D ttm_bo_populate(&bo->ttm, tbo->resource->placement & TTM_=
PL_FLAG_MEMCG, ctx);
 =09} else if (should_migrate_to_smem(bo)) {
 =09=09xe_assert(xe_bo_device(bo), bo->flags & XE_BO_FLAG_SYSTEM);
 =09=09err =3D xe_bo_migrate(bo, XE_PL_TT, ctx, exec);
diff --git a/include/drm/ttm/ttm_placement.h b/include/drm/ttm/ttm_placemen=
t.h
index ab2639e42c54..3db7f9b7e9da 100644
--- a/include/drm/ttm/ttm_placement.h
+++ b/include/drm/ttm/ttm_placement.h
@@ -70,6 +70,9 @@
 /* Placement is only used during eviction */
 #define TTM_PL_FLAG_FALLBACK=09(1 << 4)
=20
+/* Placement should account mem cgroup */
+#define TTM_PL_FLAG_MEMCG=09(1 << 5)
+
 /**
  * struct ttm_place
  *
--=20
2.54.0

