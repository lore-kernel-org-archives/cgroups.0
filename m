Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793287868;
	b=Nrv80jadA/3OVhIGERgx/by1eT0U5R0Sg49mZWP1KDwDb4wuztJhIsKsbOEKRnVWMRjM
	 XodnMc8MlAry1LvavFSYNhW5FZm483ZtIpG9NyZmKg++qmpjhZVZNxSD4+Ne4CZJ/5jIO
	 K+13kGDxt1kti7mp/qnwZD60zWMPtL/DYNRTCzE6GvKYmyke5SNO6/RTyfzxEK4nUfeL/
	 RvDClDdL1qMQMpSHtUhCsHn7yXVqHCauQYNRJswXh3U3AE1Vs1P1JDOj5iWMcGCu0DLWd
	 K3af1UjjesPzNP1ZkNOAILwz07Xodl8WzUJ5JwTBpiCq9CxtBa8exVivnPuaFTm5uEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793287868;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=uT4RO3KROVP6IrSg8gI4+YIiaJyjqMkq+ReK+O8sSOs=;
	b=ySv6u1UZNKgSWkkPc3l1bbA3zohSOuEJRWGykDKRPhKjDh2pGy1m3W8qo6ZKF6Z0iDSU
	 a7zvotEYcRTLh+rlRRIYJH+dHCpmEQzY2bBUFFK4JPq+xlITC4Y91lqBaXSGTuIICkDBm
	 nENPYj6CS5tIlASRyGGzUt1R2anojAaEHaJifci4f0w/eBDafhj5SiIfncz1rTBd4XciA
	 ROW23AWNbzVp6VzZjJvtR/xnIZNNWwMAjNxRsagONzkJGhG4L7Q/8HzcClQJn/gFppKry
	 fEWsXRj/dSQwYcmJ0x5gKtv/N5clmjOCU66gO5jGQ+82Ktj73NFXCslV98A1nxnBzLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lQK4qRvR;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEB9606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 15:31:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAEB9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lQK4qRvR
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso1307522a91.0
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 08:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793287867; x=1793892667; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uT4RO3KROVP6IrSg8gI4+YIiaJyjqMkq+ReK+O8sSOs=;
        b=lQK4qRvRegXHQ6ETzw+pLjuRN8ymPz0a17mmnmm+U8cRb5ylAaPsHlboIs++anl4pq
         u02ROIFLYTMi0Ve/XiT8D158zu57ufgxNfeY56JrRn1hAvS1K9JebfBaKe6XaIr/leme
         9RYjMVdW+xo7nzmkqQ3faPE7I4ZEn/c/rOJlknQJtIKz/BNxI+DlQvhgMSKNMtTL4AJh
         ad1SiCbSZEWhbvNKw3Yogg1rmXi2ADtuq7gEnF+bGNN6KnVvhME3JrwZn8JhO8BVDRtD
         OJ6+DR0rUQP/tozj+LDJ8Ah9cySCWdE4ANxY71j2TWRzOZutWa5Wp9rzUzfX17A4PEj9
         R++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793287867; x=1793892667;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uT4RO3KROVP6IrSg8gI4+YIiaJyjqMkq+ReK+O8sSOs=;
        b=qUR0ZhxFoRzJLjG3EazWNf8lW7DMuF2/C6xs+TJFQ+BvHGVuJQ6YT6GkWQQu8kYNh9
         llNQqG1/D/yYXATkfUX5zA4g5ssRSw4ap8iYmbZIccjgVkr7slPozImsG6MVLEg6yRyu
         sPpWV71PMt3e4DgBI700R0t1sc9EIlkbqzW/grhrXiXttygq6Lv4qiDauEtdItqH13L3
         KBL4lcJURCmPItc97HgXbx8mEtacwmxnYOtdKhZsxIYn4l1H0XduRqpXo6qL39LvW7PS
         cFMxgZy/mGdSXD6mLglKBHhXf9jFmMJbJPG2QMrUO6m2ssHS/2eOZpDHzyQ4IVcVyBHK
         dYTg==
X-Forwarded-Encrypted: i=1; AKwUvBw5XXonoIiQSU2JSAzDerw+iaK18g+K4nX69p7fnqclo9m+667vWni6hVgq57QBWZ5DEtP36VjZ@vger.kernel.org
X-Gm-Message-State: AFq9FYKpULFH+WDQaUn7/+UUf9HYqEBl40cDHicFr8lxuI1QqDY+tV12
	xlzp9WCv4iLDoqoy/uN7H7m1xdE1kOO8T+uiyEgqvN3zQ5KGyNR51Xwv
