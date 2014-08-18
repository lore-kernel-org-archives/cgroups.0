From: Alban Crequy <alban.crequy@collabora.co.uk>
Subject: [PATCH v2] cgroup: reject cgroup names with '\n'
Date: Mon, 18 Aug 2014 12:20:20 +0100
Message-ID: <1408360820-3390-1-git-send-email-alban.crequy@collabora.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alban Crequy <alban.crequy@collabora.co.uk>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>

/proc/<pid>/cgroup contains one cgroup path on each line. If cgroup names are
allowed to contain "\n", applications cannot parse /proc/<pid>/cgroup safely.

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
---
v2: Fixed according to comments from Tejun Heo: only reject '\n'

 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7dc8788..c3d1802 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4543,6 +4543,11 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	struct cftype *base_files;
 	int ssid, ret;
 
+	/* Do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable.
+	 */
+	if (strchr(name, '\n'))
+		return -EINVAL;
+
 	parent = cgroup_kn_lock_live(parent_kn);
 	if (!parent)
 		return -ENODEV;
-- 
1.8.5.3
