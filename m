From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 0/6] mm: memcontrol: clean up the LRU counts tracking
Date: Fri, 15 Feb 2019 13:14:19 -0500
Message-ID: <20190215181425.32624-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5+WUd014/LJCShtLmJFavi/k6g9qeRBc8qLTGaKJAsU=;
        b=a1C9++zg/8Xow9jJtcRPER7lqOqA1xZ/VEeGI/x4i7V07mc76UEu2txWrBTwYlTQMy
         MA4EPF8kN5QqA4OQPMrTu66ZhOhde/Am0GRS65q3N7EfRFRR3z9diBn5LH9IyH5nhRs7
         NhxjLvYwGbKfpiWvzrCAHAm+m0Y5MWauAir24VuIFJ9x5/8tvpt0MVvrfGhbcXgv8oCM
         DZEQPzM3qwpCm9lAClj4TwtskFXajON48W/UdXwVEwvxP1/EBdu6+w5goqmM/Tot222V
         oX9iJIgWFQqsbayx0Buib7Jj52TL/tiGTi+NI78UPh4sqvBBXCfgSQ1KDVj/Z0Ok3WP7
         6gmQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The memcg LRU stats usage is currently a bit messy. Memcg has private
per-zone counters because reclaim needs zone granularity sometimes,
but we also have plenty of users that need to awkwardly sum them up to
node or memcg granularity. Meanwhile the canonical per-memcg vmstats
do not track the LRU counts (NR_INACTIVE_ANON etc.) as you'd expect.

This series enables LRU count tracking in the per-memcg vmstats array
such that lruvec_page_state() and memcg_page_state() work on the enum
node_stat_item items for the LRU counters. Then it converts all the
callers that don't specifically need per-zone numbers over to that.

 include/linux/memcontrol.h | 28 ---------------
 include/linux/mm_inline.h  |  2 +-
 include/linux/mmzone.h     |  5 ---
 mm/memcontrol.c            | 85 +++++++++++++++++++++++++-------------------
 mm/vmscan.c                |  2 +-
 mm/workingset.c            |  5 +--
 6 files changed, 54 insertions(+), 73 deletions(-)


