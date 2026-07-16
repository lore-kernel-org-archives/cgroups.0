Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76AD426D0B
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 13:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208235; cv=none; b=KryV8KZ3AI4T+sfeX76jQ23mpmvZjIB6nUrPRdYyX+qgTsGsbgyRjW5d1PsNSVcWcdbr0Lx8tiG9Fwj1o3Uf6+9hUCdci7jWcmh1TXTW2D8cdnEWiC8+9C0tRmu2D4nU9I6+f7SdmRQuZxFsaUr4XYZdJug/LqEdv0vmoVPUk70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208235; c=relaxed/simple;
	bh=LDxEmI3TVHKUYrMzZXZyrOOfTxlXtBU8VlpAoeWy5yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfIgwSO8ldMkmGNVThQfmS22nBXh/2N+houXIw9QJTRHenS7XoHu76YyES2kXo/oBbd1O8PzSDpzYYkQDRhD742ZO+W07HCGqKl+S4uROTT6nErd08pPel6ahp3hdm9sGzFgyfIbEYak5kzBJaLIztDm60wHkM0eu6tiLq1aYfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=CkqVy38k; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="CkqVy38k"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493bb510ce4so45252175e9.1
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208231; x=1784813031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bRy0m6NWNW2PQCoNaWlnRG4v0MDoFwNVbRxZWj5ydd0=;
        b=CkqVy38koyILT7CJxbZaCcguTKamGCDfajkEDglxOGTXI4HuGeS/DM/UK3q6CkO3G7
         r61k4gp9OmnOG8IwQWb3vl7v4qS2/7nUY0Us/229WR/GqxpIE6bPn/TasFiIFup1JNg5
         YN6c9jIfltCMwwX41Ba9kPxUF5gh7rMw+BMxlwTTbnX4aS1b66AktkQhWqyyRNEjQSZU
         c7TwsNr7awuj9OhCzHfjMKLKiBoE644bcyIijep8yk591xb9M2RLb8wrMYnip0CWclec
         xI/9wd+4Zrhe2RZ2Pa0wtzY4fSN9g0U1Yde3ZaQfQASRL7FirA4jHR+/o7RnI+dCk9y6
         yc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208231; x=1784813031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bRy0m6NWNW2PQCoNaWlnRG4v0MDoFwNVbRxZWj5ydd0=;
        b=LLZdoA0A5gG0KfVLuqItMw+CeL7AjL6Yiv3dGvlqtqPX/PjlHBf03IV3ucCLeMpePz
         0q75/LUCZ/1waxMZSZuNp0TqrC77pWeyIbX/0cKCCjFTvctGoPzwZwW1kHeHk9CsuqQm
         Xu11iKFpqhXI2JayUG+W4r/K3yFE8A9k8jmDjap6IqBI3gzzNI68RM2e6iFmhRwqiIRI
         VTVUWFy6oBNvcp9cJq2bUeIcxOhGolNwdNsEMphPI3VqfL/1qNFvfap1J8bzdKo+g8Wg
         fhJ9ahIqmIPPqHM3W2nxY2pwhGLJilAfuwrbhlhy2Sg7eJ25MabquIUfDOcy3Cw/BPSc
         6eUA==
X-Gm-Message-State: AOJu0Yy8fNVdC43+8RZJetns2RJIRo2GhdgKM/oPcYmGJhlxuGX+U3GL
	dwjdWC1dGl7oBRmIwpKkNnJwqyR8nkhOzb40AeHB03Q+3TUUdAfDYGQb5SavblJO8wI=