X-Gm-Gg: AYBFou2sdSuhP/D3ZfXgfrK+UjbWtAxEKctw2b1B9N0hGceFyupfnabTj2ulpfHK4uW
	1q68Hu27VH29zaRX6SvVNoEoTIv0Aq5p6M07Ki1te7QX/eAQcCv49rVYDl6kdLBaF8W7tXl9mbr
	ZSN4zyBpvu3K2WDBOgTXNysGPucm1cRkq0y19Zc3CkkK2qMD8gfke8suBHj96PinBFuYvwMdiP+
	nOWaxfF3NxTd1M1gYeqcd9XOnaAK6jSFOXhcnIUZ/0hUJi1mPsZxvP6wqT+S586lhfEFrDjYzwv
	4e0dHnqv2m7R9bHsUh/HYHofgN9k6PP+z9JERzYDGLJpJvSaCqewrSwauRy+P4myNdExtKFx+Kz
	zfAtxIvtjJSWg5Fo0iUWFk0DVogcxEax6fI7CO4JQDIJszV9Hw0pw2rwkWfXw9bnfr5RgPU0Q8j
	LdIpTtBcmMP5NqvvvIOL2q9xWdnyOv53I1la9ZP9jBTX7ivS1HhgYf0KWBc/SMSUM6htIHnoRtW
	8eWGqnRxuQqP54JndyPE+72s7B5HX38k/NvU9D+xmSCwDdGlAPoAajRg5mD8F/VtjNDpWqI+R/e
	gUA37NEtB2BFxjPU2BLBGAl+jnEVRFxwbf+j8vOW+Kt2GXna+fxpVcPML0dh0KhLvT4gbhOiy0e
	7uq4LpJT6oj/h5nXyZi+zw4uuSYr7aSl1DoLOEcBYLmby2UAcLfXi41uB
X-Received: by 2002:a17:90b:4f49:b0:3ac:9e5e:d19c with SMTP id 98e67ed59e1d1-3ae580a9d68mr4812741a91.17.1793287866980;
        Thu, 29 Oct 2026 08:31:06 -0700 (PDT)
