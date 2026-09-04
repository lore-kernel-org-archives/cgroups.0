Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F2E4570FA
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 10:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519310; cv=none; b=Nm6LY1F9xysRzT+jgEW4F7KrM/gZ2iq2F4McKpd7fB77IUKARoAl+Hd/UTKzXzXWRm40sVboWmb7BB329NQwUBiLx5TTzXJ6vXNi27QfsnwbQEgeZf1NJIQd9dCIpj3XxFqyYIqZuEzJtQCP6bPhoKUHNALzs1NcODWrsQ0ms2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519310; c=relaxed/simple;
	bh=zvRp1ma2mwiDvH/BIWs5oSjIWZr662xutAh8n1iN/lg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RR+Hkm5WiWMbs3TUzWa9iVCqc1yjXb0NTKwy31CSdaPEhDYb2sa7s374kLFnK+4zollxCuMU20HDsHQkHybVYtNQJheonqeRixdKthPZdUMtwbzvJcYCkmG4RfAFItHNPp6u4Bk3ljGt6SMLSoSiFedHByzb6QqHqLP8kJKIvcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nHhlzFn6; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHhlzFn6"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3964e480f76so1033018a91.1
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 03:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788519308; x=1789124108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hCcMOQVVRtRJCmTlUSthMzO4PsVA01kcK/x92csoajc=;
        b=nHhlzFn6MfFmhu0to+X72JAbRSWf6EcN91w2yL2avBiELLB15vp+kxP2Zp0xA7PxM0
         a9pwGaBulNVsEdHAT10TYlXojqHU7kJs/tn45glCfdTrxlJV+5l90muJPvvP0ji7Kn6S
         gQYdCpWs17vYNKcQ9xcFkHjTFchIfy80wfMwgXdiLpJ7GLYgmOZp4IJIHaDfi0uSM4Zi
         TrQ34x2A+orZ42PM1ZXju4RUWrzFNmLvQDrXoeoFJTRd25syyl7CbPkfjg0HbqyPhhB4
         1oivVV808GcmkQ640sbVOzw6PP5ow8/JROAuMT6h6JRwmo+Wx4ctuxaUO//CLYwBZk7k
         k2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519308; x=1789124108;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hCcMOQVVRtRJCmTlUSthMzO4PsVA01kcK/x92csoajc=;
        b=NPI4qidbN7gPi9nJwxE/0yj/JIN9qgLtIQsGieqXpRvvNmfE/pW4kzndCuvN6Bd/li
         0QNXcXlt9xkTBXXj9Ig79v7eEydq1tqvOPpRvHHxk6t9XMuU4dwO7Cbagrw/e3dgKqwE
         yyPiXxybh8Q9dXu+JKZ7N3kKNtJcpWA/SHksmc8bkw3P1VSfmhHYg2+DghKXB7g7YRb2
         OFDNADKOxVfa42Vwgwx87ShH3USAFzVLbSgEldT9RWcO0OzzyD8JOO4F6NbSoOenSQDC
         aNP9HdtlBjxe/GCXoi7WbDHsm2s0ua+yXHOEA9/J7iLMM31yc9+Gn7Jn4ngbcuGwf9X3
         KayQ==
X-Forwarded-Encrypted: i=1; AKwUvBy3JBT542uoXzXr/85AosUX4+dVg39+p+GpDHMUour8gTJOz7rAzD42X3/IxVUXBTsw1dWsC1rS@vger.kernel.org
X-Gm-Message-State: AFuF++nunz6iSdn8SgGpu4DWjvOl6kLYujYTN41q0qe99sdiObKsJmz5
	g81ZsiweJLCkXKelwaoAd1jhd4tnprMHktqXvCjD7faINkjdr6Q4iyeD
X-Gm-Gg: AYBFou3DrdUtLtt4Gn078dD1uvVTJjM/XPUQRekZ36C/GS4Ltb1CERBtEzqlAYfn4Ah
	cY+A9xdq9XM35EYHM8wpz9e6f0eHM0EjaE9qZuajr7HD3LkjnvCtvzmKjxLDrBUp9A7PLAjHRlQ
	wLy2w8xRZP3WqJ9IWo7UMCrpg7vxuQzoi1Y7ECm2m15Pal1CMrlQvf6vxh4NavDv7yUAiqjP441
	I3bIeQZWPXfnMhBGkvzHovu3XJHV/Yyc+GpfIjrdBrGFQkjjnDBniOhoD5Tw70TbTzAuaHPESA9
	r3ZTbVK5GHIBelwcOrh+4nlUhfhPBEOgR1QHD4tDU+OZbtqTZ4/Th8wdJHrxSegYXYGajaSKdgU
	+10kGW6wiY4acv0K+1YTqTnZuhDFcD0+hAOoWJkHosnO5J+SpBEMpHbITxAZsYTbcdCoJR3J5xj
	0da2qwE5i4pXRc9HaU0K36cP/4U0AzPieleBOqVfBKRR9Qp8OgC62YRX9+pZJmmw4BelchaE8V6
	od5/XZBR+UK/l4=
