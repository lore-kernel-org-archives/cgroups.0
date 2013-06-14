From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/2] memcg: make cache index determination more robust
Date: Fri, 14 Jun 2013 14:04:35 -0400
Message-ID: <1371233076-936-2-git-send-email-glommer@openvz.org>
References: <1371233076-936-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=pm7NlnG2ZFGRBrz1F3UUrDveQUwSo0J0POLCQIgmyOI=;
        b=wznf463J+xuS0IwXamt3azwML32apzAnaLpP8DqlgfRBOiSOieBIvXf1PvIJMqTU0q
         pQ796wxbSiIUPrUzNIHv8Xno/ZAdCPeZxOE51Tw9V1rC61eMjvgm8mb58TQ0Ot/oWgPi
         4wlNPt7fUjVucciralrDvWn9earetcUpL5/p0M/kADQYtV5oYApylcwnXCal+p+yAkXu
         Dp7cbQj3PrPZMApAup4E5EleDx2PukB2MMhOALkybpZVxVL8mdahNVtXd+SPMlPQptjO
         7IJSDWM6dYaszCn7DCVAZspnR0DuC/hfBhkT1B6cFQw8BKJaqysNCfKBpkiqX1uyZRnI
         UwTg==
In-Reply-To: <1371233076-936-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

I caught myself doing something like the following outside memcg core:

	memcg_id = -1;
	if (memcg && memcg_kmem_is_active(memcg))
		memcg_id = memcg_cache_id(memcg);

to be able to handle all possible memcgs in a sane manner. In particular, the
root cache will have kmemcg_id = -1 (just because we don't call memcg_kmem_init
to the root cache since it is not limitable). We have always coped with that by
making sure we sanitize which cache is passed to memcg_cache_id. Although this
example is given for root, what we really need to know is whether or not a
cache is kmem active.

But outside the memcg core testing for root, for instance, is not trivial since
we don't export mem_cgroup_is_root. I ended up realizing that this tests really
belong inside memcg_cache_id. This patch moves a similar but stronger test
inside memcg_cache_id and make sure it always return a meaningful value.

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e851f4..359a53b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3081,7 +3081,9 @@ void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep)
  */
 int memcg_cache_id(struct mem_cgroup *memcg)
 {
-	return memcg ? memcg->kmemcg_id : -1;
+	if (!memcg || !memcg_can_account_kmem(memcg))
+		return -1;
+	return memcg->kmemcg_id;
 }
 
 /*
-- 
1.8.1.4
