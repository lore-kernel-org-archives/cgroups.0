From: Rami Rosen <rami.rosen@intel.com>
Subject: [PATCH] Documentation: cgroup v1: remove section about subsystem as a module.
Date: Thu, 14 Jan 2016 15:46:05 +0200
Message-ID: <1452779165-15567-1-git-send-email-rami.rosen@intel.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, Rami Rosen <rami.rosen@intel.com>

This patch removes the text relating to compiling cgroup as a module,
since commit  3ed80a62bf95 ("cgroup: drop module support") makes this text not
relevant anymore.

Signed-off-by: Rami Rosen <rami.rosen@intel.com>
---
 Documentation/cgroup-v1/cgroups.txt | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/cgroup-v1/cgroups.txt b/Documentation/cgroup-v1/cgroups.txt
index c6256ae..176f95e 100644
--- a/Documentation/cgroup-v1/cgroups.txt
+++ b/Documentation/cgroup-v1/cgroups.txt
@@ -525,11 +525,6 @@ Each subsystem should:
 - add an entry in linux/cgroup_subsys.h
 - define a cgroup_subsys object called <name>_subsys
 
-If a subsystem can be compiled as a module, it should also have in its
-module initcall a call to cgroup_load_subsys(), and in its exitcall a
-call to cgroup_unload_subsys(). It should also set its_subsys.module =
-THIS_MODULE in its .c file.
-
 Each subsystem may export the following methods. The only mandatory
 methods are css_alloc/free. Any others that are null are presumed to
 be successful no-ops.
-- 
2.4.3

