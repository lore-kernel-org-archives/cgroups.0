Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA3D423EAF
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 13:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208252; cv=none; b=DNauxQbk06hBzxwp9NF6z2ePULi4O07R5UMrytOaCGazEl6y6Yox65x5Gc8g40C6JSPVk4GPSeNz/Qq5fgKrQ/fiWTFxbnIBwm4gcFqIF+tuOPpl0Iusp5PVdaNYxf7hanLtiHm8A1yfwrFAd+QWT44Dw3WOpMCbYoPJtkkGXP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208252; c=relaxed/simple;
	bh=zFeWDdafDoYi7ea+8KDHKiNyfn2RCWSEnlN5ywMFr9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFRiGDDNA8oZF4SZnuvAS7823q7UUhPbQ0rnudQkF6U29mkMyQl/kdhHjEFva/LwcJ2T/aRiR3T3rNN6wdsiD+HQGWxcwA1DgFp3MSb2FQIvz3OrYPFBbDJwQuDiwk1sNrOiMUijdveZD8q+I39QSRqd0lttR3+3Ap0iWb+/hDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=O042gtuL; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="O042gtuL"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493f45e206dso1962215e9.1
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208248; x=1784813048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=myAuJMzKK/4iG9Cmnf7VPvLoMfqifqNKwX3ebA7nias=;
        b=O042gtuL4LYOEy+SyRQCnxeZzMebGdF1yLbEEsAhXGrT7ON792v3lOFl30BmMmgoi3
         DDEVwahCP3E4rh9hSd7WbpT09YiZwwQyIEnMn0ppIKZ+VfB8OB5qB7j11mkyKHVGVuWL
         reMp1MrFt+2hXtaoqZTiqOgjghVQIAV1KE0GYyf6aJj/VaPSMSicVQSUAc3rw3v0+ttd
         RL4puLpC0nIf/oCifTKz0SYijzMVumMA5m8YVS+kLCdlIgjOOPY274kaqnIkEv8Iiyph
         vcwG8uCvN4v3A5G4ry7pRn75aAftfKHdtgjJczT4XfjOhhZoMYAVWbQqf1fWJf6VjcOV
         vOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208248; x=1784813048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=myAuJMzKK/4iG9Cmnf7VPvLoMfqifqNKwX3ebA7nias=;
        b=FFu/GtoN0+JnLDQogVDsmxUgn4ZIbMSHQzvAc65qtPQKCTXGsHRqo5dWydXJyLcF/d
         MeFqmk9a3JXid0Mf5PTkq7kg+TKu5Zuyg8Q3XJmG3rA4kcql+gGOEmjD/12tC3yt5JnD
         GDcE0Cl7nWGn20OzG1EPpLTdV7bR5Gu9gFcJJ9CyI54hQ4PjKrl2E8HlyHy+3mhyyZ+T
         gk23bOwwREjQ21bOyiJKDMv8K1n5+1Cp0YOPL4BnbzO2j0IO4TMiaqp5pCcKNiC2/xSO
         p5v5ua50YGMjOwcKog2Ikm0aEKvX3X8XumjU4indXWuip1rR4jww8wIXBXz1wYapU38u
         ZO5Q==
X-Gm-Message-State: AOJu0Yx1UAjqrWCDfIG86n2ODuytoYfto7Df0LKUIOnFGDIyk216u8nK
	N4XmMwb8LNnySWQ3UG3i0HZp23oX3LCTM0WoxaB3Azrz+5ByfzwddD6oKkvl7zTjsWU=
