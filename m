From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH] memcg: enable accounting for pids in nested pid namespaces
Date: Thu, 22 Apr 2021 08:44:15 +0300
Message-ID: <7b777e22-5b0d-7444-343d-92cbfae5f8b4@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=JRp6H7IPfoU4D8K87emG7TmGRk0/tu3o/Uod9peVFD0=; b=mM9hGPjSYiPNoNsKUuV
        AjkCi4SdfWsvTqyjNi3IVBabZ28feDEaEO/p13wzqAZ5vQtd0LeMCkxctPCFV2kLomCX5O97rBtPl
        X0PJGMTgIyTQDbtIkgvJ1Vta8mySG73Q7EYIkeBEfTvqj4XcNstPVBc/8h4hVnCyNWmLsRvdDoE=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

init_pid_ns.pid_cachep have enabled memcg accounting, though this
setting was disabled for nested pid namespaces.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 kernel/pid_namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 6cd6715..a46a372 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -51,7 +51,8 @@ static struct kmem_cache *create_pid_cachep(unsigned int level)
 	mutex_lock(&pid_caches_mutex);
 	/* Name collision forces to do allocation under mutex. */
 	if (!*pkc)
-		*pkc = kmem_cache_create(name, len, 0, SLAB_HWCACHE_ALIGN, 0);
+		*pkc = kmem_cache_create(name, len, 0,
+					 SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, 0);
 	mutex_unlock(&pid_caches_mutex);
 	/* current can fail, but someone else can succeed. */
 	return READ_ONCE(*pkc);
-- 
1.8.3.1

