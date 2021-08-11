From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH] cgroup: cgroup-v1: clean up kernel-doc notation
Date: Tue, 10 Aug 2021 17:03:49 -0700
Message-ID: <20210811000349.32645-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=oEMWLoJ15XGTU1uDxOZTCeL7G0nFB55u5+5nltWOW/w=; b=mow1pUdqDHxWhPTLIo9hCoo34w
        SAo9lQlbuzaQI5wjDic//GPlEVhLzWGU8B4EEG0FiwKpS+p+uha7f4sqhOv4yx9ocWp1Lf7SVSwwp
        hlv3Ijmyap8sBxBmDMHSGwD63dy+Rk7sY5Bv9HqWr6jjno4AxFlDKZWoYxCLfF9mphlOHp56H23az
        //tRCYlw9XLhGeCYNLAEs3qL3GSQqO8zqQixzAsRgbu1z5AcTDzb11PpEEFgKVwAdpUB+g/35Ayvj
        CV/QW18zmB7KrBpnq3zl4y/1jhT1S1OaGvr33ceh5JryBCowDnEdbNRt+fVAJW3SRyFVa+uNmyMxL
        97Bfe2Wg==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Fix kernel-doc warnings found in cgroup-v1.c:

kernel/cgroup/cgroup-v1.c:55: warning: No description found for return value of 'cgroup_attach_task_all'
kernel/cgroup/cgroup-v1.c:94: warning: expecting prototype for cgroup_trasnsfer_tasks(). Prototype was for cgroup_transfer_tasks() instead
cgroup-v1.c:96: warning: No description found for return value of 'cgroup_transfer_tasks'
kernel/cgroup/cgroup-v1.c:687: warning: No description found for return value of 'cgroupstats_build'

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 kernel/cgroup/cgroup-v1.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-next-20210809.orig/kernel/cgroup/cgroup-v1.c
+++ linux-next-20210809/kernel/cgroup/cgroup-v1.c
@@ -50,6 +50,8 @@ bool cgroup1_ssid_disabled(int ssid)
  * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
  * @from: attach to all cgroups of a given task
  * @tsk: the task to be attached
+ *
+ * Return: %0 on success or a negative errno code on failure
  */
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 {
@@ -80,7 +82,7 @@ int cgroup_attach_task_all(struct task_s
 EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
 
 /**
- * cgroup_trasnsfer_tasks - move tasks from one cgroup to another
+ * cgroup_transfer_tasks - move tasks from one cgroup to another
  * @to: cgroup to which the tasks will be moved
  * @from: cgroup in which the tasks currently reside
  *
@@ -89,6 +91,8 @@ EXPORT_SYMBOL_GPL(cgroup_attach_task_all
  * is guaranteed to be either visible in the source cgroup after the
  * parent's migration is complete or put into the target cgroup.  No task
  * can slip out of migration through forking.
+ *
+ * Return: %0 on success or a negative errno code on failure
  */
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 {
@@ -682,6 +686,8 @@ int proc_cgroupstats_show(struct seq_fil
  *
  * Build and fill cgroupstats so that taskstats can export it to user
  * space.
+ *
+ * Return: %0 on success or a negative errno code on failure
  */
 int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 {
