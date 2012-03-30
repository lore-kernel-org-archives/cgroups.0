From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [RFC 4/7] move res_counter_set limit to res_counter.c
Date: Fri, 30 Mar 2012 10:04:42 +0200
Message-ID: <1333094685-5507-5-git-send-email-glommer@parallels.com>
References: <1333094685-5507-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1333094685-5507-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Preparation patch. Function is about to get complication to be
inline. Move it to the main file for consistency.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 include/linux/res_counter.h |   17 ++---------------
 kernel/res_counter.c        |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index d4f3674..53b271c 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -188,21 +188,8 @@ static inline void res_counter_reset_failcnt(struct res_counter *cnt)
 	raw_spin_unlock_irqrestore(&cnt->usage_pcp.lock, flags);
 }
 
-static inline int res_counter_set_limit(struct res_counter *cnt,
-		unsigned long long limit)
-{
-	unsigned long flags;
-	int ret = -EBUSY;
-
-	raw_spin_lock_irqsave(&cnt->usage_pcp.lock, flags);
-	if (cnt->usage <= limit) {
-		cnt->limit = limit;
-		ret = 0;
-	}
-	raw_spin_unlock_irqrestore(&cnt->usage_pcp.lock, flags);
-	return ret;
-}
-
+int res_counter_set_limit(struct res_counter *cnt,
+			  unsigned long long limit);
 static inline int
 res_counter_set_soft_limit(struct res_counter *cnt,
 				unsigned long long soft_limit)
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 70c46c9..052efaf 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -111,6 +111,20 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val)
 	local_irq_restore(flags);
 }
 
+int res_counter_set_limit(struct res_counter *cnt,
+			  unsigned long long limit)
+{
+	unsigned long flags;
+	int ret = -EBUSY;
+
+	raw_spin_lock_irqsave(&cnt->usage_pcp.lock, flags);
+	if (cnt->usage <= limit) {
+		cnt->limit = limit;
+		ret = 0;
+	}
+	raw_spin_unlock_irqrestore(&cnt->usage_pcp.lock, flags);
+	return ret;
+}
 
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
-- 
1.7.4.1
