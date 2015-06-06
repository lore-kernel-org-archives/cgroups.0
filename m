From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v13 3/5] cgroup, block: implement task_get_css()
Date: Sat,  6 Jun 2015 10:02:16 +1000
Message-ID: <1433548938-32560-3-git-send-email-cyphar@cyphar.com>
References: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

Implement task_get_css() which find and pins the css for the specified
task and subsys.  As a task is always associated with an online css
for every subsystem except while the css_set update is propagating,
task_get_css() retries till css_tryget_online() succeeds.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 82319fb..a593e29 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -354,6 +354,31 @@ static inline struct cgroup_subsys_state *task_css(struct task_struct *task,
 }
 
 /**
+ * task_get_css - find and get the css for (task, subsys)
+ * @task: the target task
+ * @subsys_id: the target subsystem ID
+ *
+ * Find the css for the (@task, @subsys_id) combination, increment a
+ * reference on and return it.  This function is guaranteed to return a
+ * valid css.
+ */
+static inline struct cgroup_subsys_state *
+task_get_css(struct task_struct *task, int subsys_id)
+{
+	struct cgroup_subsys_state *css;
+
+	rcu_read_lock();
+	while (true) {
+		css = task_css(task, subsys_id);
+		if (likely(css_tryget_online(css)))
+			break;
+		cpu_relax();
+	}
+	rcu_read_unlock();
+	return css;
+}
+
+/**
  * task_css_is_root - test whether a task belongs to the root css
  * @task: the target task
  * @subsys_id: the target subsystem ID
-- 
2.4.2
