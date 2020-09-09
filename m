From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Wed,  9 Sep 2020 14:57:52 -0700
Message-ID: <20200909215752.1725525-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=YzcEKzsIWMuMUeF2ey3rtqIWIvrrBYx2vMKWker9WzU=;
        b=C5Fv53HkIMHHoez5IYzzn36hW0UQqwW9KLZC4s9j5QoptDldkoHfHK/dGAox6TwObe
         binlTX7MkxrWT+dDuwi1/uPuq27BZAjL1xZXwx6z8eR6sakcGs866qkvuOHdXpZMHE3v
         MIZFYe87z96xRKMxatoLjAZFYuXpFWjOZgXYXRkxZpK1pAIrdGNs3glWWx2Krl+XVYoR
         YirWIwRKkYQMruUWz41tJVHXBYH6vZVckNxtYWqfWNgypkQ+aR33DELU/kyDB2nB5Quz
         MFdn1w4xVNM8sZUXG/wH/M2G13dOLlVbQ/zZEbq0CRO8B3ONI0pHD1nRDsFjRCx2OrJK
         AEJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>, Greg Thelen <gthelen@google.com>, David Rientjes <rientjes@google.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

Introduce an memcg interface to trigger memory reclaim on a memory cgroup.

Use cases:
----------

1) Per-memcg uswapd:

Usually applications consists of combination of latency sensitive and
latency tolerant tasks. For example, tasks serving user requests vs
tasks doing data backup for a database application. At the moment the
kernel does not differentiate between such tasks when the application
hits the memcg limits. So, potentially a latency sensitive user facing
task can get stuck in high reclaim and be throttled by the kernel.

Similarly there are cases of single process applications having two set
of thread pools where threads from one pool have high scheduling
priority and low latency requirement. One concrete example from our
production is the VMM which have high priority low latency thread pool
for the VCPUs while separate thread pool for stats reporting, I/O
emulation, health checks and other managerial operations. The kernel
memory reclaim does not differentiate between VCPU thread or a
non-latency sensitive thread and a VCPU thread can get stuck in high
reclaim.

One way to resolve this issue is to preemptively trigger the memory
reclaim from a latency tolerant task (uswapd) when the application is
near the limits. Finding 'near the limits' situation is an orthogonal
problem.

2) Proactive reclaim:

This is a similar to the previous use-case, the difference is instead of
waiting for the application to be near its limit to trigger memory
reclaim, continuously pressuring the memcg to reclaim a small amount of
memory. This gives more accurate and uptodate workingset estimation as
the LRUs are continuously sorted and can potentially provide more
deterministic memory overcommit behavior. The memory overcommit
controller can provide more proactive response to the changing behavior
of the running applications instead of being reactive.

Benefit of user space solution:
-------------------------------

1) More flexible on who should be charged for the cpu of the memory
reclaim. For proactive reclaim, it makes more sense to centralized the
overhead while for uswapd, it makes more sense for the application to
pay for the cpu of the memory reclaim.

2) More flexible on dedicating the resources (like cpu). The memory
overcommit controller can balance the cost between the cpu usage and
the memory reclaimed.

3) Provides a way to the applications to keep their LRUs sorted, so,
under memory pressure better reclaim candidates are selected. This also
gives more accurate and uptodate notion of working set for an
application.

Questions:
----------

1) Why memory.high is not enough?

memory.high can be used to trigger reclaim in a memcg and can
potentially be used for proactive reclaim as well as uswapd use cases.
However there is a big negative in using memory.high. It can potentially
introduce high reclaim stalls in the target application as the
allocations from the processes or the threads of the application can hit
the temporary memory.high limit.

Another issue with memory.high is that it is not delegatable. To
actually use this interface for uswapd, the application has to introduce
another layer of cgroup on whose memory.high it has write access.

2) Why uswapd safe from self induced reclaim?

This is very similar to the scenario of oomd under global memory
pressure. We can use the similar mechanisms to protect uswapd from self
induced reclaim i.e. memory.min and mlock.

Interface options:
------------------

Introducing a very simple memcg interface 'echo 10M > memory.reclaim' to
trigger reclaim in the target memory cgroup.

In future we might want to reclaim specific type of memory from a memcg,
so, this interface can be extended to allow that. e.g.

$ echo 10M [all|anon|file|kmem] > memory.reclaim

However that should be when we have concrete use-cases for such
functionality. Keep things simple for now.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  9 ++++++
 mm/memcontrol.c                         | 37 +++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6be43781ec7f..58d70b5989d7 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1181,6 +1181,15 @@ PAGE_SIZE multiple when read back.
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
 
+  memory.reclaim
+	A write-only file which exists on non-root cgroups.
+
+	This is a simple interface to trigger memory reclaim in the
+	target cgroup. Write the number of bytes to reclaim to this
+	file and the kernel will try to reclaim that much memory.
+	Please note that the kernel can over or under reclaim from
+	the target cgroup.
+
   memory.oom.group
 	A read-write single value file which exists on non-root
 	cgroups.  The default value is "0".
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75cd1a1e66c8..2d006c36d7f3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6456,6 +6456,38 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
+			      size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
+	unsigned long nr_to_reclaim, nr_reclaimed = 0;
+	int err;
+
+	buf = strstrip(buf);
+	err = page_counter_memparse(buf, "", &nr_to_reclaim);
+	if (err)
+		return err;
+
+	while (nr_reclaimed < nr_to_reclaim) {
+		unsigned long reclaimed;
+
+		if (signal_pending(current))
+			break;
+
+		reclaimed = try_to_free_mem_cgroup_pages(memcg,
+						nr_to_reclaim - nr_reclaimed,
+						GFP_KERNEL, true);
+
+		if (!reclaimed && !nr_retries--)
+			break;
+
+		nr_reclaimed += reclaimed;
+	}
+
+	return nbytes;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -6508,6 +6540,11 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_oom_group_show,
 		.write = memory_oom_group_write,
 	},
+	{
+		.name = "reclaim",
+		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
+		.write = memory_reclaim,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.28.0.526.ge36021eeef-goog

