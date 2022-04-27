From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Wed, 27 Apr 2022 15:50:53 -0400
Message-ID: <YmmenecCDr6kGvUj@cmpxchg.org>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
 <20220427160016.144237-5-hannes@cmpxchg.org>
 <20220427113654.ef8f543d7ba279952deff6f7@linux-foundation.org>
 <YmmRFOXJsjLj4a7T@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k+WgA/O8MaxUP5azclBG6sokoNy5o8y4yUP26OXeOR8=;
        b=uZ1xC8QsRltCCvXVNLLZ1uFUimA+Fhk6x01BztYRJkzQp1XAwiBizFhhQGludB4RF8
         6rJLldZpRuACG9IdRMhUdEqAqGHgcGPAQZ0FaU91KWtccpugv+IC1JFBJPoPGf1Xtzhi
         1O+BVuzb4GQDhfIsVbvwaaCtDIXlFkFoXouKLF4gC0eWBXGxwxEUFQ9r9NH+7D8hE9C7
         hGspL61RcL/LjuXlXv+DMBGM8j0jopHuQT3YKb8hkgCwtFNFMxhj3sYhn/Py9vg39yG9
         kr/xC6HCXsINGpwqvzk+vdVXZedyWOkPUMuCscpfSTRvKynfQ229ZhTwLlpoYLbBjWU4
         oK2g==
Content-Disposition: inline
In-Reply-To: <YmmRFOXJsjLj4a7T-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Apr 27, 2022 at 02:53:10PM -0400, Johannes Weiner wrote:
> I'll send a general update for that [...]

From dca20a3a4ae2218f2db7d6e9abb47f6ca9004273 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date: Wed, 27 Apr 2022 15:36:07 -0400
Subject: [PATCH 1/7] Documentation: filesystems: proc: update meminfo section

Add new entries. Minor corrections and cleanups.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 Documentation/filesystems/proc.rst | 155 ++++++++++++++++++-----------
 1 file changed, 99 insertions(+), 56 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 061744c436d9..736ed384750c 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -942,56 +942,71 @@ can be substantial.  In many cases there are other means to find out
 additional memory using subsystem specific interfaces, for instance
 /proc/net/sockstat for TCP memory allocations.
 
-The following is from a 16GB PIII, which has highmem enabled.
-You may not have all of these fields.
+Example output. You may not have all of these fields.
 
 ::
 
     > cat /proc/meminfo
 
-    MemTotal:     16344972 kB
-    MemFree:      13634064 kB
-    MemAvailable: 14836172 kB
-    Buffers:          3656 kB
-    Cached:        1195708 kB
-    SwapCached:          0 kB
-    Active:         891636 kB
-    Inactive:      1077224 kB
-    HighTotal:    15597528 kB
-    HighFree:     13629632 kB
-    LowTotal:       747444 kB
-    LowFree:          4432 kB
-    SwapTotal:           0 kB
-    SwapFree:            0 kB
-    Dirty:             968 kB
-    Writeback:           0 kB
-    AnonPages:      861800 kB
-    Mapped:         280372 kB
-    Shmem:             644 kB
-    KReclaimable:   168048 kB
-    Slab:           284364 kB
-    SReclaimable:   159856 kB
-    SUnreclaim:     124508 kB
-    PageTables:      24448 kB
-    NFS_Unstable:        0 kB
-    Bounce:              0 kB
-    WritebackTmp:        0 kB
-    CommitLimit:   7669796 kB
-    Committed_AS:   100056 kB
-    VmallocTotal:   112216 kB
-    VmallocUsed:       428 kB
-    VmallocChunk:   111088 kB
-    Percpu:          62080 kB
-    HardwareCorrupted:   0 kB
-    AnonHugePages:   49152 kB
-    ShmemHugePages:      0 kB
-    ShmemPmdMapped:      0 kB
+    MemTotal:       32858820 kB
+    MemFree:        21001236 kB
+    MemAvailable:   27214312 kB
+    Buffers:          581092 kB
+    Cached:          5587612 kB
+    SwapCached:            0 kB
+    Active:          3237152 kB
+    Inactive:        7586256 kB
+    Active(anon):      94064 kB
+    Inactive(anon):  4570616 kB
+    Active(file):    3143088 kB
+    Inactive(file):  3015640 kB
+    Unevictable:           0 kB
+    Mlocked:               0 kB
+    SwapTotal:             0 kB
+    SwapFree:              0 kB
+    Dirty:                12 kB
+    Writeback:             0 kB
+    AnonPages:       4654780 kB
+    Mapped:           266244 kB
+    Shmem:              9976 kB
+    KReclaimable:     517708 kB
+    Slab:             660044 kB
+    SReclaimable:     517708 kB
+    SUnreclaim:       142336 kB
+    KernelStack:       11168 kB
+    PageTables:        20540 kB
+    NFS_Unstable:          0 kB
+    Bounce:                0 kB
+    WritebackTmp:          0 kB
+    CommitLimit:    16429408 kB
+    Committed_AS:    7715148 kB
+    VmallocTotal:   34359738367 kB
+    VmallocUsed:       40444 kB
+    VmallocChunk:          0 kB
+    Percpu:            29312 kB
+    HardwareCorrupted:     0 kB
+    AnonHugePages:   4149248 kB
+    ShmemHugePages:        0 kB
+    ShmemPmdMapped:        0 kB
+    FileHugePages:         0 kB
+    FilePmdMapped:         0 kB
+    CmaTotal:              0 kB
+    CmaFree:               0 kB
+    HugePages_Total:       0
+    HugePages_Free:        0
+    HugePages_Rsvd:        0
+    HugePages_Surp:        0
+    Hugepagesize:       2048 kB
+    Hugetlb:               0 kB
+    DirectMap4k:      401152 kB
+    DirectMap2M:    10008576 kB
+    DirectMap1G:    24117248 kB
 
 MemTotal
               Total usable RAM (i.e. physical RAM minus a few reserved
               bits and the kernel binary code)
 MemFree
