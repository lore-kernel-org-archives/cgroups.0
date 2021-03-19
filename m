From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 1/2] mm: memcontrol: don't allocate cgroup swap arrays when memcg is disabled
Date: Fri, 19 Mar 2021 01:49:43 -0400
Message-ID: <20210319054944.50048-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4EjKKyy6zJi89FUhVJH9257gvcZYHljfd48zTgz5zIU=;
        b=x3QpbZL8xF3lB+fhzJjWSXfOdOYw7IT0xr7pVuPujmaG7k9pCD7DqET3m+8xVwZ5fs
         9k297z+F24N6dyH21lb1L1Xd/k1LuGHRov8Ow80+4RDOpZh75ea7sqWiYm12gaCu5Q0J
         sVUBYLc1+1h4Kx1tvB+uDpg0n/HxaUQ8X4aeJo9h/4EaSEOm3BpoNbfNPF+U9GdYaYI3
         73ndGlNaJSVE+R5glrk8jWDvFVtpL1IKfaJbAWKVNZ0v8wEScvUqQPE7fcnMOvALYcJR
         T7RUNMqMWmr2NpNZNqMiKeRDcre+/EKQRJ7tR6mEQYtwnxKl3A40jfWoKVM7UDzDdbvI
         VClQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Since commit 2d1c498072de ("mm: memcontrol: make swap tracking an
integral part of memory control"), the cgroup swap arrays are used to
track memory ownership at the time of swap readahead and swapoff, even
if swap space *accounting* has been turned off by the user via
swapaccount=0 (which sets cgroup_memory_noswap).

However, the patch was overzealous: by simply dropping the
cgroup_memory_noswap conditionals in the swapon, swapoff and uncharge
path, it caused the cgroup arrays being allocated even when the memory
controller as a whole is disabled. This is a waste of that memory.

Restore mem_cgroup_disabled() checks, implied previously by
cgroup_memory_noswap, in the swapon, swapoff, and swap_entry_free
callbacks.

Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
Reported-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c  | 3 +++
 mm/swap_cgroup.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 668d1d7c2645..49bdcf603af1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7101,6 +7101,9 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
+	if (mem_cgroup_disabled())
+		return;
+
 	id = swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index 7f34343c075a..08c3246f9269 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -171,6 +171,9 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
 	unsigned long length;
 	struct swap_cgroup_ctrl *ctrl;
 
+	if (mem_cgroup_disabled())
+		return 0;
+
 	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
 	array_size = length * sizeof(void *);
 
@@ -206,6 +209,9 @@ void swap_cgroup_swapoff(int type)
 	unsigned long i, length;
 	struct swap_cgroup_ctrl *ctrl;
 
+	if (mem_cgroup_disabled())
+		return;
+
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl = &swap_cgroup_ctrl[type];
 	map = ctrl->map;
-- 
2.30.1

