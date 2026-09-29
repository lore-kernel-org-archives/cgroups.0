Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E0D4E8E17
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 23:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724263; cv=none; b=bZEyr/cMWU3IblKQFC320lmEOYiokP+JnVmx4m4Mj+Z6w1qHQ2o8gBNLv7r9YSN6tNqIuyaOX2qpV4llLGPTtHFd7MnDSDx0HAKfdoQuLYVoMiuHXdLhh/tbd3pm7GK1aBWGGqRy7rxUHtubwi53zvp0NlDlO+3Yr2se+ABRTDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724263; c=relaxed/simple;
	bh=tUivgThLYPjGZKrbeYcdGqUUWS1PxgBLVBhJShD2+dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXfVP91z0d6skqBAUZe1YEKNUDe3dnVGtwF9necWI7tSXDj8JiYLpfnrMWQRmlaGbe6e1zoTPR5VLC8yTvxgCcSDVycYy8S9edH80npP9lnRkUKn3z6FfZPUZOlEbu4ScU9iNHQZXpgyaoHM3jsE+0ElrBugxbwBqR3g24OR2T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ot7MU0WN; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ot7MU0WN"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-3a49573b8bdso1175408a91.2
        for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 16:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790724260; x=1791329060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wmkdOPAfN3ztZ7PxlqvaeeQ4HbSDCKua7ym3C/IbZLY=;
        b=Ot7MU0WNudTChJqwiAu5kQJalo753HhZvaadwXIhm0aRWZWEjKTAJnICwrMinZ6eWS
         TKYG4bXwN6t+dF4jyXz8QBDiqfjwcH/XitL/fODtlzmnpgQ9/TXMP64rgcNySu4stpw7
         QhZpqoho6qJLCSmDJciqrEas2C02TDYvKjWvajHMyfcvDMPltDZvOG0k3BIbcOcDEPmM
         61DPMmq57vWLiOPxe33mZgNCcqZB6Wo1UdD7d20SoQcTvB0GOh0f0kFe3fEz3zY6Df4B
         ePTagjnDW3j92t1u0r3o16rKvBZ24mMEaWjComt9Kr5asBYdsFRC/qEa72CXYnCWUvxQ
         E7jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790724260; x=1791329060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wmkdOPAfN3ztZ7PxlqvaeeQ4HbSDCKua7ym3C/IbZLY=;
        b=JSp+YyWadbWipz1evJoo9GNqY6e+j/2R1Uvf/VkF5oVOk29JXwTogkPYMgzaI62fMt
         8zffOsbZhA8ynd3hYeQg9oXWF/ejk2YSfIfZvVXJYuAGIOmd5Y5kYoLiPkxPg41tSdXB
         5eg+PTWmYrbA6ic7JvrTsJVrKAWrELTbe6j8Lk2EJTuXFAGTORycWgwW/keiCkmGiEKg
         Ey9ChG9hxrTYXCXFAbGUcOBPUD0EWzW4B12n24bOwwvZEfsmZat7FZEfDfPYcK0R1T8c
         tY2hDpBq9yhMhfBocPrrsZIsixhJ2jXH1GPtWgMZrDdWWiY72E6geBt5i3wmRLtWTf/W
         R7WA==
X-Forwarded-Encrypted: i=1; AKwUvBzcIFge4rShhl80nsYYAgitoaPdOtlG4yXxGn9EU5zZ1EJ/fut79RKSzhUhPnZ2o93zo8nw30RL@vger.kernel.org
X-Gm-Message-State: AFq9FYLeuqVGVYAF+vDpVUmI9CYA9IUdUOAQEKwGXSF5S1GJkBiojXk3
	tgUdql8Y4GF4nl00lgq1epQZ9yf/gjXQA0piYf/FgnTf5KOkodxbGMEJ
