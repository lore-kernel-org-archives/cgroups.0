From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 97/99] xen: Convert pvcalls-back to XArray
Date: Wed, 17 Jan 2018 12:22:01 -0800
Message-ID: <20180117202203.19756-98-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Bt/rnehbKpwpk7lM0ZjKmbl49bvX+n22oI0358e1SLE=; b=oj9EyZvdex6hB/oYfI5uOTjU7
        l+4gPwaG64vXR04mWPNPez3hllT66PEZsvMyO2KLOa/0lK0PMOmYS1eiJ96LYSmVmxWu880AlJdfu
        s5WiiP8LuMs4d6piFCHhTR9ZkZ0aDHCVu3jOTcZWmx1hdauiJNQ8Rs2XYdLdMrFkp0vqBCW1GiAhR
        JDT05yZShhIxDEfKBwysolJqBiAzACSSghwLS/RETDqjUF7XwUh5Do/a3q3TtfcAqfUbSlb4KPhB0
        39HroT9/I1aSCQKNv307aQhmBu9deIAjeM+nfSmGmWIcbreMm3+Xi/Rve5bq79MjIJ8xkaydBS456
    
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/xen/pvcalls-back.c | 51 ++++++++++++++--------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
index c7822d8078b9..e059d2e777e1 100644
--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -15,10 +15,10 @@
 #include <linux/inet.h>
 #include <linux/kthread.h>
 #include <linux/list.h>
-#include <linux/radix-tree.h>
 #include <linux/module.h>
 #include <linux/semaphore.h>
 #include <linux/wait.h>
+#include <linux/xarray.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_connection_sock.h>
@@ -50,7 +50,7 @@ struct pvcalls_fedata {
 	struct xen_pvcalls_back_ring ring;
 	int irq;
 	struct list_head socket_mappings;
-	struct radix_tree_root socketpass_mappings;
+	struct xarray socketpass_mappings;
 	struct semaphore socket_lock;
 };
 
@@ -492,10 +492,9 @@ static int pvcalls_back_release(struct xenbus_device *dev,
 			goto out;
 		}
 	}
-	mappass = radix_tree_lookup(&fedata->socketpass_mappings,
-				    req->u.release.id);
+	mappass = xa_load(&fedata->socketpass_mappings, req->u.release.id);
 	if (mappass != NULL) {
-		radix_tree_delete(&fedata->socketpass_mappings, mappass->id);
+		xa_erase(&fedata->socketpass_mappings, mappass->id);
 		up(&fedata->socket_lock);
 		ret = pvcalls_back_release_passive(dev, fedata, mappass);
 	} else
@@ -650,10 +649,8 @@ static int pvcalls_back_bind(struct xenbus_device *dev,
 	map->fedata = fedata;
 	map->id = req->u.bind.id;
 
-	down(&fedata->socket_lock);
-	ret = radix_tree_insert(&fedata->socketpass_mappings, map->id,
-				map);
-	up(&fedata->socket_lock);
+	ret = xa_err(xa_store(&fedata->socketpass_mappings, map->id, map,
+								GFP_KERNEL));
 	if (ret)
 		goto out;
 
@@ -689,9 +686,7 @@ static int pvcalls_back_listen(struct xenbus_device *dev,
 
 	fedata = dev_get_drvdata(&dev->dev);
 
-	down(&fedata->socket_lock);
-	map = radix_tree_lookup(&fedata->socketpass_mappings, req->u.listen.id);
-	up(&fedata->socket_lock);
+	map = xa_load(&fedata->socketpass_mappings, req->u.listen.id);
 	if (map == NULL)
 		goto out;
 
@@ -717,10 +712,7 @@ static int pvcalls_back_accept(struct xenbus_device *dev,
 
 	fedata = dev_get_drvdata(&dev->dev);
 
-	down(&fedata->socket_lock);
-	mappass = radix_tree_lookup(&fedata->socketpass_mappings,
-		req->u.accept.id);
-	up(&fedata->socket_lock);
+	mappass = xa_load(&fedata->socketpass_mappings, req->u.accept.id);
 	if (mappass == NULL)
 		goto out_error;
 
@@ -765,10 +757,7 @@ static int pvcalls_back_poll(struct xenbus_device *dev,
 
 	fedata = dev_get_drvdata(&dev->dev);
 
-	down(&fedata->socket_lock);
-	mappass = radix_tree_lookup(&fedata->socketpass_mappings,
-				    req->u.poll.id);
-	up(&fedata->socket_lock);
+	mappass = xa_load(&fedata->socketpass_mappings, req->u.poll.id);
 	if (mappass == NULL)
 		return -EINVAL;
 
@@ -960,7 +949,7 @@ static int backend_connect(struct xenbus_device *dev)
 	fedata->dev = dev;
 
 	INIT_LIST_HEAD(&fedata->socket_mappings);
-	INIT_RADIX_TREE(&fedata->socketpass_mappings, GFP_KERNEL);
+	xa_init(&fedata->socketpass_mappings);
 	sema_init(&fedata->socket_lock, 1);
 	dev_set_drvdata(&dev->dev, fedata);
 
@@ -984,9 +973,7 @@ static int backend_disconnect(struct xenbus_device *dev)
 	struct pvcalls_fedata *fedata;
 	struct sock_mapping *map, *n;
 	struct sockpass_mapping *mappass;
-	struct radix_tree_iter iter;
-	void **slot;
-
+	unsigned long index = 0;
 
 	fedata = dev_get_drvdata(&dev->dev);
 
@@ -996,18 +983,10 @@ static int backend_disconnect(struct xenbus_device *dev)
 		pvcalls_back_release_active(dev, fedata, map);
 	}
 
-	radix_tree_for_each_slot(slot, &fedata->socketpass_mappings, &iter, 0) {
-		mappass = radix_tree_deref_slot(slot);
-		if (!mappass)
-			continue;
-		if (radix_tree_exception(mappass)) {
-			if (radix_tree_deref_retry(mappass))
-				slot = radix_tree_iter_retry(&iter);
-		} else {
-			radix_tree_delete(&fedata->socketpass_mappings,
-					  mappass->id);
-			pvcalls_back_release_passive(dev, fedata, mappass);
-		}
+	xa_for_each(&fedata->socketpass_mappings, mappass, index, ULONG_MAX,
+			XA_PRESENT) {
+		xa_erase(&fedata->socketpass_mappings, index);
+		pvcalls_back_release_passive(dev, fedata, mappass);
 	}
 	up(&fedata->socket_lock);
 
-- 
2.15.1