X-Gm-Gg: AfdE7cl7op1M46Od+ZvFD70GrZfe6RGL7PE5XsxP9qbSpJZzuAh3IBQSgBYlRdTuhCF
	/E8PcPVcOiRU59RKItMSQWXHupflq8DbMDZsxzHgUT443BEpLit1EGaxsRUL2VWBXGYCScWfgGG
	gFxbIFzIoV/MRe8YYVYpfeDt8irdsJ/q1O5bwBDVdO6n+vNDFF974K74wJq//WgQUL+P0q52Q6y
	Fk08Le19TjOuQGA2eXzh6gG1JlJL/AoCdKtiSqmwVPveOdu/B+ftrTdAMk8zaHUQp6FBdZd3vq2
	PRqOAE53Iis+brJlIwq8DWYisw4PU8wqGNafswtRLNH4iAeC08/39xhZzOW8DMSFigXd98PFWo6
	7u53xB8i0ObwKY3x4wbM5itUlirJi8rm4+sIa8cCw93wAS4HSipzXmaJ5NJHw2ZKJkIKcNoQ5xO
	uD+jBrPHGSKCThlbZcYs3anQ==
X-Received: by 2002:a05:600c:19cc:b0:495:4732:1eb9 with SMTP id 5b1f17b1804b1-49547321ef4mr2824285e9.21.1784208231072;
        Thu, 16 Jul 2026 06:23:51 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e7d799sm55609455e9.3.2026.07.16.06.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:23:50 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 08/14] RDMA/cgroup: Disambiguate devices across net namespaces
Date: Thu, 16 Jul 2026 15:23:09 +0200
Message-ID: <20260716132316.1495242-9-jiri@resnulli.us>
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

RDMA device names are unique only within a network namespace, but an
RDMA cgroup can account resources for devices from multiple namespaces.
Duplicate names therefore make cgroup output ambiguous and can cause
limit writes to select the wrong device.

Use the system-wide RDMA device index to distinguish duplicate names
while preserving the existing UAPI for unique names. Reject ambiguous
name-only writes with -ENOTUNIQ and expose a complete device view to
administrators.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- replace caller-netns filtering with global visibility and index-based
  disambiguation
---
 Documentation/admin-guide/cgroup-v1/rdma.rst |  8 +++
 Documentation/admin-guide/cgroup-v2.rst      | 15 ++++-
 drivers/infiniband/core/cgroup.c             |  1 +
 include/linux/cgroup_rdma.h                  |  1 +
 kernel/cgroup/rdma.c                         | 71 ++++++++++++++++----
 5 files changed, 83 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/rdma.rst b/Documentation/admin-guide/cgroup-v1/rdma.rst
index e69369b7252e..8d0c3a796ee3 100644
--- a/Documentation/admin-guide/cgroup-v1/rdma.rst
+++ b/Documentation/admin-guide/cgroup-v1/rdma.rst
@@ -90,6 +90,13 @@ Following resources can be accounted by rdma controller.
   hca_object 	Maximum number of HCA Objects
   ==========    =============================
 
+RDMA devices from all network namespaces are listed. Each line starts with
+the device name. If more than one device has the same name, ``index=N``
+follows the name, where ``N`` is the system-wide RDMA device index, unique
+among registered devices. When configuring a limit, the index is optional
+for a globally unique name and required for a duplicate name. A write without
+the required index fails with ``-ENOTUNIQ``.
+
 2. Usage Examples
 =================
 
@@ -97,6 +104,7 @@ Following resources can be accounted by rdma controller.
 
 	echo mlx4_0 hca_handle=2 hca_object=2000 > /sys/fs/cgroup/rdma/1/rdma.max
 	echo ocrdma1 hca_handle=3 > /sys/fs/cgroup/rdma/2/rdma.max
+	echo "rxe0 index=5 hca_handle=2" > /sys/fs/cgroup/rdma/3/rdma.max
 
 (b) Query resource limit::
 
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 993446ab66d0..df74d554d2cd 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2752,6 +2752,11 @@ RDMA
 The "rdma" controller regulates the distribution and accounting of
 RDMA resources.
 
+RDMA devices from all network namespaces are listed. Each line starts with
+the device name. If more than one device has the same name, ``index=N``
+follows the name, where ``N`` is the system-wide RDMA device index, unique
+among registered devices.
+
 RDMA Interface Files
 ~~~~~~~~~~~~~~~~~~~~
 
@@ -2760,7 +2765,11 @@ RDMA Interface Files
 	except root that describes current configured resource limit
 	for a RDMA/IB device.
 