-              The sum of LowFree+HighFree
+              Total free RAM. On highmem systems, the sum of LowFree+HighFree
 MemAvailable
               An estimate of how much memory is available for starting new
               applications, without swapping. Calculated from MemFree,
@@ -1005,8 +1020,9 @@ Buffers
               Relatively temporary storage for raw disk blocks
               shouldn't get tremendously large (20MB or so)
 Cached
-              in-memory cache for files read from the disk (the
-              pagecache).  Doesn't include SwapCached
+              In-memory cache for files read from the disk (the
+              pagecache) as well as tmpfs & shmem.
+              Doesn't include SwapCached.
 SwapCached
               Memory that once was swapped out, is swapped back in but
               still also is in the swapfile (if memory is needed it
@@ -1018,6 +1034,11 @@ Active
 Inactive
               Memory which has been less recently used.  It is more
               eligible to be reclaimed for other purposes
+Unevictable
+              Memory that cannot be reclaimed, such as mlocked pages,
+              ramfs backing pages, secret memfd pages etc.
+Mlocked
+              Memory locked with mlock().
 HighTotal, HighFree
               Highmem is all memory above ~860MB of physical memory.
               Highmem areas are for use by userspace programs, or
@@ -1040,20 +1061,10 @@ Writeback
               Memory which is actively being written back to the disk
 AnonPages
               Non-file backed pages mapped into userspace page tables
-HardwareCorrupted
-              The amount of RAM/memory in KB, the kernel identifies as
-	      corrupted.
-AnonHugePages
-              Non-file backed huge pages mapped into userspace page tables
 Mapped
               files which have been mmaped, such as libraries
 Shmem
               Total memory used by shared memory (shmem) and tmpfs
-ShmemHugePages
-              Memory used by shared memory (shmem) and tmpfs allocated
-              with huge pages
-ShmemPmdMapped
-              Shared memory mapped into userspace with huge pages
 KReclaimable
               Kernel allocations that the kernel will attempt to reclaim
               under memory pressure. Includes SReclaimable (below), and other
@@ -1064,9 +1075,10 @@ SReclaimable
               Part of Slab, that might be reclaimed, such as caches
 SUnreclaim
               Part of Slab, that cannot be reclaimed on memory pressure
+KernelStack
+              Memory consumed by the kernel stacks of all tasks
 PageTables
-              amount of memory dedicated to the lowest level of page
-              tables.
+              Memory consumed by userspace page tables
 NFS_Unstable
               Always zero. Previous counted pages which had been written to
               the server, but has not been committed to stable storage.
@@ -1098,7 +1110,7 @@ Committed_AS
               has been allocated by processes, even if it has not been
               "used" by them as of yet. A process which malloc()'s 1G
               of memory, but only touches 300M of it will show up as
-	      using 1G. This 1G is memory which has been "committed" to
+              using 1G. This 1G is memory which has been "committed" to
               by the VM and can be used at any time by the allocating
               application. With strict overcommit enabled on the system
               (mode 2 in 'vm.overcommit_memory'), allocations which would
@@ -1107,7 +1119,7 @@ Committed_AS
               not fail due to lack of memory once that memory has been
               successfully allocated.
 VmallocTotal
-              total size of vmalloc memory area
+              total size of vmalloc virtual address space
 VmallocUsed
               amount of vmalloc area which is used
 VmallocChunk
@@ -1115,6 +1127,37 @@ VmallocChunk
 Percpu
               Memory allocated to the percpu allocator used to back percpu
               allocations. This stat excludes the cost of metadata.
+HardwareCorrupted
+              The amount of RAM/memory in KB, the kernel identifies as
+              corrupted.
+AnonHugePages
+              Non-file backed huge pages mapped into userspace page tables
+ShmemHugePages
+              Memory used by shared memory (shmem) and tmpfs allocated
+              with huge pages
+ShmemPmdMapped
+              Shared memory mapped into userspace with huge pages
+FileHugePages
+              Memory used for filesystem data (page cache) allocated
+              with huge pages
+FilePmdMapped
+              Page cache mapped into userspace with huge pages
+CmaTotal
+              Memory reserved for the Contiguous Memory Allocator (CMA)
+CmaFree
+              Free remaining memory in the CMA reserves
+HugePages_Total
+HugePages_Free
+HugePages_Rsvd
+HugePages_Surp
+Hugepagesize
+Hugetlb
+              See Documentation/admin-guide/mm/hugetlbpage.rst.
+DirectMap4k
+DirectMap2M
+DirectMap1G
+              Breakdown of page table sizes used in the kernel's
+              identity mapping of RAM
 
 vmallocinfo
 ~~~~~~~~~~~
-- 
2.35.3

