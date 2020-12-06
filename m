From: Muchun Song <songmuchun@bytedance.com>
Subject: [RESEND PATCH v2 00/12] Convert all vmstat counters to pages or bytes
Date: Sun,  6 Dec 2020 18:14:39 +0800
Message-ID: <20201206101451.14706-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=94t92p220d3blDFDgpx+1JH+mQKvnsugZ3wYNVpL5Pc=;
        b=OwCooS6JnoVJtx0PMPgjcjea2S32p4mWIdoGUfK10OCc8UcA/uXphkjEoq3G+vtn0f
         ianhMPygjhbaQE/k3V2OaW1BPCvnRiB7c60kjzCNDiznenvRfo3NRkDbFvzppX7T45bG
         +S/GHPYj8t8D7DyK5Fnez4Lxt+PBYFWYnE5TtDmGXwXhcyG1D4aT8uet+hzDH3Gz2mL1
         M5pqeyrxjAReO81aNkaTykF1LM8ROq5hBYICb/mxcKNOxUw/yj3JRV6zPOVUsbEzFon+
         mk4KW7TwzPPkNKJJC1tN9AE4eFhUEtIOmpEjVxmXWyl4309sOwlCpJCYw4cq/unUV0Gl
         SIBw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, will@kernel.org, guro@fb.com, rppt@kernel.org, tglx@linutronix.de, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, surenb@google.com, avagin@openvz.org, elver@google.com, rdunlap@infradead.org, iamjoonsoo.kim@lge.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

Hi,

This patch series is aimed to convert all THP vmstat counters to pages
and some KiB vmstat counters to bytes.

The unit of some vmstat counters are pages, some are bytes, some are
HPAGE_PMD_NR, and some are KiB. When we want to expose these vmstat
counters to the userspace, we have to know the unit of the vmstat counters
is which one. It makes the code complex. Because there are too many choices,
the probability of making a mistake will be greater.

For example, the below is some bug fix:
  - 7de2e9f195b9 ("mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg")
  - not committed(it is the first commit in this series) ("mm: memcontrol: fix NR_ANON_THPS account")

This patch series can make the code simple (161 insertions(+), 187 deletions(-)).
And make the unit of the vmstat counters are either pages or bytes. Fewer choices
means lower probability of making mistakes :).

This was inspired by Johannes and Roman. Thanks to them.

Changes in v1 -> v2:
  - Change the series subject from "Convert all THP vmstat counters to pages"
    to "Convert all vmstat counters to pages or bytes".
  - Convert NR_KERNEL_SCS_KB account to bytes.
  - Convert vmstat slab counters to bytes.
  - Remove {global_}node_page_state_pages.

Muchun Song (12):
  mm: memcontrol: fix NR_ANON_THPS account
  mm: memcontrol: convert NR_ANON_THPS account to pages
  mm: memcontrol: convert NR_FILE_THPS account to pages
  mm: memcontrol: convert NR_SHMEM_THPS account to pages
  mm: memcontrol: convert NR_SHMEM_PMDMAPPED account to pages
  mm: memcontrol: convert NR_FILE_PMDMAPPED account to pages
  mm: memcontrol: convert kernel stack account to bytes
  mm: memcontrol: convert NR_KERNEL_SCS_KB account to bytes
  mm: memcontrol: convert vmstat slab counters to bytes
  mm: memcontrol: scale stat_threshold for byted-sized vmstat
  mm: memcontrol: make the slab calculation consistent
  mm: memcontrol: remove {global_}node_page_state_pages

 drivers/base/node.c     |  25 ++++-----
 fs/proc/meminfo.c       |  22 ++++----
 include/linux/mmzone.h  |  21 +++-----
 include/linux/vmstat.h  |  21 ++------
 kernel/fork.c           |   8 +--
 kernel/power/snapshot.c |   2 +-
 kernel/scs.c            |   4 +-
 mm/filemap.c            |   4 +-
 mm/huge_memory.c        |   9 ++--
 mm/khugepaged.c         |   4 +-
 mm/memcontrol.c         | 131 ++++++++++++++++++++++++------------------------
 mm/oom_kill.c           |   2 +-
 mm/page_alloc.c         |  17 +++----
 mm/rmap.c               |  19 ++++---
 mm/shmem.c              |   3 +-
 mm/vmscan.c             |   2 +-
 mm/vmstat.c             |  54 ++++++++------------
 17 files changed, 161 insertions(+), 187 deletions(-)

-- 
2.11.0

