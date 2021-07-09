From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 1/3] mm, memcg: add mem_cgroup_disabled checks in vmpressure
 and swap-related functions
Date: Thu,  8 Jul 2021 17:05:07 -0700
Message-ID: <20210709000509.2618345-2-surenb@google.com>
References: <20210709000509.2618345-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ljZtH/3TfSN/L2o7cH/WG4F/EQa0MpAf0ZWdg5C/FNc=;
        b=tjuzLHVF6l4VVoKLeCICczn6YDJN3WpgP2EKbpGIwoImA0pbzF/WW9fGwmIFgZjIbF
         ioFEOo80oORCzs77cXbZqQuT/dC8ElHWoBKrlQCrAisasje6lH4lQlJCXjncXzU4DqQh
         2AU0p4gnRO7+7Eu9EL6ZXgZ44X/qWm/IzNyC32JDqh9i3SbKbBPTlFBUvit5atKoadxd
         7JZ65EULEJRyeFkovh0oGnZfcOfKGVQVu88YAAMnPVktwy7KV4m/qX2aRgOidCH095n7
         SdgX49cVT5lkj5ZtQr0JzkyElR8g/YiUM4L5WTjEHJL6M0JzllWjTEVN5V0u5340zWZ7
         bT4g==
In-Reply-To: <20210709000509.2618345-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, songmuchun@bytedance.com, shy828301@gmail.com, alexs@kernel.org, alexander.h.duyck@linux.intel.com, richard.weiyang@gmail.com, vbabka@suse.cz, axboe@kernel.dk, iamjoonsoo.kim@lge.com, david@redhat.com, willy@infradead.org, apopple@nvidia.com, minchan@kernel.org, linmiaohe@huawei.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@android.com, surenb@google.com

Add mem_cgroup_disabled check in vmpressure, mem_cgroup_uncharge_swap and
cgroup_throttle_swaprate functions. This minimizes the memcg overhead in
the pagefault and exit_mmap paths when memcgs are disabled using
cgroup_disable=memory command-line option.
This change results in ~2.1% overhead reduction when running PFT test
comparing {CONFIG_MEMCG=n, CONFIG_MEMCG_SWAP=n} against {CONFIG_MEMCG=y,
CONFIG_MEMCG_SWAP=y, cgroup_disable=memory} configuration on an 8-core
ARM64 Android device.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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

