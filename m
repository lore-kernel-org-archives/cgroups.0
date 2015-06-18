From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 4/4] cgroup: add delegation section to unified hierarchy
 documentation
Date: Thu, 18 Jun 2015 16:23:27 -0400
Message-ID: <20150618202327.GG12934@mtj.duckdns.org>
References: <1434481817-32001-1-git-send-email-tj@kernel.org>
 <1434481817-32001-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=H9Ec/ZlyURVGRSM+8XvoksVlH4ZjBqjmJutFWFlQTmE=;
        b=ynvPGBWR5Evm6aGbqIdQ3qZzJGvZTqqpmSJPORHp2+ShPpqmlxrPAJVyTAD7UaqJc6
         fBEByz1jUpmSQnIy8BQbi5+6ITCRSX1FStKMM1klR/IJrXKYJn3XPepxoF6lQlDnPd4O
         idcwI9aKHuIUwQBEjQ/lqY28TxLjOXNabVtgqUfB4lNexN6KfQD668KGGEdWNW/h5vhH
         L9m+eEb9xeazZ7pDC8BHWjDgFeIDtsPi2v+J6lZ9t7zjfRb0JUkVfCdja9rzaqi9x7Cj
         e5b81eG4c3c3zugfeqYTtgWJcKMldQii7qTrgd9PHKYcssbUUvcu2eiehhPYxhrYP4EM
         Ro9A==
Content-Disposition: inline
In-Reply-To: <1434481817-32001-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

v2: Rearranged paragraphs as suggested by Johannes Weiner.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 Documentation/cgroups/unified-hierarchy.txt |  102 +++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 18 deletions(-)

--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -17,15 +17,18 @@ CONTENTS
 3. Structural Constraints
   3-1. Top-down
   3-2. No internal tasks
-4. Other Changes
-  4-1. [Un]populated Notification
-  4-2. Other Core Changes
-  4-3. Per-Controller Changes
-    4-3-1. blkio
-    4-3-2. cpuset
-    4-3-3. memory
-5. Planned Changes
-  5-1. CAP for resource control
+4. Delegation
+  4-1. Model of delegation
+  4-2. Common ancestor rule
+5. Other Changes
+  5-1. [Un]populated Notification
+  5-2. Other Core Changes
+  5-3. Per-Controller Changes
+    5-3-1. blkio
+    5-3-2. cpuset
+    5-3-3. memory
+6. Planned Changes
+  6-1. CAP for resource control
 
 
 1. Background
@@ -245,9 +248,72 @@ cgroup must create children and transfer
 before enabling controllers in its "cgroup.subtree_control" file.
 
 
-4. Other Changes
+4. Delegation
 
-4-1. [Un]populated Notification
+4-1. Model of delegation
+
+A cgroup can be delegated to a less privileged user by granting write
+access of the directory and its "cgroup.procs" file to the user.  Note
+that the resource control knobs in a given directory concern the
+resources of the parent and thus must not be delegated along with the
+directory.
+
+Once delegated, the user can build sub-hierarchy under the directory,
+organize processes as it sees fit and further distribute the resources
+it got from the parent.  The limits and other settings of all resource
+controllers are hierarchical and regardless of what happens in the
+delegated sub-hierarchy, nothing can escape the resource restrictions
+imposed by the parent.
+
+Currently, cgroup doesn't impose any restrictions on the number of
+cgroups in or nesting depth of a delegated sub-hierarchy; however,
+this may in the future be limited explicitly.
+
+
+4-2. Common ancestor rule
+
+On the unified hierarchy, to write to a "cgroup.procs" file, in
+addition to the usual write permission to the file and uid match, the
+writer must also have write access to the "cgroup.procs" file of the
+common ancestor of the source and destination cgroups.  This prevents
+delegatees from smuggling processes across disjoint sub-hierarchies.
+
+Let's say cgroups C0 and C1 have been delegated to user U0 who created
+C00, C01 under C0 and C10 under C1 as follows.
+
+ ~~~~~~~~~~~~~ - C0 - C00
+ ~ cgroup    ~      \ C01
+ ~ hierarchy ~
+ ~~~~~~~~~~~~~ - C1 - C10
+
+C0 and C1 are separate entities in terms of resource distribution
+regardless of their relative positions in the hierarchy.  The
+resources the processes under C0 are entitled to are controlled by
+C0's ancestors and may be completely different from C1.  It's clear
+that the intention of delegating C0 to U0 is allowing U0 to organize
+the processes under C0 and further control the distribution of C0's
+resources.
+
+On traditional hierarchies, if a task has write access to "tasks" or
+"cgroup.procs" file of a cgroup and its uid agrees with the target, it
+can move the target to the cgroup.  In the above example, U0 will not
+only be able to move processes in each sub-hierarchy but also across
+the two sub-hierarchies, effectively allowing it to violate the
+organizational and resource restrictions implied by the hierarchical
+structure above C0 and C1.
+
+On the unified hierarchy, let's say U0 wants to write the pid of a
+process which has a matching uid and is currently in C10 into
+"C00/cgroup.procs".  U0 obviously has write access to the file and
+migration permission on the process; however, the common ancestor of
+the source cgroup C10 and the destination cgroup C00 is above the
+points of delegation and U0 would not have write access to its
+"cgroup.procs" and thus be denied with -EACCES.
+
+
+5. Other Changes
+
+5-1. [Un]populated Notification
 
 cgroup users often need a way to determine when a cgroup's
 subhierarchy becomes empty so that it can be cleaned up.  cgroup
@@ -289,7 +355,7 @@ supported and the interface files "relea
 "notify_on_release" do not exist.
 
 
-4-2. Other Core Changes
+5-2. Other Core Changes
 
 - None of the mount options is allowed.
 
@@ -306,14 +372,14 @@ supported and the interface files "relea
 - The "cgroup.clone_children" file is removed.
 
 
-4-3. Per-Controller Changes
+5-3. Per-Controller Changes
 
-4-3-1. blkio
+5-3-1. blkio
 
 - blk-throttle becomes properly hierarchical.
 
 
-4-3-2. cpuset
+5-3-2. cpuset
 
 - Tasks are kept in empty cpusets after hotplug and take on the masks
   of the nearest non-empty ancestor, instead of being moved to it.
@@ -322,7 +388,7 @@ supported and the interface files "relea
   masks of the nearest non-empty ancestor.
 
 
-4-3-3. memory
+5-3-3. memory
 
 - use_hierarchy is on by default and the cgroup file for the flag is
   not created.
@@ -407,9 +473,9 @@ supported and the interface files "relea
   memory.low, memory.high, and memory.max will use the string "max" to
   indicate and set the highest possible value.
 
-5. Planned Changes
+6. Planned Changes
 
-5-1. CAP for resource control
+6-1. CAP for resource control
 
 Unified hierarchy will require one of the capabilities(7), which is
 yet to be decided, for all resource control related knobs.  Process
