From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 4/4] mm: Add orphaned kernel-doc to the rst files.
Date: Fri, 18 Aug 2023 21:06:30 +0100
Message-ID: <20230818200630.2719595-5-willy@infradead.org>
References: <20230818200630.2719595-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HEUqudgPIORhVtUepujoEAHkjLRlCh4kIh4ylDVS334=; b=fOFUrOiJoU+PYtWXIoWPp0biHN
        1Iq2DbevP7Pj0Xo/lF1SpR5VllaM/JQGPznG3Hqk5Xwy0HQgNVBF0kqx56qtEkZ9YveSgLQD5ltey
        HeNAHPvW1If7K5JSc3kmmXIjsUGO4iKiKBZQUwC3r8p9h2WDYgK3axUogZZCbsRn9hyNh1W20nr5P
        jSNtiUDZRYo/5plPR1Q6xFGlrqFsptza3FrnkXM1My+Io2Fq3aTUTxMGlURxE9wEeOvYOOEmk1ZYz
        VuC0LdL2kbXOmnQwLGUSJJ+Ewit+QsdinLFP3OXV0FInJsbi4m5MR5SvQm02k8nwnErrrcqgx38am
        qKtG6Lqw==;
In-Reply-To: <20230818200630.2719595-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There are many files in mm/ that contain kernel-doc which is not
currently published on kernel.org.  Some of it is easily categorisable,
but most of it is going into the miscellaneous documentation section to
be organised later.

Some files aren't ready to be included; they contain documentation with
build errors.  Or they're nommu.c which duplicates documentation from
"real" MMU systems.  Those files are noted with a # mark (although really
anything which isn't a recognised directive would do to prevent inclusion)

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 Documentation/core-api/mm-api.rst | 25 +++++++++++++++++++++++++
 Documentation/mm/highmem.rst      |  1 +
 Documentation/mm/zsmalloc.rst     |  5 +++++
 3 files changed, 31 insertions(+)

diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
index f5dde5bceaea..2d091c873d1e 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -115,3 +115,28 @@ More Memory Management Functions
 .. kernel-doc:: include/linux/mmzone.h
 .. kernel-doc:: mm/util.c
    :functions: folio_mapping
+
+.. kernel-doc:: mm/rmap.c
+.. kernel-doc:: mm/migrate.c
+.. kernel-doc:: mm/mmap.c
+.. kernel-doc:: mm/kmemleak.c
+.. #kernel-doc:: mm/hmm.c (build warnings)
+.. kernel-doc:: mm/memremap.c
+.. kernel-doc:: mm/hugetlb.c
+.. kernel-doc:: mm/swap.c
+.. kernel-doc:: mm/zpool.c
+.. kernel-doc:: mm/memcontrol.c
+.. #kernel-doc:: mm/memory-tiers.c (build warnings)
+.. kernel-doc:: mm/shmem.c
+.. kernel-doc:: mm/migrate_device.c
+.. #kernel-doc:: mm/nommu.c (duplicates kernel-doc from other files)
+.. kernel-doc:: mm/mapping_dirty_helpers.c
+.. #kernel-doc:: mm/memory-failure.c (build warnings)
+.. kernel-doc:: mm/percpu.c
+.. kernel-doc:: mm/maccess.c
+.. kernel-doc:: mm/vmscan.c
+.. kernel-doc:: mm/memory_hotplug.c
+.. kernel-doc:: mm/mmu_notifier.c
+.. kernel-doc:: mm/balloon_compaction.c
+.. kernel-doc:: mm/huge_memory.c
+.. kernel-doc:: mm/io-mapping.c
diff --git a/Documentation/mm/highmem.rst b/Documentation/mm/highmem.rst
index fe68e02fc8ff..9d92e3f2b3d6 100644
--- a/Documentation/mm/highmem.rst
+++ b/Documentation/mm/highmem.rst
@@ -209,4 +209,5 @@ Functions
 =========
 
 .. kernel-doc:: include/linux/highmem.h
+.. kernel-doc:: mm/highmem.c
 .. kernel-doc:: include/linux/highmem-internal.h
diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
index a3c26d587752..76902835e68e 100644
--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -263,3 +263,8 @@ is heavy internal fragmentation and zspool compaction is unable to relocate
 objects and release zspages. In these cases, it is recommended to decrease
 the limit on the size of the zspage chains (as specified by the
 CONFIG_ZSMALLOC_CHAIN_SIZE option).
+
+Functions
+=========
+
+.. kernel-doc:: mm/zsmalloc.c
-- 
2.40.1

