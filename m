From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 1/7] cgroup: fix a leak when percpu_ref_init() fails
Date: Wed, 31 Jul 2013 16:16:28 +0800
Message-ID: <51F8C7DC.8060306@huawei.com>
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

ss->css_free() is not called when perfcpu_ref_init() fails.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a64b7b8..e60eba2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4274,8 +4274,10 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		}
 
 		err = percpu_ref_init(&css->refcnt, css_release);
-		if (err)
+		if (err) {
+			ss->css_free(cgrp);
 			goto err_free_all;
+		}
 
 		init_cgroup_css(css, ss, cgrp);
 	}
-- 
1.8.0.2
