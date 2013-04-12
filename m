From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] memcg: force use_hierarchy if sane_behavior
Date: Fri, 12 Apr 2013 16:10:59 -0700
Message-ID: <1365808259-31073-5-git-send-email-tj@kernel.org>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=F/AiwxqjTnlYwuOIYffHvQP5G1jWErcoltPA9VyTpd4=;
        b=quGVC50F6Nb7gYWmo1F5U6sKjeUlTIyMSxtx9POCb9R+oc5n3Ul4cnfiVQqu/mYHoT
         iZ/gc3BVMTeMOL1Y1CVFyiXb+oMfJPXYaNNIDMKjguwmtqSlxgA8MYa+Y/H/QdUDv33y
         r417xOGYDNN3YYSZWZwFMPbtsHD+fX5wxcbhIqI+77K3ITfVwmYfWwjZc9zciFJ24TL2
         8E9P3cpgbcQQIqRVboom87/W/JOliKwWG9ztriv+liO5LseRkVG1X6PvbKQsoT97dzC3
         wyRRfYU4puGf9dn0nHjN/xrrHzYREfeinB+GRMGQDI32ULCrJWVGT6YewH2pUpT8at8r
         TuXg==
In-Reply-To: <1365808259-31073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org, glommer@parallels.com, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

Turn on use_hierarchy by default if sane_behavior is specified and
don't create .use_hierarchy file.

It is debatable whether to remove .use_hierarchy file or make it ro as
the former could make transition easier in certain cases; however, the
behavior changes which will be gated by sane_behavior are intensive
including changing basic meaning of certain control knobs in a few
controllers and I don't really think keeping this piece would make
things easier in any noticeable way, so let's remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/cgroup.h |  3 +++
 mm/memcontrol.c        | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9c300ad..c562e33 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -269,6 +269,9 @@ enum {
 	 *
 	 * - Remount is disallowed.
 	 *
+	 * - memcg: use_hierarchy is on by default and the cgroup file for
+	 *   the flag is not created.
+	 *
 	 * The followings are planned changes.
 	 *
 	 * - release_agent will be disallowed once replacement notification
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9715c0c..a651131 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5814,6 +5814,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "use_hierarchy",
+		.flags = CFTYPE_INSANE,
 		.write_u64 = mem_cgroup_hierarchy_write,
 		.read_u64 = mem_cgroup_hierarchy_read,
 	},
@@ -6784,6 +6785,17 @@ static void mem_cgroup_move_task(struct cgroup *cont,
 }
 #endif
 
+/*
+ * Cgroup retains root cgroups across [un]mount cycles making it necessary
+ * to verify sane_behavior flag on each mount attempt.
+ */
+static void mem_cgroup_bind(struct cgroup *root)
+{
+	/* use_hierarchy is forced with sane_behavior */
+	if (cgroup_sane_behavior(root))
+		mem_cgroup_from_cont(root)->use_hierarchy = true;
+}
+
 struct cgroup_subsys mem_cgroup_subsys = {
 	.name = "memory",
 	.subsys_id = mem_cgroup_subsys_id,
@@ -6794,6 +6806,7 @@ struct cgroup_subsys mem_cgroup_subsys = {
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.attach = mem_cgroup_move_task,
+	.bind = mem_cgroup_bind,
 	.base_cftypes = mem_cgroup_files,
 	.early_init = 0,
 	.use_id = 1,
-- 
1.8.1.4