-	Lines are keyed by device name and are not ordered.
+	Lines are keyed by device name and are not ordered. A write may
+	include ``index=N`` after the device name. The index is optional
+	when the name is globally unique. If multiple devices have that
+	name, the index is required and a write without it fails with
+	``-ENOTUNIQ``.
 	Each line contains space separated resource name and its configured
 	limit that can be distributed.
 
@@ -2776,6 +2785,10 @@ RDMA Interface Files
 	  mlx4_0 hca_handle=2 hca_object=2000
 	  ocrdma1 hca_handle=3 hca_object=max
 
+	For devices with duplicate names, select the device by index::
+
+	  echo "rxe0 index=5 hca_handle=2" > rdma.max
+
   rdma.current
 	A read-only file that describes current resource usage.
 	It exists for all the cgroup except root.
diff --git a/drivers/infiniband/core/cgroup.c b/drivers/infiniband/core/cgroup.c
index 1f037fe01450..8611b4e32cfb 100644
--- a/drivers/infiniband/core/cgroup.c
+++ b/drivers/infiniband/core/cgroup.c
@@ -17,6 +17,7 @@
 void ib_device_register_rdmacg(struct ib_device *device)
 {
 	device->cg_device.name = device->name;
+	device->cg_device.index = device->index;
 	rdmacg_register_device(&device->cg_device);
 }
 
diff --git a/include/linux/cgroup_rdma.h b/include/linux/cgroup_rdma.h
index 404e746552ca..9a5c9ee728e7 100644
--- a/include/linux/cgroup_rdma.h
+++ b/include/linux/cgroup_rdma.h
@@ -34,6 +34,7 @@ struct rdmacg_device {
 	struct list_head	dev_node;
 	struct list_head	rpools;
 	char			*name;
+	u32			index;
 };
 
 /*
diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
index 5e82a03b3270..9489f3df0bf3 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -19,6 +19,7 @@
 #define RDMACG_MAX_STR "max"
 
 enum rdmacg_limit_tokens {
+	RDMACG_DEVICE_INDEX,
 	RDMACG_HCA_HANDLE_VAL,
 	RDMACG_HCA_HANDLE_MAX,
 	RDMACG_HCA_OBJECT_VAL,
@@ -27,6 +28,7 @@ enum rdmacg_limit_tokens {
 };
 
 static const match_table_t rdmacg_limit_tokens = {
+	{ RDMACG_DEVICE_INDEX,		"index=%u"	},
 	{ RDMACG_HCA_HANDLE_VAL,	"hca_handle=%d"	},
 	{ RDMACG_HCA_HANDLE_MAX,	"hca_handle=max"	},
 	{ RDMACG_HCA_OBJECT_VAL,	"hca_object=%d"	},
@@ -464,17 +466,53 @@ void rdmacg_unregister_device(struct rdmacg_device *device)
 }
 EXPORT_SYMBOL(rdmacg_unregister_device);
 
-static struct rdmacg_device *rdmacg_get_device_locked(const char *name)
+static struct rdmacg_device *
+rdmacg_get_device_locked(const char *name, bool has_index, u32 index)
 {
+	struct rdmacg_device *match = NULL;
 	struct rdmacg_device *device;
 
 	lockdep_assert_held(&rdmacg_mutex);
 
-	list_for_each_entry(device, &rdmacg_devices, dev_node)
-		if (!strcmp(name, device->name))
-			return device;
+	list_for_each_entry(device, &rdmacg_devices, dev_node) {
+		if (strcmp(name, device->name))
+			continue;
 
-	return NULL;
+		if (has_index) {
+			if (device->index == index)
+				return device;
+			continue;
+		}
+
+		if (match)
+			return ERR_PTR(-ENOTUNIQ);
+		match = device;
+	}
+
+	return match ?: ERR_PTR(-ENODEV);
+}
+
+static bool
+rdmacg_device_name_unique_locked(const struct rdmacg_device *device)
+{
+	struct rdmacg_device *other;
+
+	lockdep_assert_held(&rdmacg_mutex);
+
+	list_for_each_entry(other, &rdmacg_devices, dev_node)
+		if (other != device && !strcmp(other->name, device->name))
+			return false;
+
+	return true;
+}
+
+static void rdmacg_print_device_key(struct seq_file *sf,
+				    const struct rdmacg_device *device)
+{
+	seq_puts(sf, device->name);
+	if (!rdmacg_device_name_unique_locked(device))
+		seq_printf(sf, " index=%u", device->index);
+	seq_putc(sf, ' ');
 }
 
 static ssize_t rdmacg_resource_set_max(struct kernfs_open_file *of,
@@ -488,6 +526,8 @@ static ssize_t rdmacg_resource_set_max(struct kernfs_open_file *of,
 	char *p;
 	int *new_limits;
 	unsigned long enables = 0;
+	u32 dev_index = 0;
+	bool has_index = false;
 	int i = 0, ret = 0;
 
 	/* extract the device name first */
