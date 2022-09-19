From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/2] mm: memcontrol: use memcg_kmem_enabled in count_objcg_event
Date: Tue, 20 Sep 2022 02:06:33 +0800
Message-ID: <20220919180634.45958-2-ryncsn@gmail.com>
References: <20220919180634.45958-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date;
        bh=C+GNb1CRkpsaWy3nNaUeEZwBpKEJtnfXNeVMo/vFMIU=;
        b=fJXZ9vt1XMtBtJhooHOuHVO6gpZg/2Uq4qGa9T5h11pcGRnzjkEqyCrZLqmAkJO3mt
         6jZ6Kmcm5Xrl4n/4Ha9OVyvbf7KSeSHSaBIOVNkl/Y+DFmj3H/uy0xNC+pLhyrze7MCr
         dwJzSTDmkot2vsTjksuK2VD4SWXd5wJcjGqt1tPITOlZ7VGEfcr6qO3cRxkn0CYilHgB
         T55kdJjZVfwysg0KjtfHwmZN+5pQSnz3gMRiZsYhWXzRHLhezJGrkX5qv07Q/7gmikk6
         B/FPhC5n0u2iEpfA1o6oGoGvCu3B2YW8UjFu0aCFVVNQytVv//tVdMVPcPIP8TNm7bdz
         I93w==
In-Reply-To: <20220919180634.45958-1-ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

There are currently two helpers for checking if cgroup kmem
accounting is enabled:

- mem_cgroup_kmem_disabled
- memcg_kmem_enabled

mem_cgroup_kmem_disabled is a simple helper that returns true
if cgroup.memory=nokmem is specified, otherwise returns false.

memcg_kmem_enabled is a bit different, it returns true if
cgroup.memory=nokmem is not specified and there was at least one
non-root memory control enabled cgroup ever created. This help improve
performance when kmem accounting was not actually activated. And it's
optimized with static branch.

The usage of mem_cgroup_kmem_disabled is for sub-systems that need to
preallocate data for kmem accounting since they could be initialized
before kmem accounting is activated. But count_objcg_event doesn't
need that, so using memcg_kmem_enabled is better here.

Signed-off-by: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/memcontrol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6257867fbf95..e6d3d5870d6f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1779,7 +1779,7 @@ static inline void count_objcg_event(struct obj_cgroup *objcg,
 {
 	struct mem_cgroup *memcg;
 
-	if (mem_cgroup_kmem_disabled())
+	if (!memcg_kmem_enabled())
 		return;
 
 	rcu_read_lock();
-- 
2.35.2

