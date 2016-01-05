From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv1 1/6] rdmacg: Added rdma cgroup header file
Date: Wed,  6 Jan 2016 00:28:01 +0530
Message-ID: <1452020286-9508-2-git-send-email-pandit.parav@gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m2LIUNxpvnKpZOl9WtjPkWC2b92uDaa25hbxYLYMeL4=;
        b=gKVdJAwUMrx7Ud4cm6TuZn8TYMfTphE5g70k7+yxhBio/sKJ1F09kJC8IPVApr38Rk
         GNTt/v5us5Jve6mc1N8+zjVrVSq5TpgjSeUUVa+GipJ9Q1ZnRu+QGMKugVNHicZlz2YU
         GYdPKPeumk2MMLT1l7dra+benmDntcmNlzP4YKMLaVZdImhfAWu5L8wHRB2ObmPw7uRM
         uYk6T55p9cl/smGFAXGu/IBExbSylPlGsiKP3Q9m7sgAEAx8PYtmHOHRjtMDo8z30TVs
         Ont6AtEjJ0tfpZVchRvwSZVupird37A2H06wChsiCZ6fFPcHOscpmHV3350hJwxPbJdc
         kflQ==
In-Reply-To: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

Added rdma cgroup header file which defines its APIs to perform
charing/uncharing functionality.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 include/linux/cgroup_rdma.h | 91 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 include/linux/cgroup_rdma.h

diff --git a/include/linux/cgroup_rdma.h b/include/linux/cgroup_rdma.h
new file mode 100644
index 0000000..01d220f
--- /dev/null
+++ b/include/linux/cgroup_rdma.h
@@ -0,0 +1,91 @@
+#ifndef _CGROUP_RDMA_H
+#define _CGROUP_RDMA_H
+
+/*
+ * This file is subject to the terms and conditions of version 2 of the GNU
+ * General Public License.  See the file COPYING in the main directory of the
+ * Linux distribution for more details.
+ */
+
+enum rdmacg_resource_pool_type {
+	RDMACG_RESOURCE_POOL_VERB,
+	RDMACG_RESOURCE_POOL_HW,
+	RDMACG_RESOURCE_POOL_TYPE_MAX,
+};
+
+struct ib_device;
+struct pid;
+struct match_token;
+
+#ifdef CONFIG_CGROUP_RDMA
+#define RDMACG_MAX_RESOURCE_INDEX (64)
+
+struct rdmacg_pool_info {
+	struct match_token *resource_table;
+	int resource_count;
+};
+
+struct rdmacg_resource_pool_ops {
+	struct rdmacg_pool_info*
+		(*get_resource_pool_tokens)(struct ib_device *);
+};
+
+/* APIs for RDMA/IB subsystem to publish when a device wants to
+ * participate in resource accounting
+ */
+void rdmacg_register_ib_device(struct ib_device *device);
+void rdmacg_unregister_ib_device(struct ib_device *device);
+
+/* APIs for RDMA/IB subsystem to charge/uncharge pool specific resources */
+int rdmacg_try_charge_resource(struct ib_device *device,
+			       struct pid *pid,
+			       enum rdmacg_resource_pool_type type,
+			       int resource_index,
+			       int num);
+void rdmacg_uncharge_resource(struct ib_device *device,
+			      struct pid *pid,
+			      enum rdmacg_resource_pool_type type,
+			      int resource_index,
+			      int num);
+
+void rdmacg_set_rpool_ops(struct ib_device *device,
+			  enum rdmacg_resource_pool_type pool_type,
+			  struct rdmacg_resource_pool_ops *ops);
+void rdmacg_clear_rpool_ops(struct ib_device *device,
+			    enum rdmacg_resource_pool_type pool_type);
+int rdmacg_query_resource_limit(struct ib_device *device,
+				struct pid *pid,
+				enum rdmacg_resource_pool_type type,
+				int *limits, int max_count);
+#else
+/* APIs for RDMA/IB subsystem to charge/uncharge device specific resources */
+static inline
+int rdmacg_try_charge_resource(struct ib_device *device,
+			       struct pid *pid,
+			       enum rdmacg_resource_pool_type type,
+			       int resource_index,
+			       int num)
+{ return 0; }
+
+static inline void rdmacg_uncharge_resource(struct ib_device *device,
+					    struct pid *pid,
+					    enum rdmacg_resource_pool_type type,
+					    int resource_index,
+					    int num)
+{ }
+
+static inline
+int rdmacg_query_resource_limit(struct ib_device *device,
+				struct pid *pid,
+				enum rdmacg_resource_pool_type type,
+				int *limits, int max_count)
+{
+	int i;
+
+	for (i = 0; i < max_count; i++)
+		limits[i] = S32_MAX;
+
+	return 0;
+}
+#endif	/* CONFIG_CGROUP_RDMA */
+#endif	/* _CGROUP_RDMA_H */
-- 
1.8.3.1