X-Gm-Gg: AYBFou3n2cJKt4BASoj7zLu2pT84Uk41xuShR5Lu6i2VBPihtAWtkopF9CKF3xT8QYX
	cySbALX17A5fK3SF8U3szHeHzjd054tebQBXKrGW7xj8VhoB3OVviokwZuSboYudMuNXnukmW6b
	G8661nBNkGn7puC3ffbC83Dpu99QIgSqnybIjOKgcwcaCrz/4tC6Y1pRprwmx+hFKZdfpP6ra8o
	7xKEV/HpGwiaEFhEowno5i/H+6dFJNI5FuBuKe5ErrBSSF1VtfUrAU6T30UPDgxhJKfQUH7lJp2
	5cTfTwXKXDHxtBlzyqPc1uk8Fws0nVwpH0hqsxL1JMp3MpTyxlblNjsFoV77T/8eQxUSaKJvp9W
	JdHTX5L0QOMIadCGJRET+vWHE+IEtwW41l+Z0X+P+EC+XyVv7IXSJPGAKWLAnXh4JlPrdqhfZWj
	9nkHqYgavd2zzm4wtPRU4mHC7WWX/EvsW81P6mBsJWx8qEbLtpf8Uab/Stby35FZmpE5xCcxzY4
	e5oL0diG9pLEE8V6lvmCwPcLCXzqCxuSFA7L7qVfdWMTEYCzfGOFuCcBu4NRu+yuwvMVPf1/p5Q
	hdA=
X-Received: by 2002:a17:90b:538b:b0:3a0:345a:3646 with SMTP id 98e67ed59e1d1-3a4bfe98dcamr677153a91.45.1790724260338;
        Tue, 29 Sep 2026 16:24:20 -0700 (PDT)
