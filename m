From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 6/7] cgroup: rename current_css_set_cg_links
Date: Wed, 31 Jul 2013 16:18:07 +0800
Message-ID: <51F8C83F.6010407@huawei.com>
References: <51F8C7C5.9040608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51F8C7C5.9040608@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

As we've renamed css_set->cg_links to css_set->cgrp_links (See commit
69d0206c79 "cgroup: bring some sanity to naming around cg_cgroup_link"),
it's better to also rename the debug file.

As the "debug" cgroup subsystem is for debug only and acts as a sample
on how to write a cgroup subsystem, it's fine to change the interface.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ac77d87..89d63b0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5312,9 +5312,9 @@ static u64 current_css_set_refcount_read(struct cgroup *cgrp,
 	return count;
 }
 
-static int current_css_set_cg_links_read(struct cgroup *cgrp,
-					 struct cftype *cft,
-					 struct seq_file *seq)
+static int current_css_set_cgrp_links_read(struct cgroup *cgrp,
+					   struct cftype *cft,
+					   struct seq_file *seq)
 {
 	struct cgrp_cset_link *link;
 	struct css_set *cset;
@@ -5387,8 +5387,8 @@ static struct cftype debug_files[] =  {
 	},
 
 	{
-		.name = "current_css_set_cg_links",
-		.read_seq_string = current_css_set_cg_links_read,
+		.name = "current_css_set_cgrp_links",
+		.read_seq_string = current_css_set_cgrp_links_read,
 	},
 
 	{
-- 
1.8.0.2
