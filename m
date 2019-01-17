From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next] IB/core: Simplify rdma cgroup registration
Date: Thu, 17 Jan 2019 20:14:15 +0200
Message-ID: <20190117181415.28566-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547748881;
        bh=YUoXJ+YfyP/8CGhuS8JfQatsoIOW6rsIMgb+J5JGTzs=;
        h=From:To:Cc:Subject:Date:From;
        b=kbow17SJotJvNv252MQbz3snEhJum36zCrwT4c+vZ9RFItrJkEMg0p3gbQKX8rhcL
         bLjFQRw1wpsn3aeGLvbew50xnyobZulWlImeLMkqYhheZTZ2iwOOukyzTY3mPq0Pkz
         ky3Odhac+Nl71qzhpyupEEaAw5P6Wy7rOS6xC9Gc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Parav Pandit <parav@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>

From: Parav Pandit <parav@mellanox.com>

RDMA cgroup registration routine always returns success,
so simplify function to be void and run clang formatter
over whole CONFIG_CGROUP_RDMA art of core_priv.h.

This reduces unwinding error path for regular registration and
future net namespace change functionality for rdma device.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
----
Sorry for resend, now with relevant people in TO and CC
---
 drivers/infiniband/core/cgroup.c    |  5 ++---
 drivers/infiniband/core/core_priv.h | 17 +++++++++++------
 drivers/infiniband/core/device.c    |  8 +-------
 include/linux/cgroup_rdma.h         |  2 +-
 kernel/cgroup/rdma.c                |  5 +----
 5 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/cgroup.c b/drivers/infiniband/core/cgroup.c
index 126ac5f99db7..388fd04e5f63 100644
--- a/drivers/infiniband/core/cgroup.c
+++ b/drivers/infiniband/core/cgroup.c
@@ -21,12 +21,11 @@
  * Register with the rdma cgroup. Should be called before
  * exposing rdma device to user space applications to avoid
  * resource accounting leak.
- * Returns 0 on success or otherwise failure code.
  */
-int ib_device_register_rdmacg(struct ib_device *device)
+void ib_device_register_rdmacg(struct ib_device *device)
 {
 	device->cg_device.name = device->name;
-	return rdmacg_register_device(&device->cg_device);
+	rdmacg_register_device(&device->cg_device);
 }

 /**
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index a3d14cb1f9d1..cda2db1add39 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -115,7 +115,7 @@ void ib_cache_cleanup_one(struct ib_device *device);
 void ib_cache_release_one(struct ib_device *device);

 #ifdef CONFIG_CGROUP_RDMA
-int ib_device_register_rdmacg(struct ib_device *device);
+void ib_device_register_rdmacg(struct ib_device *device);
 void ib_device_unregister_rdmacg(struct ib_device *device);

 int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
@@ -126,21 +126,26 @@ void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
 			struct ib_device *device,
 			enum rdmacg_resource_type resource_index);
 #else
-static inline int ib_device_register_rdmacg(struct ib_device *device)
-{ return 0; }
+static inline void ib_device_register_rdmacg(struct ib_device *device)
+{
+}

 static inline void ib_device_unregister_rdmacg(struct ib_device *device)
-{ }
+{
+}

 static inline int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
 				       struct ib_device *device,
 				       enum rdmacg_resource_type resource_index)
-{ return 0; }
+{
+	return 0;
+}

 static inline void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
 				      struct ib_device *device,
 				      enum rdmacg_resource_type resource_index)
-{ }
+{
+}
 #endif

 static inline bool rdma_is_upper_dev_rcu(struct net_device *dev,
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index fe06c65e8039..f8e6b13fd6a6 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -605,12 +605,7 @@ int ib_register_device(struct ib_device *device, const char *name)

 	device->index = __dev_new_index();

-	ret = ib_device_register_rdmacg(device);
-	if (ret) {
-		dev_warn(&device->dev,
-			 "Couldn't register device with rdma cgroup\n");
-		goto dev_cleanup;
-	}
+	ib_device_register_rdmacg(device);

 	ret = ib_device_register_sysfs(device);
 	if (ret) {
@@ -633,7 +628,6 @@ int ib_register_device(struct ib_device *device, const char *name)

 cg_cleanup:
 	ib_device_unregister_rdmacg(device);
-dev_cleanup:
 	cleanup_device(device);
 out:
 	mutex_unlock(&device_mutex);
diff --git a/include/linux/cgroup_rdma.h b/include/linux/cgroup_rdma.h
index e94290b29e99..ef1bae2983f3 100644
--- a/include/linux/cgroup_rdma.h
+++ b/include/linux/cgroup_rdma.h
@@ -39,7 +39,7 @@ struct rdmacg_device {
  * APIs for RDMA/IB stack to publish when a device wants to
  * participate in resource accounting
  */
-int rdmacg_register_device(struct rdmacg_device *device);
+void rdmacg_register_device(struct rdmacg_device *device);
 void rdmacg_unregister_device(struct rdmacg_device *device);

 /* APIs for RDMA/IB stack to charge/uncharge pool specific resources */
diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
index d3bbb757ee49..1d75ae7f1cb7 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -313,10 +313,8 @@ EXPORT_SYMBOL(rdmacg_try_charge);
  * If IB stack wish a device to participate in rdma cgroup resource
  * tracking, it must invoke this API to register with rdma cgroup before
  * any user space application can start using the RDMA resources.
- * Returns 0 on success or EINVAL when table length given is beyond
- * supported size.
  */
-int rdmacg_register_device(struct rdmacg_device *device)
+void rdmacg_register_device(struct rdmacg_device *device)
 {
 	INIT_LIST_HEAD(&device->dev_node);
 	INIT_LIST_HEAD(&device->rpools);
@@ -324,7 +322,6 @@ int rdmacg_register_device(struct rdmacg_device *device)
 	mutex_lock(&rdmacg_mutex);
 	list_add_tail(&device->dev_node, &rdmacg_devices);
 	mutex_unlock(&rdmacg_mutex);
-	return 0;
 }
 EXPORT_SYMBOL(rdmacg_register_device);

--
2.19.1

