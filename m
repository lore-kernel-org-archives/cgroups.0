Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792730068;
	b=dyet7SRtNaaHh5OkkNISnMzXCLO+jiA9R2sx9ts3jnzHGY1UU2g3IFNL/Opbbg5ZQ6mf
	 bqZrOVVTqh7TP/DW6cmpIle1fEnDYbmGW41ky0c2DldASa74CrM8S+26B2E4rh/9asfm5
	 6JRbwicfe+tPDrCJZX+fXmDBBWCMWD2FFC5qwIZTfauLI0Xh2mxc5SqEOkLMp+4VuVX0S
	 oYzfQ8FC15Bq56epzTUvt4c5/ZdaJTfW5Gz7n7HeFVSLuHDJIA5sKqKFdYq8IRN6Fi5XJ
	 /4mdMgokMNYRFt19qVIUjw9R7HTwjj64wGmqXOBgqI0Ahwl5Ozh1aQcqPRIO57dFrdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792730068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9rn/wpfGgzUAkTiGzAEvsGQw2UemSGaoO12StfjCKuk=;
	b=yCKS5/7BGJmYrrVke+gaEzfd8py8Rd3qTJmWESFUvhD95Rwgvoug4+stIUOO2gOjwq3M
	 u0drpuv4gCqe1B5oc7MeVtJpHOdv9ZVFh1gogtYmVQRHv1X5hzygjBfTq27vLjTIkGWxv
	 lAu09CTa+HM4A047JUv4kMFl4woFg75AHtMSosWQSukCyvBtSTQ497CL1MRRP4RfbKuNK
	 6cxA43PzEezvYTID/dMy4T2jDlgRlK58F30iKin/2qYWNT4ID73qJSWJEzO+rMN73FQWd
	 Ey8Y7q9mMIItLKkN7fTWpVMMOISD3d2qQYR1h8cenRMRwQJfA4vETKbQOMJudvdR/4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lhnAjzTn;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3284C606A321
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 04:34:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3284C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lhnAjzTn
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e9995ce866so3512305ad.0
        for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 21:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792730067; x=1793334867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9rn/wpfGgzUAkTiGzAEvsGQw2UemSGaoO12StfjCKuk=;
        b=lhnAjzTnAJcITTeFeT5zob7kwfs7g2Zp59dW3w/suSS0VGE+StlhujX5pOasZs9/Be
         AcYweOxhqNGmL9C4E8mZQLJaNEe5LSPOows5BodukgDllG821hKthf7mKeb43XKcek+M
         1N5Y6DyCaXLCkjf9CTh9jHYNSlaJMZUdPbxFm11BqLzS8nWSOM663qpVOlMEhOMGpGCC
         L1KSDCxzqpDcUq5IghzH/IRsAInAliNu33iq++C2nC5zvaI9sQO9oY/OteqwZlkfCYdq
         k087Xr+VBu2wmpS9Gw/dd+4PRJxbekxs8TBFrq3EjVj0nUFSSJi2aegwKcDoU2Fae/4F
         0Gug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792730067; x=1793334867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9rn/wpfGgzUAkTiGzAEvsGQw2UemSGaoO12StfjCKuk=;
        b=iz8Z+2jmqI8gkWWUwcW4y7keJZWIj+GVT0u/srQOpp2KqrLcwrlqka7hLmrPRgLCXk
         HEh44iSYk8+XbWYHvH8srUEZTFui5gbO5aM+ehhZEGWej7F0EkeSjvhoYE4xV9j53YXy
         Otlc9PdVgFTovfbSE9Kb9cSgaoahfj3WmhXEVmIRG8p6gnIDPf4oyTKs+MGSXyX4PCL0
         OyKmzo6LMcmm+SUT4wjuHSuxsCtl+9Abudd/jSs4ZFvGOi0XgFs5lsHTIYNulgR9fs8d
         xz4Hy3zRdPOtwABb5Hc5jJHE8gTzyu3Nvs6uGZLiOQ9aDykaxx+YqCN5e/4ncTeulmXJ
         XbZw==
