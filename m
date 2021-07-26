From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v6 08/16] memcg: enable accounting for pollfd and select bits
 arrays
Date: Mon, 26 Jul 2021 22:00:54 +0300
Message-ID: <d4c21050-cc0e-5c07-b64a-d0245e155663@virtuozzo.com>
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <cover.1627321321.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=7c123YSCTdMincmxsUMhI0gcAR3i6drsKgalA/feMPM=; b=OM1ywa0FINzPxgssHvz
        uMeln3xNmKRwTBX5ClBVDs1ebLGKCE56jvO/HAux6oHnIrCaJWgLnTiuTzMF6Pywq3KJHpcvF7ydW
        683QCNaK+qJ5+s1W1RTYWTBQ94DOQSpYYyg85LjkeWAcD8oawmr1o7apPCiyf0wCWSt3ScUXqyY=;
In-Reply-To: <cover.1627321321.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

User can call select/poll system calls with a large number of assigned
file descriptors and force kernel to allocate up to several pages of memory
till end of these sleeping system calls. We have here long-living
unaccounted per-task allocations.

It makes sense to account for these allocations to restrict the host's
memory consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 fs/select.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 945896d..e83e563 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -655,7 +655,7 @@ int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			goto out_nofds;
 
 		alloc_size = 6 * size;
-		bits = kvmalloc(alloc_size, GFP_KERNEL);
+		bits = kvmalloc(alloc_size, GFP_KERNEL_ACCOUNT);
 		if (!bits)
 			goto out_nofds;
 	}
@@ -1000,7 +1000,7 @@ static int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 
 		len = min(todo, POLLFD_PER_PAGE);
 		walk = walk->next = kmalloc(struct_size(walk, entries, len),
-					    GFP_KERNEL);
+					    GFP_KERNEL_ACCOUNT);
 		if (!walk) {
 			err = -ENOMEM;
 			goto out_fds;
-- 
1.8.3.1

