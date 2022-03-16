From: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH -next] block: Add parameter description in kernel-doc comment
Date: Wed, 16 Mar 2022 20:53:27 +0800
Message-ID: <20220316125327.126996-1-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Add the description of @ioprio_class in bfq_reparent_leaf_entity()
and bfq_reparent_active_queues() kernel-doc comment to remove
warning found by running scripts/kernel-doc, which is caused by
using 'make W=1'.

block/bfq-cgroup.c:848: warning: Function parameter or member
'ioprio_class' not described in 'bfq_reparent_leaf_entity'
block/bfq-cgroup.c:878: warning: Function parameter or member
'ioprio_class' not described in 'bfq_reparent_active_queues'

Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 block/bfq-cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 420eda2589c0..af92c2e5fd98 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -841,6 +841,7 @@ static void bfq_flush_idle_tree(struct bfq_service_tree *st)
  * @bfqd: the device data structure with the root group.
  * @entity: the entity to move, if entity is a leaf; or the parent entity
  *	    of an active leaf entity to move, if entity is not a leaf.
+ * @ioprio_class: the offset used to manipulate the service_tree
  */
 static void bfq_reparent_leaf_entity(struct bfq_data *bfqd,
 				     struct bfq_entity *entity,
@@ -870,6 +871,7 @@ static void bfq_reparent_leaf_entity(struct bfq_data *bfqd,
  * @bfqd: the device data structure with the root group.
  * @bfqg: the group to move from.
  * @st: the service tree to start the search from.
+ * @ioprio_class: the offset used to manipulate the service_tree
  */
 static void bfq_reparent_active_queues(struct bfq_data *bfqd,
 				       struct bfq_group *bfqg,
-- 
2.20.1.7.g153144c

