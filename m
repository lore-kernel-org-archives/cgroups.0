From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] cgroup: make interface file "cgroup.sane_behavior" legacy-only
Date: Wed,  2 Jul 2014 19:45:45 -0400
Message-ID: <1404344747-7957-3-git-send-email-tj@kernel.org>
References: <1404344747-7957-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wHRX9V14fqqZHLQTtbAqwAs27450eEiVsnF+0fmrwi8=;
        b=mLAdZinXgIc3u7lpOBNqSdKDZyU4EjKcq2G4jSUUkXONnpdD+V/AhquGGhC4pG2NAj
         fcjtKYVnRWm45vc3dHGl45VE0bBSc0FZ2RrV/qP/36wfqQmECiP5FV5uU30b7ohE0lQb
         SWNO31tlBkYAYgTjfboh1gngg0rb7XEQDqlnwKXpTbd/LXt4kyxUf42zT187Z2UIyU6p
         BdtwTmetq0H5Z7o8sdPXHPhe3VMOwUFStpvdh5SRZYT1wMYQDvZz7KKO25jEQbcgnOHs
         t31mOpVO3U26s+1XzztbKBs367fbyUnMxqzkN1XdwUWbnX/1CUgGAQNops4BwkWEgj2r
         4crw==
In-Reply-To: <1404344747-7957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

"cgroup.sane_behavior" is added to help distinguishing whether
sane_behavior is in effect or not.  We now have the default hierarchy
where the flag is always in effect and are planning to remove
supporting sane behavior on the legacy hierarchies making this file on
the default hierarchy rather pointless.  Let's make it legacy only and
thus always zero.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e27f4d4..be701d9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2414,9 +2414,7 @@ static int cgroup_release_agent_show(struct seq_file *seq, void *v)
 
 static int cgroup_sane_behavior_show(struct seq_file *seq, void *v)
 {
-	struct cgroup *cgrp = seq_css(seq)->cgroup;
-
-	seq_printf(seq, "%d\n", cgroup_sane_behavior(cgrp));
+	seq_puts(seq, "0\n");
 	return 0;
 }
 
@@ -4016,7 +4014,7 @@ static struct cftype cgroup_base_files[] = {
 	},
 	{
 		.name = "cgroup.sane_behavior",
-		.flags = CFTYPE_ONLY_ON_ROOT,
+		.flags = CFTYPE_INSANE | CFTYPE_ONLY_ON_ROOT,
 		.seq_show = cgroup_sane_behavior_show,
 	},
 	{
-- 
1.9.3
