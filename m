From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH] memcontrol: drop duplicate word and fix spello in
 <linux/memcontrol.h>
Date: Fri, 17 Jul 2020 16:37:54 -0700
Message-ID: <b04aa2e4-7c95-12f0-599d-43d07fb28134@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Cc:To:Subject:From:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=M3QiKi1JcWwj8bC7tSmSd1af0WRuIi4gwW+Grh7mYOg=; b=YAzqSdhPO520UAiR5iyt9Jr0ff
        eaFZLgVzYfQJUu/UsvHx9xpd18nuVH/Htw358n2nFCznpIQNq5IwMjvcoxIsmXQpMGqbAKn65MIl/
        bN0+ZqVDpso/8UNVDihqGg+iPukyMf4YRuyCu3j1kZJi5D6YAxqUGyjMyL/ODNfQMBuqmvPuXToSm
        N5J8MfeeY8lec3FFZoRwMDfYCl3WVyrw9AqnGwm8HSTsdHnV4v7y8B++QRLLl0Y7WSvblrCY9p4f4
        98fiWHYk3O8w1Lh7CM9JOgrB8UZlBmu8EdTNY91158J0d/CQMFnaZ3eqD27OYI/+gLrTkLLLSVUPh
        ORmnoNkw==;
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Drop the doubled word "for" in a comment.
Fix spello of "incremented".

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 include/linux/memcontrol.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200714.orig/include/linux/memcontrol.h
+++ linux-next-20200714/include/linux/memcontrol.h
@@ -72,8 +72,8 @@ struct mem_cgroup_id {
 
 /*
  * Per memcg event counter is incremented at every pagein/pageout. With THP,
- * it will be incremated by the number of pages. This counter is used for
- * for trigger some periodic events. This is straightforward and better
+ * it will be incremented by the number of pages. This counter is used
+ * to trigger some periodic events. This is straightforward and better
  * than using jiffies etc. to handle periodic memcg event.
  */
 enum mem_cgroup_events_target {