X-Forwarded-Encrypted: i=1; AKwUvBydnfminUng0AdcXEtBKEogunqCGBbwJTKUc/qS72qtDtIYKrWX9qWA1e33Z+Vl2ctZWOMceIAz@vger.kernel.org
X-Gm-Message-State: AFq9FYLCrlMtDwK5zZ7cmzu6xVd5PZKyI39+j9nHBBb7lA4qEhXX6zyr
	0EiTdHMnjbhX3XFCHAGC/2r8lDHDP1KCi3J+6HAA2GJDH8O+4Zh7JfgN7DhIWYNSbek=
X-Gm-Gg: AYBFou2ltaR4rGwf01rjx4m9wevV5eBWqxI2q9Mzwgbd9gI/jdZ6YtqccKOqJNPHHdv
	U85VB+JRK3FAEChiohTzuTI6MC9dh2GnHUeYaxmMtF0X4OGhVgCo5jRlm0bTYsu/ak4EoFjrqK+
	9gLajC/qP/Av5UZjfbavyB3npdKE8kWVefmocA0e68l04EyjNTpxYSyOHLDIQc0MGSv1rQvK9M2
	7kibYCUdIWgT2pD8NqQM2k/XetuU3e88IScfgYrXLo4eWTnYuIs4AOO+iGEwCjjrZHP/ueOFz2x
	qyvKjB4jlGUpQfte3kARRhMfIgEC+QaTGx99xcCWlrc9ozfvzdUb2DSKryGOxmcuNw+2VDmsEIT
	WjKbSYbh5pWZq6fFKppvfl9tiClY9E1TiUJhy636uKSM3a3VArrAHBi5bbPjQzyoBhOch5lBw7L
	gy6JRRJ9QDIw462VUmyLJVEbV+dLTeMILk6IgPUEGHx+l+Nv21xoL+S09ANmoeVEVOZVqJ2JTG4
	gLyO6ClggAo5PgzZpJoW0EVy22YgapjweXa/jBaU/yoUoQwBA6wSqHmEh9HWprg36YiOvqQ2eSB
	7tRFzN+8gQRxd0buZzCEVgQ5HKMJtA071004oM8hHIIRRalGfcKlwpgSLAKnVJE=
X-Received: by 2002:a17:90b:580d:b0:3ac:e9d4:5530 with SMTP id 98e67ed59e1d1-3adce01a52fmr867823a91.24.1792730067216;
        Thu, 22 Oct 2026 21:34:27 -0700 (PDT)