Received: from yupeng-XPS-15-9520.. (c-73-169-192-12.hsd1.wa.comcast.net. [73.169.192.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4ca78102csm138700a91.4.2026.09.29.16.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 16:24:19 -0700 (PDT)
From: Peng Yu <yupeng0921@gmail.com>
To: Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Maurizio Lombardi <mlombard@arkamax.eu>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Peng Yu <yupeng0921@gmail.com>
Subject: [PATCH v7 2/2] nvmet: add cgroup_id to charge namespace I/O to a cgroup
Date: Tue, 29 Sep 2026 16:24:11 -0700
Message-ID: <20260929232411.101087-3-yupeng0921@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929232411.101087-1-yupeng0921@gmail.com>
References: <20260929232411.101087-1-yupeng0921@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implementation:
* Add a `cgroup_id` attribute under the nvmet namespace folder, e.g.:
  /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:bdev/namespaces/1/cgroup_id
* We can write a cgroup id to it, then that cgroup will control
  the IOs used by the namespace.
* Write 0 to clear it.
* The cgroup_id could be modified when the namespace is disabled.
* Support both block device backed namespaces and file backed namespaces.
* Only the direct io scenario is supported, enabling a namespace that
  has both cgroup_id and buffered_io set fails with -EINVAL.

Change since v2:
* Fix the in ns->cgroup_path error free issue nvmet_ns_cgroup_path_store.
* Use nvmet_blkcg_begin/end in nvmet_bdev_zmgmt_send_work.

Change since v3:
* Use cgroup_id instead of cgroup_path.

Change since v6:
* Use cgroup_get_e_css() and css_put() in nvmet_blkcg_set_bio() instead
  of cgroup_e_css() under rcu_read_lock(), so queue_lock isn't nested
  under RCU when a blkg is created.
* Drop the patch that exported cgroup_e_css().

Signed-off-by: Peng Yu <yupeng0921@gmail.com>
Assisted-by: Claude:claude-fable-5 [Claude Code]
Assisted-by: Claude:claude-opus-5-5 [Claude Code]
---
 drivers/nvme/target/configfs.c    | 47 +++++++++++++++++++++++++
 drivers/nvme/target/core.c        | 54 ++++++++++++++++++++++++++++
 drivers/nvme/target/io-cmd-bdev.c | 18 +++++++++-
 drivers/nvme/target/io-cmd-file.c | 21 +++++++++--
 drivers/nvme/target/nvmet.h       | 58 +++++++++++++++++++++++++++++++
 drivers/nvme/target/zns.c         |  5 +++
 6 files changed, 200 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 6286e38436dd..cef832303d72 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -561,6 +561,50 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 
 CONFIGFS_ATTR(nvmet_ns_, device_path);
 
+#ifdef CONFIG_BLK_CGROUP
+static ssize_t nvmet_ns_cgroup_id_show(struct config_item *item, char *page)
+{
+	struct nvmet_ns *ns = to_nvmet_ns(item);
+	struct nvmet_subsys *subsys = ns->subsys;
+	ssize_t ret;
+
+	mutex_lock(&subsys->lock);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", ns->cgroup_id);
+	mutex_unlock(&subsys->lock);
+	return ret;
+}
+
+static ssize_t nvmet_ns_cgroup_id_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_ns *ns = to_nvmet_ns(item);
+	struct nvmet_subsys *subsys = ns->subsys;
+	u64 cgroup_id;
+	int ret;
+
+	ret = kstrtou64(page, 0, &cgroup_id);
+	if (ret)
+		return ret;
+
+	mutex_lock(&subsys->lock);
+
+	if (ns->enabled) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	/* Writing 0 clears the association. */
+	ns->cgroup_id = cgroup_id;
+	ret = count;
+
+out_unlock:
+	mutex_unlock(&subsys->lock);
+	return ret;
+}
+
+CONFIGFS_ATTR(nvmet_ns_, cgroup_id);
+#endif /* CONFIG_BLK_CGROUP */
+
 #ifdef CONFIG_PCI_P2PDMA
 static ssize_t nvmet_ns_p2pmem_show(struct config_item *item, char *page)
 {
@@ -833,6 +877,9 @@ static struct configfs_attribute *nvmet_ns_attrs[] = {
 	&nvmet_ns_attr_buffered_io,
 	&nvmet_ns_attr_revalidate_size,
 	&nvmet_ns_attr_resv_enable,
+#ifdef CONFIG_BLK_CGROUP
+	&nvmet_ns_attr_cgroup_id,
+#endif
 #ifdef CONFIG_PCI_P2PDMA
 	&nvmet_ns_attr_p2pmem,
 #endif
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 43871a8f56ca..6d9d55eb11eb 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2015-2016 HGST, a Western Digital Company.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/cgroup.h>
 #include <linux/hex.h>
 #include <linux/module.h>
 #include <linux/random.h>
@@ -474,8 +475,57 @@ void nvmet_put_namespace(struct nvmet_ns *ns)
 	percpu_ref_put(&ns->ref);
 }
 
+#ifdef CONFIG_BLK_CGROUP
+static int nvmet_blkcg_ns_enable(struct nvmet_ns *ns)
+{
+	struct cgroup *cgrp;
+
+	if (!ns->cgroup_id)
+		return 0;
+
+	/*
+	 * Buffered writes will be handled by a separate thread,
+	 * these IOs have no namespace/cgroup information at that time,
+	 * so we don't support buffered io.
+	 */
+	if (ns->buffered_io) {
+		pr_err("cgroup_id is not supported with buffered_io: %s\n",
+		       ns->device_path);
+		return -EINVAL;
+	}
+
+	cgrp = cgroup_get_from_id(ns->cgroup_id);
+	if (IS_ERR(cgrp)) {
+		pr_err("failed to resolve cgroup id %llu: %ld\n",
+		       ns->cgroup_id, PTR_ERR(cgrp));
+		return PTR_ERR(cgrp);
+	}
+
+	ns->cgrp = cgrp;
+	return 0;
+}
+
+static void nvmet_blkcg_ns_disable(struct nvmet_ns *ns)
+{
+	if (ns->cgrp) {
+		cgroup_put(ns->cgrp);
+		ns->cgrp = NULL;
+	}
+}
+#else
+static inline int nvmet_blkcg_ns_enable(struct nvmet_ns *ns)
+{
+	return 0;
+}
+
+static inline void nvmet_blkcg_ns_disable(struct nvmet_ns *ns)
+{
+}
+#endif /* CONFIG_BLK_CGROUP */
+
 static void nvmet_ns_dev_disable(struct nvmet_ns *ns)
 {
+	nvmet_blkcg_ns_disable(ns);
 	nvmet_bdev_ns_disable(ns);
 	nvmet_file_ns_disable(ns);
 }
@@ -602,6 +652,10 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 	if (ret)
 		goto out_unlock;
 
+	ret = nvmet_blkcg_ns_enable(ns);
+	if (ret)
+		goto out_dev_disable;
+
 	ret = nvmet_p2pmem_ns_enable(ns);
 	if (ret)
 		goto out_dev_disable;
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index f2d9e8901df4..0014e5ef2853 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -297,6 +297,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 		bio = bio_alloc(req->ns->bdev, bio_max_segs(sg_cnt), opf,
 				GFP_KERNEL);
 	}
+	nvmet_blkcg_set_bio(req->ns, bio);
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_private = req;
 	bio->bi_end_io = nvmet_bio_done;
@@ -322,6 +323,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 
 			bio = bio_alloc(req->ns->bdev, bio_max_segs(sg_cnt),
 					opf, GFP_KERNEL);
+			nvmet_blkcg_set_bio(req->ns, bio);
 			bio->bi_iter.bi_sector = sector;
 
 			bio_chain(bio, prev);
@@ -358,6 +360,7 @@ static void nvmet_bdev_execute_flush(struct nvmet_req *req)
 
 	bio_init(bio, req->ns->bdev, req->inline_bvec,
 		 ARRAY_SIZE(req->inline_bvec), REQ_OP_WRITE | REQ_PREFLUSH);
+	nvmet_blkcg_set_bio(req->ns, bio);
 	bio->bi_private = req;
 	bio->bi_end_io = nvmet_bio_done;
 
@@ -366,10 +369,16 @@ static void nvmet_bdev_execute_flush(struct nvmet_req *req)
 
 u16 nvmet_bdev_flush(struct nvmet_req *req)
 {
+	bool associated;
+	int ret;
+
 	if (!bdev_write_cache(req->ns->bdev))
 		return 0;
 
-	if (blkdev_issue_flush(req->ns->bdev))
+	associated = nvmet_blkcg_begin(req->ns);
+	ret = blkdev_issue_flush(req->ns->bdev);
+	nvmet_blkcg_end(associated);
+	if (ret)
 		return NVME_SC_INTERNAL | NVME_STATUS_DNR;
 	return 0;
 }
@@ -380,9 +389,11 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 	struct nvme_dsm_range range;
 	struct bio *bio = NULL;
 	sector_t nr_sects;
+	bool associated;
 	int i;
 	u16 status = NVME_SC_SUCCESS;
 
+	associated = nvmet_blkcg_begin(ns);
 	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
 		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
 				sizeof(range));
