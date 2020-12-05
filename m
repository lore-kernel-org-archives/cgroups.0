From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 0/9] Convert all THP vmstat counters to pages
Date: Sat,  5 Dec 2020 21:02:15 +0800
Message-ID: <20201205130224.81607-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rn/xJo/gyofLtl+hMU5/+p5RPWpj2PYm655A9wivV4I=;
        b=uba4FH2KhW8Vj9ZYwLUzGFQb0rHgkyFMDpdk3RQHbve17Sp28OLnmrjvqmSb7sYkVZ
         GM2sEhv8//q4hMDDw9bSK+KF1xViMm8tK+G62u/ihXhQtDR6S3MrhvCimce8xo/v1yJc
         bg3/PyxdoGBF2fi20Nbuv+ATPqryNxDZ9soMAkuMxesk34ZbmkQaPxkCzT1BRg3imlEF
         kHEnEc6Y3U3Yo7Oz6xkqjTlFZivTKMRGE7SfVIN3QNGkJTujq9fRG70Z4Kun2RCad9XO
         X4JErJiw7JPjNFWAM6zaHsdGTbDzc6tcn0DKBJmA+DptSICQMiH/IjugkoJWDToHLNgH
         pnlA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, will@kernel.org, guro@fb.com, rppt@kernel.org, tglx@linutronix.de, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, surenb@google.com, avagin@openvz.org, elver@google.com, rdunlap@infradead.org, iamjoonsoo.kim@lge.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

Hi,

This patch series is aimed to convert all THP vmstat counters to pages
and the kernel stack vmstat counter to bytes.

The unit of some vmstat counters are pages, the unit of some vmstat counters
are bytes, the unit of some vmstat counters are HPAGE_PMD_NR, and the unit
of some vmstat counters are KiB. When we want to expose these vmstat counters
to the userspace, we have to know the unit of the vmstat counters is which
one. It makes the code complex.

This patch series can make the code simple. And the unit of the vmstat
counters are either pages or bytes.

This was inspired by Johannes and Roman. Thanks to them.

Muchun Song (9):
  mm: vmstat: fix stat_threshold for NR_KERNEL_STACK_KB
  mm: memcontrol: fix NR_ANON_THPS account
  mm: memcontrol: convert kernel stack account to byte-sized
  mm: memcontrol: convert NR_ANON_THPS account to pages
  mm: memcontrol: convert NR_FILE_THPS account to pages
  mm: memcontrol: convert NR_SHMEM_THPS account to pages
  mm: memcontrol: convert NR_SHMEM_PMDMAPPED account to pages
  mm: memcontrol: convert NR_FILE_PMDMAPPED account to pages
  mm: memcontrol: make the slab calculation consistent

 drivers/base/node.c    |  17 +++---
 fs/proc/meminfo.c      |  12 ++---
 include/linux/mmzone.h |   2 +-
 kernel/fork.c          |   8 +--
 mm/filemap.c           |   4 +-
 mm/huge_memory.c       |   9 ++--
 mm/khugepaged.c        |   4 +-
 mm/memcontrol.c        | 139 +++++++++++++++++++++++++------------------------
 mm/page_alloc.c        |   9 ++--
 mm/rmap.c              |  19 ++++---
 mm/shmem.c             |   3 +-
 mm/vmstat.c            |   4 ++
 12 files changed, 120 insertions(+), 110 deletions(-)

-- 
2.11.0

