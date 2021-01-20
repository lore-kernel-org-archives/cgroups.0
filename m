From: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/10] docs/admin-guide: cgroup-v2: typos and spaces
Date: Tue, 19 Jan 2021 16:18:20 -0800
Message-ID: <20210120001824.385168-7-kolyshkin@gmail.com>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MClthhiRASKx89OyXDAWaQGxQLzHlwXXba8sXj7wtYg=;
        b=mSOIbc4Lg/dAwgp5ccUf0gm8Q8YOE4xeHySRx9KMvE3UueOXiwM1ZOnFQYjECzUZQz
         gXjmlwo9Y+lLkWSuwEaVps+e5wp30twhKpbzcX9sWh4DO1+jFGzQxhQT2Z5l1pIehvFc
         YWDGEO7MSVE0+vyHixnVh56JRzRXcf8v31WV5O+K6i1hV4vpSaO4orX/WPPk1U+2yY77
         6VBrDkN7KyK1+YhNbwQLrNl1WL2LTOv3mDCi9RZh/BoSp1dWQ8Jbc6aKDsuo/zjzmpub
         DXEgFCuFNBlsVUaSJRGGomIPtIuzgbNtCSOlC5Zfl1VxG8nBb6iHgGQYxO3QrkNFyDNQ
         fEEQ==
In-Reply-To: <20210120001824.385168-1-kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet-T1hC0tSOHrs@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

- fix a typo (mempry -> memory) in a file name;
- add space before "(" where appropriate.

Fixes: 5f9a4f4a70960
Signed-off-by: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 34 ++++++++++++-------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b55362454886..073f976d44ea 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1263,9 +1263,9 @@ PAGE_SIZE multiple when read back.
 	can show up in the middle. Don't rely on items remaining in a
 	fixed position; use the keys to look up specific values!
 
-	If the entry has no per-node counter(or not show in the
-	mempry.numa_stat). We use 'npn'(non-per-node) as the tag
-	to indicate that it will not show in the mempry.numa_stat.
+	If the entry has no per-node counter (or not show in the
+	memory.numa_stat). We use 'npn' (non-per-node) as the tag
+	to indicate that it will not show in the memory.numa_stat.
 
 	  anon
 		Amount of memory used in anonymous mappings such as
@@ -1281,11 +1281,11 @@ PAGE_SIZE multiple when read back.
 	  pagetables
                 Amount of memory allocated for page tables.
 
-	  percpu(npn)
+	  percpu (npn)
 		Amount of memory used for storing per-cpu kernel
 		data structures.
 
-	  sock(npn)
+	  sock (npn)
 		Amount of memory used in network transmission buffers
 
 	  shmem
@@ -1333,7 +1333,7 @@ PAGE_SIZE multiple when read back.
 		Part of "slab" that cannot be reclaimed on memory
 		pressure.
 
-	  slab(npn)
+	  slab (npn)
 		Amount of memory used for storing in-kernel data
 		structures.
 
@@ -1361,39 +1361,39 @@ PAGE_SIZE multiple when read back.
 	  workingset_nodereclaim
 		Number of times a shadow node has been reclaimed
 
-	  pgfault(npn)
+	  pgfault (npn)
 		Total number of page faults incurred
 
-	  pgmajfault(npn)
+	  pgmajfault (npn)
 		Number of major page faults incurred
 
-	  pgrefill(npn)
+	  pgrefill (npn)
 		Amount of scanned pages (in an active LRU list)
 
-	  pgscan(npn)
+	  pgscan (npn)
 		Amount of scanned pages (in an inactive LRU list)
 
-	  pgsteal(npn)
+	  pgsteal (npn)
 		Amount of reclaimed pages
 
-	  pgactivate(npn)
+	  pgactivate (npn)
 		Amount of pages moved to the active LRU list
 
-	  pgdeactivate(npn)
+	  pgdeactivate (npn)
 		Amount of pages moved to the inactive LRU list
 
-	  pglazyfree(npn)
+	  pglazyfree (npn)
 		Amount of pages postponed to be freed under memory pressure
 
-	  pglazyfreed(npn)
+	  pglazyfreed (npn)
 		Amount of reclaimed lazyfree pages
 
-	  thp_fault_alloc(npn)
+	  thp_fault_alloc (npn)
 		Number of transparent hugepages which were allocated to satisfy
 		a page fault. This counter is not present when CONFIG_TRANSPARENT_HUGEPAGE
                 is not set.
 
-	  thp_collapse_alloc(npn)
+	  thp_collapse_alloc (npn)
 		Number of transparent hugepages which were allocated to allow
 		collapsing an existing range of pages. This counter is not
 		present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
-- 
2.29.2

