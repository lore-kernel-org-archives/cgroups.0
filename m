From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 0/2] mm: memcontrol: fix race between migration and writeback
Date: Wed, 22 Oct 2014 14:29:26 -0400
Message-ID: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

This is fall-out from the memcg lifetime rework in 3.17, where
writeback statistics can get lost against a migrating page.

The (-stable) fix is adapting the page stat side to the new lifetime
rules, rather than making an exception specifically for them, which
seems less error prone and generally the right way forward.

 include/linux/memcontrol.h | 58 ++++++++++++++--------------------------------
 include/linux/mm.h         |  1 -
 mm/memcontrol.c            | 54 ++++++++++++++++++------------------------
 mm/page-writeback.c        | 43 ++++++++++++----------------------
 mm/rmap.c                  | 20 ++++++++--------
 5 files changed, 64 insertions(+), 112 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
