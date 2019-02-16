From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: [PATCH] doc: cgroup: correct the wrong information about measure of memory pressure
Date: Sat, 16 Feb 2019 08:56:04 +0800
Message-ID: <1550278564-81540-1-git-send-email-yang.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, hannes@cmpxchg.org, corbet@lwn.net
Cc: yang.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Since PSI has implemented some kind of measure of memory pressure, the
statement about lack of such measure is not true anymore.

Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7bf3f12..9a92013 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1310,8 +1310,7 @@ network to a file can use all available memory but can also operate as
 performant with a small amount of memory.  A measure of memory
 pressure - how much the workload is being impacted due to lack of
 memory - is necessary to determine whether a workload needs more
-memory; unfortunately, memory pressure monitoring mechanism isn't
-implemented yet.
+memory.
 
 
 Memory Ownership
-- 
1.8.3.1

