From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH] cpuset: update MAINTAINERS entry
Date: Tue, 28 Jan 2014 11:29:09 +0800
Message-ID: <52E72405.7070402@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Add mailing list and tree tag to the entry.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8285ed4..81bcbe0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2376,8 +2376,10 @@ F:	tools/power/cpupower/
 
 CPUSETS
 M:	Li Zefan <lizefan@huawei.com>
+L:	cgroups@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
 F:	Documentation/cgroups/cpusets.txt
 F:	include/linux/cpuset.h
-- 
1.8.0.2
