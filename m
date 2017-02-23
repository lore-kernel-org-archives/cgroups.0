From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: [PATCH v2 0/2] mm/cgroup soft limit data allocation
Date: Thu, 23 Feb 2017 14:36:37 +0100
Message-ID: <1487856999-16581-1-git-send-email-ldufour@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Balbir Singh <bsingharora@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

The first patch of this series is fixing a panic occurring when soft
limit data allocation is using soft limit data.

The second patch, as suggested by Michal Hocko, is pushing forward by
delaying the soft limit data allocation when a soft limit is set.

V1->V2:
 - move sanity pointer checks to the first patch
 - differ also the allocation of the pointer table
 - return error in the case allocation failed

Laurent Dufour (2):
  mm/cgroup: avoid panic when init with low memory
  mm/cgroup: delay soft limit data allocation

 mm/memcontrol.c | 74 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 57 insertions(+), 17 deletions(-)

-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
