From: Glauber Costa <glommer@gmail.com>
Subject: [PATCH v10 01/16] memcg: make cache index determination more robust
Date: Sun,  7 Jul 2013 11:56:41 -0400
Message-ID: <1373212616-11713-2-git-send-email-glommer@openvz.org>
References: <1373212616-11713-1-git-send-email-glommer@openvz.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=zZCIx9jtkjNGnxvKyEiGyi7s8MnFKfw+z+MYl7O6uc0=;
        b=vz1YR6yn+t+5tWFFQ/hgHCqGTRJDkwnMA4kvjENX7sL6MrwfMNbkXQKkwi+cnUe5fS
         yQqOV1DBHr08cXiqXR/aCqR7HeV6PnX1yoMxdNpcLAPYSJ+ptGteRSD+AjL7IHv0spHx
         tQWblfLu6M40GGtPP8F2jmETaDTRDZxPZMMyq1g27z6TJ0r9y1oQqNfxMhN80Z2yH3h5
         qg2bdPuY+P/pGw+oWVmEx3mtzR9Tfhk84Tr2bB3cdBqO59YGN2okXP54X1qtw3SAQ/sU
         I3CKE4yMZKNFHbNhv80KEJ0XJ1aDuJNwhdKqtbVGVMktQfIV6Dx3dn15ehgX0Ups5/0O
         X/jg==
In-Reply-To: <1373212616-11713-1-git-send-email-glommer@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, mgorman@suse.de, david@fromorbit.com, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suze.cz, hannes@cmpxchg.org, hughd@google.com, gthelen@google.com, akpm@linux-foundation.org, Glauber Costa <glommer@gmail.com>, Glauber Costa <glommer@openvz.org>, Michal Hocko <mhocko@suse.cz>

From: Glauber Costa <glommer@gmail.com>

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

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6e120e4..506ad46 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3061,7 +3061,9 @@ void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep)
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
1.8.2.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
