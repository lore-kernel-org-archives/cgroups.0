From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 0/6] mm: per-lruvec slab stats
Date: Tue, 30 May 2017 14:17:18 -0400
Message-ID: <20170530181724.27197-1-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6yMk4V5jNDs7U29dCSh1NurrzRucKMnC7MptAdVEVv8=; b=HQQZh2fgLVjPEcdClImeKD59Za
	8qiL2C7/rYAb0XLEI/yk5xfe5hiMsqLDwgpL/Zh226GUOHhdElBKA9Qt5uGT5VNN6B4FLEArSiSPU
	YuJXDzxRL1zzTz0eGh5GmF2bpjYQwcKkbVsL7VnF0YxGskiTb5dRUJrM/Q4rF+jyE9Lw=;
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hi everyone,

Josef is working on a new approach to balancing slab caches and the
page cache. For this to work, he needs slab cache statistics on the
lruvec level. These patches implement that by adding infrastructure
that allows updating and reading generic VM stat items per lruvec,
then switches some existing VM accounting sites, including the slab
accounting ones, to this new cgroup-aware API.

I'll follow up with more patches on this, because there is actually
substantial simplification that can be done to the memory controller
when we replace private memcg accounting with making the existing VM
accounting sites cgroup-aware. But this is enough for Josef to base
his slab reclaim work on, so here goes.

 drivers/base/node.c        |  10 +-
 include/linux/memcontrol.h | 257 ++++++++++++++++++++++++++++++++++++---------
 include/linux/mmzone.h     |   4 +-
 include/linux/swap.h       |   1 -
 include/linux/vmstat.h     |   1 -
 kernel/fork.c              |   8 +-
 mm/memcontrol.c            |  14 ++-
 mm/page-writeback.c        |  15 +--
 mm/page_alloc.c            |   4 -
 mm/rmap.c                  |   8 +-
 mm/slab.c                  |  12 +--
 mm/slab.h                  |  18 +---
 mm/slub.c                  |   4 +-
 mm/vmscan.c                |  18 +---
 mm/vmstat.c                |   4 +-
 mm/workingset.c            |   9 +-
 16 files changed, 250 insertions(+), 137 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