@@ -503,7 +543,7 @@ static ssize_t rdmacg_resource_set_max(struct kernfs_open_file *of,
 		goto err;
 	}
 
-	/* parse resource limit tokens */
+	/* parse the optional device index and resource limit tokens */
 	while ((p = strsep(&options, " \t\n"))) {
 		substring_t args[MAX_OPT_ARGS];
 		int tok, intval;
@@ -513,6 +553,13 @@ static ssize_t rdmacg_resource_set_max(struct kernfs_open_file *of,
 
 		tok = match_token(p, rdmacg_limit_tokens, args);
 		switch (tok) {
+		case RDMACG_DEVICE_INDEX:
+			if (has_index || match_uint(&args[0], &dev_index)) {
+				ret = -EINVAL;
+				goto parse_err;
+			}
+			has_index = true;
+			break;
 		case RDMACG_HCA_HANDLE_VAL:
 			if (match_int(&args[0], &intval) || intval < 0) {
 				ret = -EINVAL;
@@ -546,9 +593,9 @@ static ssize_t rdmacg_resource_set_max(struct kernfs_open_file *of,
 	/* acquire lock to synchronize with hot plug devices */
 	mutex_lock(&rdmacg_mutex);
 
-	device = rdmacg_get_device_locked(dev_name);
-	if (!device) {
-		ret = -ENODEV;
+	device = rdmacg_get_device_locked(dev_name, has_index, dev_index);
+	if (IS_ERR(device)) {
+		ret = PTR_ERR(device);
 		goto dev_err;
 	}
 
@@ -626,7 +673,7 @@ static int rdmacg_resource_read(struct seq_file *sf, void *v)
 	mutex_lock(&rdmacg_mutex);
 
 	list_for_each_entry(device, &rdmacg_devices, dev_node) {
-		seq_printf(sf, "%s ", device->name);
+		rdmacg_print_device_key(sf, device);
 
 		rpool = find_cg_rpool_locked(cg, device);
 		print_rpool_values(sf, rpool);
@@ -650,7 +697,7 @@ static int rdmacg_events_show(struct seq_file *sf, void *v)
 	list_for_each_entry(device, &rdmacg_devices, dev_node) {
 		rpool = find_cg_rpool_locked(cg, device);
 
-		seq_printf(sf, "%s ", device->name);
+		rdmacg_print_device_key(sf, device);
 		for (i = 0; i < RDMACG_RESOURCE_MAX; i++) {
 			seq_printf(sf, "%s.max=%llu %s.alloc_fail=%llu",
 				   rdmacg_resource_names[i],
@@ -679,7 +726,7 @@ static int rdmacg_events_local_show(struct seq_file *sf, void *v)
 	list_for_each_entry(device, &rdmacg_devices, dev_node) {
 		rpool = find_cg_rpool_locked(cg, device);
 
-		seq_printf(sf, "%s ", device->name);
+		rdmacg_print_device_key(sf, device);
 		for (i = 0; i < RDMACG_RESOURCE_MAX; i++) {
 			seq_printf(sf, "%s.max=%llu %s.alloc_fail=%llu",
 				   rdmacg_resource_names[i],
-- 
2.54.0

