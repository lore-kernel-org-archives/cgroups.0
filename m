Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B223BCD0D;
	Mon, 12 Oct 2026 18:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.117.225.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791831573; cv=none; b=qAF9vDS9rwWLOCegvhImuhktQQV5aDO21jrd0kiz34Zt+2DyDlDBVlHneRTaPy8dPiA1BcT4B/4PMjAM7S7UttrQ9G6v2UoEDKfpZWTSJ00dMzKVvsKeUzwUdxVBurLZexL4mDiaoe0NZ7i8oxz/msUrh7wOmktw0x24eT5Np6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791831573; c=relaxed/simple;
	bh=2bPcfVGTS80cMbqLQOtpnz41cUxttMSol2uwcpqfi0s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P0H5+RF8tgzad4s8832uv3Y0twpjzD5k3bVykR+02J076bEdacgDt+jtKX6QU/sAcAxYQQdeBPp1UT8V38Uaic6GABUy0BGn7XRNbx+AgfBilza/lOZIq3h4H7lWnnmgJ6MuYfJqwREyj8QFs0a2bhd6A2XSPSsqatUhjzk1hLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=NsHntO7f; arc=none smtp.client-ip=130.117.225.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="NsHntO7f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=qA5EK/Wa96FVW4oU58RgT4UF+JCxctbidCL6ltk8p1o=; b=NsHntO7fnZYNFH7wFAI
	Iyqnr4jJ0d4L9lU9rnQ7iOzrSQd81v5lxgyvYhHhYyIjLOo9PnLM1CS0K2s9Krqb63BaoAHKm0J3Z
	bJdvdvgmaoPMANUy5nqLKbngfJRSmT4M8lscLptxLDPOA5/7/LdjmJowTGWnX65GNnfCIxQ+bZnpb
	MTz1wSnFJ2z2Wco1WjzwITTkCYb1ifMMj0DuKLkC660lqp+sKnSZfHjeMO7WpuxOSlrRJhAidnyCt
	hiI5ntaM4FTmbpoIXBFTMPxFIf2h1pNog1e8MnwrKfpB4O0ul2UUUfvIBb0Z1Q7e1DS56h1JLlRjv
	J27dwsb62pDcjCQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xGLBb-007pPW-1u;
	Mon, 12 Oct 2026 20:59:09 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 12 Oct 2026 20:59:06 +0200
Subject: [PATCH 2/2] selftests: cgroup: make test_memcg_sock check flushed
 sock stats
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-2-bc864b1950ad@virtuozzo.com>
References: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
In-Reply-To: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
To: Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7763;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=2bPcfVGTS80cMbqLQOtpnz41cUxttMSol2uwcpqfi0s=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqzS4DgaidbMKjbP3IgO7QMgUbXfw4p7qrhlWbW
 f8xX0sK/nOJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas0uAwAKCRBRlgpH+WFc
 KlOJD/0d2kRvQ33GJ+qflRrSnLSsOysIGJGWhBG3BnIqBP+Ve184OLIAryF81XiNiZQm5rmDM1p
 W5GdsV3nH39IsZMQCn6x71QVw48tGPWwrz3pAIIL839ayQAyHV9RxEBhepZTolStdUtJYONbhTm
 46TLxH1qzvECUiAeZlkr+9tOIjIn/k3E1YesZq0sIhfUVb47wAdq2kDnKN+q6AM9WQxNUVKeUSh
 DFjR63+RkY2hmrEKdMbDivtskEytCxZsOCYew6hQE70AUS6vHZhjBHYkWgwQAPuFGotjC7VraIM
 J8MDkpyJFQXnJf8rIohipaPn0gpwZy2ou73//aMVaEtqV7IQI9u5FsMb9egiBqCQHJXwpDbh6Z0
 EdY6r5iOowBsXpivcYBPO+rwIiA+oMZVrnYjT3sNnlbmMkGALvFhywDiDh0JNz2PD6CSUmIZGkU
 oVMKNIrCfxHAnj85ch9iJKoi7zt1Ne9TbxQXIoKjYO4U2yhYAnKwFRK9tBU4GnPNxx7XNqvrTMW
 3KI5aIMVFvToR0oLpL849XMfXJU9XEstZ0S+NhAfLjkNZwnN08PmL46QclOHLcJtKwy0TW1Y/3u
 oD2BrXy1eitotWv47ftKYBqAeVXaAEDdRAsuSOqOHFEWUC50mEUgx5RSD+a1582hnR1d9WOOxRR
 qirwr6ygfFqY9qw==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