Received: from yupeng-XPS-15-9520.. (c-73-169-192-12.hsd1.wa.comcast.net. [73.169.192.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adcb0a28f3sm1587374a91.3.2026.10.22.21.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 21:34:26 -0700 (PDT)
From: Peng Yu <yupeng0921@gmail.com>
To: Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Keith Busch <kbusch@kernel.org>,
	Tejun Heo <tj@kernel.org>,
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
Subject: [PATCH v9] nvmet: add cgroup_id to charge namespace I/O to a cgroup
Date: Thu, 22 Oct 2026 21:34:23 -0700
Message-ID: <20261023043423.176002-1-yupeng0921@gmail.com>
X-Mailer: git-send-email 2.43.0
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

The nvmet issues namespace IOs from kernel threads. So the io.max and
other cgroup controllers can't apply limits to the namespaces.
Considering this scenario: The LVM creates multiple logical volumes on
the same physical disk, the logical volumes are assigned to different
nvmet subsystems/namespaces. We want to stop a remote noisy user from
using all the disk iops via nvmet. So add a per namespace css. Each
namespace could be throttled separately.

The per namespace css is good enough for the io.max, but is not good
enough for the io.cost and io.latency. The io.cost and io.latency may
put a thread to sleep. If the thread is shared by different namespaces,
all of them will be impacted together. Submit the IOs via a workqueue to
avoid this impact.

Signed-off-by: Peng Yu <yupeng0921@gmail.com>
Assisted-by: Claude:claude-fable-5 [Claude Code]
Assisted-by: Claude:claude-opus-5-5 [Claude Code]
---
Changes since v8:
* Execute the I/O commands of a namespace with a cgroup_id, except
  Reservation commands, from a work item of that namespace on a
  workqueue of its own, so io.cost and io.latency don't put a shared
  transport context to sleep (Tejun).
* Associate the cgroup in that work item for each command, and in the
  file backend's Flush, DSM and Write Zeroes and the Zone Management
  Send work items, which now run on the namespace's workqueue too. The
  admin Write Protect flush is no longer charged.
* Don't throttle the queued commands of a namespace that is being
  disabled, and abort those of a queue that is being deleted.
* KernelVersion 7.5. Rebased on nvme-7.4 (54817c45e962).

Unthrottled cost, fio 4k randread on brd, cgroup_id set, io.max at
max, IOPS v8 -> v9 (median of 6 runs):
  loop, 1 queue, QD32        408k -> 326k
  tcp, 1 queue, QD32         141k -> 116k
  loop, 4 queues x 4 jobs    1.25M -> 610k
  tcp, 4 queues x 4 jobs     616k -> 576k (runs vary from 295k to 761k)

Tejun's v8 comment: https://lore.kernel.org/all/66f87058e7e811af340d920e654117eb@kernel.org/
v8: https://lore.kernel.org/all/20261002152821.410591-1-yupeng0921@gmail.com/
v7 (with test steps): https://lore.kernel.org/all/20260929232411.101087-1-yupeng0921@gmail.com/

 Documentation/ABI/stable/configfs-nvmet |  16 +++
 drivers/nvme/target/configfs.c          |  47 +++++++
 drivers/nvme/target/core.c              | 166 ++++++++++++++++++++++++
 drivers/nvme/target/io-cmd-file.c       |  19 ++-
 drivers/nvme/target/nvmet.h             |  54 ++++++++
 drivers/nvme/target/zns.c               |   6 +-
 6 files changed, 303 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/stable/configfs-nvmet b/Documentation/ABI/stable/configfs-nvmet
index 36b587404ee7..ea9c4083c6a0 100644
--- a/Documentation/ABI/stable/configfs-nvmet
+++ b/Documentation/ABI/stable/configfs-nvmet
@@ -314,6 +314,22 @@ Description:
 		attr_subsys_vendor_id: Shows or sets the PCI subsystem
 		vendor ID. Displayed in "0x%x" format.
 
+What:		/config/nvmet/subsystems/NAME/namespaces/NSID/cgroup_id
+Date:		October 2026
+KernelVersion:	7.5
+Contact:	Peng Yu <yupeng0921@gmail.com>
+Description:
+		Shows or sets the cgroup2 ID of the cgroup to charge this
+		namespace's I/O to. Writing 0 clears it. The I/O is
+		charged to the cgroup's effective io css: the cgroup
+		itself or its nearest ancestor with the io controller
+		enabled. The namespace must be disabled before
+		modification. Enabling the namespace fails if the cgroup
+		can't be found or if buffered_io is set. A cgroup that is
+		removed and created again gets a new ID.
+
+		Only available when CONFIG_BLK_CGROUP is enabled.
+
 What:		/config/nvmet/hosts/HOSTNQN/dhchap_key
 What:		/config/nvmet/hosts/HOSTNQN/dhchap_ctrl_key
 What:		/config/nvmet/hosts/HOSTNQN/dhchap_hash
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 2b085327320e..2652f4fffe11 100644
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
index 291d782ce544..94c400eef9d6 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -4,12 +4,15 @@
  * Copyright (c) 2015-2016 HGST, a Western Digital Company.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/cgroup.h>
 #include <linux/hex.h>
+#include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/rculist.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/scatterlist.h>
+#include <linux/sched/mm.h>
 
 #include <generated/utsrelease.h>
 
@@ -474,8 +477,164 @@ void nvmet_put_namespace(struct nvmet_ns *ns)
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
+	ns->blkcg_wq = alloc_workqueue("nvmet-blkcg-%u",
+			WQ_MEM_RECLAIM | WQ_UNBOUND, 0, ns->nsid);
+	if (!ns->blkcg_wq) {
+		cgroup_put(cgrp);
+		return -ENOMEM;
+	}
+
+	ns->cgrp = cgrp;
+	return 0;
+}
+
+static void nvmet_blkcg_ns_disable(struct nvmet_ns *ns)
+{
+	if (ns->cgrp) {
+		/*
+		 * No command is left, but a run of ->blkcg_work queued for a
+		 * command that an earlier run already executed may still be
+		 * pending: destroy_workqueue() waits for it.
+		 */
+		destroy_workqueue(ns->blkcg_wq);
+		ns->blkcg_wq = NULL;
+		cgroup_put(ns->cgrp);
+		ns->cgrp = NULL;
+	}
+}
+
+/*
+ * Charge the I/O that the current work item submits for @req to the
+ * effective io css of the namespace's cgroup, looked up for each command.
+ */
+bool nvmet_blkcg_begin(struct nvmet_req *req)
+{
+	struct nvmet_ns *ns = req->ns;
+	struct cgroup_subsys_state *css;
+
+	/* a disable waits for the command: don't throttle it any more */
+	if (!ns->cgrp || !READ_ONCE(ns->enabled))
+		return false;
+
+	css = cgroup_get_e_css(ns->cgrp, &io_cgrp_subsys);
+	kthread_associate_blkcg(css);
+	css_put(css);
+	return true;
+}
+
+void nvmet_blkcg_end(bool associated)
+{
+	if (associated)
+		kthread_associate_blkcg(NULL);
+}
+
+/*
+ * The io.cost and io.latency enforce their limits by putting the thread to
+ * sleep. A transport thread may be shared by multiple namespaces. In the
+ * tcp-nvmeof case, all namespaces in the same subsystem may share a
+ * thread. So we submit the IOs via the workqueue, thus the current thread
+ * won't be blocked.
+ */
+static void nvmet_blkcg_work(struct work_struct *work)
+{
+	struct nvmet_ns *ns = container_of(work, struct nvmet_ns, blkcg_work);
+	struct nvmet_req *req, *next;
+	struct llist_node *node;
+	unsigned int noio_flag;
+	bool associated;
+
+	node = llist_reverse_order(llist_del_all(&ns->blkcg_reqs));
+	/* reclaim must not wait for I/O queued behind this work item */
+	noio_flag = memalloc_noio_save();
+	llist_for_each_entry_safe(req, next, node, blkcg_entry) {
+		/* its queue is being deleted: abort it rather than throttle it */
+		if (unlikely(percpu_ref_is_dying(&req->sq->ref))) {
+			nvmet_req_complete(req, NVME_SC_ABORT_QUEUE);
+			continue;
+		}
+		associated = nvmet_blkcg_begin(req);
+		req->blkcg_execute(req);
+		nvmet_blkcg_end(associated);
+	}
+	memalloc_noio_restore(noio_flag);
+}
+
+static void nvmet_blkcg_queue_req(struct nvmet_req *req)
+{
+	struct nvmet_ns *ns = req->ns;
+
+	/*
+	 * The command can complete, and drop its namespace reference, as
+	 * soon as it is on the list.  Hold one across queue_work().
+	 */
+	percpu_ref_get(&ns->ref);
+	llist_add(&req->blkcg_entry, &ns->blkcg_reqs);
+	queue_work(ns->blkcg_wq, &ns->blkcg_work);
+	nvmet_put_namespace(ns);
+}
+
+static void nvmet_blkcg_init_req(struct nvmet_req *req)
+{
+	if (!req->ns->cgrp)
+		return;
+
+	req->blkcg_execute = req->execute;
+	req->execute = nvmet_blkcg_queue_req;
+}
+
+static void nvmet_blkcg_ns_init(struct nvmet_ns *ns)
+{
+	init_llist_head(&ns->blkcg_reqs);
+	INIT_WORK(&ns->blkcg_work, nvmet_blkcg_work);
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
+
+static inline void nvmet_blkcg_init_req(struct nvmet_req *req)
+{
+}
+
+static inline void nvmet_blkcg_ns_init(struct nvmet_ns *ns)
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
@@ -602,6 +761,10 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 	if (ret)
 		goto out_unlock;
 
+	ret = nvmet_blkcg_ns_enable(ns);
+	if (ret)
+		goto out_dev_disable;
+
 	ret = nvmet_p2pmem_ns_enable(ns);
 	if (ret)
 		goto out_dev_disable;
@@ -716,6 +879,7 @@ struct nvmet_ns *nvmet_ns_alloc(struct nvmet_subsys *subsys, u32 nsid)
 		goto out_unlock;
 
 	init_completion(&ns->disable_done);
+	nvmet_blkcg_ns_init(ns);
 
 	ns->nsid = nsid;
 	ns->subsys = subsys;
@@ -1157,6 +1321,8 @@ static u16 nvmet_parse_io_cmd(struct nvmet_req *req)
 	if (ret)
 		return ret;
 
+	nvmet_blkcg_init_req(req);
+
 	if (req->ns->pr.enable) {
 		ret = nvmet_pr_check_cmd_access(req);
 		if (ret)
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 695963dd932e..673df713c954 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -257,8 +257,13 @@ u16 nvmet_file_flush(struct nvmet_req *req)
 static void nvmet_file_flush_work(struct work_struct *w)
 {
 	struct nvmet_req *req = container_of(w, struct nvmet_req, f.work);
+	bool associated;
+	u16 status;
 
-	nvmet_req_complete(req, nvmet_file_flush(req));
+	associated = nvmet_blkcg_begin(req);
+	status = nvmet_file_flush(req);
+	nvmet_blkcg_end(associated);
+	nvmet_req_complete(req, status);
 }
 
 static void nvmet_file_execute_flush(struct nvmet_req *req)
@@ -266,7 +271,7 @@ static void nvmet_file_execute_flush(struct nvmet_req *req)
 	if (!nvmet_check_transfer_len(req, 0))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_flush_work);
-	queue_work(nvmet_wq, &req->f.work);
+	nvmet_req_queue_work(req, nvmet_wq, &req->f.work);
 }
 
 static void nvmet_file_execute_discard(struct nvmet_req *req)
@@ -274,10 +279,12 @@ static void nvmet_file_execute_discard(struct nvmet_req *req)
 	int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 	struct nvme_dsm_range range;
 	loff_t offset, len;
+	bool associated;
 	u16 status = 0;
 	int ret;
 	int i;
 
+	associated = nvmet_blkcg_begin(req);
 	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
 		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
 					sizeof(range));
