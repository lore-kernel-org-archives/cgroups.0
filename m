From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 4/5] cgroup: Removing racy check in test_memcg_sock()
Date: Sat, 23 Apr 2022 08:56:21 -0700
Message-ID: <20220423155619.3669555-5-void@manifault.com>
References: <20220423155619.3669555-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220423155619.3669555-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org

test_memcg_sock() in the cgroup memcg tests, verifies expected memory
accounting for sockets. The test forks a process which functions as a TCP
server, and sends large buffers back and forth between itself (as the TCP
client) and the forked TCP server. While doing so, it verifies that
memory.current and memory.stat.sock look correct.

There is currently a check in tcp_client() which asserts memory.current >=
memory.stat.sock. This check is racy, as between memory.current and
memory.stat.sock being queried, a packet could come in which causes
mem_cgroup_charge_skmem() to be invoked. This could cause memory.stat.sock
to exceed memory.current. Reversing the order of querying doesn't address
the problem either, as memory may be reclaimed between the two calls.
Instead, this patch just removes that assertion altogether, and instead
relies on the values_close() check that follows to validate the expected
accounting.

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index e899b3f28c22..38d2054eefe6 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -993,9 +993,6 @@ static int tcp_client(const char *cgroup, unsigned short port)
 		if (current < 0 || sock < 0)
 			goto close_sk;
 
-		if (current < sock)
-			goto close_sk;
-
 		if (values_close(current, sock, 10)) {
 			ret = KSFT_PASS;
 			break;
-- 
2.30.2

