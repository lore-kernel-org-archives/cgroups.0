From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RESEND, PATCH] memcg: make threshold index in the right position
Date: Mon, 12 Mar 2012 15:56:45 +0800
Message-ID: <1331539005-16216-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=L8kv+W1izzP9imIexonZhGE7AcH9HbKls/HNLyZdBqQ=;
        b=Wx/4uc0WELLc5OdWjFuKwFcSouyvqBthGO953Bo9i5Nd1X6LAApjYKK1tgixVRX+NE
         1+Nk5L+TifE/sOOlYYKGQSi7pGY4t4ac1hDKySCj7jz09VN5QFfYGQP/RC9mtK0hJ/Gx
         WN94FVnZ2DPG3GCa+hNODnjqx8R0LBVWDd4P55uFtQ2yzy0xZOpKcxARhl4g/+hBDg0V
         Mzdzy2Uge54d6EX+0L0hrZxGQaT2WswMaqnWopLlS9WHRQSjjqsBzyaBgN9HDd27z6Mh
         eSiQfWjG5LBmp8h8br33tnjiOJ+LJbI1Y7IF0SE5bHFBTb6aIOgZdMWNpnSXCdvBFDvN
         8jeA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Index current_threshold may point to threshold that just equal to
usage after last call of __mem_cgroup_threshold. But after registering
or unregistering a new event, it will change (pointing to threshold 
just below usage). So make it consistent here.

For example:
now:
        threshold array:  3  [5]  7  9   (usage = 6, [index] = 5)

next turn (after calling __mem_cgroup_threshold):
        threshold array:  3   5  [7]  9   (usage = 7, [index] = 7)

after registering a new event (threshold = 10):
        threshold array:  3  [5]  7  9  10 (usage = 7, [index] = 5)

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Reviewed-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

---
 mm/memcontrol.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22d94f5..34737b7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -183,7 +183,7 @@ struct mem_cgroup_threshold {
 
 /* For threshold */
 struct mem_cgroup_threshold_ary {
-	/* An array index points to threshold just below usage. */
+	/* An array index points to threshold just below or equal to usage. */
 	int current_threshold;
 	/* Size of entries[] */
 	unsigned int size;
@@ -4193,7 +4193,7 @@ static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 	usage = mem_cgroup_usage(memcg, swap);
 
 	/*
-	 * current_threshold points to threshold just below usage.
+	 * current_threshold points to threshold just below or equal to usage.
 	 * If it's not true, a threshold was crossed after last
 	 * call of __mem_cgroup_threshold().
 	 */
@@ -4319,14 +4319,15 @@ static int mem_cgroup_usage_register_event(struct cgroup *cgrp,
 	/* Find current threshold */
 	new->current_threshold = -1;
 	for (i = 0; i < size; i++) {
-		if (new->entries[i].threshold < usage) {
+		if (new->entries[i].threshold <= usage) {
 			/*
 			 * new->current_threshold will not be used until
 			 * rcu_assign_pointer(), so it's safe to increment
 			 * it here.
 			 */
 			++new->current_threshold;
-		}
+		} else
+			break;
 	}
 
 	/* Free old spare buffer and save old primary buffer as spare */
@@ -4398,7 +4399,7 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
 			continue;
 
 		new->entries[j] = thresholds->primary->entries[i];
-		if (new->entries[j].threshold < usage) {
+		if (new->entries[j].threshold <= usage) {
 			/*
 			 * new->current_threshold will not be used
 			 * until rcu_assign_pointer(), so it's safe to increment
-- 
1.7.4.1
