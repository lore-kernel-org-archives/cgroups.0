From: Lucas Karpinski <lkarpins@redhat.com>
Subject: [PATCH v3] selftests: cgroup: fix test_kmem_memcg_deletion kernel
 mem check
Date: Thu, 17 Aug 2023 15:57:48 -0400
Message-ID: <bvrhe2tpsts2azaroq4ubp2slawmop6orndsswrewuscw3ugvk@kmemmrttsnc7>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692302280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=M+cHwSXYqzyiBAs9LYfm9bQki8Ktpzfnu45rfgTUfPw=;
        b=TLwweBo8vhcHQPXVebA4cRIYmiGacO/t78+g+Tcl+8KxHB+jqxAv3A1TNsHp/MtfZ+uwxo
        tNeYCKbiZ3PdniFuUVs0dUhQK5kjbptq2u3Nwic1BmwhUe9GKrK8RFkDdN+BA3TC7bThmB
        R/qZe2BQrRPiVheFpXjrpGq+udakLcc=
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Shuah Khan <shuah@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org

Currently, not all kernel memory usage is being accounted for. This
commit switches to using the kernel entry within memory.stat which
already includes kernel_stack, pagetables, and slab. The kernel entry
also includes vmalloc and other additional kernel memory use cases which
were missing.

Signed-off-by: Lucas Karpinski <lkarpins@redhat.com>
---
Changes in v3:
    - Fixed test case description
    - Included anon, file, and sock as mentioned by Shakeel.

 tools/testing/selftests/cgroup/test_kmem.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index ed2e50bb1e76..c82f974b85c9 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -162,11 +162,11 @@ static int cg_run_in_subcgroups(const char *parent,
  * allocates some slab memory (mostly negative dentries) using 2 * NR_CPUS
  * threads. Then it checks the sanity of numbers on the parent level:
  * the total size of the cgroups should be roughly equal to
- * anon + file + slab + kernel_stack.
+ * anon + file + kernel + sock.
  */
 static int test_kmem_memcg_deletion(const char *root)
 {
-	long current, slab, anon, file, kernel_stack, pagetables, percpu, sock, sum;
+	long current, anon, file, kernel, sock, sum;
 	int ret = KSFT_FAIL;
 	char *parent;
 
@@ -184,29 +184,22 @@ static int test_kmem_memcg_deletion(const char *root)
 		goto cleanup;
 
 	current = cg_read_long(parent, "memory.current");
-	slab = cg_read_key_long(parent, "memory.stat", "slab ");
 	anon = cg_read_key_long(parent, "memory.stat", "anon ");
 	file = cg_read_key_long(parent, "memory.stat", "file ");
-	kernel_stack = cg_read_key_long(parent, "memory.stat", "kernel_stack ");
-	pagetables = cg_read_key_long(parent, "memory.stat", "pagetables ");
-	percpu = cg_read_key_long(parent, "memory.stat", "percpu ");
+	kernel = cg_read_key_long(parent, "memory.stat", "kernel ");
 	sock = cg_read_key_long(parent, "memory.stat", "sock ");
-	if (current < 0 || slab < 0 || anon < 0 || file < 0 ||
-	    kernel_stack < 0 || pagetables < 0 || percpu < 0 || sock < 0)
+	if (current < 0 || anon < 0 || file < 0 || kernel < 0 || sock < 0)
 		goto cleanup;
 
-	sum = slab + anon + file + kernel_stack + pagetables + percpu + sock;
+	sum = anon + file + kernel + sock;
 	if (abs(sum - current) < MAX_VMSTAT_ERROR) {
 		ret = KSFT_PASS;
 	} else {
 		printf("memory.current = %ld\n", current);
-		printf("slab + anon + file + kernel_stack = %ld\n", sum);
-		printf("slab = %ld\n", slab);
+		printf("anon + file + kernel + sock = %ld\n", sum);
 		printf("anon = %ld\n", anon);
 		printf("file = %ld\n", file);
-		printf("kernel_stack = %ld\n", kernel_stack);
-		printf("pagetables = %ld\n", pagetables);
-		printf("percpu = %ld\n", percpu);
+		printf("kernel = %ld\n", kernel);
 		printf("sock = %ld\n", sock);
 	}
 
-- 
2.41.0