Received: from yupeng-XPS-15-9520.. (c-73-169-192-12.hsd1.wa.comcast.net. [73.169.192.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9db612sm4838707a91.17.2026.10.29.08.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 08:31:06 -0700 (PDT)
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
Subject: [PATCH v11] nvmet: add cgroup_id to charge namespace I/O to a cgroup
Date: Thu, 29 Oct 2026 08:31:03 -0700
Message-ID: <20261029153103.13689-1-yupeng0921@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
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

Performance test:
On a 4 core VM and 4G ramdisk, export tcp-nvmeof targets to 127.0.0.1,
run fio with below parameters:
fio --bs=4k --rw=randwrite --iodepth=32 --numjobs=4 --ioengine=libaio --direct=1

file backend result:
|                            | IOPS   | Mean Latency | p99 latency |
|without this patch          | 424.4k | 301.4 µs     | 330 µs      |
|this patch, cgroup_id unset | 425.1k | 300.9 µs     | 330 µs      |
|this patch, cgroup_id set   | 363.4k | 352.0 µs     | 1171 µs     |

block device backend result:
|                            | IOPS   | Mean Latency | p99 latency |
|without this patch          | 446.4k | 286.5 µs     | 313 µs      |
|this patch, cgroup_id unset | 446.4k | 286.5 µs     | 313 µs      |
|this patch, cgroup_id set   | 356.7k | 358.6 µs     | 864 µs      |

With this patch and no cgroup_id set, the peformance is almost the same.
When we set the cgroup_id, we can see a performance decrease but it
is still very fast.

Signed-off-by: Peng Yu <yupeng0921@gmail.com>
Assisted-by: Claude:claude-fable-5 [Claude Code]
Assisted-by: Claude:claude-opus-5-5 [Claude Code]
---
Changes since v10:
* Run the file backend's Flush, DSM and Write Zeroes and the zoned
  backend's Zone Management Send directly from the command's work item
  on the namespace's workqueue instead of queueing a second work item,
  so the NOIO scope and the dying-queue check of nvmet_blkcg_work()
  cover them, and drop the backends' own cgroup association (Sashiko's
  v10 review). Do the same for Zone Management Receive.
* Rebased on nvme-7.4 (89480d137bf0).

Sashiko's v10 review: https://lore.kernel.org/all/sashiko-outbox-185466@kernel.org/
v10: https://lore.kernel.org/all/20261026153020.47791-1-yupeng0921@gmail.com/
Tejun's v9 comment: https://lore.kernel.org/all/aee729fd53ef9c7c084a443216cfeb39@kernel.org/
v9: https://lore.kernel.org/all/20261023043423.176002-1-yupeng0921@gmail.com/
v8: https://lore.kernel.org/all/20261002152821.410591-1-yupeng0921@gmail.com/
v7 (with test steps): https://lore.kernel.org/all/20260929232411.101087-1-yupeng0921@gmail.com/

 Documentation/ABI/stable/configfs-nvmet |  16 +++
 drivers/nvme/target/configfs.c          |  47 ++++++++
 drivers/nvme/target/core.c              | 145 ++++++++++++++++++++++++
 drivers/nvme/target/io-cmd-file.c       |  10 +-
 drivers/nvme/target/nvmet.h             |  40 +++++++
 drivers/nvme/target/zns.c               |   8 +-
 6 files changed, 256 insertions(+), 10 deletions(-)

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
index 1d46a2bb40f8..55b57551b50c 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -569,6 +569,50 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 
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
@@ -841,6 +885,9 @@ static struct configfs_attribute *nvmet_ns_attrs[] = {
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
index 956f9a552e70..c94b57f85849 100644
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
 
@@ -476,8 +479,144 @@ void nvmet_put_namespace(struct nvmet_ns *ns)
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
+			WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus(),
+			ns->nsid);
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
+		 * No command is left, but the work item of a command that
+		 * completed from inside ->blkcg_execute() may still be
+		 * returning: destroy_workqueue() waits for it.
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
+static bool nvmet_blkcg_begin(struct nvmet_req *req)
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
+static void nvmet_blkcg_end(bool associated)
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
+	struct nvmet_req *req =
+		container_of(work, struct nvmet_req, blkcg_work);
+	unsigned int noio_flag;
+	bool associated;
+
+	/* its queue is being deleted: abort it rather than throttle it */
+	if (unlikely(percpu_ref_is_dying(&req->sq->ref))) {
+		nvmet_req_complete(req, NVME_SC_ABORT_QUEUE);
+		return;
+	}
+
+	/* reclaim must not wait for I/O queued on this workqueue */
+	noio_flag = memalloc_noio_save();
+	associated = nvmet_blkcg_begin(req);
+	req->blkcg_execute(req);
+	nvmet_blkcg_end(associated);
+	memalloc_noio_restore(noio_flag);
+}
+
+static void nvmet_blkcg_queue_req(struct nvmet_req *req)
+{
+	INIT_WORK(&req->blkcg_work, nvmet_blkcg_work);
+	queue_work(req->ns->blkcg_wq, &req->blkcg_work);
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
+#endif /* CONFIG_BLK_CGROUP */
+
 static void nvmet_ns_dev_disable(struct nvmet_ns *ns)
 {
+	nvmet_blkcg_ns_disable(ns);
 	nvmet_bdev_ns_disable(ns);
 	nvmet_file_ns_disable(ns);
 }
@@ -604,6 +743,10 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 	if (ret)
 		goto out_unlock;
 
+	ret = nvmet_blkcg_ns_enable(ns);
+	if (ret)
+		goto out_dev_disable;
+
 	ret = nvmet_p2pmem_ns_enable(ns);
 	if (ret)
 		goto out_dev_disable;
@@ -1162,6 +1305,8 @@ static u16 nvmet_parse_io_cmd(struct nvmet_req *req)
 	if (ret)
 		return ret;
 
+	nvmet_blkcg_init_req(req);
+
 	if (req->ns->pr.enable) {
 		ret = nvmet_pr_check_cmd_access(req);
 		if (ret)
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 695963dd932e..b9d221eeef57 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -265,8 +265,7 @@ static void nvmet_file_execute_flush(struct nvmet_req *req)
 {
 	if (!nvmet_check_transfer_len(req, 0))
 		return;
-	INIT_WORK(&req->f.work, nvmet_file_flush_work);
-	queue_work(nvmet_wq, &req->f.work);
+	nvmet_req_run_work(req, nvmet_wq, &req->f.work, nvmet_file_flush_work);
 }
 
 static void nvmet_file_execute_discard(struct nvmet_req *req)
@@ -325,8 +324,7 @@ static void nvmet_file_execute_dsm(struct nvmet_req *req)
 {
 	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
 		return;
-	INIT_WORK(&req->f.work, nvmet_file_dsm_work);
-	queue_work(nvmet_wq, &req->f.work);
+	nvmet_req_run_work(req, nvmet_wq, &req->f.work, nvmet_file_dsm_work);
 }
 
 static void nvmet_file_write_zeroes_work(struct work_struct *w)
@@ -355,8 +353,8 @@ static void nvmet_file_execute_write_zeroes(struct nvmet_req *req)
 {
 	if (!nvmet_check_transfer_len(req, 0))
 		return;
-	INIT_WORK(&req->f.work, nvmet_file_write_zeroes_work);
-	queue_work(nvmet_wq, &req->f.work);
+	nvmet_req_run_work(req, nvmet_wq, &req->f.work,
+			nvmet_file_write_zeroes_work);
 }
 
 u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index bd13adc72f67..de590dd07535 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -115,6 +115,22 @@ struct nvmet_ns {
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
+	 * commands, are executed from their own work items on ->blkcg_wq, so
+	 * the cgroup's throttling doesn't put a transport context to sleep.
+	 */
+	struct workqueue_struct	*blkcg_wq;
+#endif
+
 	struct config_group	device_group;
 	struct config_group	group;
 
@@ -507,6 +523,11 @@ struct nvmet_req {
 
 	void (*execute)(struct nvmet_req *req);
 	const struct nvmet_fabrics_ops *ops;
+#ifdef CONFIG_BLK_CGROUP
+	/* the backend's ->execute, called from ->blkcg_work */
+	void (*blkcg_execute)(struct nvmet_req *req);
+	struct work_struct	blkcg_work;
+#endif
 
 	struct pci_dev		*p2p_dev;
 	struct device		*p2p_client;
@@ -746,6 +767,25 @@ void nvmet_bdev_execute_zone_mgmt_recv(struct nvmet_req *req);
 void nvmet_bdev_execute_zone_mgmt_send(struct nvmet_req *req);
 void nvmet_bdev_execute_zone_append(struct nvmet_req *req);
 
+/*
+ * A command of a namespace with a cgroup already runs from its own work
+ * item on the namespace's workqueue (see nvmet_blkcg_work()), so run the
+ * backend's work function right there; otherwise queue it on @wq.
+ */
+static inline void nvmet_req_run_work(struct nvmet_req *req,
+		struct workqueue_struct *wq, struct work_struct *work,
+		work_func_t func)
+{
+#ifdef CONFIG_BLK_CGROUP
+	if (req->ns->blkcg_wq) {
+		func(work);
+		return;
+	}
+#endif
+	INIT_WORK(work, func);
+	queue_work(wq, work);
+}
+
 static inline u32 nvmet_rw_data_len(struct nvmet_req *req)
 {
 	return ((u32)le16_to_cpu(req->cmd->rw.length) + 1) <<
diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 92f5c1435582..38455481da24 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -335,8 +335,8 @@ void nvmet_bdev_execute_zone_mgmt_recv(struct nvmet_req *req)
 	if (!nvmet_check_transfer_len(req, (numd + 1) << 2))
 		return;
 
-	INIT_WORK(&req->z.zmgmt_work, nvmet_bdev_zone_zmgmt_recv_work);
-	queue_work(zbd_wq, &req->z.zmgmt_work);
+	nvmet_req_run_work(req, zbd_wq, &req->z.zmgmt_work,
+			   nvmet_bdev_zone_zmgmt_recv_work);
 }
 
 static inline enum req_op zsa_req_op(u8 zsa)
@@ -534,8 +534,8 @@ static void nvmet_bdev_zmgmt_send_work(struct work_struct *w)
 
 void nvmet_bdev_execute_zone_mgmt_send(struct nvmet_req *req)
 {
-	INIT_WORK(&req->z.zmgmt_work, nvmet_bdev_zmgmt_send_work);
-	queue_work(zbd_wq, &req->z.zmgmt_work);
+	nvmet_req_run_work(req, zbd_wq, &req->z.zmgmt_work,
+			   nvmet_bdev_zmgmt_send_work);
 }
 
 static void nvmet_bdev_zone_append_bio_done(struct bio *bio)

base-commit: 89480d137bf0d943a82c64f86ae2407a15276b5e
-- 
2.53.0

