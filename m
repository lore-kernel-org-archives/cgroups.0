From: Joe Perches <joe@perches.com>
Subject: [PATCH 23/27] cgroup: Remove use of seq_printf return value
Date: Sat, 21 Feb 2015 18:53:50 -0800
Message-ID: <bbe7b355b687cf112bfeed3bc5e2a9cdef8d9d50.1424573328.git.joe@perches.com>
References: <cover.1424573328.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1424573328.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 29a7b2c..e8c7e8c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4199,7 +4199,9 @@ static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
 
 static int cgroup_pidlist_show(struct seq_file *s, void *v)
 {
-	return seq_printf(s, "%d\n", *(int *)v);
+	seq_printf(s, "%d\n", *(int *)v);
+
+	return 0;
 }
 
 static u64 cgroup_read_notify_on_release(struct cgroup_subsys_state *css,
-- 
2.1.2
