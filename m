From: Waiman Long <longman@redhat.com>
Subject: [PATCH 1/3] mm/memcg: Clean up obsolete enum charge_type
Date: Thu, 20 Aug 2020 09:03:48 -0400
Message-ID: <20200820130350.3211-2-longman@redhat.com>
References: <20200820130350.3211-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597928656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=9Qlf4jXoP5jt/C4m3Gv4DFULDSZN0cJYKBX7J86Hq4I=;
        b=dJ9K69apAqkL0vO5C4TdxJp07+o+lN8E1p5rDeqrOv6vVv7x340i1wEl8U4LxbadBf/yuL
        3NQ4VVMViYo1oPAWfLt2XCufybliOouJbfYrjCAtsEFd4V/UR86Q6FMs/srlLRqtUefUbQ
        zaQ/6A2zqecO7zw7JSFTQUrQ15Kd18w=
In-Reply-To: <20200820130350.3211-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>, Waiman Long <longman@redhat.com>

Since commit 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") and
commit 00501b531c47 ("mm: memcontrol: rewrite charge API") in v3.17, the
enum charge_type was no longer used anywhere. However, the enum itself
was not removed at that time. Remove the obsolete enum charge_type now.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 mm/memcontrol.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b807952b4d43..26b7a48d3afb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -197,14 +197,6 @@ static struct move_charge_struct {
 #define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
 #define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	2
 
-enum charge_type {
-	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
-	MEM_CGROUP_CHARGE_TYPE_ANON,
-	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
-	MEM_CGROUP_CHARGE_TYPE_DROP,	/* a page was unused swap cache */
-	NR_CHARGE_TYPE,
-};
-
 /* for encoding cft->private value on file */
 enum res_type {
 	_MEM,
-- 
2.18.1

