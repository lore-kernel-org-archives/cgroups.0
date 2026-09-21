Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF72449BD6B;
	Mon, 21 Sep 2026 13:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996608; cv=none; b=kAUhQgS6Eb5bXbOszZrXmgd5er+20SqYM3tZU080Kqm8tPlJPuji+x784Qbc225Os9OHBJHQl3KSXUan6JByqwzt9XGEoht5IHcpeX0xlH9VirJVuU2GUa+kJEUQDgQaQ0GsjehxvKAH9t1FOXVFp5NFnGb4PBVhddcdeVg2qcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996608; c=relaxed/simple;
	bh=alMkwpLLq8o/W5ksx/Aslq+G/hhCkBzj+g1lvIR3Qj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ema3s7r75O3TIN7fl2bX5yZhFqJoQ64PLFxWWl/559W3RfPZnk8oOpKHeyO9yvGMB8yJf8BliBlqj9ddB9DWnkfwqDWNisfx9TDdg2v8ETpaIifVf93vGU+GOh0+GAGp+czeqB2ZLVQtKr1ozUzymCzBvwvtK6cRakBkCTQOsew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a8bc8a8ab5be11f19a56ed5b684f684d-20260921
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2e4e5417-57c3-4e8f-a228-bea0547a69f9,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.19,REQID:2e4e5417-57c3-4e8f-a228-bea0547a69f9,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:7db8b62,CLOUDID:5facdd19d369d6921df06601d3987007,BulkI
	D:2609212116331NOFBL1S,BulkQuantity:0,SF:10|66|78|81|82|102|127|865|898,TC
	:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a8bc8a8ab5be11f19a56ed5b684f684d-20260921
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1807090; Mon, 21 Sep 2026 21:16:30 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	mkoutny@suse.com,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li Wang <li.wang@linux.dev>,
	Hongfu Li <lihongfu@kylinos.cn>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH 1/2] selftests/cgroup: read the entire file in read_text()
Date: Mon, 21 Sep 2026 21:15:55 +0800
Message-ID: <20260921131556.444661-2-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260921131556.444661-1-sunshaojie@kylinos.cn>
References: <20260921131556.444661-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

read_text() issues a single read(2) and returns whatever it got, so a
caller that asks for a whole file silently gets a prefix of it instead.
For a seq_file larger than one page it never gets more than that prefix:
seq_read_iter() copies out at most one internal PAGE_SIZE buffer per call
and leaves the rest for the next read(2), no matter how much room the
caller's buffer has.

/proc/self/mounts is one of those files, so cg_find_root() only ever sees
the first 4K of the mount table.  On a machine with ~80 mounts the cgroup2
entry already sits past that limit: the file is 7177 bytes, the single
read(2) into the 40K buffer in cg_find_root() returns 4035 bytes, and the
cgroup2 line starts at offset 4953.  cg_find_root() then fails, and every
test that calls cg_find_unified_root() -- test_core, test_cpu, test_cpuset,
test_freezer, test_hugetlb_memcg, test_kill, test_kmem, test_memcontrol,
test_pids and test_zswap -- exits with SKIP "cgroup v2 isn't mounted"
without running a single test.

proc_mount_contains() searches only that same prefix, so a mount option
listed later in /proc/mounts is reported as absent, which is what the
probes in test_memcontrol and test_hugetlb_memcg are based on.

Read until the buffer is full or EOF instead.  A partial read is still
possible when max_len is too small, so callers that deliberately read a
prefix, such as cg_read_strcmp(), keep working.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 .../selftests/cgroup/lib/cgroup_util.c        | 35 +++++++++++++++----
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 2596c12cd864..65cd85c467bb 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -24,20 +24,43 @@ bool cg_test_v1_named;
 /* Returns read len on success, or -errno on failure. */
 ssize_t read_text(const char *path, char *buf, size_t max_len)
 {
-	ssize_t len;
+	size_t total = 0;
+	ssize_t len, ret;
 	int fd;
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0)
 		return -errno;
 
-	len = read(fd, buf, max_len - 1);
-
-	if (len >= 0)
-		buf[len] = 0;
+	/*
+	 * A single read() is not enough.  procfs and sysfs are backed by
+	 * seq_file, and seq_read_iter() copies out at most one internal
+	 * buffer (PAGE_SIZE) per call, leaving the rest for the next read().
+	 * Reading only once therefore silently drops everything past the
+	 * first page, no matter how big the caller's buffer is.
+	 *
+	 * Loop until the buffer is full or EOF.  A full buffer still means
+	 * the file may be longer than max_len, but that is now limited by
+	 * the caller's buffer rather than by a page of seq_file output.
+	 */
+	while (total < max_len - 1) {
+		len = read(fd, buf + total, max_len - 1 - total);
+		if (len < 0) {
+			if (errno == EINTR)
+				continue;
+			ret = -errno;
+			goto out;
+		}
+		if (!len)
+			break;
+		total += len;
+	}
 
+	buf[total] = 0;
+	ret = total;
+out:
 	close(fd);
-	return len < 0 ? -errno : len;
+	return ret;
 }
 
 /* Returns written len on success, or -errno on failure. */
-- 
2.50.1

