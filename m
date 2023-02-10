From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm/memcg: Skip high limit check in root memcg
Date: Fri, 10 Feb 2023 09:45:50 +0000
Message-ID: <20230210094550.5125-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ppfFWpSAcZ1aESEIi3DI7xxDUI8KrBz5/PkXTDog9ro=;
        b=LWCJXAT7I+EECVCLtdt5TrDfY1jP64bH1PN4m10e5ID9k8mohRc90Id/D9P5YQ0zo8
         tpNUNA/I+Y2qw21VFtzvbQq/iFU1JdeU5uWGqhcnZwqEX8DlWw+irAGC01fg4inhfNUj
         qfVuPkwbTvxBq/JFjbEKnDjL/vfK4QSLJHUBBrCzAQJAmSckmSmlND9nVCiYZS9FwxM7
         +mUz9uyIMg8cibzSLzifH+bR9e0N1BIuhqHHXFjp60clgMKLA9obumlPzfdkCI9SomZS
         xSKsStJ8KUfMd4aBExGiaG0EOb+1TG/W36cWikejp1fQnLVQm6sVf36/6dWb00RBzrR7
         nhUw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

The high limit checks the memory usage from given memcg to root memcg.
However, there is no limit in root memcg. So this check makes no sense
and we can ignore it.

Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 73afff8062f9..a31a56598f29 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2780,6 +2780,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	do {
 		bool mem_high, swap_high;
 
+		/* There is no need for root memcg to check high limit */
+		if (mem_cgroup_is_root(memcg))
+			break;
+
 		mem_high = page_counter_read(&memcg->memory) >
 			READ_ONCE(memcg->memory.high);
 		swap_high = page_counter_read(&memcg->swap) >
-- 
2.25.1

