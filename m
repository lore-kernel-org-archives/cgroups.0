From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpuset: fix a regression in validating config change
Date: Wed, 21 Aug 2013 08:45:58 -0400
Message-ID: <20130821124558.GA19286@mtj.dyndns.org>
References: <52142464.1060603@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Zt+xKiA7B+yBLRd+tN79uwRfpnQwjASKpO36OIXO6ZM=;
        b=Qog9Zk9n2CHIcRa1tfmV1V+1k7HvPANR4cWKJSG1q57nJHsoCD5UBFJEuPm2XelRAq
         ToZtoL3gf4ArlAm9dkMjSjcbIQEta2TsGI5E2yqN8vBN91T48zNr5t66z5PgXWc46UNq
         y3U09nUfCMSFaegOMvvy9IxfHYo0TY57YXBLI9QUYHwItzMhzyjqzZO9HxcxPJQxOqOd
         gt1O8xQmtIuDWWVlFzAXqor3g1CP4l9bK7g5VDTMzZsr97kjV1Ah/c4/uO9a3acWNR8O
         iVNqySewTrXp/h6hVjClTRrrTj6lz/MUDJ9+puk6e7W6XE7x19lzF3SLuAhskqHJVVaQ
         EVDQ==
Content-Disposition: inline
In-Reply-To: <52142464.1060603@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hello, Li.

I dropped the make_*_empty variables and just put the conditionals
directly inside the outer if.  Please scream if I messed it up.
Applied to cgroup/for-3.11-fixes.

Thanks.

------- 8< --------
From 1c09b195d37fa459844036f429a0f378e70c3db6 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan@huawei.com>
Date: Wed, 21 Aug 2013 10:22:28 +0800
Subject: [PATCH] cpuset: fix a regression in validating config change

It's not allowed to clear masks of a cpuset if there're tasks in it,
but it's broken:

  # mkdir /cgroup/sub
  # echo 0 > /cgroup/sub/cpuset.cpus
  # echo 0 > /cgroup/sub/cpuset.mems
  # echo $$ > /cgroup/sub/tasks
  # echo > /cgroup/sub/cpuset.cpus
  (should fail)

This bug was introduced by commit 88fa523bff295f1d60244a54833480b02f775152
("cpuset: allow to move tasks to empty cpusets").

tj: Dropped temp bool variables and nestes the conditionals directly.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cpuset.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 010a008..ea1966d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -475,13 +475,17 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 
 	/*
 	 * Cpusets with tasks - existing or newly being attached - can't
-	 * have empty cpus_allowed or mems_allowed.
+	 * be changed to have empty cpus_allowed or mems_allowed.
 	 */
 	ret = -ENOSPC;
-	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress) &&
-	    (cpumask_empty(trial->cpus_allowed) &&
-	     nodes_empty(trial->mems_allowed)))
-		goto out;
+	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress)) {
+		if (!cpumask_empty(cur->cpus_allowed) &&
+		    cpumask_empty(trial->cpus_allowed))
+			goto out;
+		if (!nodes_empty(cur->mems_allowed) &&
+		    nodes_empty(trial->mems_allowed))
+			goto out;
+	}
 
 	ret = 0;
 out:
-- 
1.8.3.1