X-Received: by 2002:a17:90b:2e0e:b0:398:9be5:b419 with SMTP id 98e67ed59e1d1-39b2622bfecmr8626947a91.20.1788519307614;
        Fri, 04 Sep 2026 03:55:07 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b123731sm5504962eec.18.2026.09.04.03.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:55:07 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jonathan Derrick <jonathan.derrick@linux.dev>,
	Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH] block: fix typos in comments
Date: Fri,  4 Sep 2026 16:24:56 +0530
Message-ID: <20260904105501.35807-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 block/blk-cgroup-rwstat.c         | 2 +-
 block/blk-iocost.c                | 6 +++---
 block/blk-iolatency.c             | 4 ++--
 block/blk-merge.c                 | 2 +-
 block/blk-mq.c                    | 2 +-
 block/ioprio.c                    | 2 +-
 block/opal_proto.h                | 4 ++--
 block/partitions/sun.c            | 2 +-
 block/sed-opal.c                  | 2 +-
 drivers/block/mtip32xx/mtip32xx.c | 2 +-
 drivers/block/mtip32xx/mtip32xx.h | 2 +-
 drivers/block/ublk_drv.c          | 2 +-
 12 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/block/blk-cgroup-rwstat.c b/block/blk-cgroup-rwstat.c
index 2e9bf081cce2..ab87b33a29b0 100644
--- a/block/blk-cgroup-rwstat.c
+++ b/block/blk-cgroup-rwstat.c
@@ -31,7 +31,7 @@ EXPORT_SYMBOL_GPL(blkg_rwstat_exit);
  * @pd: policy private data of interest
  * @rwstat: rwstat to print
  *
- * Print @rwstat to @sf for the device assocaited with @pd.
+ * Print @rwstat to @sf for the device associated with @pd.
  */
 u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 			 const struct blkg_rwstat_sample *rwstat)
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2745bffcd5ee..c14b79a5b2b0 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -68,7 +68,7 @@
  * gets 300/(100+300) or 75% share, and A0 and A1 equally splits the rest,
  * 12.5% each.  The distribution mechanism only cares about these flattened
  * shares.  They're called hweights (hierarchical weights) and always add
- * upto 1 (WEIGHT_ONE).
+ * up to 1 (WEIGHT_ONE).
  *
  * A given cgroup's vtime runs slower in inverse proportion to its hweight.
  * For example, with 12.5% weight, A0's time runs 8 times slower (100/12.5)
@@ -833,7 +833,7 @@ static int ioc_autop_idx(struct ioc *ioc, struct gendisk *disk)
 }
 
 /*
- * Take the followings as input
+ * Take the following as input
  *
  *  @bps	maximum sequential throughput
  *  @seqiops	maximum sequential 4k iops
@@ -2154,7 +2154,7 @@ static void ioc_forgive_debts(struct ioc *ioc, u64 usage_us_sum, int nr_debtors,
 }
 
 /*
- * Check the active iocgs' state to avoid oversleeping and deactive
+ * Check the active iocgs' state to avoid oversleeping and deactivate
  * idle iocgs.
  *
  * Since waiters determine the sleep durations based on the vrate
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 2caa79a008ad..cd85809586a6 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -18,7 +18,7 @@
  * every configured node, and each configured node has it's own independent
  * queue depth.  This means that we only care about our latency targets at the
  * peer level.  Some group at the bottom of the hierarchy isn't going to affect
- * a group at the end of some other path if we're only configred at leaf level.
+ * a group at the end of some other path if we're only configured at leaf level.
  *
  * Consider the following
  *
@@ -34,7 +34,7 @@
  * throttle "unloved", but nobody else.
  *
  * In this example "fast", "slow", and "normal" will be the only groups actually
- * accounting their io latencies.  We have to walk up the heirarchy to the root
+ * accounting their io latencies.  We have to walk up the hierarchy to the root
  * on every submit and complete so we can do the appropriate stat recording and
  * adjust the queue depth of ourselves if needed.
  *
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 258a726071d1..6b87b0d34f34 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -401,7 +401,7 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 	 * there may either be too many discontiguous vectors for the max
 	 * segments limit, or contain virtual boundary gaps without having a
 	 * valid block sized split. A zero byte result means one of those
-	 * conditions occured.
+	 * conditions occurred.
 	 */
 	bytes = ALIGN_DOWN(bytes, bio_split_alignment(bio, lim));
 	if (!bytes)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a26a11c73ee3..a1c3cf269072 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2358,7 +2358,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 EXPORT_SYMBOL(blk_mq_run_hw_queue);
 
 /*
- * Return prefered queue to dispatch from (if any) for non-mq aware IO
+ * Return preferred queue to dispatch from (if any) for non-mq aware IO
  * scheduler.
  */
 static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(struct request_queue *q)
