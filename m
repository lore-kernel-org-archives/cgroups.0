From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v2 6/9] docs: cgroup-v1: use bullet lists for list of stat file tables
Date: Thu,  5 Jan 2023 20:16:31 +0700
Message-ID: <20230105131633.553574-7-bagasdotme@gmail.com>
References: <20230105131633.553574-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xwHqK93GBSz13u5EOGerS6VNG9qcHKdmktoqbjmWNKQ=;
        b=I+haejsbxcT8QansUCm5NiZgqf2JOyk2XoX+L9ANWJ+oZ3TVmy88uTaaDIAnH60Se4
         QC+8pZ1DVABAn9fbxX+01giMJL8QxVbK5JPMK71xZAR5l7hIoZ2HXOLK7XsTFATW8Ixz
         q5RKiApAiRwuaEXAif1bny8NJyICU1d5b6cBVkt8ozpHIt9kHXCkiP5RwaeGheITxLGD
         pv66I/8vKCfVNCU4pCKkHXOn0aYd0sZ7fEE9fRKjDaTaPdM6tDTlOWpzJaqe86/t7zq+
         J5IuSSFoT4VVRLtFO79+qqLr4ipbuvJqdL0XtgxljHoOaC9wrD8egICm691ltJy92+D9
         o4lg==
In-Reply-To: <20230105131633.553574-1-bagasdotme@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=6795; i=bagasdotme@gmail.com; h=from:subject; bh=SoIEcDdcT5n5ldqzkBmfedkjJd/EdMw6QuqYA3S+KDs=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnbzm6ofK+yRrC/JWDHq/r1ulxRxxxnKLB3/v5w8IjPvxk1 Z7pEOkpZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjAR325GhpZFRVP+NhbwxQf07X/ULH dQqH2NpZHRx3nVQsUaj+IvuTD8z7n7YJ5tTpdh076r6d6G/05xbVAXtfb+sau3RtPG+o4bBwA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups@vger.kernel.org>, Linux Documentation <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

The stat file section contains three tables, where the leading texts for
them are subsection heading. Organize them in the bullet list, while
demoting headings into normal text.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../admin-guide/cgroup-v1/memory.rst          | 93 +++++++++----------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 4d96a5bbbfcfdc..162cc26dcddb25 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -519,60 +519,59 @@ will be charged as a new owner of it.
 5.2 stat file
 -------------
 
-memory.stat file includes following statistics
+memory.stat file includes following statistics:
 
-per-memory cgroup local status
-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+  * per-memory cgroup local status
 
-=============== ===============================================================
-cache		# of bytes of page cache memory.
-rss		# of bytes of anonymous and swap cache memory (includes
-		transparent hugepages).
-rss_huge	# of bytes of anonymous transparent hugepages.
-mapped_file	# of bytes of mapped file (includes tmpfs/shmem)
-pgpgin		# of charging events to the memory cgroup. The charging
-		event happens each time a page is accounted as either mapped
-		anon page(RSS) or cache page(Page Cache) to the cgroup.
-pgpgout		# of uncharging events to the memory cgroup. The uncharging
-		event happens each time a page is unaccounted from the cgroup.
-swap		# of bytes of swap usage
-dirty		# of bytes that are waiting to get written back to the disk.
-writeback	# of bytes of file/anon cache that are queued for syncing to
-		disk.
-inactive_anon	# of bytes of anonymous and swap cache memory on inactive
-		LRU list.
-active_anon	# of bytes of anonymous and swap cache memory on active
-		LRU list.
-inactive_file	# of bytes of file-backed memory and MADV_FREE anonymous memory(
-                LazyFree pages) on inactive LRU list.
-active_file	# of bytes of file-backed memory on active LRU list.
-unevictable	# of bytes of memory that cannot be reclaimed (mlocked etc).
-=============== ===============================================================
+    =============== ===============================================================
+    cache           # of bytes of page cache memory.
+    rss             # of bytes of anonymous and swap cache memory (includes
+                    transparent hugepages).
+    rss_huge        # of bytes of anonymous transparent hugepages.
+    mapped_file     # of bytes of mapped file (includes tmpfs/shmem)
+    pgpgin          # of charging events to the memory cgroup. The charging
+                    event happens each time a page is accounted as either mapped
+                    anon page(RSS) or cache page(Page Cache) to the cgroup.
+    pgpgout         # of uncharging events to the memory cgroup. The uncharging
+                    event happens each time a page is unaccounted from the
+                    cgroup.
+    swap            # of bytes of swap usage
+    dirty           # of bytes that are waiting to get written back to the disk.
+    writeback       # of bytes of file/anon cache that are queued for syncing to
+                    disk.
+    inactive_anon   # of bytes of anonymous and swap cache memory on inactive
+                    LRU list.
+    active_anon     # of bytes of anonymous and swap cache memory on active
+                    LRU list.
+    inactive_file   # of bytes of file-backed memory and MADV_FREE anonymous
+                    memory (LazyFree pages) on inactive LRU list.
+    active_file     # of bytes of file-backed memory on active LRU list.
+    unevictable     # of bytes of memory that cannot be reclaimed (mlocked etc).
+    =============== ===============================================================
 
-status considering hierarchy (see memory.use_hierarchy settings)
-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+  * status considering hierarchy (see memory.use_hierarchy settings):
 
-========================= ===================================================
-hierarchical_memory_limit # of bytes of memory limit with regard to hierarchy
-			  under which the memory cgroup is
-hierarchical_memsw_limit  # of bytes of memory+swap limit with regard to
-			  hierarchy under which memory cgroup is.
+    ========================= ===================================================
+    hierarchical_memory_limit # of bytes of memory limit with regard to
+                              hierarchy
+                              under which the memory cgroup is
+    hierarchical_memsw_limit  # of bytes of memory+swap limit with regard to
+                              hierarchy under which memory cgroup is.
 
-total_<counter>		  # hierarchical version of <counter>, which in
-			  addition to the cgroup's own value includes the
-			  sum of all hierarchical children's values of
-			  <counter>, i.e. total_cache
-========================= ===================================================
+    total_<counter>           # hierarchical version of <counter>, which in
+                              addition to the cgroup's own value includes the
+                              sum of all hierarchical children's values of
+                              <counter>, i.e. total_cache
+    ========================= ===================================================
 
-The following additional stats are dependent on CONFIG_DEBUG_VM
-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+  * additional vm parameters (depends on CONFIG_DEBUG_VM):
 
-========================= ========================================
-recent_rotated_anon	  VM internal parameter. (see mm/vmscan.c)
-recent_rotated_file	  VM internal parameter. (see mm/vmscan.c)
-recent_scanned_anon	  VM internal parameter. (see mm/vmscan.c)
-recent_scanned_file	  VM internal parameter. (see mm/vmscan.c)
-========================= ========================================
+    ========================= ========================================
+    recent_rotated_anon       VM internal parameter. (see mm/vmscan.c)
+    recent_rotated_file       VM internal parameter. (see mm/vmscan.c)
+    recent_scanned_anon       VM internal parameter. (see mm/vmscan.c)
+    recent_scanned_file       VM internal parameter. (see mm/vmscan.c)
+    ========================= ========================================
 
 .. hint::
 	recent_rotated means recent frequency of LRU rotation.
-- 
An old man doll... just what I always wanted! - Clara

