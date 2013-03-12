From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 5/8] cgroup: remove useless code in cgroup_write_event_control()
Date: Tue, 12 Mar 2013 14:50:58 +0800
Message-ID: <513ED052.7080907@huawei.com>
References: <513ED010.5060906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <513ED010.5060906@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

eventfd_poll() never returns POLLHUP.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 58ae040..3206137 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3938,12 +3938,6 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 	if (ret)
 		goto fail;
 
-	if (efile->f_op->poll(efile, &event->pt) & POLLHUP) {
-		event->cft->unregister_event(cgrp, event->cft, event->eventfd);
-		ret = 0;
-		goto fail;
-	}
-
 	/*
 	 * Events should be removed after rmdir of cgroup directory, but before
 	 * destroying subsystem state objects. Let's take reference to cgroup
-- 
1.8.0.2
