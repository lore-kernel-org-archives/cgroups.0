From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: [PATCH] cgroup/cpuset: Avoid memory migration when nodemasks match
Date: Wed, 25 Aug 2021 12:54:15 +0200
Message-ID: <20210825105415.1365360-1-nsaenzju@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629888867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dbXTR2d96IOT3FxhihVlnlP/ppDRoO6Czu1qX4JGEHY=;
        b=U7kWf1m6mF8++uSJu27SyuJIuVhSK8lkCnEftzR5v3i2LhHHv0bDGCJxEIezi9pc9l0C/P
        1DE469c64GaqQI2It+0ygFTOQ6cC4FD48xrLsIYjuVQAmTGuo6gGNCFKOEUZhSvpStzViS
        7gECzdMHxMTIYYlfCoVRD5r5bR8fsdo=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, mtosatti@redhat.com, nilal@redhat.com, frederic@kernel.org, longman@redhat.com, Nicolas Saenz Julienne <nsaenzju@redhat.com>

With the introduction of ee9707e8593d ("cgroup/cpuset: Enable memory
migration for cpuset v2") attaching a process to a different cgroup will
trigger a memory migration regardless of whether it's really needed.
Memory migration is an expensive operation, so bypass it if the
nodemasks passed to cpuset_migrate_mm() are equal.

Note that we're not only avoiding the migration work itself, but also a
call to lru_cache_disable(), which triggers and flushes an LRU drain
work on every online CPU.

Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>

---

NOTE: This also alleviates hangs I stumbled upon while testing
linux-next on systems with nohz_full CPUs (running latency sensitive
loads). ee9707e8593d's newly imposed memory migration never finishes, as
the LRU drain is never scheduled on isolated CPUs.

I tried to follow the user-space call trace, it's something like this:

  Create new tmux pane, which triggers hostname operation, hangs...
    -> systemd (pid 1) creates new hostnamed process (using clone())
      -> hostnamed process attaches itself to:
  	 "system.slice/systemd-hostnamed.service/cgroup.procs"
        -> hangs... Waiting for LRU drain to finish on nohz_full CPUs.

As far as CPU isolation is concerned, this calls for better
understanding of the underlying issues. For example, should LRU be made
CPU isolation aware or should we deal with it at cgroup/cpuset level? In
the meantime, I figured this small optimization is worthwhile on its
own.

 kernel/cgroup/cpuset.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 44d234b0df5e..d497a65c4f04 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1634,6 +1634,11 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 {
 	struct cpuset_migrate_mm_work *mwork;
 
+	if (nodes_equal(*from, *to)) {
+		mmput(mm);
+		return;
+	}
+
 	mwork = kzalloc(sizeof(*mwork), GFP_KERNEL);
 	if (mwork) {
 		mwork->mm = mm;
-- 
2.31.1

