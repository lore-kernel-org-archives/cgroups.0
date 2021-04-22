From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v3 09/16] memcg: enable accounting for mnt_cache entries
Date: Thu, 22 Apr 2021 13:37:09 +0300
Message-ID: <a198ee99-ed84-fc0a-893b-06c6040591a3@virtuozzo.com>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=afhYD1X2+3SAdjfj4AmF+/Ff2fiTPNdUADuOJ81ts1A=; b=q54iZ1drnmuhJ/jQ0zI
        R6MD5l2CYptLMdumaSVBW0BZNCpDW1jM3D7OU5C1cZ8W5v07qYCb3ZmTW6soUUnPlarABKuwJ1Wco
        7n7Blu0QFnUVOFQIO8OQr1v6iQS+VZnt0L9LwaltQnDbWfjdSCLjUIyGvmX3d+FOpvEijz1hZtc=
In-Reply-To: <dddf6b29-debd-dcb5-62d0-74909d610edb-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

The kernel allocates ~400 bytes of 'strcut mount' for any new mount.
Creating a new mount namespace clones most of the parent mounts,
and this can be repeated many times. Additionally, each mount allocates
up to PATH_MAX=4096 bytes for mnt->mnt_devname.

It makes sense to account for these allocations to restrict the host's
memory consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 fs/namespace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5ecfa349..fc1b50d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -203,7 +203,8 @@ static struct mount *alloc_vfsmnt(const char *name)
 			goto out_free_cache;
 
 		if (name) {
-			mnt->mnt_devname = kstrdup_const(name, GFP_KERNEL);
+			mnt->mnt_devname = kstrdup_const(name,
+							 GFP_KERNEL_ACCOUNT);
 			if (!mnt->mnt_devname)
 				goto out_free_id;
 		}
@@ -4213,7 +4214,7 @@ void __init mnt_init(void)
 	int err;
 
 	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct mount),
-			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
 
 	mount_hashtable = alloc_large_system_hash("Mount-cache",
 				sizeof(struct hlist_head),
-- 
1.8.3.1

