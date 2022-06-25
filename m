From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH RFC] memcg: avoid idr ids space depletion
Date: Sat, 25 Jun 2022 12:43:59 +0300
Message-ID: <b3225994-2a71-f38c-75b2-5366df848419@openvz.org>
References: <YrXDV7uPpmDigh3G@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=HHB0HiD0LfT4KAnBHG/5IT4f6jchD/lpeXSDdegmO/0=;
        b=4q8DDHI/VDs0sbgwpDTFVXDdLjVTFa4XUcthupWBfu+DIv8IrQecPraWwswb+CXy4/
         mFEenje9ltJ+KD3tjvrgrg2qKhDazl5wclhMg0r64nV2SrCw0M1bdY4sK8VLilTO+sNO
         bifcq3RpdEGglOrC/0GFG/iXbH6UVNay4ED88oQhaRB36A5yH1JAIN5sysGBXBkoBobI
         v6lclW8E28i79ARkqX8PvmxuPzgwnlfMvwJrtX8rZRS3PpEbkheRxfKmaqlkf5EPzhoZ
         TLBx/wQ1WZHIGC+blMtCteQHDRvfCIBWwqBsCnyzYaLH239g3Xm+ceZa88WPccp8fI2H
         C+SQ==
Content-Language: en-US
In-Reply-To: <YrXDV7uPpmDigh3G-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I tried to increase MEM_CGROUP_ID_MAX to INT_MAX and found no
significant difficulties. What do you think about following patch?
I did not tested it, just checked its compilation.
I hope it allows:
- to avoid memcg id space depletion on normal nodes
- to set up per-container cgroup limit to USHRT_MAX to prevent possible misuse
  and in general use memcg accounting for allocated resources.

Thank you,
	Vasily Averin
---

Michal Hocko pointed that memory controller depends on idr ids which
have a space that is rather limited
 #define MEM_CGROUP_ID_MAX       USHRT_MAX

The limit can be reached on nodes hosted several hundred OS containers
with new distributions running hundreds of services in their own memory
cgroups.

This patch increases the space up to INT_MAX.
---
 include/linux/memcontrol.h  | 15 +++++++++------
 include/linux/swap_cgroup.h | 14 +++++---------
 mm/memcontrol.c             |  6 +++---
 mm/swap_cgroup.c            | 10 ++++------
 4 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 744cde2b2368..e3468550ba20 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -59,10 +59,13 @@ struct mem_cgroup_reclaim_cookie {
 };
 
 #ifdef CONFIG_MEMCG
-
+#ifdef CONFIG_64BIT
+#define MEM_CGROUP_ID_SHIFT	31
+#define MEM_CGROUP_ID_MAX	INT_MAX - 1
+#else
 #define MEM_CGROUP_ID_SHIFT	16
 #define MEM_CGROUP_ID_MAX	USHRT_MAX
-
+#endif
 struct mem_cgroup_id {
 	int id;
 	refcount_t ref;
@@ -852,14 +855,14 @@ void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 int mem_cgroup_scan_tasks(struct mem_cgroup *,
 			  int (*)(struct task_struct *, void *), void *);
 
-static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
+static inline int mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return 0;
 
 	return memcg->id.id;
 }
-struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
+struct mem_cgroup *mem_cgroup_from_id(int id);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
@@ -1374,12 +1377,12 @@ static inline int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 	return 0;
 }
 
-static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
+static inline int mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	return 0;
 }
 
-static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
+static inline struct mem_cgroup *mem_cgroup_from_id(int id)
 {
 	WARN_ON_ONCE(id);
 	/* XXX: This should always return root_mem_cgroup */
diff --git a/include/linux/swap_cgroup.h b/include/linux/swap_cgroup.h
index a12dd1c3966c..711dd18380ed 100644
--- a/include/linux/swap_cgroup.h
+++ b/include/linux/swap_cgroup.h
@@ -6,25 +6,21 @@
 
 #ifdef CONFIG_MEMCG_SWAP
 
-extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
-					unsigned short old, unsigned short new);
-extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
-					 unsigned int nr_ents);
-extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
+extern int swap_cgroup_cmpxchg(swp_entry_t ent, int old, int new);
+extern int swap_cgroup_record(swp_entry_t ent, int id, unsigned int nr_ents);
+extern int lookup_swap_cgroup_id(swp_entry_t ent);
 extern int swap_cgroup_swapon(int type, unsigned long max_pages);
 extern void swap_cgroup_swapoff(int type);
 
 #else
 
 static inline
-unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
-				  unsigned int nr_ents)
+unsigned short swap_cgroup_record(swp_entry_t ent, int id, unsigned int nr_ents)
 {
 	return 0;
 }
 
-static inline
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
+static inline int lookup_swap_cgroup_id(swp_entry_t ent)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 275d0c847f05..d4c606a06bcd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5224,7 +5224,7 @@ static inline void mem_cgroup_id_put(struct mem_cgroup *memcg)
  *
  * Caller must hold rcu_read_lock().
  */
-struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
+struct mem_cgroup *mem_cgroup_from_id(int id)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	return idr_find(&mem_cgroup_idr, id);
@@ -7021,7 +7021,7 @@ int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
 {
 	struct folio *folio = page_folio(page);
 	struct mem_cgroup *memcg;
-	unsigned short id;
+	int id;
 	int ret;
 
 	if (mem_cgroup_disabled())
@@ -7541,7 +7541,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 {
 	struct mem_cgroup *memcg;
-	unsigned short id;
+	int id;
 
 	id = swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index 5a9442979a18..76fa5c42e03f 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -15,7 +15,7 @@ struct swap_cgroup_ctrl {
 static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
 
 struct swap_cgroup {
-	unsigned short		id;
+	int		id;
 };
 #define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
 
@@ -94,8 +94,7 @@ static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
  * Returns old id at success, 0 at failure.
  * (There is no mem_cgroup using 0 as its id)
  */
-unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
-					unsigned short old, unsigned short new)
+int swap_cgroup_cmpxchg(swp_entry_t ent, int old, int new)
 {
 	struct swap_cgroup_ctrl *ctrl;
 	struct swap_cgroup *sc;
@@ -123,8 +122,7 @@ unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
  * Returns old value at success, 0 at failure.
  * (Of course, old value can be 0.)
  */
-unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
-				  unsigned int nr_ents)
+int swap_cgroup_record(swp_entry_t ent, int id, unsigned int nr_ents)
 {
 	struct swap_cgroup_ctrl *ctrl;
 	struct swap_cgroup *sc;
@@ -159,7 +157,7 @@ unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
  *
  * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
  */
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
+int lookup_swap_cgroup_id(swp_entry_t ent)
 {
 	return lookup_swap_cgroup(ent, NULL)->id;
 }
-- 
2.36.1

