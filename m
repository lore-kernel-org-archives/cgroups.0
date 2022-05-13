From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/4] memcg: enable accounting for kernfs nodes and iattrs
Date: Fri, 13 May 2022 18:51:55 +0300
Message-ID: <22ccf325-6aa5-9b55-4729-d03f34125650@openvz.org>
References: <Ynv7+VG+T2y9rpdk@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=xdLDfq+CWT8JDkKJCr5lOfzn0f1CBOYqpqvcgd4oF3I=;
        b=AOt8diTFiicIrXp0RywXesaFiBTVFqNQpRUmgcob7AdT1m4qVHyAT/nPjfEfourXYu
         VFFaL/IDpLxzjUSSTYCu5hMuf+OKjYOe/HamJ6cYFtndD5F80Cxs9vngm1uigjcBc6YV
         McmK5Boa/eUKkqJaZzTZaqNWHiI/9NzMTpCfl0yHN9zl8kJEZnuUvwE/hiAx8v0cXZ7k
         xQyr4Lsk69dMvKMPJu61svF+KqC73U4AGIa8cXKDNGEkykKhh2PtQC0YkehHHGgigu32
         U5z6wawLGwA5a18ezUpeVzwNCtOjC6Wxio0XMepLaQpfoVKBQVIkqv61BTkxIPek6ifk
         u0lg==
Content-Language: en-US
In-Reply-To: <Ynv7+VG+T2y9rpdk@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

kernfs nodes are quite small kernel objects, however there are few
scenarios where it consumes significant piece of all allocated memory:

1) creating a new netdevice allocates ~50Kb of memory, where ~10Kb
   was allocated for 80+ kernfs nodes.

2) cgroupv2 mkdir allocates ~60Kb of memory, ~10Kb of them are kernfs
   structures.

3) Shakeel Butt reports that Google has workloads which create 100s
   of subcontainers and they have observed high system overhead
   without memcg accounting of kernfs.

It makes sense to enable accounting for kernfs objects, otherwise its
misuse inside memcg-limited can lead to global memory shortage,
OOM and random kills of host processes.

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/kernfs/mount.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index cfa79715fc1a..40e896c7c86b 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -391,10 +391,12 @@ void __init kernfs_init(void)
 {
 	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
 					      sizeof(struct kernfs_node),
-					      0, SLAB_PANIC, NULL);
+					      0, SLAB_PANIC | SLAB_ACCOUNT,
+					      NULL);
 
 	/* Creates slab cache for kernfs inode attributes */
 	kernfs_iattrs_cache  = kmem_cache_create("kernfs_iattrs_cache",
 					      sizeof(struct kernfs_iattrs),
-					      0, SLAB_PANIC, NULL);
+					      0, SLAB_PANIC | SLAB_ACCOUNT,
+					      NULL);
 }
-- 
2.31.1

