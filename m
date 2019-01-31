From: Andrea Parri <andrea.parri@amarulasolutions.com>
Subject: [PATCH] MAINTAINERS: Update cgroup entry
Date: Thu, 31 Jan 2019 15:22:19 +0100
Message-ID: <20190131142219.10175-1-andrea.parri@amarulasolutions.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=JIMo3w7sRDSl/keT71uYvTtuh4JE+UyImwPdfucCUkE=;
        b=G1BKxAbp2I4l6BcAvYlc3tr15PTmFxb6TK+igQETJs3Z974oXS6XYoIF7FDaeeETbo
         liUmbJQw5Z8JHHFEXjIM1recEd//z3F2feQ0kTxEnCAe9MhY+bLqnwdSjzfhTCmQvLZ7
         XAm84JWJtiz3frNJqQuzMFTyKC8FNJNrxkYuc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Andrea Parri <andrea.parri@amarulasolutions.com>

Fix wildcard patterns and add cgroup-v2 documentation.

Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
---
 MAINTAINERS | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9f64f8d3740ed..a96054c1d870a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3906,9 +3906,10 @@ M:	Johannes Weiner <hannes@cmpxchg.org>
 L:	cgroups@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
-F:	Documentation/cgroup*
+F:	Documentation/admin-guide/cgroup-v2.rst
+F:	Documentation/cgroup-v1/
 F:	include/linux/cgroup*
-F:	kernel/cgroup*
+F:	kernel/cgroup/
 
 CONTROL GROUP - CPUSET
 M:	Li Zefan <lizefan@huawei.com>
-- 
2.17.1

