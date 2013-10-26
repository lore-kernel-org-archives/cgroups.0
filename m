From: Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 3/3] cgroups: remove calls to simple_kstrtoll
Date: Fri, 25 Oct 2013 19:33:13 -0700
Message-ID: <1382754793-8827-3-git-send-email-dwalker@fifo99.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 kernel/cgroup.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 41f71c3..bf8b891 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2276,7 +2276,7 @@ static ssize_t cgroup_write_X64(struct cgroup_subsys_state *css,
 {
 	char buffer[CGROUP_LOCAL_BUFFER_SIZE];
 	int retval = 0;
-	char *end;
+	int ret;
 
 	if (!nbytes)
 		return -EINVAL;
@@ -2287,13 +2287,15 @@ static ssize_t cgroup_write_X64(struct cgroup_subsys_state *css,
 
 	buffer[nbytes] = 0;     /* nul-terminate */
 	if (cft->write_u64) {
-		u64 val = simple_strtoull(strstrip(buffer), &end, 0);
-		if (*end)
+		u64 val;
+		ret = kstrtoull(strstrip(buffer), 0, &val);
+		if (ret != 0)
 			return -EINVAL;
 		retval = cft->write_u64(css, cft, val);
 	} else {
-		s64 val = simple_strtoll(strstrip(buffer), &end, 0);
-		if (*end)
+		s64 val;
+		ret = kstrtoll(strstrip(buffer), 0, &val);
+		if (ret != 0)
 			return -EINVAL;
 		retval = cft->write_s64(css, cft, val);
 	}
-- 
1.8.3.2
