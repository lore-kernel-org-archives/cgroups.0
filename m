From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: [PATCH] mm, memcg: Bypass high reclaim iteration for cgroup
 hierarchy root
Date: Thu, 12 Mar 2020 16:41:37 +0000
Message-ID: <20200312164137.GA1753625@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=N2Uu/Isy7NWEK22NJk3FeLyFIU8DnOEsZiiSW7A75uw=;
        b=t7xkgWzL7lP8/guUn9rLcXqc2L/I8M4mdPLj2rg4UyMUaDhBh7A5BFsyNeuUrfj5Sy
         sZUf9YD87y994A6gKWXRpHFpH80VKHCF7N3X/4Pv5qvlLvmKlvIqQmk2yNsoJjceEcwr
         RTAWrygWaUxgm6QfhsJnWIPCeHwo+bWOupSI0=
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The root of the hierarchy cannot have high set, so we will never reclaim
based on it. This makes that clearer and avoids another entry.

Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-team-b10kYP2dOMg@public.gmane.org
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 63bb6a2aab81..ab9d24a657b9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2232,7 +2232,8 @@ static void reclaim_high(struct mem_cgroup *memcg,
 			continue;
 		memcg_memory_event(memcg, MEMCG_HIGH);
 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
-	} while ((memcg = parent_mem_cgroup(memcg)));
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		 !mem_cgroup_is_root(memcg));
 }
 
 static void high_work_func(struct work_struct *work)
-- 
2.25.1