@@ -300,6 +307,7 @@ static void nvmet_file_execute_discard(struct nvmet_req *req)
 			break;
 		}
 	}
+	nvmet_blkcg_end(associated);
 
 	nvmet_req_complete(req, status);
 }
@@ -326,7 +334,7 @@ static void nvmet_file_execute_dsm(struct nvmet_req *req)
 	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_dsm_work);
-	queue_work(nvmet_wq, &req->f.work);
+	nvmet_req_queue_work(req, nvmet_wq, &req->f.work);
 }
 
 static void nvmet_file_write_zeroes_work(struct work_struct *w)
@@ -336,6 +344,7 @@ static void nvmet_file_write_zeroes_work(struct work_struct *w)
 	int mode = FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE;
 	loff_t offset;
 	loff_t len;
+	bool associated;
 	int ret;
 
 	offset = le64_to_cpu(write_zeroes->slba) << req->ns->blksize_shift;
@@ -347,7 +356,9 @@ static void nvmet_file_write_zeroes_work(struct work_struct *w)
 		return;
 	}
 
+	associated = nvmet_blkcg_begin(req);
 	ret = vfs_fallocate(req->ns->file, mode, offset, len);
+	nvmet_blkcg_end(associated);
 	nvmet_req_complete(req, ret < 0 ? errno_to_nvme_status(req, ret) : 0);
 }
 
