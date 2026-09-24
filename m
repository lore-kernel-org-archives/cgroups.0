Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28E842AF8D;
	Thu, 24 Sep 2026 07:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235393; cv=none; b=Ipk/4FmIkPCL3QMQCdMmxdPhO7QbwOGyUUCnI+e0q0egobgwzKAsKWGkmn5vBQlxj/6x52dgBnEnewBORtaPZkEiU7N85PqUCLIz8j50myLyD0CfTr0bSrfNosIMsRv+hWwOZOcqkyGYPIQ/dMHJPHd4Z8IBhYgQmvs8MjtqqsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235393; c=relaxed/simple;
	bh=I00N0sC6N8z/NihuWASPNcr6BoeUuPaC8rphpErkLeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XcuMlKG692dmTHbuxEk5M/iLZ5SDv9YY6CU1Jd77fPtkSz0o+robjZj5JWNnoLodiUiS1VUtbqIBgCW1crB8Ngv/boOGhiybAir0b5NOsCYtSCoz9sFxEY8mSL2rbQ9PfitpfXGgrbq08MupUZIeRtTfx0DDNwWc8eaDDxWI4U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xo4e0qcW; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xo4e0qcW"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AM/1COYI+X2cxZahYdg2nMaQ9CPWb/Pi9FF0HZq9dI8=;
	b=xo4e0qcWYUKb+XSdoEELGMTI9wjW82TMlWcj31whkd2V3Qjx9MHato7sp5L3DCl4rrjFgXAk2
	l+apV22HWtkX2LDdzIWioU1kaq2lpBRU81qUybOOqT721sSCyjyEdMe63VVppSohvA0QfMgfApF
	wvtZ8BublnUnhUv4ijDY2XM=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hr51N5Gw1z1prLc;
	Thu, 24 Sep 2026 15:24:08 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 6D41C40537;
	Thu, 24 Sep 2026 15:36:16 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:36:14 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<edumazet@google.com>, <kuniyu@google.com>, <pabeni@redhat.com>,
	<willemb@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<horms@kernel.org>, <ncardwell@google.com>, <matttbe@kernel.org>,
	<martineau@kernel.org>, <geliang@kernel.org>, <mhocko@kernel.org>,
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, <muchun.song@linux.dev>
CC: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<mptcp@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>, <caixinchen1@huawei.com>,
	<lujialin4@huawei.com>
Subject: [PATCH RFC -next 5/5] selftests/cgroup: compare socket memory deltas in test_memcg_sock
Date: Thu, 24 Sep 2026 16:02:19 +0800
Message-ID: <20260924080219.1036588-6-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260924080219.1036588-1-caixinchen1@huawei.com>
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100010.china.huawei.com (7.152.184.41)

test_memcg_sock() baselines memory.current and then requires the
growth of memory.current to match the absolute value of the "sock"
counter.  That relies on "sock" being zero at the baseline: with an
idle listener it used to be, because socket memory was only charged
for in-flight buffers.

With upfront budget charging, a listening socket is charged its full
buffer budget as soon as it exists, so "sock" is non-zero at the
baseline and the absolute comparison breaks.  Baseline the "sock"
counter as well and compare the growth of both counters; this is valid
under both the old and the new accounting model.

Assisted-by: opencode:glm-5.3
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 .../testing/selftests/cgroup/test_memcontrol.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 3a84d068fbf3..54dae37291c3 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1335,9 +1335,12 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	char servport[6];
 	int retries = 0x10; /* nice round number */
 	int sk, ret;
-	long allocated;
+	long allocated, sock_pre;
 
 	allocated = cg_read_long(cgroup, "memory.current");
+	sock_pre = cg_read_key_long(cgroup, "memory.stat", "sock ");
+	if (sock_pre < 0)
+		return KSFT_FAIL;
 	snprintf(servport, sizeof(servport), "%hd", port);
 	ret = getaddrinfo(server, servport, NULL, &ai);
 	if (ret)
@@ -1365,8 +1368,12 @@ static int tcp_client(const char *cgroup, unsigned short port)
 		if (current < 0 || sock < 0)
 			goto close_sk;
 
-		/* exclude the memory not related to socket connection */
-		if (values_close(current - allocated, sock, 10)) {
+		/* exclude the memory not related to socket connection;
+		 * compare the growth of both counters since the baseline,
+		 * as the listening socket may already hold socket memory
+		 * (e.g. its pre-charged memory budget) at the baseline.
+		 */
+		if (values_close(current - allocated, sock - sock_pre, 10)) {
 			ret = KSFT_PASS;
 			break;
 		}
@@ -1384,8 +1391,9 @@ static int tcp_client(const char *cgroup, unsigned short port)
  * The test forks a TCP server listens on a random port between 1000
  * and 61000. Once it gets a client connection, it starts writing to
  * its socket.
- * The TCP client interleaves reads from the socket with check whether
- * memory.current and memory.stat.sock are similar.
+ * The TCP client interleaves reads from the socket with checking whether
+ * the growth of memory.current and memory.stat.sock since the baseline
+ * are similar.
  */
 static int test_memcg_sock(const char *root)
 {
-- 
2.18.0.huawei.25

