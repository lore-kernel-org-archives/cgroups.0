From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 17/19] mm: memcontrol: document the new swap control behavior
Date: Fri,  8 May 2020 14:31:04 -0400
Message-ID: <20200508183105.225460-18-hannes@cmpxchg.org>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WjwifLkaxtnwjsDLki9oTn/ODVTE0c1W9xwEMFneqd4=;
        b=q2dyjdEbv83IUE3u02r2JwYp7811qVwPgshXKCrQ9XsOoThuy+yCgx3eE+3O06I4nk
         sA2UB6pDLm7Cl3ukEoSeqZ4absWqRl+rAuxVm35o9C8uulHk6tDaLg2OW64hPvYjMfPq
         h1nO3+CuPO7MSvFT8px0tCOrBddzqfjGfIsySPjI7CJLvGVVKfGcW9YX0CHvGlWCu3eI
         ZSOGDPjXfO7ba7ayjNCh1zngQEJvJ0Q7F/lJ9RAxmpg0eca0qEWUl/Zhn6BNtOlpc3JP
         KMXOdTZnVyl63bvpRi5/fbOGw/EtLtsnjpmczC5i18yY0lhPEZL3g44yjE/BuRqyt+9f
         tzQg==
In-Reply-To: <20200508183105.225460-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 .../admin-guide/cgroup-v1/memory.rst          | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 0ae4f564c2d6..12757e63b26c 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -199,11 +199,11 @@ An RSS page is unaccounted when it's fully unmapped. A PageCache page is
 unaccounted when it's removed from radix-tree. Even if RSS pages are fully
 unmapped (by kswapd), they may exist as SwapCache in the system until they
 are really freed. Such SwapCaches are also accounted.
-A swapped-in page is not accounted until it's mapped.
+A swapped-in page is accounted after adding into swapcache.
 
 Note: The kernel does swapin-readahead and reads multiple swaps at once.
-This means swapped-in pages may contain pages for other tasks than a task
-causing page fault. So, we avoid accounting at swap-in I/O.
+Since page's memcg recorded into swap whatever memsw enabled, the page will
+be accounted after swapin.
 
 At page migration, accounting information is kept.
 
@@ -222,18 +222,13 @@ the cgroup that brought it in -- this will happen on memory pressure).
 But see section 8.2: when moving a task to another cgroup, its pages may
 be recharged to the new cgroup, if move_charge_at_immigrate has been chosen.
 
-Exception: If CONFIG_MEMCG_SWAP is not used.
-When you do swapoff and make swapped-out pages of shmem(tmpfs) to
-be backed into memory in force, charges for pages are accounted against the
-caller of swapoff rather than the users of shmem.
-
-2.4 Swap Extension (CONFIG_MEMCG_SWAP)
+2.4 Swap Extension
 --------------------------------------
 
-Swap Extension allows you to record charge for swap. A swapped-in page is
-charged back to original page allocator if possible.
+Swap usage is always recorded for each of cgroup. Swap Extension allows you to
+read and limit it.
 
-When swap is accounted, following files are added.
+When CONFIG_SWAP is enabled, following files are added.
 
  - memory.memsw.usage_in_bytes.
  - memory.memsw.limit_in_bytes.
-- 
2.26.2

