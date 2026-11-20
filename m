Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173206;
	b=X3GWN8Ns7Mx0d9UW7tuUupNxa1wS9bMW7ZdXk7y9G3ppeOYGuBAgJ448+KwO2HpBj0KS
	 4mgxpTbqdzLEGjV9V0RIuBq2xajvSqGQ5JcJYJ3TQ3L8AlIiTXb8ppt8NpGIRsJ0I6P+P
	 26ygduFsAciN6bjDUlkZVlBY9kIYd7D3vHbh+t04cwHKdzeA4QNpLSjKQNS1nCbkF6eDl
	 43l+SqijHnRWnyEQlCkITcgFMs3YXYOyRJtJQH4llQya95IeXoy/0a1L6RQQ1TATy3q9D
	 xwaN+PNYr+untlF/McMbwhOipfw077dhoF7JQRmnwyjvR56O7MdWIpBula1zwKmJF1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173206;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sHV6R5VdqBenxKmkKRJz4RqQ7y3PyXHP6+IiNr5Dy9w=;
	b=KBG3v3w76oKpc0yqhpT0EJQIRM7+rUlRuAygM8i7+OP/Ia2fmxkvjInuVdtph0opYCCm
	 RVZpHuf9sUUIlZiBub2H/TE1p5QAI4NoAMTfBtEdsaTwrflWNfakC5iJtCjR6VSmYy81w
	 i7FkQTr7CtS48b0yssLnS+wmqEzVW0wTGPDXj14WDUaz0zqkOsqvoPMI65sEOYXTHmG7u
	 VASsCaYDXq/wT4zvCD9qhf3Rp5MSDfo9jkP13uuYDHdSKd78J9WSfk52RAjlhhfxCkaWz
	 LZpPy/LKdXxT166cM5+M3RWAzCaVfJu7q+tjO7FpAzYh1KBCL30Q7+IcHlA3zBOd2yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1B0606A320;
	Fri, 20 Nov 2026 11:13:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF1B0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5e0e0d3ae4d311f19a56ed5b684f684d-20261120
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:cf6426ae-48b5-445f-8f4e-eb3d17a30a6f,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.19,REQID:cf6426ae-48b5-445f-8f4e-eb3d17a30a6f,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:7db8b62,CLOUDID:eda1691aecdce999b70bdae6a163fe26,BulkI
	D:2611201913124DBAFVY1,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|850|86
	5|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5e0e0d3ae4d311f19a56ed5b684f684d-20261120
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1349181360; Fri, 20 Nov 2026 19:13:09 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	arnd@arndb.de,
	rppt@kernel.org,
	kmehltretter@gmail.com,
	dapeng1.mi@linux.intel.com,
	elver@google.com,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	jlayton@kernel.org,
	yukuai@fygo.io,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhe Liu <liuzhe1@kylinos.cn>
