From: Matt Roper <matthew.d.roper@intel.com>
Subject: [PATCH 1/2] Documentation/cgroup-v1: fix outdated programming details
Date: Fri, 29 Dec 2017 12:01:59 -0800
Message-ID: <20171229200200.18873-1-matthew.d.roper@intel.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: Matt Roper <matthew.d.roper@intel.com>, Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org

The cgroup-v1 documentation is out of date in a few places:

 * cgroup controllers can no longer be compiled as modules since commit
   3ed80a6 ("cgroup: drop module support"); the functions and fields
   referenced here no longer exist.

 * Controllers need to create of a cgroup_subsys object named
   "<name>_cgrp_subsys" instead of "<name>_subsys" since commit
   073219e ("cgroup: clean up cgroup_subsys names and initialization")

Cc: Tejun Heo <tj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
---
 Documentation/cgroup-v1/cgroups.txt | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/Documentation/cgroup-v1/cgroups.txt b/Documentation/cgroup-v1/cgroups.txt
index 308e5ff..059f706 100644
--- a/Documentation/cgroup-v1/cgroups.txt
+++ b/Documentation/cgroup-v1/cgroups.txt
@@ -523,12 +523,7 @@ Accessing a task's cgroup pointer may be done in the following ways:
 Each subsystem should:
 
 - add an entry in linux/cgroup_subsys.h
-- define a cgroup_subsys object called <name>_subsys
-
-If a subsystem can be compiled as a module, it should also have in its
-module initcall a call to cgroup_load_subsys(), and in its exitcall a
-call to cgroup_unload_subsys(). It should also set its_subsys.module =
-THIS_MODULE in its .c file.
+- define a cgroup_subsys object called <name>_cgrp_subsys
 
 Each subsystem may export the following methods. The only mandatory
 methods are css_alloc/free. Any others that are null are presumed to
-- 
2.9.5

