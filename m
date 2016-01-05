From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv1 2/6] IB/core: Added members to support rdma cgroup
Date: Wed,  6 Jan 2016 00:28:02 +0530
Message-ID: <1452020286-9508-3-git-send-email-pandit.parav@gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iQvaJPfAnVSdNJC6u0Iqtp++lFDv4Qy+bty9PvTsYC4=;
        b=saiV6sE4eMI481539rJywZvgTPGe/uxPfcUKUcK4EKHmkGA3tN2Bsk2O70ftlwtiuT
         KgDCdHkCZn6KSy815rOqVoK6DeqshuWikZW9mMnnk+xbxUQbAnr07etWknYi58D52HfU
         RspbNjuqzbvGMwawzpSEUPYKGyt+z7YD27kr9UUXQEO8CjJmrC54d48lVMgnp9ipuqxu
         CJlHpx/AFZ3SkJV64gG/wwSYacIbrwF6LZpkbzAKqokbieGgzLcrrAg3Iu9ZPUdKqwz/
         ZRIUmyi6X4oKLZkhXaGGBJruUK7CxuSGyb0tHKQP/ZO0EnSztYONUIbqYW6H0mf/QqpD
         SF+A==
In-Reply-To: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

Added function pointer table to store resource pool specific
operation for each resource type (verb and hw).
Added list node to link device to rdma cgroup so that it can
participate in resource accounting and limit configuration.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 include/rdma/ib_verbs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9a68a19..1a17249 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -51,6 +51,7 @@
 #include <linux/socket.h>
 #include <uapi/linux/if_ether.h>
 
+#include <linux/cgroup_rdma.h>
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
 #include <asm/uaccess.h>
@@ -1823,6 +1824,12 @@ struct ib_device {
 	u8                           node_type;
 	u8                           phys_port_cnt;
 
+#ifdef CONFIG_CGROUP_RDMA
+	struct rdmacg_resource_pool_ops
+				*rpool_ops[RDMACG_RESOURCE_POOL_TYPE_MAX];
+	struct list_head             rdmacg_list;
+#endif
+
 	/**
 	 * The following mandatory functions are used only at device
 	 * registration.  Keep functions such as these at the end of this
-- 
1.8.3.1