@@ -356,7 +367,7 @@ static void nvmet_file_execute_write_zeroes(struct nvmet_req *req)
 	if (!nvmet_check_transfer_len(req, 0))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_write_zeroes_work);
-	queue_work(nvmet_wq, &req->f.work);
+	nvmet_req_queue_work(req, nvmet_wq, &req->f.work);
 }
 
 u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index e315f1c24e73..2c026101d0c0 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -21,6 +21,7 @@
 #include <linux/radix-tree.h>
 #include <linux/t10-pi.h>
 #include <linux/kfifo.h>
+#include <linux/llist.h>
 
 #define NVMET_DEFAULT_VS		NVME_VS(2, 1, 0)
 
@@ -115,6 +116,24 @@ struct nvmet_ns {
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
+	/*
+	 * The I/O commands of a namespace with a cgroup, except Reservation
+	 * commands, are executed from ->blkcg_work on ->blkcg_wq, so the
+	 * cgroup's throttling doesn't put a transport context to sleep.
+	 */
+	struct workqueue_struct	*blkcg_wq;
+	struct llist_head	blkcg_reqs;
+	struct work_struct	blkcg_work;
+#endif
+
 	struct config_group	device_group;
 	struct config_group	group;
 
@@ -507,6 +526,11 @@ struct nvmet_req {
 
 	void (*execute)(struct nvmet_req *req);
 	const struct nvmet_fabrics_ops *ops;
+#ifdef CONFIG_BLK_CGROUP
+	/* the backend's ->execute, called from ns->blkcg_work */
+	void (*blkcg_execute)(struct nvmet_req *req);
+	struct llist_node	blkcg_entry;
+#endif
 
 	struct pci_dev		*p2p_dev;
 	struct device		*p2p_client;
@@ -746,6 +770,36 @@ void nvmet_bdev_execute_zone_mgmt_recv(struct nvmet_req *req);
 void nvmet_bdev_execute_zone_mgmt_send(struct nvmet_req *req);
 void nvmet_bdev_execute_zone_append(struct nvmet_req *req);
 
+#ifdef CONFIG_BLK_CGROUP
+bool nvmet_blkcg_begin(struct nvmet_req *req);
+void nvmet_blkcg_end(bool associated);
+#else
+static inline bool nvmet_blkcg_begin(struct nvmet_req *req)
+{
+	return false;
+}
+
+static inline void nvmet_blkcg_end(bool associated)
+{
+}
+#endif /* CONFIG_BLK_CGROUP */
+
+/*
+ * The backends' work items of a namespace with a cgroup may sleep in the
+ * cgroup's throttling, so queue them on the namespace's own workqueue,
+ * where they can't use up the max_active or the rescuer of a workqueue
+ * that other namespaces share.
+ */
+static inline void nvmet_req_queue_work(struct nvmet_req *req,
+		struct workqueue_struct *wq, struct work_struct *work)
+{
+#ifdef CONFIG_BLK_CGROUP
+	if (req->ns->blkcg_wq)
+		wq = req->ns->blkcg_wq;
+#endif
+	queue_work(wq, work);
+}
+
 static inline u32 nvmet_rw_data_len(struct nvmet_req *req)
 {
 	return ((u32)le16_to_cpu(req->cmd->rw.length) + 1) <<
diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 78d82b6ff121..33faf32a1a3b 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -490,8 +490,11 @@ static void nvmet_bdev_zmgmt_send_work(struct work_struct *w)
 	struct block_device *bdev = req->ns->bdev;
 	sector_t zone_sectors = bdev_zone_sectors(bdev);
 	u16 status = NVME_SC_SUCCESS;
+	bool associated;
 	int ret;
 
+	associated = nvmet_blkcg_begin(req);
+
 	if (op == REQ_OP_LAST) {
 		req->error_loc = offsetof(struct nvme_zone_mgmt_send_cmd, zsa);
 		status = NVME_SC_ZONE_INVALID_TRANSITION | NVME_STATUS_DNR;
@@ -521,13 +524,14 @@ static void nvmet_bdev_zmgmt_send_work(struct work_struct *w)
 		status = blkdev_zone_mgmt_errno_to_nvme_status(ret);
 
 out:
+	nvmet_blkcg_end(associated);
 	nvmet_req_complete(req, status);
 }
 
 void nvmet_bdev_execute_zone_mgmt_send(struct nvmet_req *req)
 {
 	INIT_WORK(&req->z.zmgmt_work, nvmet_bdev_zmgmt_send_work);
-	queue_work(zbd_wq, &req->z.zmgmt_work);
+	nvmet_req_queue_work(req, zbd_wq, &req->z.zmgmt_work);
 }
 
 static void nvmet_bdev_zone_append_bio_done(struct bio *bio)

base-commit: 54817c45e96249d0390b9f6e534039b58cada5f5
-- 
2.53.0

