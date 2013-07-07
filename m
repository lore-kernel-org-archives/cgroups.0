From: Glauber Costa <glommer@gmail.com>
Subject: [PATCH v10 16/16] memcg: flush memcg items upon memcg destruction
Date: Sun,  7 Jul 2013 11:56:56 -0400
Message-ID: <1373212616-11713-17-git-send-email-glommer@openvz.org>
References: <1373212616-11713-1-git-send-email-glommer@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=2WgixP9rhHvOejyaN/GNDUe0w6lkzihlFNBpBB4Ke7A=;
        b=RpftiDzk+9s7tMdWI7qTidempMcAT0cxsLj93cDNQGVH0R+eeboJ7dJROMOorjhg9m
         KcdftWojNLn5cA99K6PlGuy6U2krleBJJSDEz2yi5gZcdDD6TodWpanJtaYgiNMeizhz
         7ho+aQEtF05qYYDZ4j0YcYFP7VVQQP1z05CWY4tgY5NYpLuiRniNH6uybhsxNqNRfqbS
         QmBBBiMRBGmJB9IkewC4bdXdezQ6uXm912pw4Q/GsUAZEYPIRTADO9WAXlurb6o9dgqi
         OFbNcH6qyWOYWQeF3qLaijMSdFWCRGB/6tvqWsqWhSZ0XYaxvqsLrodYiWg4Ze1rFagQ
         3pzw==
In-Reply-To: <1373212616-11713-1-git-send-email-glommer@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, mgorman@suse.de, david@fromorbit.com, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suze.cz, hannes@cmpxchg.org, hughd@google.com, gthelen@google.com, akpm@linux-foundation.org, Glauber Costa <glommer@openvz.org>, Michal Hocko <mhocko@suse.cz>

When a memcg is destroyed, it won't be imediately released until all
objects are gone. This means that if a memcg is restarted with the very
same workload - a very common case, the objects already cached won't be
billed to the new memcg. This is mostly undesirable since a container
can exploit this by restarting itself every time it reaches its limit,
and then coming up again with a fresh new limit.

Since now we have targeted reclaim, I sustain that we should assume that
a memcg that is destroyed should be flushed away. It makes perfect sense
if we assume that a memcg that goes away most likely indicates an
isolated workload that is terminated.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2dc89c..90173bc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6310,10 +6310,27 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 
 static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
 {
+	int ret;
 	if (!memcg_kmem_is_active(memcg))
 		return;
 
 	/*
+	 * When a memcg is destroyed, it won't be imediately released until all
+	 * objects are gone. This means that if a memcg is restarted with the
+	 * very same workload - a very common case, the objects already cached
+	 * won't be billed to the new memcg. This is mostly undesirable since a
+	 * container can exploit this by restarting itself every time it
+	 * reaches its limit, and then coming up again with a fresh new limit.
+	 *
+	 * Therefore a memcg that is destroyed should be flushed away. It makes
+	 * perfect sense if we assume that a memcg that goes away indicates an
+	 * isolated workload that is terminated.
+	 */
+	do {
+		ret = try_to_free_mem_cgroup_kmem(memcg, GFP_KERNEL);
+	} while (ret);
+
+	/*
 	 * kmem charges can outlive the cgroup. In the case of slab
 	 * pages, for instance, a page contain objects from various
 	 * processes. As we prevent from taking a reference for every
-- 
1.8.2.1

