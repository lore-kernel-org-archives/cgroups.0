From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv12 2/3] IB/core: added support to use rdma cgroup controller
Date: Wed, 31 Aug 2016 14:07:26 +0530
Message-ID: <1472632647-1525-3-git-send-email-pandit.parav@gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FDIuiDxi14CNGr/SA82yEJr23qYVMWg/XhTT3cgpLB8=;
        b=vKm6kZlNHKnJo42XfuC298d6Uzk1XRVWKFCCgv46Dy9dJgn1kXPrvWNtep8eahECbQ
         /2J8SMskRWL21w5xbPR3kRmRYcKk6MJynoEPRi76qZVvCZ1zuyXafWsNg+Mbq518JU7X
         kM9Gqpnqmu7zhKx6G1fboiYGQ2km/LuSNtehs/k6qbseU2QTHSq8MAoyrVu7+T2K9Oku
         ygGRG1m8DRV7MiJp5NQ7UQ/FK5yBnpra+rfglD/gG8k0+iVYK0uqC6m/FDE2ONUgmmuQ
         LPxRfhtXgfR51Peq6hDAIerZd7hJLqaIzUe1kJ8x/PFl/1fp3v/qvY6hX1Gr8fsdrwdy
         wLJg==
In-Reply-To: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

Added support APIs for IB core to register/unregister every IB/RDMA
device with rdma cgroup for tracking verbs and hw resources.
IB core registers with rdma cgroup controller.
Added support APIs for uverbs layer to make use of rdma controller.
Added uverbs layer to perform resource charge/uncharge functionality.
Added support during query_device uverb operation to ensure it
returns resource limits by honoring rdma cgroup configured limits.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 drivers/infiniband/core/Makefile    |  1 +
 drivers/infiniband/core/cgroup.c    | 93 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/core_priv.h | 41 ++++++++++++++++
 drivers/infiniband/core/device.c    | 10 ++++
 4 files changed, 145 insertions(+)
 create mode 100644 drivers/infiniband/core/cgroup.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index edaae9f..e426ac8 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -13,6 +13,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 				multicast.o mad.o smi.o agent.o mad_rmpp.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
+ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
 
 ib_cm-y :=			cm.o
 
diff --git a/drivers/infiniband/core/cgroup.c b/drivers/infiniband/core/cgroup.c
new file mode 100644
index 0000000..ffe7234
--- /dev/null
+++ b/drivers/infiniband/core/cgroup.c
@@ -0,0 +1,93 @@
+/*
+ * Copyright (C) 2016 Parav Pandit <pandit.parav@gmail.com>
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include "core_priv.h"
+
+/*
+ * resource table definition as to be seen by the user.
+ * Need to add entries to it when more resources are
+ * added/defined at IB verb/core layer.
+ */
+
+/**
+ * ib_device_register_rdmacg - register with rdma cgroup.
+ * @device: device to register to participate in resource
+ *          accounting by rdma cgroup.
+ *
+ * Register with the rdma cgroup. Should be called before
+ * exposing rdma device to user space applications to avoid
+ * resource accounting leak.
+ * Returns 0 on success or otherwise failure code.
+ */
+int ib_device_register_rdmacg(struct ib_device *device)
+{
+	device->cg_device.name = device->name;
+	return rdmacg_register_device(&device->cg_device);
+}
+
+/**
+ * ib_device_unregister_rdmacg - unregister with rdma cgroup.
+ * @device: device to unregister.
+ *
+ * Unregister with the rdma cgroup. Should be called after
+ * all the resources are deallocated, and after a stage when any
+ * other resource allocation by user application cannot be done
+ * for this device to avoid any leak in accounting.
+ */
+void ib_device_unregister_rdmacg(struct ib_device *device)
+{
+	rdmacg_unregister_device(&device->cg_device);
+}
+
+int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
+			 struct ib_device *device,
+			 enum rdmacg_resource_type resource_index)
+{
+	return rdmacg_try_charge(&cg_obj->cg, &device->cg_device,
+				 resource_index);
+}
+EXPORT_SYMBOL(ib_rdmacg_try_charge);
+
+void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
+			struct ib_device *device,
+			enum rdmacg_resource_type resource_index)
+{
+	rdmacg_uncharge(cg_obj->cg, &device->cg_device,
+			resource_index);
+}
+EXPORT_SYMBOL(ib_rdmacg_uncharge);
+
+void ib_rdmacg_query_limit(struct ib_device *device, int *limits)
+{
+	rdmacg_query_limit(&device->cg_device, limits);
+}
+EXPORT_SYMBOL(ib_rdmacg_query_limit);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 19d499d..d1e432e 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -35,6 +35,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/cgroup_rdma.h>
 
 #include <rdma/ib_verbs.h>
 
@@ -124,6 +125,46 @@ int ib_cache_setup_one(struct ib_device *device);
 void ib_cache_cleanup_one(struct ib_device *device);
 void ib_cache_release_one(struct ib_device *device);
 
+#ifdef CONFIG_CGROUP_RDMA
+int ib_device_register_rdmacg(struct ib_device *device);
+void ib_device_unregister_rdmacg(struct ib_device *device);
+
+int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
+			 struct ib_device *device,
+			 enum rdmacg_resource_type resource_index);
+
+void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
+			struct ib_device *device,
+			enum rdmacg_resource_type resource_index);
+
+void ib_rdmacg_query_limit(struct ib_device *device, int *limits);
+#else
+static inline int ib_device_register_rdmacg(struct ib_device *device)
+{ return 0; }
+
+static inline void ib_device_unregister_rdmacg(struct ib_device *device)
+{ }
+
+static inline int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
+				       struct ib_device *device,
+				       enum rdmacg_resource_type resource_index)
+{ return 0; }
+
+static inline void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
+				      struct ib_device *device,
+				      enum rdmacg_resource_type resource_index)
+{ }
+
+static inline void ib_rdmacg_query_limit(struct ib_device *device,
+					 int *limits)
+{
+	int i;
+
+	for (i = 0; i < RDMACG_RESOURCE_MAX; i++)
+		limits[i] = S32_MAX;
+}
+#endif
+
 static inline bool rdma_is_upper_dev_rcu(struct net_device *dev,
 					 struct net_device *upper)
 {
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 760ef60..08e3259 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -363,10 +363,18 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
+	ret = ib_device_register_rdmacg(device);
+	if (ret) {
+		pr_warn("Couldn't register device with rdma cgroup\n");
+		ib_cache_cleanup_one(device);
+		goto out;
+	}
+
 	memset(&device->attrs, 0, sizeof(device->attrs));
 	ret = device->query_device(device, &device->attrs, &uhw);
 	if (ret) {
 		pr_warn("Couldn't query the device attributes\n");
+		ib_device_unregister_rdmacg(device);
 		ib_cache_cleanup_one(device);
 		goto out;
 	}
@@ -375,6 +383,7 @@ int ib_register_device(struct ib_device *device,
 	if (ret) {
 		pr_warn("Couldn't register device %s with driver model\n",
 			device->name);
+		ib_device_unregister_rdmacg(device);
 		ib_cache_cleanup_one(device);
 		goto out;
 	}
@@ -424,6 +433,7 @@ void ib_unregister_device(struct ib_device *device)
 
 	mutex_unlock(&device_mutex);
 
+	ib_device_unregister_rdmacg(device);
 	ib_device_unregister_sysfs(device);
 	ib_cache_cleanup_one(device);
 
-- 
1.8.3.1

