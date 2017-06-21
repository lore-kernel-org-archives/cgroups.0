From: Roman Gushchin <guro@fb.com>
Subject: [v3 1/6] mm, oom: use oom_victims counter to synchronize oom victim selection
Date: Wed, 21 Jun 2017 22:19:11 +0100
Message-ID: <1498079956-24467-2-git-send-email-guro@fb.com>
References: <1498079956-24467-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=lBmEEH/8J16gVDaGeVUhv4fng8WLg2xMm3SVkRzkBTM=;
 b=PDMfbC0D1MBO1VCAW588HCa7Poz+HPTjBfIvo2ZswZdFFxuYLrPbSb69/LReWVHcO26m
 O9GrxObzCnYUfVIzsNmUBnWT8GXCA8elkiJQDWwVxptgaf9XtqTJNE6F8GaFLxxtgPkT
 GJ9L0ygq5GzCGDwvWWKCumabeHQBJ2L0d30= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lBmEEH/8J16gVDaGeVUhv4fng8WLg2xMm3SVkRzkBTM=;
 b=Iro6FICLqZb9WIgdmyqXppJyEKUl9sQ94n4xH/FZze3akJqPsyTfaYVy/rxCKMuwnsCxbqKYBK2C/tf8vUl8Et3/Z92kGLI5zehPcsZ7DnY9s2cUESUglWRbUS2MNhwxSNqqRLjxJ2f7JHWWyKHAFDHdmv3Td4dVU5+AMpohDuo=
In-Reply-To: <1498079956-24467-1-git-send-email-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Oom killer should avoid unnecessary kills. To prevent them, during
the tasks list traverse we check for task which was previously
selected as oom victims. If there is such a task, new victim
is not selected.

This approach is sub-optimal (we're doing costly iteration over the task
list every time) and will not work for the cgroup-aware oom killer.

We already have oom_victims counter, which can be effectively used
for the task.

If there are victims in flight, don't do anything; if the counter
falls to 0, there are no more oom victims left.
So, it's a good time to start looking for a new victim.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/oom_kill.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0e2c925..e3aaf5c8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -992,6 +992,13 @@ bool out_of_memory(struct oom_control *oc)
 	if (oom_killer_disabled)
 		return false;
 
+	/*
+	 * If there are oom victims in flight, we don't need to select
+	 * a new victim.
+	 */
+	if (atomic_read(&oom_victims) > 0)
+		return true;
+
 	if (!is_memcg_oom(oc)) {
 		blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 		if (freed > 0)
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
