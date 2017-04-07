From: Todd Poynor <toddpoynor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: move cgroup_subsys_state partner field for cache locality
Date: Thu,  6 Apr 2017 17:00:00 -0700
Message-ID: <1491523200-32174-1-git-send-email-todd@tjlinux.dyndns.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=COR6h7K1qZXqB7exmqqViqzrDNc2zV/dqJs9fh4RZD0=;
        b=Jo4xCacl7fp432iKvYOskRf8bV34jN85FJLTPUm4V+GlMjrtUhMLm7cEeEa+vcFIio
         2RoZ43Y9XsazsROxYFTuAmNTIQ75fA73xVeQl0NgiQyKev4sXRV5AB5s1lGnjU7fjx60
         S9qUFpDaEJmronvKd79mhlgcRB49wkM0XUrKiLJ4ZnpndMncNcmjdr32DyVWSYSjyhA8
         prMABFa8kFYv11YiJ8rQeh5BDfVg0kkq/MAtBi4l9xN/6cwkYgQtU46em5IXolIN+dAE
         40mQVQ3nQ8JoYyUtLwhKW5SHzcaNhgatszaitSv1r2uKpkEbQLg7jrqCNgQqpY14CYZV
         tF/Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Todd Poynor <toddpoynor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Todd Poynor <toddpoynor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Various structures embed a struct cgroup_subsys_state, typically at
the top of the containing structure.  It is common for code that
accesses the structures to perform operations that iterate over the
chain of parent css pointers, also accessing data in each containing
structure.  In particular, struct cpuacct is used by fairly hot code
paths in the scheduler such as cpuacct_charge().

Move the parent css pointer field to the end of the structure to
increase the chances of residing in the same cache line as the data
from the containing structure.

Signed-off-by: Todd Poynor <toddpoynor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup-defs.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

root_cpuacct fields .cpuusage and. css.parent show up as frequently-
accessed memory in separate cache lines (and usually the only thing
accessed in those cache lines until eviction) in armv8 simulations.
A quick search turned up struct blkcg, struct mem_cgroup, and
struct freezer as other examples using a similar struct layout and
access code.

Instead, could move the parent field to the top of css, and have hot
code paths use __cacheline_aligned with hot data prior to css... or
open to suggestions, thanks.

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 6a3f850cabab..53c698207ad0 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -106,9 +106,6 @@ struct cgroup_subsys_state {
 	/* reference count - access via css_[try]get() and css_put() */
 	struct percpu_ref refcnt;
 
-	/* PI: the parent css */
-	struct cgroup_subsys_state *parent;
-
 	/* siblings list anchored at the parent's ->children */
 	struct list_head sibling;
 	struct list_head children;
@@ -138,6 +135,12 @@ struct cgroup_subsys_state {
 	/* percpu_ref killing and RCU release */
 	struct rcu_head rcu_head;
 	struct work_struct destroy_work;
+
+	/*
+	 * PI: the parent css.	Placed here for cache proximity to following
+	 * fields of the containing structure.
+	 */
+	struct cgroup_subsys_state *parent;
 };
 
 /*
-- 
2.12.2.715.g7642488e1d-goog
