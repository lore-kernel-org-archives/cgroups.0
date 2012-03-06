From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH] memcg: Free spare array to avoid memory leak
Date: Tue,  6 Mar 2012 20:13:24 +0800
Message-ID: <1331036004-7550-1-git-send-email-handai.szj@taobao.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=U2UuEkRDF9/bwcw5Wqn5t3JeUbQU6JJbpCC6TOkxut4=;
        b=m3GqvLdPchAS1Auyx6eduMNoTtRpNt1GlUtSwooQ3gAR2o1mgHz41UW2GJQisEqHRR
         K+Sj2Dchc9SLm57yurwL5r3yK2NOpmJNrpIjg1G+jLTfOeCaaC5s/U4yhX2OhzLGIqor
         erjDkAYlSDIadjLtUXkbOlU9ClJK1p7Bmh3/NiXaZsV3IbhEU0i78kIML1o7SX80XxCa
         9dRWrPpUrUlb8Umn6qw/EcsU/BlL3mrR/4uvzvUtURozt6PHkt7Qdl9s9uMy/YR9adMn
         qCW26gROlg6ubEC4KuTDDYNWCJtdlkAAIaauMd2saVRrp0K3+z/4uSfpszXMGpHO5q7N
         8i7A==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

When the last event is unregistered, there is no need to keep the spare
array anymore. So free it to avoid memory leak.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

---
 mm/memcontrol.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22d94f5..3c09a84 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4412,6 +4412,12 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
 swap_buffers:
 	/* Swap primary and spare array */
 	thresholds->spare = thresholds->primary;
+	/* If all events are unregistered, free the spare array */
+	if (!new) {
+		kfree(thresholds->spare);
+		thresholds->spare = NULL;
+	}
+
 	rcu_assign_pointer(thresholds->primary, new);
 
 	/* To be sure that nobody uses thresholds */
-- 
1.7.4.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