@@ -394,6 +405,7 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 				nvmet_lba_to_sect(ns, range.slba), nr_sects,
 				GFP_KERNEL, &bio);
 	}
+	nvmet_blkcg_end(associated);
 
 	if (bio) {
 		bio->bi_private = req;
@@ -431,6 +443,7 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
 	struct bio *bio = NULL;
 	sector_t sector;
 	sector_t nr_sector;
+	bool associated;
 	int ret;
 
 	if (!nvmet_check_transfer_len(req, 0))
@@ -440,8 +453,11 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
 	nr_sector = (((sector_t)le16_to_cpu(write_zeroes->length) + 1) <<
 		(req->ns->blksize_shift - 9));
 
+	associated = nvmet_blkcg_begin(req->ns);
 	ret = __blkdev_issue_zeroout(req->ns->bdev, sector, nr_sector,
 			GFP_KERNEL, &bio, 0);
+	nvmet_blkcg_end(associated);
+
 	if (bio) {
 		bio->bi_private = req;
 		bio->bi_end_io = nvmet_bio_done;
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 0b22d183f927..570e65259ad8 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -79,6 +79,8 @@ static ssize_t nvmet_file_submit_bvec(struct nvmet_req *req, loff_t pos,
 	struct kiocb *iocb = &req->f.iocb;
 	ssize_t (*call_iter)(struct kiocb *iocb, struct iov_iter *iter);
 	struct iov_iter iter;
+	bool associated;
+	ssize_t ret;
 	int rw;
 
 	if (req->cmd->rw.opcode == nvme_cmd_write) {
@@ -97,7 +99,10 @@ static ssize_t nvmet_file_submit_bvec(struct nvmet_req *req, loff_t pos,
 	iocb->ki_filp = req->ns->file;
 	iocb->ki_flags = ki_flags | iocb->ki_filp->f_iocb_flags;
 
-	return call_iter(iocb, &iter);
+	associated = nvmet_blkcg_begin(req->ns);
+	ret = call_iter(iocb, &iter);
+	nvmet_blkcg_end(associated);
+	return ret;
 }
 
 static void nvmet_file_io_done(struct kiocb *iocb, long ret)
@@ -251,7 +256,13 @@ static void nvmet_file_execute_rw(struct nvmet_req *req)
 
 u16 nvmet_file_flush(struct nvmet_req *req)
 {
-	return errno_to_nvme_status(req, vfs_fsync(req->ns->file, 1));
+	bool associated;
+	int ret;
+
+	associated = nvmet_blkcg_begin(req->ns);
+	ret = vfs_fsync(req->ns->file, 1);
+	nvmet_blkcg_end(associated);
+	return errno_to_nvme_status(req, ret);
 }
 
 static void nvmet_file_flush_work(struct work_struct *w)
@@ -274,10 +285,12 @@ static void nvmet_file_execute_discard(struct nvmet_req *req)
 	int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 	struct nvme_dsm_range range;
 	loff_t offset, len;
+	bool associated;
 	u16 status = 0;
 	int ret;
 	int i;
 
+	associated = nvmet_blkcg_begin(req->ns);
 	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
 		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
 					sizeof(range));
@@ -300,6 +313,7 @@ static void nvmet_file_execute_discard(struct nvmet_req *req)
 			break;
 		}
 	}
+	nvmet_blkcg_end(associated);
 
 	nvmet_req_complete(req, status);
 }
