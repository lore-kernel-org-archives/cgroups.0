Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A1D374E5A;
	Mon, 12 Oct 2026 18:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.117.225.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791831573; cv=none; b=ULbutxM7zUQZZQN3YLj3wxuI25NLU8DhWLTKPY68/ajkPZmwZ+OuUKi+CSqnmyCeNfEiFFyHtnbByEzk1F1nPg6nPFtc15jSPbh6AlxbmG0pL7wZk/cXZG+/WN8+vhLivdIbh7XmdYYsqiluOvc6gIyxaIsDVNCjObqPbZM0XYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791831573; c=relaxed/simple;
	bh=NDcnXEQvkxTSDc7OEmOpPUIL28bEAcCqKO16/nQ9nHY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YyLMOC80gurTnNmdn+gcRqHxlOwbIoWOnpD4Qy8amizDG6wnlh2c6obcu3BVC8liQZynh5BKA4fDARRp4FgxK+KsSIb/8o9yP70zkZJ1MPYJqk9mp/Gl6QmcH3DNim2RvIQloX0Asvs0cadO0la1t7qGY4sIyPWqx5uHrFseEcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=wuqJNlLp; arc=none smtp.client-ip=130.117.225.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="wuqJNlLp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=xABwQzsz7Q7HeYTm3a7cqXm8Re+2/3UYBe4Ql6Rc5uk=; b=wuqJNlLpTPZXGeWPY6z
	RbmO3Xtnk2lTELwJlu8MCShhrdKvYkJq9irIolxAXzPM0naiCrGW3pH8qr54ncd++swVD7hXNWoBz
	hEHnkbdPAi07FA+8ZpDtydwtxFnao/WsBWoiLs4IHVuOuHdo3j7Xm7F4djjbG1tfSYF1pZRSsaYrT
	dln7qcJPBYYpbug69GSuHVpv77hDNNZ9mQLBoPf760E6Ylp9MwUMAoigjb6FWXzJ1vD2Y2qbKAEX/
	iS1grzdQGFbdPn8o+YaOQQOkUoTW4fQ+Hww32qQYInENDATweU+fW25vXJ/qhhhfRXBtvUkKykUC6
	RhrN1IfJ3FordbA==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xGLBb-007pPW-0K;
	Mon, 12 Oct 2026 20:59:08 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 12 Oct 2026 20:59:05 +0200
Subject: [PATCH 1/2] selftests: cgroup: skip test_memcg_sock under
 cgroup.memory=nosocket
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-1-bc864b1950ad@virtuozzo.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1810;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=NDcnXEQvkxTSDc7OEmOpPUIL28bEAcCqKO16/nQ9nHY=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqzS4Dq31RlSyeRnJrQb5BqdajPr4aqA1nSsHEP
 tO3tnluCEyJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas0uAwAKCRBRlgpH+WFc
 Kq9zD/9hCfrn+3/QeRccmHR5iUlw8bwPXqJF0/A/r0TWCtxaq6wsiclWoWkfYmVqaCiIBssMXn/
 wQYqt8NQcCMiGopXo+1sT6yiEjE1QY+WVSkAFi2SooA0ums9KcN/RqvH4Y3ei6FnGy51pL1tPXR
 QhUqk5B9HEOpLdj05cjU2unGkTS0+a9eZKwBG9J3BMENdXmtxzB6PVe77COpbQFbFrEQ1XOZKC2
 KL0Cr2fE7lsDn5oeDCNQcklnquShVlaUbQ65GauytxgDrVfdbaz3noDy2vntGrDOBlkr+pI2E6o
 FVgoOObbPMejOgXEXmUzM4rh7E7AxACvZYse8kAG46RLp0+fdk5PHiXMdOhannqA1w1wIQGFn6N
 XBiUciNPno2Kyhz6EZaUxbXCsLTHIJsZKbBc3p05k2eQrC4W9zWNgh0F4Ip8M5gFvU+TfGNZZ0P
 GQUMVIAXFg9wYJuoXEYqtc6Wgf21WO4Aq3wC9A1C8kgVkM/ompDWh4IYVIPY8uftRi1rS+7zkWl
 FBcI/fbSNktog4X2gc7jWOGPyyHANwD7cDXIJSaEtlrSpsuWHTJHnPMFcpQZ7d4t4ElMEpIQ4h7
 ewNE2mTnItIMoukD/Lg89R7/x9Fp05p5AWHvh8lekHFg6xx5FK0WBp+fwesnCxWBFdRAQKwCug9
 Wl4TFPQ6oDmWBTg==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

With cgroup.memory=nosocket the memory controller does not charge
socket memory, so the "sock " entry of memory.stat stays 0 and
memory.current moves only by the kernel objects accept() allocates.
tcp_client() then passes on 0 == 0 without having checked any
accounting, or fails if those objects took a fresh charge batch.

Look for nosocket among the cgroup.memory= options on the kernel command
line and skip the test there.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044ed..a24c1e07b2035 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1379,6 +1379,24 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	return ret;
 }
 
+static bool memcg_sockets_disabled(void)
+{
+	char buf[4 * BUF_SIZE], *opt;
+
+	if (read_text("/proc/cmdline", buf, sizeof(buf)) <= 0)
+		return false;
+
+	for (opt = strstr(buf, "cgroup.memory="); opt;
+	     opt = strstr(opt + 1, "cgroup.memory=")) {
+		char *end = strchrnul(opt, ' ');
+		char *ns = strstr(opt, "nosocket");
+
+		if (ns && ns < end)
+			return true;
+	}
+	return false;
+}
+
 /*
  * This test checks socket memory accounting.
  * The test forks a TCP server listens on a random port between 1000
@@ -1394,6 +1412,9 @@ static int test_memcg_sock(const char *root)
 	char *memcg;
 	long sock_post = -1;
 
+	if (memcg_sockets_disabled())
+		return KSFT_SKIP;
+
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
 		goto cleanup;

-- 
2.43.0

