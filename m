From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] MAINTAINERS, mm: add IRC info and update include file list
Date: Thu, 15 Dec 2016 09:08:48 +0100
Message-ID: <20161215080848.18070-1-vbabka@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>

There's a new C: entry for IRC or similar chat, so add the OFTC #mm channel.
While at it, add more F: entries for least the more prominent include/ files
related to mm.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 MAINTAINERS | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 59c9895d73d5..fd1ac4bfc2cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3355,6 +3355,7 @@ M:	Vladimir Davydov <vdavydov.dev@gmail.com>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/memcontrol.h
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
 
@@ -8058,12 +8059,27 @@ F:	include/uapi/linux/membarrier.h
 MEMORY MANAGEMENT
 L:	linux-mm@kvack.org
 W:	http://www.linux-mm.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	include/linux/mm.h
+F:	include/linux/mm_types.h
+F:	include/linux/mm_inline.h
+F:	include/linux/mmdebug.h
+F:	include/linux/compaction.h
+F:	include/linux/oom.h
 F:	include/linux/gfp.h
 F:	include/linux/mmzone.h
 F:	include/linux/memory_hotplug.h
+F:	include/linux/mempolicy.h
+F:	include/linux/page-isolation.h
+F:	include/linux/page_ext.h
+F:	include/linux/page_owner.h
+F:	include/linux/migrate.h
+F:	include/linux/hugetlb.h
+F:	include/linux/rmap.h
 F:	include/linux/vmalloc.h
+F:	include/linux/vmstat.h
+F:	include/linux/vm_event_item.h
 F:	mm/
 
 MEMORY TECHNOLOGY DEVICES (MTD)
-- 
2.11.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
