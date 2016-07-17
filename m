From: Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH 1/2] cgroup_pids: highwater mark of pids
Date: Sun, 17 Jul 2016 23:03:37 +0300
Message-ID: <1468785820-3960-2-git-send-email-toiwoton@gmail.com>
References: <1468785820-3960-1-git-send-email-toiwoton@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eS0T5mdFzyk1zXbye+t8oSkGVV14yMYqRORcAfZgtBU=;
        b=k3QbAaGomdCcUvPNF3AtkkmlhnckI9V0sHhPwMlZTqcRW9Fr+RdAMV1uhLNR5KoE/Y
         HfG0JHDWPc20Od5Hh2z2oa3zjMY1gUMfTyWoJB5wSOd4svUgzApy7t+VffyMgnv3q276
         E3M42ee62g9wszlVlf2/dzFpq+SjUQIGdb4nt7IlOZFP+PgnV5pjUEv33WOVluyeVUuU
         XuA/ypRYFwWlqElbSlqAn0ANMnnBAir+njqZmXhkVXmm8tHXl4zusnEuDOTas4fkgvdR
         +BwCrIYs4j9TxPZO2+L+Tfesw0ZvRR1UZ23UwxjwLIn+25RPdH6o3JC50TS//5wwDXg2
         Mi+g==
In-Reply-To: <1468785820-3960-1-git-send-email-toiwoton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Topi Miettinen <toiwoton@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>

Track maximum number of processes in cgroup, to be able to configure
cgroup pids limits. The information is available in cgroup FS as file
pids.highwater_mark.

Example case demonstrating how to use the figure for systemd configuration:
root@debian:~# cat /sys/fs/cgroup/system.slice/systemd-timesyncd.service/pids.highwater_mark
2
root@debian:~# cat /etc/systemd/system/systemd-timesyncd.service.d/local.conf
[Service]
TasksMax=2
root@debian:~# systemctl status systemd-timesyncd.service | grep Tasks
    Tasks: 2 (limit: 2)

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 kernel/cgroup_pids.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index 303097b..da5a696 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -48,6 +48,7 @@ struct pids_cgroup {
 	 * %PIDS_MAX = (%PID_MAX_LIMIT + 1).
 	 */
 	atomic64_t			counter;
+	atomic64_t			highwater_mark;
 	int64_t				limit;
 };
 
@@ -72,6 +73,7 @@ pids_css_alloc(struct cgroup_subsys_state *parent)
 
 	pids->limit = PIDS_MAX;
 	atomic64_set(&pids->counter, 0);
+	atomic64_set(&pids->highwater_mark, 0);
 	return &pids->css;
 }
 
@@ -80,6 +82,25 @@ static void pids_css_free(struct cgroup_subsys_state *css)
 	kfree(css_pids(css));
 }
 
+static void pids_update_highwater_mark(struct pids_cgroup *p)
+{
+	while (1) {
+		int64_t old_mark, new_mark, cur_mark;
+
+		old_mark = atomic64_read(&p->highwater_mark);
+		new_mark = atomic64_read(&p->counter);
+		if (old_mark >= new_mark)
+			return;
+		cur_mark = atomic64_cmpxchg(&p->highwater_mark, old_mark,
+					    new_mark);
+
+		/* It's OK if the counter was decreased meanwhile */
+		if (cur_mark == old_mark &&
+		    atomic64_read(&p->counter) <= new_mark)
+			return;
+	}
+}
+
 /**
  * pids_cancel - uncharge the local pid count
  * @pids: the pid cgroup state
@@ -106,8 +127,10 @@ static void pids_uncharge(struct pids_cgroup *pids, int num)
 {
 	struct pids_cgroup *p;
 
-	for (p = pids; parent_pids(p); p = parent_pids(p))
+	for (p = pids; parent_pids(p); p = parent_pids(p)) {
 		pids_cancel(p, num);
+		pids_update_highwater_mark(p);
+	}
 }
 
 /**
@@ -123,8 +146,10 @@ static void pids_charge(struct pids_cgroup *pids, int num)
 {
 	struct pids_cgroup *p;
 
-	for (p = pids; parent_pids(p); p = parent_pids(p))
+	for (p = pids; parent_pids(p); p = parent_pids(p)) {
 		atomic64_add(num, &p->counter);
+		pids_update_highwater_mark(p);
+	}
 }
 
 /**
@@ -152,6 +177,7 @@ static int pids_try_charge(struct pids_cgroup *pids, int num)
 			goto revert;
 	}
 
+	pids_update_highwater_mark(p);
 	return 0;
 
 revert:
@@ -236,6 +262,13 @@ static void pids_free(struct task_struct *task)
 	pids_uncharge(pids, 1);
 }
 
+static void pids_fork(struct task_struct *task)
+{
+	struct pids_cgroup *pids = css_pids(task_css(task, pids_cgrp_id));
+
+	pids_update_highwater_mark(pids);
+}
+
 static ssize_t pids_max_write(struct kernfs_open_file *of, char *buf,
 			      size_t nbytes, loff_t off)
 {
@@ -288,6 +321,14 @@ static s64 pids_current_read(struct cgroup_subsys_state *css,
 	return atomic64_read(&pids->counter);
 }
 
+static s64 pids_highwater_mark_read(struct cgroup_subsys_state *css,
+				    struct cftype *cft)
+{
+	struct pids_cgroup *pids = css_pids(css);
+
+	return atomic64_read(&pids->highwater_mark);
+}
+
 static struct cftype pids_files[] = {
 	{
 		.name = "max",
@@ -300,6 +341,11 @@ static struct cftype pids_files[] = {
 		.read_s64 = pids_current_read,
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
+	{
+		.name = "highwater_mark",
+		.read_s64 = pids_highwater_mark_read,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{ }	/* terminate */
 };
 
@@ -313,4 +359,5 @@ struct cgroup_subsys pids_cgrp_subsys = {
 	.free		= pids_free,
 	.legacy_cftypes	= pids_files,
 	.dfl_cftypes	= pids_files,
+	.fork		= pids_fork,
 };
-- 
2.8.1

