From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv1 4/6] IB/core: rdmacg support infrastructure APIs
Date: Wed,  6 Jan 2016 00:28:04 +0530
Message-ID: <1452020286-9508-5-git-send-email-pandit.parav@gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SnPLcRBUoKDw1KKUDE2QMDENtiCp+7LOb/ojkI0uZpQ=;
        b=cX2h28X7hC5oWI/KJggLN2wJxdpXFDUQZi79MAq5z4FFBJkeSEKEZBnQCWaxXXN/CT
         veKjnYQEQcOAg2Hnr3w3OaIhnCLEdrva2cicB+Ct+2YuDyHKyC5GIb6S3cwFIIW08z/U
         lyNXOOLyi8jH68WVjsKwfQGtrojWCYPrDoo53jA8ifc37vhU9fyN8WRlKVXIYQY4vfhF
         D4YZaJchRtYZM+qP1sfwTkiMwK3TFgqcKYBhpOUu0Rhu7oZPa6c25ZmpAZw99samzkd1
         6SLWRkYiYElhwhtkOuHgqW7dHmiuXZGwJQYRVlbsx2wSSRdtTBvNPAhMEu9R1ejjqTxM
         xE0Q==
In-Reply-To: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

It defines verb RDMA resources that will be registered with
RDMA cgroup. It defines new APIs to register device with
RDMA cgroup and defines resource token table access interface.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 drivers/infiniband/core/Makefile    |  1 +
 drivers/infiniband/core/cgroup.c    | 80 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/core_priv.h |  5 +++
 include/rdma/ib_verbs.h             | 13 ++++++
 4 files changed, 99 insertions(+)
 create mode 100644 drivers/infiniband/core/cgroup.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index d43a899..df40cee 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -13,6 +13,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
 				roce_gid_mgmt.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
+ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
 
 ib_mad-y :=			mad.o smi.o agent.o mad_rmpp.o
 
diff --git a/drivers/infiniband/core/cgroup.c b/drivers/infiniband/core/cgroup.c
new file mode 100644
index 0000000..8d80add
--- /dev/null
+++ b/drivers/infiniband/core/cgroup.c
@@ -0,0 +1,80 @@
+#include <linux/kernel.h>
+#include <linux/parser.h>
+#include <linux/cgroup_rdma.h>
+
+#include "core_priv.h"
+
+/**
+ * resource table definition as to be seen by the user.
+ * Need to add entries to it when more resources are
+ * added/defined at IB verb/core layer.
+ */
+static match_table_t resource_tokens = {
+	{RDMA_VERB_RESOURCE_UCTX, "uctx=%d"},
+	{RDMA_VERB_RESOURCE_AH, "ah=%d"},
+	{RDMA_VERB_RESOURCE_PD, "pd=%d"},
+	{RDMA_VERB_RESOURCE_CQ, "cq=%d"},
+	{RDMA_VERB_RESOURCE_MR, "mr=%d"},
+	{RDMA_VERB_RESOURCE_MW, "mw=%d"},
+	{RDMA_VERB_RESOURCE_SRQ, "srq=%d"},
+	{RDMA_VERB_RESOURCE_QP, "qp=%d"},
+	{RDMA_VERB_RESOURCE_FLOW, "flow=%d"},
+	{-1, NULL}
+};
+
+/**
+ * setup table pointers for RDMA cgroup to access.
+ */
+static struct rdmacg_pool_info verbs_token_info = {
+	.resource_table = resource_tokens,
+	.resource_count =
+		(sizeof(resource_tokens) / sizeof(struct match_token)) - 1,
+};
+
+static struct rdmacg_pool_info*
+	rdmacg_get_resource_pool_tokens(struct ib_device *device)
+{
+	return &verbs_token_info;
+}
+
+static struct rdmacg_resource_pool_ops verbs_pool_ops = {
+	.get_resource_pool_tokens = &rdmacg_get_resource_pool_tokens,
+};
+
+/**
+ * ib_device_register_rdmacg - register with rdma cgroup.
+ * @device: device to register to participate in resource
+ *          accounting by rdma cgroup.
+ *
+ * Register with the rdma cgroup. Should be called before
+ * exposing rdma device to user space applications to avoid
+ * resource accounting leak.
+ * HCA drivers should set resource pool ops first if they wish
+ * to support hw specific resource accounting before IB core
+ * registers with rdma cgroup.
+ */
+void ib_device_register_rdmacg(struct ib_device *device)
+{
+	rdmacg_set_rpool_ops(device,
+			     RDMACG_RESOURCE_POOL_VERB,
+			     &verbs_pool_ops);
+	rdmacg_register_ib_device(device);
+}
+
+/**
+ * ib_device_unregister_rdmacg - unregister with rdma cgroup.
+ * @device: device to unregister.
+ *
+ * Unregister with the rdma cgroup. Should be called after
+ * all the resources are deallocated, and after a stage when any
+ * other resource allocation of user application cannot be done
+ * for this device to avoid any leak in accounting.
+ * HCA drivers should clear resource pool ops after ib stack
+ * unregisters with rdma cgroup.
+ */
+void ib_device_unregister_rdmacg(struct ib_device *device)
+{
+	rdmacg_unregister_ib_device(device);
+	rdmacg_clear_rpool_ops(device,
+			       RDMACG_RESOURCE_POOL_VERB);
+}
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 5cf6eb7..29bdfe2 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -92,4 +92,9 @@ int ib_cache_setup_one(struct ib_device *device);
 void ib_cache_cleanup_one(struct ib_device *device);
 void ib_cache_release_one(struct ib_device *device);
 
+#ifdef CONFIG_CGROUP_RDMA
+void ib_device_register_rdmacg(struct ib_device *device);
+void ib_device_unregister_rdmacg(struct ib_device *device);
+#endif
+
 #endif /* _CORE_PRIV_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1a17249..f44b884 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -96,6 +96,19 @@ enum rdma_protocol_type {
 	RDMA_PROTOCOL_USNIC_UDP
 };
 
+enum rdma_resource_type {
+	RDMA_VERB_RESOURCE_UCTX,
+	RDMA_VERB_RESOURCE_AH,
+	RDMA_VERB_RESOURCE_PD,
+	RDMA_VERB_RESOURCE_CQ,
+	RDMA_VERB_RESOURCE_MR,
+	RDMA_VERB_RESOURCE_MW,
+	RDMA_VERB_RESOURCE_SRQ,
+	RDMA_VERB_RESOURCE_QP,
+	RDMA_VERB_RESOURCE_FLOW,
+	RDMA_VERB_RESOURCE_MAX,
+};
+
 __attribute_const__ enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type);
 
-- 
1.8.3.1