X-Gm-Gg: AfdE7cnwlHXzWCWdCcgFxHjg9rniA5rHRguve1S+/V9T0ay2XeEBIaSTnoGLaIfcjje
	WGSOE23x2oZtr+yCQnIn0EA9qVjE2EM+sJiD7+pXxrxnpBkC9+FsYaUmpLqbsdAWvDGslJ4UVUj
	pW1xsAX0MhqkejGfU1VS/B+fr7iBujNU22YX2jSL3lED/ofKYRazF+Dvo6WRBiT5K/groMeL+nb
	EkoxUP3+YqcMVjwCyjEdxoNuVyGuIfGcAQ+pMl4kNoRCpgn/qLn2lcLwm7ChLEZk0KBEi4ovnHY
	N36wV645lFf2t206+G2Yrg1cADMFxZ2Ord0M6xv686YrJO2AL7yYBLS7u29hpLFMbZt4AiQBFfy
	z9kMXsgUA7AknHmpyfAJYla03CyH+gUfD/pPj0qesVnUT1vgXyysDGIWZJ7qqTwABamL4NNR/Vd
	otqfzUtaYd3Oo=
X-Received: by 2002:a05:600c:6094:b0:492:714d:8c4 with SMTP id 5b1f17b1804b1-495428801cfmr26808555e9.11.1784208248133;
        Thu, 16 Jul 2026 06:24:08 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4953c599049sm100313305e9.0.2026.07.16.06.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:24:07 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: cgroups@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	parav@nvidia.com,
	mbloch@nvidia.com,
	cmeiohas@nvidia.com,
	roman.gushchin@linux.dev,
	bvanassche@acm.org,
	zyjzyj2000@gmail.com,
	shuah@kernel.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	yanjun.zhu@linux.dev,
	cui.tao@linux.dev
Subject: [PATCH rdma-next v3 12/14] RDMA/rxe: Allow queue VMAs to outlive ucontexts
Date: Thu, 16 Jul 2026 15:23:13 +0200
Message-ID: <20260716132316.1495242-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716132316.1495242-1-jiri@resnulli.us>
References: <20260716132316.1495242-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Prepare queue mappings for asynchronous ucontext disassociation during
device disable. Rely on the VMA page references to preserve mapped
memory until the final unmap.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- new patch
---
 drivers/infiniband/sw/rxe/rxe_mmap.c | 35 ++--------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mmap.c b/drivers/infiniband/sw/rxe/rxe_mmap.c
index 7f723a2f3700..a4ead89ccbd3 100644
--- a/drivers/infiniband/sw/rxe/rxe_mmap.c
+++ b/drivers/infiniband/sw/rxe/rxe_mmap.c
@@ -11,7 +11,6 @@
 
 #include "rxe.h"
 #include "rxe_loc.h"
-#include "rxe_queue.h"
 
 void rxe_mmap_release(struct kref *ref)
 {
@@ -30,29 +29,6 @@ void rxe_mmap_release(struct kref *ref)
 	kfree(ip);
 }
 
-/*
- * open and close keep track of how many times the memory region is mapped,
- * to avoid releasing it.
- */
-static void rxe_vma_open(struct vm_area_struct *vma)
-{
-	struct rxe_mmap_info *ip = vma->vm_private_data;
-
-	kref_get(&ip->ref);
-}
-
-static void rxe_vma_close(struct vm_area_struct *vma)
-{
-	struct rxe_mmap_info *ip = vma->vm_private_data;
-
-	kref_put(&ip->ref, rxe_mmap_release);
-}
-
-static const struct vm_operations_struct rxe_vm_ops = {
-	.open = rxe_vma_open,
-	.close = rxe_vma_close,
-};
-
 /**
  * rxe_mmap - create a new mmap region
  * @context: the IB user context of the process making the mmap() call
@@ -106,17 +82,10 @@ int rxe_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	list_del_init(&ip->pending_mmaps);
 	spin_unlock_bh(&rxe->pending_lock);
 
-	vma->vm_ops = &rxe_vm_ops;
-	vma->vm_private_data = ip;
-
 	ret = remap_vmalloc_range(vma, ip->obj, 0);
-	if (ret) {
-		vma->vm_private_data = NULL;
-		vma->vm_ops = NULL;
-		kref_put(&ip->ref, rxe_mmap_release);
+	kref_put(&ip->ref, rxe_mmap_release);
+	if (ret)
 		rxe_dbg_dev(rxe, "err %d from remap_vmalloc_range\n", ret);
-		goto done;
-	}
 
 done:
 	return ret;
-- 
2.54.0

