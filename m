From: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] selftests: cgroup: fix test_kmem_basic slab1 check
Date: Thu, 3 Aug 2023 12:00:47 -0400
Message-ID: <ix6vzgjqay2x7bskle7pypoint4nj66fwq7odvd5hektatvp2l@kukoifnfj3dr>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691078459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=cwXRj1KBICVmDyXNwF6/K1df3vGE/T6x9GRpnMzQtuM=;
        b=fXfuTyl9529XxoXuRK1mBvY3jcrxrtPpo+yFmuET/VL2QOqPRAu1A9YoOkE6eWBrS5OL19
        h/k77UDupzGe7rCKuwh+WyBDBtY8AWkkMIj/Vx2Uonc/KucOrYzpsI7ioE+RInu/hraBFu
        PCzyPk9XivrdzH22N0cuGzDoQ1sADHs=
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

test_kmem_basic creates 100,000 negative dentries, with each one mapping
to a slab object. After memory.high is set, these are reclaimed through
the shrink_slab function call which reclaims all 100,000 entries. The
test passes the majority of the time because when slab1 is calculated,
it is often above 0, however, 0 is also an acceptable value.

Signed-off-by: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
https://lore.kernel.org/all/m6jbt5hzq27ygt3l4xyiaxxb7i5auvb2lahbcj4yaxxigqzu5e@5rn6s2yjzv7u/
V2: Corrected title

 tools/testing/selftests/cgroup/test_kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 258ddc565deb..ba0a0bfc5a98 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -71,7 +71,7 @@ static int test_kmem_basic(const char *root)
 
 	cg_write(cg, "memory.high", "1M");
 	slab1 = cg_read_key_long(cg, "memory.stat", "slab ");
-	if (slab1 <= 0)
+	if (slab1 < 0)
 		goto cleanup;
 
 	current = cg_read_long(cg, "memory.current");
-- 
2.41.0

