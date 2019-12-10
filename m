From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 244/350] cgroup: freezer: don't change task and cgroups status unnecessarily
Date: Tue, 10 Dec 2019 16:05:49 -0500
Message-ID: <20191210210735.9077-205-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012308;
        bh=tAbFYOoxcn51RpAMI0jKgF/Wshvkc/kFB0GWGJLeoG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6lpSmT7lRZteQcPbzSJgxrw2k8vooZf45pspkmzmQVY7tDEZLgHWyY3EYkEg4qxA
         2USyNP5vcmXhVFiPmQzqH8cZUpu8P163HJDAQXwN3OCpbOZ2HjAAeMSETsOlyDevOS
         8gjEHMS91QPIA2lKcTIGWR0aRDAsRN63XA5qc9D0=
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Honglei Wang <honglei.wang@oracle.com>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org

From: Honglei Wang <honglei.wang@oracle.com>

[ Upstream commit 742e8cd3e1ba6f19cad6d912f8d469df5557d0fd ]

It's not necessary to adjust the task state and revisit the state
of source and destination cgroups if the cgroups are not in freeze
state and the task itself is not frozen.

And in this scenario, it wakes up the task who's not supposed to be
ready to run.

Don't do the unnecessary task state adjustment can help stop waking
up the task without a reason.

Signed-off-by: Honglei Wang <honglei.wang@oracle.com>
Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/freezer.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
index 8cf0106806789..3984dd6b8ddbc 100644
--- a/kernel/cgroup/freezer.c
+++ b/kernel/cgroup/freezer.c
@@ -230,6 +230,15 @@ void cgroup_freezer_migrate_task(struct task_struct *task,
 	if (task->flags & PF_KTHREAD)
 		return;
 
+	/*
+	 * It's not necessary to do changes if both of the src and dst cgroups
+	 * are not freezing and task is not frozen.
+	 */
+	if (!test_bit(CGRP_FREEZE, &src->flags) &&
+	    !test_bit(CGRP_FREEZE, &dst->flags) &&
+	    !task->frozen)
+		return;
+
 	/*
 	 * Adjust counters of freezing and frozen tasks.
 	 * Note, that if the task is frozen, but the destination cgroup is not
-- 
2.20.1

