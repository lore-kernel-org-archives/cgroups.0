From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 0/4] mm: memcontrol: remove the page_cgroup->flags field
Date: Mon, 20 Oct 2014 11:22:08 -0400
Message-ID: <1413818532-11042-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

this series gets rid of the remaining page_cgroup flags, thus cutting
the memcg per-page overhead down to one pointer.

 include/linux/page_cgroup.h |  12 ----
 mm/memcontrol.c             | 154 ++++++++++++++++++------------------------
 2 files changed, 64 insertions(+), 102 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
