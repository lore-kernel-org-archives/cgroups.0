From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL allocations
Date: Fri, 22 Nov 2013 12:17:56 -0500
Message-ID: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=Message-Id:Date:Subject:Cc:To:From; bh=3mzDa4XyPE6Ng8Kac5btYGsHQ0UvbCUs2jokfUNKOs4=;
	b=Q0lo9QDPTm1xXRg8m9JoAcGY8NrEzUGpjuDqOMJp/lKSHuD/9HRxheGjwnSciML8+PnctXx1FO1xGG9sd7EP6jygjGyYj0boHPHxIl4A0Qbft5x+4uL0c3AQcJ3RtJqNvh8mAWZdpkxGOM467IWu8OHkTN/oIuTOyVX9ga5SDwQ=;
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

84235de394d9 ("fs: buffer: move allocation failure loop into the
allocator") started recognizing __GFP_NOFAIL in memory cgroups but
forgot to disable the OOM killer.

Any task that does not fail allocation will also not enter the OOM
completion path.  So don't declare an OOM state in this case or it'll
be leaked and the task be able to bypass the limit until the next
userspace-triggered page fault cleans up the OOM state.

Reported-by: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org # 3.12
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 13b9d0f..cc4f9cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2677,6 +2677,9 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	if (unlikely(task_in_memcg_oom(current)))
 		goto bypass;
 
+	if (gfp_mask & __GFP_NOFAIL)
+		oom = false;
+
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
-- 
1.8.4.2