diff --git a/block/ioprio.c b/block/ioprio.c
index f0ee2798539c..69af8831a5b2 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -153,7 +153,7 @@ static int get_task_ioprio(struct task_struct *p)
  * Return raw IO priority value as set by userspace. We use this for
  * ioprio_get(pid, IOPRIO_WHO_PROCESS) so that we keep historical behavior and
  * also so that userspace can distinguish unset IO priority (which just gets
- * overriden based on task's nice value) from IO priority set to some value.
+ * overridden based on task's nice value) from IO priority set to some value.
  */
 static int get_task_raw_ioprio(struct task_struct *p)
 {
diff --git a/block/opal_proto.h b/block/opal_proto.h
index 7c24247aa186..3224452fa53d 100644
--- a/block/opal_proto.h
+++ b/block/opal_proto.h
@@ -237,7 +237,7 @@ enum opal_revertlsp {
 
 /* Packets derived from:
  * TCG_Storage_Architecture_Core_Spec_v2.01_r1.00
- * Secion: 3.2.3 ComPackets, Packets & Subpackets
+ * Section: 3.2.3 ComPackets, Packets & Subpackets
  */
 
 /* Comm Packet (header) for transmissions. */
@@ -449,7 +449,7 @@ struct d0_single_user_mode {
 };
 
 /*
- * Additonal Datastores feature
+ * Additional Datastores feature
  *
  * code == 0x0202
  */
diff --git a/block/partitions/sun.c b/block/partitions/sun.c
index 92c645fcd2e0..bf51227727d6 100644
--- a/block/partitions/sun.c
+++ b/block/partitions/sun.c
@@ -98,7 +98,7 @@ int sun_partition(struct parsed_partitions *state)
 
 	/*
 	 * So that old Linux-Sun partitions continue to work,
-	 * alow the VTOC to be used under the additional condition ...
+	 * allow the VTOC to be used under the additional condition ...
 	 */
 	use_vtoc = use_vtoc || !(label->vtoc.sanity ||
 				 label->vtoc.version || label->vtoc.nparts);
diff --git a/block/sed-opal.c b/block/sed-opal.c
index 79b290d9458a..4749a5e63051 100644
--- a/block/sed-opal.c
+++ b/block/sed-opal.c
@@ -2114,7 +2114,7 @@ static int set_lr_boolean_ace(struct opal_dev *dev,
 		/*
 		 * Add boolean operator in postfix only with
 		 * two or more authorities being added in ACE
-		 * expresion.
+		 * expression.
 		 * */
 		if (u > 0)
 			add_boolean_object_ref(&err, dev, OPAL_BOOLEAN_OR);
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 113bdb868c46..0893e2cd9e95 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2679,7 +2679,7 @@ static int mtip_hw_get_identify(struct driver_data *dd)
 		}
 	}
 
-	/* get write protect progess */
+	/* get write protect progress */
 	memset(&attr242, 0, sizeof(struct smart_attr));
 	if (mtip_get_smart_attr(dd->port, 242, &attr242))
 		dev_warn(&dd->pdev->dev,
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 0963c07b5845..064afcc9c8fb 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -20,7 +20,7 @@
 /* Offset of Subsystem Device ID in pci confoguration space */
 #define PCI_SUBSYSTEM_DEVICEID	0x2E
 
-/* offset of Device Control register in PCIe extended capabilites space */
+/* offset of Device Control register in PCIe extended capabilities space */
 #define PCIE_CONFIG_EXT_DEVICE_CONTROL_OFFSET	0x48
 
 /* check for erase mode support during secure erase */
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 6c5bec7da97c..b9daf0c11ef7 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2529,7 +2529,7 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 	 *
 	 * Wait until active references are dropped for avoiding use-after-free
 	 *
-	 * registered buffer may be unregistered in io_ring's release hander,
+	 * registered buffer may be unregistered in io_ring's release handler,
 	 * so have to wait by scheduling work function for avoiding the two
 	 * file release dependency.
 	 */
-- 
2.48.1

