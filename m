From: Yu Zhao <yuzhao@google.com>
Subject: [PATCH 00/13] mm: clean up some lru related pieces
Date: Thu, 17 Sep 2020 21:00:38 -0600
Message-ID: <20200918030051.650890-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=MShH3I1oLcjvEJbj3NYW9C342mvg+PbbBJCOoSH1HSQ=;
        b=CDRIysijqlvkYU+kfz4ExesE+3SJEmw3l9qWCAyu0Yl6J6QfFZHDzRMn2cts4G/GOz
         due2AZm8uZnE02XEz5UeXJrQLnFVWnnCS9C/pPkMQNrCt04NXlx25xEYkfo0PmopvTxC
         6Mc1ISZvlBE8hm/TYls84q50iEmrO8OTSwUfAOYHWxvmq5G4q3tHrvddW6BfGlAJaXXa
         7jtZbfY4KCbYKA922DT7v4HaAYQlRavyHrrpgTJ650wUBUgxocGjlFGX5ZdwB2iFOxvt
         Sb0vnDNEX8KpkSdUPfi9dXotay6ssMYaQk9GrMx5bqH0g6TjEErAVqtu1pf7rtwPgd1d
         LRRw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Huang Ying <ying.huang@intel.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Matthew Wilcox <willy@infradead.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Minchan Kim <minchan@kernel.org>, Jaewon Kim <jaewon31.kim@samsung.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>

Hi Andrew,

I see you have taken this:
  mm: use add_page_to_lru_list()/page_lru()/page_off_lru()
Do you mind dropping it?

Michal asked to do a bit of additional work. So I thought I probably
should create a series to do more cleanups I've been meaning to.

This series contains the change in the patch above and goes a few
more steps farther. It's intended to improve readability and should
not have any performance impacts. There are minor behavior changes in
terms of debugging and error reporting, which I have all highlighted
in the individual patches. All patches were properly tested on 5.8
running Chrome OS, with various debug options turned on.

Michal,

Do you mind taking a looking at the entire series?

Thank you.

Yu Zhao (13):
  mm: use add_page_to_lru_list()
  mm: use page_off_lru()
  mm: move __ClearPageLRU() into page_off_lru()
  mm: shuffle lru list addition and deletion functions
  mm: don't pass enum lru_list to lru list addition functions
  mm: don't pass enum lru_list to trace_mm_lru_insertion()
  mm: don't pass enum lru_list to del_page_from_lru_list()
  mm: rename page_off_lru() to __clear_page_lru_flags()
  mm: inline page_lru_base_type()
  mm: VM_BUG_ON lru page flags
  mm: inline __update_lru_size()
  mm: make lruvec_lru_size() static
  mm: enlarge the int parameter of update_lru_size()

 include/linux/memcontrol.h     |  14 ++--
 include/linux/mm_inline.h      | 115 ++++++++++++++-------------------
 include/linux/mmzone.h         |   2 -
 include/linux/vmstat.h         |   2 +-
 include/trace/events/pagemap.h |  11 ++--
 mm/compaction.c                |   2 +-
 mm/memcontrol.c                |  10 +--
 mm/mlock.c                     |   2 +-
 mm/swap.c                      |  53 ++++++---------
 mm/vmscan.c                    |  28 +++-----
 10 files changed, 95 insertions(+), 144 deletions(-)

-- 
2.28.0.681.g6f77f65b4e-goog

