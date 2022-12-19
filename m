From: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/10] docs: cgroup-v1: use bullet lists for list of stat file tables
Date: Mon, 19 Dec 2022 11:22:06 +0700
Message-ID: <20221219042209.22898-8-bagasdotme@gmail.com>
References: <20221219042209.22898-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lRDhbAuFFMtCfx+H7ZJIpQoYnynck5HVInZvHowpBNk=;
        b=aJ8LYUErJn/ZPG6EC26fQcgCJgiRXAOf+Wbw+PidOOWMUaiVUsUcSgo8htcy1YlFQ7
         5bm1d9ZM3R2uYEKryoIQ4t6aV5PBbAJSRU1yzOikLW9IDPs009uccbn2P3EEMCtnWvJR
         +CyqWbBcyowHmuqUUkGyOLvHs1ktvjGk7UMvLkomuT7rgqpvddtVJC/vMnYvTDSX4Uz9
         unhqp0K6PAkA6+9AIErzHE/RGpYjG/w/jfoTnxq83m5DMytP1sh8csjErB9nFyUidNm+
         woDrW5wk2XJcVeUrU1oFu23rb7xClFXHHQdRWDYcarrITAEVGSjXIOwCNx5JycJ7tL5+
         /HOA==
In-Reply-To: <20221219042209.22898-1-bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=6795; i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; h=from:subject; bh=Qv/IUrGqp6BPq2cwpkOiVBXASeOlAsriWizhHWQnHq4=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnzn703LdK1T/66R/jyZrvEyVzW0yr0r//Oum3vofGLRydv z+/ijlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAExk+lVGhjki233c9qqJ3Zpyt+jn+o gkR7uyW9yffms/71tXPOvhEVZGhmurJaxWvK0rVNIV2j5n64a4vZzP7l50Cfn0u+h7TswiJh4A
X-Developer-Key: i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The stat file section contains three tables, where the leading texts for
them are subsection heading. Organize them in the bullet list, while
demoting headings into normal text.

Signed-off-by: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 .../admin-guide/cgroup-v1/memory.rst          | 93 +++++++++----------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 3b365a72996be5..01104b459b4cbd 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -521,60 +521,59 @@ will be charged as a new owner of it.
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

