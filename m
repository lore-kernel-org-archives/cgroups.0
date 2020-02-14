From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] memcg: net: do not associate sock with unrelated memcg
Date: Thu, 13 Feb 2020 23:12:33 -0800
Message-ID: <20200214071233.100682-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GUW2iSWVcQnIpjOPNE/ThNp+Hs+3dImvwMIhxUppeuc=;
        b=X/KjJzEFSqSYWdSfML7JzS6n8HILLSQQiXHtsSRI37f+n9WVM5YZMoHTy7mrHn4gGG
         hiPLZs7adC6g14eb5Li+tsysiLOlk8Tm2QXpXorPLvcipOR2ey7hQGzHi/U4dnqIMYqe
         znIerMU7p8tjZjFbH0Zc0oTlRND+PiTNe3d94aV6gKKoRrlRGnwcmXmydkAf852PDJcU
         wDUPiEnhJ7CO/mAQ39rQ+aGDyE0+Nwcqt9EtBy2NyB7VfJIBImkoe3Xcq668JvykU6aJ
         QuJrqgKAcgR/YnrcmcwLhj9TFG9UrPEwL70sB3KLjiV9T3OsyGpnREhIXRMROfT7Q7A3
         yvEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Eric Dumazet <edumazet@google.com>
Cc: Greg Thelen <gthelen@google.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

We are testing network memory accounting in our setup and noticed
inconsistent network memory usage and often unrelated memcgs network
usage correlates with testing workload. On further inspection, it seems
like mem_cgroup_sk_alloc() is broken in irq context specially for
cgroup v1.

mem_cgroup_sk_alloc() can be called in irq context and kind
of assumes that it can only happen from sk_clone_lock() and the source
sock object has already associated memcg. However in cgroup v1, where
network memory accounting is opt-in, the source sock can be not
associated with any memcg and the new cloned sock can get associated
with unrelated interrupted memcg.

Cgroup v2 can also suffer if the source sock object was created by
process in the root memcg or if sk_alloc() is called in irq context.
The fix is to just do nothing in interrupt.

Fixes: 2d7580738345 ("mm: memcontrol: consolidate cgroup socket tracking")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 63bb6a2aab81..f500da82bfe8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6697,6 +6697,10 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 		return;
 	}
 
+	/* Do not associate the sock with unrelated interrupted task's memcg. */
+	if (in_interrupt())
+		return;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
 	if (memcg == root_mem_cgroup)
-- 
2.25.0.265.gbab2e86ba0-goog