test_memcg_sock compares memory.current with the "sock " entry of
memory.stat. memory.current changes at charge time, "sock " only when
the memcg stats are flushed: by a memory.stat read once enough updates
are pending (MEMCG_CHARGE_BATCH per online CPU), or by a periodic,
deferrable worker. Nothing in the test makes sure a flush happens:

- tcp_client() takes 16 readings right after connect(). If no flush
  lands among them, "sock " reads 0, and the test either passes on
  0 == 0 without checking anything or, once memory.current shows the
  first charge, cannot pass any more and fails:

    not ok 11 test_memcg_sock

- The final check waits 3 seconds for "sock " to drop to 0, counting on
  the deferrable worker, which can run later than that on an idle
  machine.

Make the test cause the flushes instead of waiting for them. Every page
of socket or anonymous memory that comes and goes in the cgroup counts
towards the flush threshold, and MEMCG_FLUSH_BYTES (twice the vmstat error
test_kmem allows for) is enough to cross it. After that much, either
another flush has reset the count or the next memory.stat read flushes.

- tcp_client() sets a small receive buffer before it connects. Only
  the server's socket is charged to the test cgroup, and with a large
  receive window its data moves straight on to the client; with few
  CPUs the client then drains it between reads and "sock " stays near 0.
  A small window keeps the data queued in the server's socket.
- tcp_client() then keeps reading, comparing after every read, until
  "sock " is nonzero and matches memory.current, for up to four times
  MEMCG_FLUSH_BYTES. A comparison can still miss after a flush: one
  that came midway leaves "sock " behind, and memory.current also holds
  the per-CPU charge stock. The budget leaves room for several flushes.
- After the server has exited, the test allocates and frees
  MEMCG_FLUSH_BYTES of anonymous memory in the cgroup and reads "sock ",
  for up to three rounds until it reads 0. The socket memory is
  uncharged before the first round, so any flush that has gone through
  all CPUs since sees "sock " at 0. A flush still running in parallel
  can reset the count before it reaches the CPU that did the uncharge,
  and the read then misses the uncharge. That flush only has to finish
  its walk over the CPUs for the next read to see it, and each round
  gives it the time of another allocation. Three rounds are a margin for
  a flusher that gets rescheduled midway, not a guarantee: nothing
  bounds how long it can be held up.

MEMCG_CHARGE_BATCH goes to cgroup_util.h, and test_kmem's
MAX_VMSTAT_ERROR uses it too.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 .../selftests/cgroup/lib/include/cgroup_util.h     |  3 ++
 tools/testing/selftests/cgroup/test_kmem.c         |  2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   | 47 +++++++++++++---------
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 5d39c709ac7a4..5307f3bf32a09 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -21,6 +21,9 @@
 
 #define DEFAULT_WAIT_INTERVAL_US (100 * 1000) /* 100 ms */
 
+/* from include/linux/memcontrol.h, which userspace cannot include */
+#define MEMCG_CHARGE_BATCH	64
+
 /*
  * Checks if two given values differ by less than err% of their sum.
  */
diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 437f2d35f205e..30af47ad69793 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -24,7 +24,7 @@
  * the maximum discrepancy between charge and vmstat entries is number
  * of cpus multiplied by 64 pages.
  */
-#define MAX_VMSTAT_ERROR (sysconf(_SC_PAGESIZE) * 64 * get_nprocs())
+#define MAX_VMSTAT_ERROR (sysconf(_SC_PAGESIZE) * MEMCG_CHARGE_BATCH * get_nprocs())
 
 #define KMEM_DEAD_WAIT_RETRIES        80
 
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index a24c1e07b2035..e9d3a04ecf7fc 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -18,11 +18,14 @@
 #include <netdb.h>
 #include <errno.h>
 #include <sys/mman.h>