@@ -336,6 +350,7 @@ static void nvmet_file_write_zeroes_work(struct work_struct *w)
 	int mode = FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE;
 	loff_t offset;
 	loff_t len;
+	bool associated;
 	int ret;
 
 	offset = le64_to_cpu(write_zeroes->slba) << req->ns->blksize_shift;
@@ -347,7 +362,9 @@ static void nvmet_file_write_zeroes_work(struct work_struct *w)
 		return;
 	}
 
+	associated = nvmet_blkcg_begin(req->ns);
 	ret = vfs_fallocate(req->ns->file, mode, offset, len);
+	nvmet_blkcg_end(associated);
 	nvmet_req_complete(req, ret < 0 ? errno_to_nvme_status(req, ret) : 0);
 }
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index dbda55895f4f..d5dfca18f5fa 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -21,6 +21,8 @@
 #include <linux/radix-tree.h>
 #include <linux/t10-pi.h>
 #include <linux/kfifo.h>
+#include <linux/kthread.h>
+#include <linux/cgroup.h>
 
 #define NVMET_DEFAULT_VS		NVME_VS(2, 1, 0)
 
@@ -115,6 +117,16 @@ struct nvmet_ns {
 	struct nvmet_subsys	*subsys;
 	const char		*device_path;
 
+#ifdef CONFIG_BLK_CGROUP
+	u64			cgroup_id;
+	/*
+	 * Resolved from ->cgroup_id when the namespace is enabled and
+	 * released when it is disabled, so it has the same lifetime and
+	 * visibility rules as ->bdev and ->file.
+	 */
+	struct cgroup		*cgrp;
+#endif
+
 	struct config_group	device_group;
 	struct config_group	group;
 
@@ -732,6 +744,52 @@ void nvmet_bdev_execute_zone_mgmt_recv(struct nvmet_req *req);
 void nvmet_bdev_execute_zone_mgmt_send(struct nvmet_req *req);
 void nvmet_bdev_execute_zone_append(struct nvmet_req *req);
 
+#ifdef CONFIG_BLK_CGROUP
+static inline void nvmet_blkcg_set_bio(struct nvmet_ns *ns, struct bio *bio)
+{
+	struct cgroup_subsys_state *css;
+
+	if (!ns->cgrp)
+		return;
+
+	css = cgroup_get_e_css(ns->cgrp, &io_cgrp_subsys);
+	bio_associate_blkg_from_css(bio, css);
+	css_put(css);
+}
+
+static inline bool nvmet_blkcg_begin(struct nvmet_ns *ns)
+{
+	struct cgroup_subsys_state *css;
+
+	if (!ns->cgrp || !in_task() || !(current->flags & PF_KTHREAD))
+		return false;
+
+	css = cgroup_get_e_css(ns->cgrp, &io_cgrp_subsys);
+	kthread_associate_blkcg(css);
+	css_put(css);
+	return true;
+}
+
+static inline void nvmet_blkcg_end(bool associated)
+{
+	if (associated)
+		kthread_associate_blkcg(NULL);
+}
+#else
+static inline void nvmet_blkcg_set_bio(struct nvmet_ns *ns, struct bio *bio)
+{
+}
+
+static inline bool nvmet_blkcg_begin(struct nvmet_ns *ns)
+{
+	return false;
+}
+
+static inline void nvmet_blkcg_end(bool associated)
+{
+}
+#endif /* CONFIG_BLK_CGROUP */
+
 static inline u32 nvmet_rw_data_len(struct nvmet_req *req)
 {
 	return ((u32)le16_to_cpu(req->cmd->rw.length) + 1) <<
diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 23a17c02abee..a9836d44f5e6 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -480,8 +480,11 @@ static void nvmet_bdev_zmgmt_send_work(struct work_struct *w)
 	struct block_device *bdev = req->ns->bdev;
 	sector_t zone_sectors = bdev_zone_sectors(bdev);
 	u16 status = NVME_SC_SUCCESS;
+	bool associated;
 	int ret;
 
+	associated = nvmet_blkcg_begin(req->ns);
+
 	if (op == REQ_OP_LAST) {
 		req->error_loc = offsetof(struct nvme_zone_mgmt_send_cmd, zsa);
 		status = NVME_SC_ZONE_INVALID_TRANSITION | NVME_STATUS_DNR;
@@ -511,6 +514,7 @@ static void nvmet_bdev_zmgmt_send_work(struct work_struct *w)
 		status = blkdev_zone_mgmt_errno_to_nvme_status(ret);
 
 out:
+	nvmet_blkcg_end(associated);
 	nvmet_req_complete(req, status);
 }
 
@@ -580,6 +584,7 @@ void nvmet_bdev_execute_zone_append(struct nvmet_req *req)
 		bio = bio_alloc(req->ns->bdev, req->sg_cnt, opf, GFP_KERNEL);
 	}
 
+	nvmet_blkcg_set_bio(req->ns, bio);
 	bio->bi_end_io = nvmet_bdev_zone_append_bio_done;
 	bio->bi_iter.bi_sector = sect;
 	bio->bi_private = req;
-- 
2.53.0

