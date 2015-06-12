From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: add documentation for the PIDs controller
Date: Sat, 13 Jun 2015 03:21:58 +1000
Message-ID: <1434129718-8823-1-git-send-email-cyphar@cyphar.com>
References: <CAOviyagqdXEk=_4u0ijc2AJ-dkAEYYWVbjH_gy2TACmHAnhOOA@mail.gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOviyagqdXEk=_4u0ijc2AJ-dkAEYYWVbjH_gy2TACmHAnhOOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

The attached patch adds documentation concerning the PIDs controller.
This should be applied alongside the rest of this patchset[1].

[1]: https://lkml.org/lkml/2015/6/9/320

8<-----------------------------------------------------------------------------

Add documentation derived from kernel/cgroup_pids.c to the relevant
Documentation/ directory, along with a few examples of how to use the
PIDs controller as well an explanation of its peculiarities.

Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/00-INDEX |  2 +
 Documentation/cgroups/pids.txt | 85 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)
 create mode 100644 Documentation/cgroups/pids.txt

diff --git a/Documentation/cgroups/00-INDEX b/Documentation/cgroups/00-INDEX
index 96ce071..3f5a40f 100644
--- a/Documentation/cgroups/00-INDEX
+++ b/Documentation/cgroups/00-INDEX
@@ -22,6 +22,8 @@ net_cls.txt
 	- Network classifier cgroups details and usages.
 net_prio.txt
 	- Network priority cgroups details and usages.
+pids.txt
+	- Process number cgroups details and usages.
 resource_counter.txt
 	- Resource Counter API.
 unified-hierarchy.txt
diff --git a/Documentation/cgroups/pids.txt b/Documentation/cgroups/pids.txt
new file mode 100644
index 0000000..1a078b5
--- /dev/null
+++ b/Documentation/cgroups/pids.txt
@@ -0,0 +1,85 @@
+						   Process Number Controller
+						   =========================
+
+Abstract
+--------
+
+The process number controller is used to allow a cgroup hierarchy to stop any
+new tasks from being fork()'d or clone()'d after a certain limit is reached.
+
+Since it is trivial to hit the task limit without hitting any kmemcg limits in
+place, PIDs are a fundamental resource. As such, PID exhaustion must be
+preventable in the scope of a cgroup hierarchy by allowing resource limiting of
+the number of tasks in a cgroup.
+
+Usage
+-----
+
+In order to use the `pids` controller, set the maximum number of tasks in
+pids.max (this is not available in the root cgroup for obvious reasons). The
+number of processes currently in the cgroup is given by pids.current.
+
+Organisational operations are not blocked by cgroup policies, so it is possible
+to have pids.current > pids.max. This can be done by either setting the limit to
+be smaller than pids.current, or attaching enough processes to the cgroup such
+that pids.current > pids.max. However, it is not possible to violate a cgroup
+policy through fork() or clone(). fork() and clone() will return -EAGAIN if the
+creation of a new process would cause a cgroup policy to be violated.
+
+To set a cgroup to have no limit, set pids.max to "max". This is the default for
+all new cgroups (N.B. that PID limits are hierarchical, so the most stringent
+limit in the hierarchy is followed).
+
+pids.current tracks all child cgroup hierarchies, so parent/pids.current is a
+superset of parent/child/pids.current.
+
+Example
+-------
+
+First, we mount the pids controller:
+# mkdir -p /sys/fs/cgroup/pids
+# mount -t cgroup -o pids none /sys/fs/cgroup/pids
+
+Then we create a hierarchy, set limits and attach processes to it:
+# mkdir -p /sys/fs/cgroup/pids/parent/child
+# echo 2 > /sys/fs/cgroup/pids/parent/pids.max
+# echo $$ > /sys/fs/cgroup/pids/parent/cgroup.procs
+# cat /sys/fs/cgroup/pids/parent/pids.current
+2
+#
+
+It should be noted that attempts to overcome the set limit (2 in this case) will
+fail:
+
+# cat /sys/fs/cgroup/pids/parent/pids.current
+2
+# ( /bin/echo "Here's some processes for you." | cat )
+sh: fork: Resource temporary unavailable
+#
+
+Even if we migrate to a child cgroup (which doesn't have a set limit), we will
+not be able to overcome the most stringent limit in the hierarchy (in this case,
+parent's):
+
+# echo $$ > /sys/fs/cgroup/pids/parent/child/cgroup.procs
+# cat /sys/fs/cgroup/pids/parent/pids.current
+2
+# cat /sys/fs/cgroup/pids/parent/child/pids.current
+2
+# cat /sys/fs/cgroup/pids/parent/child/pids.max
+max
+# ( /bin/echo "Here's some processes for you." | cat )
+sh: fork: Resource temporary unavailable
+#
+
+We can set a limit that is smaller than pids.current, which will stop any new
+processes from being forked at all (note that the shell itself counts towards
+pids.current):
+
+# echo 1 > /sys/fs/cgroup/pids/parent/pids.max
+# /bin/echo "We can't even spawn a single process now."
+sh: fork: Resource temporary unavailable
+# echo 0 > /sys/fs/cgroup/pids/parent/pids.max
+# /bin/echo "We can't even spawn a single process now."
+sh: fork: Resource temporary unavailable
+#
-- 
2.4.2
