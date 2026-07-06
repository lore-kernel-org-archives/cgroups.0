Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE6B3A9618
	for <cgroups@vger.kernel.org>; Mon,  6 Jul 2026 02:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.139.111.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783305725; cv=none; b=IrmjMy6rz17Pllu+bSi4CHD6ENuZvPcVdgexuBRBp96AzE3uW5k5e0PGm7OJUbcEwhjw7niKCfcvdqmvQmTmSuOYTLOuuEH7MHpTGzfNex/8EGEMQbWSy2H//rExViPqU2+H58okE9dwcY3mBHHj+pWbrmdTfNskmlAYBqiAeGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783305725; c=relaxed/simple;
	bh=/AxeHYs1HhaOsgsj+ofpvnx1Z/2UQf8kD/3UQHdIR5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=heaer31dZPZYL68n5qzv3kl7bswbei8+iRu1KmmxTYEzxh4sRJgwkm+VQ4P25YLBbYgCvEOWkR/vhBqEpE9bujQ7ADNFMq3zoZUsNSAnlziUTnXfGxjYcoBaHerpKfjg2cSjCvDxHP0fMicwe1c/sU09n2XKTc1j4vl2fvLUKj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=205.139.111.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-8LAwM2rRPAW9RSKF91AsMg-1; Sun,
 05 Jul 2026 22:42:01 -0400
X-MC-Unique: 8LAwM2rRPAW9RSKF91AsMg-1
X-Mimecast-MFC-AGG-ID: 8LAwM2rRPAW9RSKF91AsMg_1783305719
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 900761800605;
	Mon,  6 Jul 2026 02:41:59 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.13])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B4B8E300070A;
	Mon,  6 Jul 2026 02:41:52 +0000 (UTC)
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
Subject: [PATCH 03/10] ttm/pool: initialise the shrinker earlier
Date: Mon,  6 Jul 2026 12:36:12 +1000
Message-ID: <20260706024122.853329-4-airlied@gmail.com>
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
X-Mimecast-MFC-PROC-ID: 3VF7R-d-6KERt1Vt_oYVw7ByVpKYinSEF8UjogyMzhQ_1783305719
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true

From: Dave Airlie <airlied@redhat.com>

Later memcg enablement needs the shrinker initialised before the list lru,
Just move it for now.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.=
c
index e4dbf4c93091..8461d0c6f1f7 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -1402,6 +1402,17 @@ int ttm_pool_mgr_init(unsigned long num_pages)
 =09spin_lock_init(&shrinker_lock);
 =09INIT_LIST_HEAD(&shrinker_list);
=20
+=09mm_shrinker =3D shrinker_alloc(SHRINKER_NUMA_AWARE, "drm-ttm_pool");
+=09if (!mm_shrinker)
+=09=09return -ENOMEM;
+
+=09mm_shrinker->count_objects =3D ttm_pool_shrinker_count;
+=09mm_shrinker->scan_objects =3D ttm_pool_shrinker_scan;
+=09mm_shrinker->batch =3D TTM_SHRINKER_BATCH;
+=09mm_shrinker->seeks =3D 1;
+
+=09shrinker_register(mm_shrinker);
+
 =09for (i =3D 0; i < NR_PAGE_ORDERS; ++i) {
 =09=09ttm_pool_type_init(&global_write_combined[i], NULL,
 =09=09=09=09   ttm_write_combined, i);
@@ -1424,17 +1435,6 @@ int ttm_pool_mgr_init(unsigned long num_pages)
 #endif
 #endif
=20
-=09mm_shrinker =3D shrinker_alloc(SHRINKER_NUMA_AWARE, "drm-ttm_pool");
-=09if (!mm_shrinker)
-=09=09return -ENOMEM;
-
-=09mm_shrinker->count_objects =3D ttm_pool_shrinker_count;
-=09mm_shrinker->scan_objects =3D ttm_pool_shrinker_scan;
-=09mm_shrinker->batch =3D TTM_SHRINKER_BATCH;
-=09mm_shrinker->seeks =3D 1;
-
-=09shrinker_register(mm_shrinker);
-
 =09return 0;
 }
=20
--=20
2.54.0

