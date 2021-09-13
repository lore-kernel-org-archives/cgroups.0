From: yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v1] vmpressure: wake up work only when there is registration event
Date: Mon, 13 Sep 2021 08:54:01 -0700
Message-ID: <1631548441-2784-1-git-send-email-wang.yong12@zte.com.cn>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id;
        bh=y/l6pZsY0+2abPXmYytXZzrEUxa84oSBx60olTgQf5E=;
        b=mySNaluwtOtRo928O2znR/NiPO5G6dqZfvoJdPmgWCMzUgffI575v5P84+CHHB0Vfl
         DdzelrBd3luKHRw23f4nlwsau96M4VKeCeePlQ381ozCkE2Q93w+7C8hHj9CjM3PJcpR
         tWXVkRQzMnbron3nqCIfSDXucVPzZbtf3/TzXvE5dKu4fJ0IpmRfYgXO5HS7iTeEY3Xj
         Pm2AYeBFlsxuceo0EjeJBuTL8OOsgePonPmKHpvzZhro/p9GixF6BZBcXiK8Mzs7Dwtg
         lob1qjaliO8X4iXY3XGpzpTvPx9X70z8BJeQCYPBZv2/Tt+HCnwbBdQUVDTQz050SALw
         1Bzg==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

From: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Use the global variable num_events to record the number of vmpressure
events registered by the system, and wake up work only when there is
registration event.
Usually, the vmpressure event is not registered in the system, this patch
can avoid waking up work and doing nothing.

Refer to Michal Hocko's suggestion:
https://lore.kernel.org/linux-mm/YR%2FNRJEhPKRQ1r22-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org/

Tested-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
---
 mm/vmpressure.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 76518e4..dfac76b 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -67,6 +67,11 @@ static const unsigned int vmpressure_level_critical = 95;
  */
 static const unsigned int vmpressure_level_critical_prio = ilog2(100 / 10);
 
+/*
+ * Count the number of vmpressure events registered in the system.
+ */
+static atomic_t num_events = ATOMIC_INIT(0);
+
 static struct vmpressure *work_to_vmpressure(struct work_struct *work)
 {
 	return container_of(work, struct vmpressure, work);
@@ -277,7 +282,7 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 		vmpr->tree_reclaimed += reclaimed;
 		spin_unlock(&vmpr->sr_lock);
 
-		if (scanned < vmpressure_win)
+		if (scanned < vmpressure_win || atomic_read(&num_events) == 0)
 			return;
 		schedule_work(&vmpr->work);
 	} else {
@@ -407,6 +412,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
 	mutex_lock(&vmpr->events_lock);
 	list_add(&ev->node, &vmpr->events);
 	mutex_unlock(&vmpr->events_lock);
+	atomic_add(1, &num_events);
 	ret = 0;
 out:
 	kfree(spec_orig);
@@ -435,6 +441,7 @@ void vmpressure_unregister_event(struct mem_cgroup *memcg,
 		if (ev->efd != eventfd)
 			continue;
 		list_del(&ev->node);
+		atomic_sub(1, &num_events);
 		kfree(ev);
 		break;
 	}
-- 
2.7.4

