From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 0/3] mm: memcontrol: performance fixlets for 3.18
Date: Wed, 24 Sep 2014 11:08:55 -0400
Message-ID: <1411571338-8178-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Thelen <gthelen@google.com>, Vladimir Davydov <vdavydov@parallels.com>, Dave Hansen <dave@sr71.net>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Andrew,

here are 2 memcg performance fixlets for 3.18.  One improves uncharge
batching to reduce expensive res_counter ops and irq-toggling, the
other one allows THP charges to succeed under cache pressure.

Thanks!

 include/linux/swap.h |   6 ++-
 mm/memcontrol.c      | 116 +++++++++++++------------------------------------
 mm/swap.c            |  27 +++++++++---
 mm/swap_state.c      |  14 ++----
 mm/vmscan.c          |   7 +--
 5 files changed, 63 insertions(+), 107 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
