From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH V3 08/10] cgroup: Constrain the addition of CPUs to a new CPUset
Date: Tue, 13 Feb 2018 13:32:45 -0700
Message-ID: <1518553967-20656-9-git-send-email-mathieu.poirier@linaro.org>
References: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oUUAzyuPxc2AWJT2EOSXQAEFlSz5Oal6yF3Vntlh3d8=;
        b=fhvNaP3VFNS+rKp8IezXtyq1ExfwA0JvnoeHnWOcdBYWAd9+76CSseGsgm/PHlqzvn
         tNSinUrTQ8VDhzOO7GUN2aCMgi2/Q+otsAcU9nj3To93RM6I+47a/zTHyQKdlX88xfYw
         qatqfzmWizXlTGteL+xWX+9YeyDoaP800lQf0=
In-Reply-To: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org
Cc: lizefan@huawei.com, mingo@redhat.com, rostedt@goodmis.org, claudio@evidence.eu.com, bristot@redhat.com, tommaso.cucinotta@santannapisa.it, juri.lelli@redhat.com, luca.abeni@santannapisa.it, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Care must be taken when CPUs are added to a new CPUset.  If an ancestor
of that set has its sched_load_balance flag switch off then the CPUs in
the new CPUset will be added to a new root domain.  If the ancestor also
had DL tasks those will end up covering more than one root domain,
breaking at the same time the DL integrity model.

This patch prevents adding CPUs to a new CPUset if one of its ancestor
had its sched_load_balance flag off and had DL tasks assigned to it.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 kernel/cgroup/cpuset.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4f5e8bac5337..4c1b71608c23 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -481,6 +481,43 @@ static bool cpuset_has_dl_tasks(struct cpuset *cs)
  * Assumes RCU read lock and cpuset_mutex are held.
  */
 static int
+validate_change_cpus(struct cpuset *cur, struct cpuset *trial)
+{
+	int ret = 0;
+
+	/*
+	 * CPUs are being added to a CPUset.  If any parent of @trial has its
+	 * sched_load_balance flag switched off this operation will create a
+	 * new root domain spanning trial->cpus_allowed. At the same time
+	 * if any parent of @trial has a DL task, that task will end up
+	 * spanning more than one root domain and break the deadline integrity
+	 * model.
+	 */
+	if (cpumask_weight(cur->cpus_allowed) <
+	    cpumask_weight(trial->cpus_allowed)) {
+		struct cpuset *parent;
+
+		parent = parent_cs(trial);
+		/* Go up until we reach the top_cpuset */
+		while (parent) {
+			if (cpuset_has_dl_tasks(parent) &&
+			    !is_sched_load_balance(parent)) {
+				ret = -EBUSY;
+				goto out;
+			}
+
+			parent = parent_cs(parent);
+		}
+	}
+
+out:
+	return ret;
+}
+
+/*
+ * Assumes RCU read lock and cpuset_mutex are held.
+ */
+static int
 validate_change_load_balance(struct cpuset *cur, struct cpuset *trial)
 {
 	bool populated = false, dl_tasks = false;
@@ -553,8 +590,11 @@ validate_dl_change(struct cpuset *cur, struct cpuset *trial)
 	/* Check if the sched_load_balance flag has been changed */
 	ret = validate_change_load_balance(cur, trial);
 	if (ret)
-		return ret;
+		goto out;
 
+	ret = validate_change_cpus(cur, trial);
+
+out:
 	return ret;
 }
 
-- 
2.7.4