+#include <sys/sysinfo.h>
 
 #include "kselftest.h"
 #include "cgroup_util.h"
 
-#define MEMCG_SOCKSTAT_WAIT_RETRIES        30
+/* enough page updates for a memory.stat read to flush, see MAX_VMSTAT_ERROR in test_kmem.c */
+#define MEMCG_FLUSH_BYTES	\
+	(2 * sysconf(_SC_PAGESIZE) * MEMCG_CHARGE_BATCH * get_nprocs())
 
 static bool has_localevents;
 static bool has_recursiveprot;
@@ -1333,7 +1336,8 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	const char server[] = "localhost";
 	struct addrinfo *ai;
 	char servport[6];
-	int retries = 0x10; /* nice round number */
+	long budget = 4 * MEMCG_FLUSH_BYTES;
+	int rcvbuf = 64 * 1024;
 	int sk, ret;
 	long allocated;
 
@@ -1347,17 +1351,25 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	if (sk < 0)
 		goto free_ainfo;
 
+	/* keep the data in the server's socket, the one charged to the cgroup */
+	ret = setsockopt(sk, SOL_SOCKET, SO_RCVBUF, &rcvbuf, sizeof(rcvbuf));
+	if (ret < 0)
+		goto close_sk;
+
 	ret = connect(sk, ai->ai_addr, ai->ai_addrlen);
 	if (ret < 0)
 		goto close_sk;
 
 	ret = KSFT_FAIL;
-	while (retries--) {
+	while (budget > 0) {
 		uint8_t buf[0x100000];
 		long current, sock;
+		ssize_t len;
 
-		if (read(sk, buf, sizeof(buf)) <= 0)
+		len = read(sk, buf, sizeof(buf));
+		if (len <= 0)
 			goto close_sk;
+		budget -= len;
 
 		current = cg_read_long(cgroup, "memory.current");
 		sock = cg_read_key_long(cgroup, "memory.stat", "sock ");
@@ -1366,7 +1378,7 @@ static int tcp_client(const char *cgroup, unsigned short port)
 			goto close_sk;
 
 		/* exclude the memory not related to socket connection */
-		if (values_close(current - allocated, sock, 10)) {
+		if (sock > 0 && values_close(current - allocated, sock, 10)) {
 			ret = KSFT_PASS;
 			break;
 		}
@@ -1411,6 +1423,7 @@ static int test_memcg_sock(const char *root)
 	unsigned short port;
 	char *memcg;
 	long sock_post = -1;
+	int flush_rounds = 3;
 
 	if (memcg_sockets_disabled())
 		return KSFT_SKIP;
@@ -1468,21 +1481,15 @@ static int test_memcg_sock(const char *root)
 	if (cg_read_long(memcg, "memory.current") < 0)
 		goto cleanup;
 
-	/*
-	 * memory.stat is updated asynchronously via the memcg rstat
-	 * flushing worker, which runs periodically (every 2 seconds,
-	 * see FLUSH_TIME). On a busy system, the "sock " counter may
-	 * stay non-zero for a short period of time after the TCP
-	 * connection is closed and all socket memory has been
-	 * uncharged.
-	 *
-	 * Poll memory.stat for up to 3 seconds (~FLUSH_TIME plus some
-	 * scheduling slack) and require that the "sock " counter
-	 * eventually drops to zero.
-	 */
-	sock_post = cg_read_key_long_poll(memcg, "memory.stat", "sock ", 0,
-					 MEMCG_SOCKSTAT_WAIT_RETRIES,
-					 DEFAULT_WAIT_INTERVAL_US);
+	/* the uncharge is done, but a flush still walking the CPUs can hide it from a read */
+	while (flush_rounds--) {
+		if (cg_run(memcg, alloc_anon, (void *)MEMCG_FLUSH_BYTES))
+			goto cleanup;
+
+		sock_post = cg_read_key_long(memcg, "memory.stat", "sock ");
+		if (!sock_post)
+			break;
+	}
 	if (sock_post)
 		goto cleanup;
 

-- 
2.43.0

