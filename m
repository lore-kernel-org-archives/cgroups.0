From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH] cpuset: update MAINTAINERS
Date: Fri, 11 Jan 2013 17:29:17 +0800
Message-ID: <50EFDB6D.9070309@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Paul Menage <paul@paulmenage.org>

As Paul doesn't maintain cpusets anymore, I'll take over the
maintainership.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa309ab..d58bc12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2128,10 +2128,10 @@ S:	Maintained
 F:	tools/power/cpupower
 
 CPUSETS
-M:	Paul Menage <paul@paulmenage.org>
+M:	Li Zefan <lizefan@huawei.com>
 W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
-S:	Supported
+S:	Maintained
 F:	Documentation/cgroups/cpusets.txt
 F:	include/linux/cpuset.h
 F:	kernel/cpuset.c
-- 
1.8.0.2
