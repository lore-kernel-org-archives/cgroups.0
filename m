From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v6 0/7] Convert all THP vmstat counters to pages
Date: Tue, 29 Dec 2020 00:41:03 +0800
Message-ID: <20201228164110.2838-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9BSdNC8lHN68aG8S1wMx9ZgOFQWuy+oQNc4t7FQtAYE=;
        b=JCYWpHOzrc0moPNkbT4K1+8ejthEgyO6J+0H5rLuTnRgqihY4K8EhTtP+EVmWbPcFR
         SM7d3vlwF1uregFJzL88mMfEgzxWPySQMav0rGrq2KbjIKi9z6NsdGFpenHQyBHrG15Q
         s2zNXzxrf3uruZ6May8QER0dm9ZwgtH1Bw19ePcMnU0bT8yLCiLsRpSoA6a+Ee9uy80a
         VTXp4hvFo5LyOivbl+eL4I9B5I1N1RPJlKFswoJegcrbaR06PqMguSQZH7Q5apu8Zx+e
         IAJ5rjKcRFa1h+DzzYqVMqzYAsITA8GkCzfxMfOYD7VaBybB+Pi8J6qBO53r3G0QVr13
         h6LA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, shakeelb@google.com, guro@fb.com, samitolvanen@google.com, feng.tang@intel.com, neilb@suse.de, iamjoonsoo.kim@lge.com, rdunlap@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

This patch series is aimed to convert all THP vmstat counters to pages.

The unit of some vmstat counters are pages, some are bytes, some are
HPAGE_PMD_NR, and some are KiB. When we want to expose these vmstat
counters to the userspace, we have to know the unit of the vmstat counters
is which one. When the unit is bytes or kB, both clearly distinguishable
by the B/KB suffix. But for the THP vmstat counters, we may make mistakes.

For example, the below is some bug fix for the THP vmstat counters:

  - 7de2e9f195b9 ("mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg")
  - The first commit in this series ("fix NR_ANON_THPS accounting in charge moving")

This patch series can make the code clear. And make all the unit of the THP
vmstat counters in pages. Finally, the unit of the vmstat counters are
pages, kB and bytes. The B/KB suffix can tell us that the unit is bytes
or kB. The rest which is without suffix are pages.

In this series, I changed the following vmstat counters unit from HPAGE_PMD_NR
to pages. However, there is no change to the print format of output to user
space.

  - NR_ANON_THPS
  - NR_FILE_THPS
  - NR_SHMEM_THPS
  - NR_SHMEM_PMDMAPPED
  - NR_FILE_PMDMAPPED

Doing this also can make the statistics more accuracy for the THP vmstat
counters. This series is consistent with 8f182270dfec ("mm/swap.c: flush lru
pvecs on compound page arrival").

Because we use struct per_cpu_nodestat to cache the vmstat counters, which
leads to inaccurate statistics especially THP vmstat counters. In the systems
with hundreds of processors it can be GBs of memory. For example, for a 96
CPUs system, the threshold is the maximum number of 125. And the per cpu
counters can cache 23.4375 GB in total.

The THP page is already a form of batched addition (it will add 512 worth of
memory in one go) so skipping the batching seems like sensible. Although every
THP stats update overflows the per-cpu counter, resorting to atomic global
updates. But it can make the statistics more accuracy for the THP vmstat
counters. From this point of view, I think that do this converting is
reasonable.

Thanks Hugh for mentioning this. This was inspired by Johannes and Roman.
Thanks to them.

Changes in v5 -> v6:
  - Fix compiler errors when CONFIG_TRANSPARENT_HUGEPAGE is not set/enabled
    reported by Randy Dunlap <rdunlap@infradead.org>. Thanks.
  - Fix typo in the commit message.

Changes in v4 -> v5:
  - Add motivation to each patch. Thanks to Michal.
  - Replace some HPAGE_PMD_NR to thp_nr_pages(). Thanks to Matthew.

Changes in v3 -> v4:
  - Rename the first commit subject to "mm: memcontrol: fix NR_ANON_THPS
    accounting in charge moving".
  - Fix /proc/vmstat printing. Thanks to Johannes points out that.

Changes in v2 -> v3:
  - Change the series subject from "Convert all vmstat counters to pages or bytes"
    to "Convert all THP vmstat counters to pages".
  - Remove convert of KB to B.

Changes in v1 -> v2:
  - Change the series subject from "Convert all THP vmstat counters to pages"
    to "Convert all vmstat counters to pages or bytes".
  - Convert NR_KERNEL_SCS_KB account to bytes.
  - Convert vmstat slab counters to bytes.
  - Remove {global_}node_page_state_pages.

Muchun Song (7):
  mm: memcontrol: fix NR_ANON_THPS accounting in charge moving
  mm: memcontrol: convert NR_ANON_THPS account to pages
  mm: memcontrol: convert NR_FILE_THPS account to pages
  mm: memcontrol: convert NR_SHMEM_THPS account to pages
  mm: memcontrol: convert NR_SHMEM_PMDMAPPED account to pages
  mm: memcontrol: convert NR_FILE_PMDMAPPED account to pages
  mm: memcontrol: make the slab calculation consistent

 drivers/base/node.c    |  27 +++++-----
 fs/proc/meminfo.c      |  10 ++--
 include/linux/mmzone.h |  17 +++++++
 mm/filemap.c           |   4 +-
 mm/huge_memory.c       |  11 +++--
 mm/khugepaged.c        |   6 ++-
 mm/memcontrol.c        | 132 +++++++++++++++++++++++--------------------------
 mm/page_alloc.c        |   7 ++-
 mm/rmap.c              |  26 ++++++----
 mm/shmem.c             |   2 +-
 mm/vmstat.c            |  11 ++++-
 11 files changed, 142 insertions(+), 111 deletions(-)

-- 
2.11.0

