From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v2 5/8] memcg: accounting for fasync_cache
Date: Mon, 15 Mar 2021 15:23:33 +0300
Message-ID: <4eb97c88-b87c-6f6e-3960-b1a61b46d380@virtuozzo.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okllHbx6+ZsTES5H52bKAiWF8wQKsmsU0hqDpnVlNuo=;
 b=m/2apD/UPAXRGYDi9kqkQxX303BU3aMu0ZlhcSLLYZTwwhPhUcHFwk5k7uiXDSsQKmfncXuNtR+dPZJWOuTUixNmyBdoiNtSEMM7uaQ5fez1r4ADSwOLYWd7WWA51T0YJANvgcRrtdRAi8+aq1GUTymbaCaLdu6jNME9xGDBRRo=
In-Reply-To: <YEnWUrYOArju66ym-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

unprivileged user inside memcg-limited container can trigger
creation of huge number of non-accounted fasync_struct objects
---
 fs/fcntl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index dfc72f1..7941559 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -1049,7 +1049,8 @@ static int __init fcntl_init(void)
 			__FMODE_EXEC | __FMODE_NONOTIFY));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
-		sizeof(struct fasync_struct), 0, SLAB_PANIC, NULL);
+					 sizeof(struct fasync_struct), 0,
+					 SLAB_PANIC | SLAB_ACCOUNT, NULL);
 	return 0;
 }
 
-- 
1.8.3.1

