From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: remove useless check on page->mem_cgroup
Date: Tue, 4 Aug 2020 15:35:08 +0800
Message-ID: <bd61e672-b997-c4cd-2047-fca9dc11cc4c@linux.alibaba.com>
References: <1596166480-22814-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200731151655.GB491801@cmpxchg.org>
 <9338716f-ca0e-057f-8d94-03e2b3f70281@linux.alibaba.com>
 <20200803081815.GD5174@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200803081815.GD5174-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



在 2020/8/3 下午4:18, Michal Hocko 写道:
> On Sat 01-08-20 11:58:41, Alex Shi wrote:
>>
>>
>> 在 2020/7/31 下午11:16, Johannes Weiner 写道:
>>>>  	if (!entry.val) {
>>>>  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>>> Uncharged readahead pages are gone, but I'm not 100% sure uncharged
>>> pages in general are gone. ISTR that the !page->mem_cgroup check in
>>> mem_cgroup_uncharge() prevented a crash - although that is of course a
>>> much broader interface, whereas the ones you change should only apply
>>> to LRU pages (which are hopefully all charged).
>>>
>>> Nevertheless, to avoid unnecessary crashes if we discover that we've
>>> been wrong, how about leaving the branches for now, but adding a (new)
>>> VM_WARN_ON_ONCE_PAGE() to them?
> 
> Agreed!
> 
>> Right, let's see if other unexcepted things happens, and then do actions.
>> So it's the patch:
>>
>> >From 28893cf8e55b98665cce58c0ba6d54aeafb63a62 Mon Sep 17 00:00:00 2001
>> From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>> Date: Sat, 1 Aug 2020 10:43:55 +0800
>> Subject: [PATCH] mm/memcg: warning on !memcg after readahead page charged
>>
>> Since readahead page is charged on memcg too, in theory we don't have to
>> check this exception now. Before safely remove them all, add a warning
>> for the unexpected !memcg.
> 
> I would find it useful to mention since when this assumption holds.> 
>> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>  include/linux/mmdebug.h |  8 ++++++++
>>  mm/memcontrol.c         | 15 ++++++++-------
>>  2 files changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
>> index 2ad72d2c8cc5..639e98a3384e 100644
>> --- a/include/linux/mmdebug.h
>> +++ b/include/linux/mmdebug.h
>> @@ -37,6 +37,13 @@
>>  			BUG();						\
>>  		}							\
>>  	} while (0)
>> +#define VM_WARN_ON_ONCE_PAGE(cond, page)				\
>> +	do {								\
>> +		if (unlikely(cond)) {					\
>> +			dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
>> +			WARN_ON_ONCE(cond);				\
>> +		}							\
> 
> This is a bit strange behavior. You dump page for each occasion but warn
> only once. I would expect either "once" semantic for any output or just
> dump on each occasion because if the whole point is to reduce to amount
> of output then the above doesn't serve the purpose.
> 

Yes, left more dump_page may ommited by users. for reduce dmesg purpose, warn once
is better.

Thanks for comment!
Alex 
--
From 3cee031d50625733a64b58240d0e6f8151e5299c Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Date: Sat, 1 Aug 2020 10:43:55 +0800
Subject: [PATCH v2] mm/memcg: warning on !memcg after readahead page charged

Since readahead page is charged on memcg too, in theory we don't have to
check this exception now. Before safely remove them all, add a warning
for the unexpected !memcg.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/linux/mmdebug.h | 13 +++++++++++++
 mm/memcontrol.c         | 15 ++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 2ad72d2c8cc5..698eaf56f89f 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -37,6 +37,18 @@
 			BUG();						\
 		}							\
 	} while (0)
+#define VM_WARN_ON_ONCE_PAGE(condition, page)	({			\
+	static bool __section(.data.once) __warned;			\
+	int __ret_warn_once = !!(condition);				\
+									\
+	if (unlikely(__ret_warn_once && !__warned)) {			\
+		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
+		__warned = true;					\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn_once);					\
+})
+
 #define VM_WARN_ON(cond) (void)WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) (void)WARN_ONCE(cond, format)
@@ -48,6 +60,7 @@
 #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 130093bdf74b..299382fc55a9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1322,10 +1322,8 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
 	}
 
 	memcg = page->mem_cgroup;
-	/*
-	 * Swapcache readahead pages are added to the LRU - and
-	 * possibly migrated - before they are charged.
-	 */
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
@@ -6906,8 +6904,9 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 	if (newpage->mem_cgroup)
 		return;
 
-	/* Swapcache readahead pages can get replaced before being charged */
 	memcg = oldpage->mem_cgroup;
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, oldpage);
 	if (!memcg)
 		return;
 
@@ -7104,7 +7103,8 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 
 	memcg = page->mem_cgroup;
 
-	/* Readahead page, never charged */
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		return;
 
@@ -7168,7 +7168,8 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 
 	memcg = page->mem_cgroup;
 
-	/* Readahead page, never charged */
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		return 0;
 
-- 
1.8.3.1

