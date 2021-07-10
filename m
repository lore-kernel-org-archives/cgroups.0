From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/3] mm, memcg: add mem_cgroup_disabled checks in
 vmpressure and swap-related functions
Date: Fri,  9 Jul 2021 17:36:24 -0700
Message-ID: <20210710003626.3549282-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZSFxQqEllnhgQqgVGWhX1TPVzgfo+pOEQxzVXUrGXrk=;
        b=sAc/7ecFZP5kXA30C5YZ8xkXOBRQdtm2F5t0/CXgWYYABwvtTUr/VKqm/I/gky0Rq8
         WveSgzFU18PV2ZevoAP+ectWUbltAEfoTlMnhaj/RjMSDDPfpZ4P36rsnHFI1zv7oHT5
         AuepZM6oeCMBUm0kxEG65nYNsEVn3AIOnXyEHJ7TlLkF0Z2Vb6FULt+zS/JoVFNTjHhe
         1ArC5OTnPtacdAyffJBWyYYjx3lrCgZGjp9uK/zuiR0Kc7YDoaBa1Pp5MdKA040qqPX/
         7N0i9ZQTB556jwAN+CJxb8G/iCx2WwlA9F25zL7moMckGy85MVe2PxoqJBl/9kj8Oe47
         2Qng==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Add mem_cgroup_disabled check in vmpressure, mem_cgroup_uncharge_swap and
cgroup_throttle_swaprate functions. This minimizes the memcg overhead in
the pagefault and exit_mmap paths when memcgs are disabled using
cgroup_disable=memory command-line option.
This change results in ~2.1% overhead reduction when running PFT test
comparing {CONFIG_MEMCG=n, CONFIG_MEMCG_SWAP=n} against {CONFIG_MEMCG=y,
CONFIG_MEMCG_SWAP=y, cgroup_disable=memory} configuration on an 8-core
ARM64 Android device.

Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 3 +++
 mm/swapfile.c   | 3 +++
 mm/vmpressure.c | 7 ++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae1f5d0cb581..a228cd51c4bd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7305,6 +7305,9 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
+	if (mem_cgroup_disabled())
+		return;
+
 	id = swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1e07d1c776f2..707fa0481bb4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3778,6 +3778,9 @@ void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
 	struct swap_info_struct *si, *next;
 	int nid = page_to_nid(page);
 
+	if (mem_cgroup_disabled())
+		return;
+
 	if (!(gfp_mask & __GFP_IO))
 		return;
 
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index d69019fc3789..9b172561fded 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -240,7 +240,12 @@ static void vmpressure_work_fn(struct work_struct *work)
 void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 		unsigned long scanned, unsigned long reclaimed)
 {
-	struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
+	struct vmpressure *vmpr;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	vmpr = memcg_to_vmpressure(memcg);
 
 	/*
 	 * Here we only want to account pressure that userland is able to
-- 
2.32.0.93.g670b81a890-goog