Subject: [PATCH v2] blk-throttle: add opt-in eager activation for cgroup v1 stats
Date: Fri, 20 Nov 2026 19:12:43 +0800
Message-Id: <20261120111243.952530-1-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a3166c51702b ("blk-throttle: delay initialization until
configuration") deferred throttle policy activation until an I/O limit is
configured. However, cgroup v1 accounting still lives in the throttle
policy and is performed after the activation check in blk_should_throtl().
Without an activated throttle policy, v1 statistics such as
blkio.throttle.io_service_bytes remain zero even while I/O is issued.

This forces cgroup v1 users to configure the throttle policy just
to obtain I/O statistics, even when no throttling is needed.

Add a read-only boot parameter, blk_throttle.eager_init, to activate
the throttle policy at disk initialization, regardless of the current
cgroup hierarchy. This allows cgroup v1 users to collect I/O statistics
without configuring throttle limits. Keep lazy activation as the
default to retain its memory and CPU savings.

Tested on next-20261119 in an x86-64 QEMU guest with
lockdep enabled. With no throttle limits configured, a 1 MiB O_DIRECT
write to /dev/ram0 produced these blkio.throttle.io_service_bytes
results:

Baseline:               0 bytes
Patched, default:       0 bytes
Patched, eager_init=1:  1048576 bytes

Fixes: a3166c51702b ("blk-throttle: delay initialization until configuration")
Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
Changes in v2:

Replace the v1 accounting rework with a boot parameter that activates
the existing throttle policy at disk allocation.

Document the parameter and its effect on cgroup v1 statistics.

 .../admin-guide/cgroup-v1/blkio-controller.rst        | 11 +++++++++++
 Documentation/admin-guide/kernel-parameters.txt       | 11 +++++++++++
 block/blk-cgroup.c                                    |  7 ++++++-
 block/blk-throttle.c                                  | 11 +++++++++++
 block/blk-throttle.h                                  |  2 ++
 5 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/blkio-controller.rst b/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
index dabb80cdd25a..6a9e4239e0fd 100644
--- a/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
+++ b/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
@@ -49,6 +49,17 @@ Run dd to read a file and see if rate is throttled to 1MB/s or not::
 
 Limits for writes can be put using blkio.throttle.write_bps_device file.
 
+I/O statistics without throttling
+---------------------------------
+
+By default, ``blkio.throttle.io_service_bytes``,
+``blkio.throttle.io_serviced`` and their recursive variants start counting
+I/O for a disk on the first write to a throttle limit file for that disk.
+
+To collect these statistics without setting upper I/O rate limits, add
+``blk_throttle.eager_init=1`` to the kernel command line. This activates
+the throttling policy as each disk is created.
+
 Hierarchical Cgroups
 ====================
 
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1e8317483844..47749c67671a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -646,6 +646,17 @@ Kernel parameters
 			embedded devices based on command line input.
 			See Documentation/block/cmdline-partition.rst
 
+	blk_throttle.eager_init=
+			[KNL] Format: <bool>
+			Requires CONFIG_BLK_DEV_THROTTLING=y.
+			Enable cgroup v1 throttle statistics without setting
+			upper I/O rate limits.
+			Activate blk-throttle when each disk is created.
+			Eager initialization uses additional memory for each disk.
+			The parameter is read-only at runtime.
+			Default: off (initialize on the first throttle limit
+			write).
+
 	boot_delay=	[KNL,EARLY]
 			Milliseconds to delay each printk during boot.
 			Only works if CONFIG_BOOT_PRINTK_DELAY is enabled,
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5b7a32293dc6..cf243a3ac32f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1490,6 +1490,7 @@ int blkcg_init_disk(struct gendisk *disk)
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *new_blkg, *blkg;
 	bool preloaded;
+	int ret;
 
 	/*
 	 * If the queue is shared across disk rebind (e.g., SCSI), the
@@ -1521,7 +1522,11 @@ int blkcg_init_disk(struct gendisk *disk)
 	if (preloaded)
 		radix_tree_preload_end();
 
-	return 0;
+	ret = blk_throtl_init_disk(disk);
+	if (ret)
+		blkg_destroy_all(disk);
+
+	return ret;
 
 err_unlock:
 	spin_unlock_irq(&q->queue_lock);
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c5e26551956a..527937aa552c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -26,6 +26,10 @@
 /* A workqueue to queue throttle related work */
 static struct workqueue_struct *kthrotld_workqueue;
 
+static bool eager_init;
+module_param(eager_init, bool, 0444);
+MODULE_PARM_DESC(eager_init, "Initialize blk-throttle eagerly for each disk");
+
 #define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
 
 struct throtl_data
@@ -1349,6 +1353,13 @@ static int blk_throtl_init(struct gendisk *disk)
 	return ret;
 }
 
+int blk_throtl_init_disk(struct gendisk *disk)
+{
+	if (!eager_init)
+		return 0;
+
+	return blk_throtl_init(disk);
+}
 
 static ssize_t tg_set_conf(struct kernfs_open_file *of,
 			   char *buf, size_t nbytes, loff_t off, bool is_u64)
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 1b5775771e07..4e275794138b 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -144,10 +144,12 @@ static inline struct throtl_grp *blkg_to_tg(struct blkcg_gq *blkg)
  * Internal throttling interface
  */
 #ifndef CONFIG_BLK_DEV_THROTTLING
+static inline int blk_throtl_init_disk(struct gendisk *disk) { return 0; }
 static inline void blk_throtl_exit(struct gendisk *disk) { }
 static inline bool blk_throtl_bio(struct bio *bio) { return false; }
 static inline void blk_throtl_cancel_bios(struct gendisk *disk) { }
 #else /* CONFIG_BLK_DEV_THROTTLING */
+int blk_throtl_init_disk(struct gendisk *disk);
 void blk_throtl_exit(struct gendisk *disk);
 bool __blk_throtl_bio(struct bio *bio);
 void blk_throtl_cancel_bios(struct gendisk *disk);

base-commit: 630059a5a632377b9b7b487baccde92b7ae1dd47
-- 
2.25.1

