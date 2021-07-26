From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v6 09/16] memcg: enable accounting for file lock caches
Date: Mon, 26 Jul 2021 22:01:00 +0300
Message-ID: <22c439e5-d66c-97ad-1d04-f5579527b11a@virtuozzo.com>
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <cover.1627321321.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=Y/DbUubFB7jqdWx1m9No/2F70Z4aAsJqjDWHRW9Ebg8=; b=DDjhoUsvboC2HFxAKC8
        3cmTNlEc9kXKbUGILhLybHNEaTqPXt/wphVg1ENIW87NzsTSKfme1I5perjZNgHRuFLfPG3MpxdT6
        0/33g69EP952EiKmN1O1Ou9Xdea/Nhe4rHbaCOR/VxPbDCMMVbmeSxG39o3BcO8lLjhyQWdmlzw=;
In-Reply-To: <cover.1627321321.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

User can create file locks for each open file and force kernel
to allocate small but long-living objects per each open file.

It makes sense to account for these objects to limit the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 fs/locks.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 74b2a1d..1bc7ede 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -3056,10 +3056,12 @@ static int __init filelock_init(void)
 	int i;
 
 	flctx_cache = kmem_cache_create("file_lock_ctx",
-			sizeof(struct file_lock_context), 0, SLAB_PANIC, NULL);
+			sizeof(struct file_lock_context), 0,
+			SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	filelock_cache = kmem_cache_create("file_lock_cache",
-			sizeof(struct file_lock), 0, SLAB_PANIC, NULL);
+			sizeof(struct file_lock), 0,
+			SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	for_each_possible_cpu(i) {
 		struct file_lock_list_struct *fll = per_cpu_ptr(&file_lock_list, i);
-- 
1.8.3.1

