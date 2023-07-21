From: <xiongwei.song@windriver.com>
Subject: [PATCH 1/2] docs: cgroup-v1: correct the term of Page Cache organization in inode
Date: Fri, 21 Jul 2023 13:49:37 +0800
Message-ID: <20230721054938.1666475-1-xiongwei.song@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding:content-type; s=PPS06212021; bh=ujkXA
        VCxBZj9F45iQ5IJ+YX1d9OwAy1El3x8A5hKVp0=; b=XDMMhe7OQC17YJgu6jhIY
        nub0gACJkbdJJgC07Mqzhr3CvvcnnNxFIoLXNmGb4w09TbB/bvKGDJfUBDwX6Fg/
        SZJUKgwvJLuoq5HLSWHaZE/shhqGxat5BRy+pCYQDMRvuvLJmdoQH/6MP50eOfOz
        SjHdgHAk0u9d33LAvKks7VDK2k5OuHnn91qOc6GwYJQCJzDfWiwQS1GO/LFXJv9x
        6/M2vrc/noUk8HtjJHFh3abFHPFNWcA4WUI6uKu0edAKXK73uQs0/KZYcV2fUCfW
        KIjTMoR+c3tyVx2FEZv0RbOL5RDqdIl2cg0EyANEPzuINmft9iz4hCIFHgClNyUK
        g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

From: Xiongwei Song <xiongwei.song@windriver.com>

The radix-tree for Page Cache has been replaced with xarray, see
commit eb797a8ee0ab ("page cache: Rearrange address_space"), so move
"radix-tree" to "xarray".

Signed-off-by: Xiongwei Song <xiongwei.song@windriver.com>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 47d1d7d932a8..dcb65b49bb22 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -197,11 +197,11 @@ are not accounted. We just account pages under usual VM management.
 
 RSS pages are accounted at page_fault unless they've already been accounted
 for earlier. A file page will be accounted for as Page Cache when it's
-inserted into inode (radix-tree). While it's mapped into the page tables of
+inserted into inode (xarray). While it's mapped into the page tables of
 processes, duplicate accounting is carefully avoided.
 
 An RSS page is unaccounted when it's fully unmapped. A PageCache page is
-unaccounted when it's removed from radix-tree. Even if RSS pages are fully
+unaccounted when it's removed from xarray. Even if RSS pages are fully
 unmapped (by kswapd), they may exist as SwapCache in the system until they
 are really freed. Such SwapCaches are also accounted.
 A swapped-in page is accounted after adding into swapcache.
-- 
2.25.1

