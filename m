Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54E849BD9C;
	Mon, 21 Sep 2026 13:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996602; cv=none; b=RQefTqMKEFKj32lQQ6KnlMxLiAoSYxgqWGaIhKpjlAGXHNqQmJT/0cd0yubkvdK2ygaLX0hlQf+cf5qvkTkX5KhfebxHLotsbNwzCuPfA+smHQ6GD7RNcbwpnRLN2AsdD6mkYH4L7CH0pd6Xuw4bb9Vr63cNBOxJpHxlRVHD2dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996602; c=relaxed/simple;
	bh=ny9kj5UxpSjiy3RXxKQ4tP5Nb0ArRzlWoFjWBBy09iM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=irjw1bvPVKQXj7LNvvItn0XbQXsHzGNrcMzALPdWP3UXYSHLjJoq2kYw0KdSS7c7IIlYIM8Vxj2MA543qfZ6aDKRro0G1hsHKRt2dL2e0pAKWoauD3LKuZXvFRrRxQuWtmXiZ7Oj7qbE5G4wEQLKGB21pb7esdDwofm2djFULM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a774e672b5be11f19a56ed5b684f684d-20260921
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
X-CID-O-INFO: VERSION:1.3.19,REQID:4f0a2cda-90f8-47fd-a734-959b1bf39393,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:4f0a2cda-90f8-47fd-a734-959b1bf39393,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:950ff3d5b25a25a7153a29519c3a72f6,BulkI
	D:260921211633Z580QKMB,BulkQuantity:0,SF:10|66|78|102|127|865|898,TC:nil,C
	ontent:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:n
	il,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a774e672b5be11f19a56ed5b684f684d-20260921
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 408941128; Mon, 21 Sep 2026 21:16:28 +0800
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
Subject: [PATCH 0/2] selftests/cgroup: fix truncated reads of /proc/self/mounts
Date: Mon, 21 Sep 2026 21:15:54 +0800
Message-ID: <20260921131556.444661-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cgroup selftests read /proc/self/mounts with read_text(), which issued
a single read(2) and treated the result as the whole file.  For a seq_file
larger than one page it never is: seq_read_iter() copies out at most one
internal PAGE_SIZE buffer per call and leaves the rest for the next
read(2), no matter how much room the caller's buffer has.

On a machine with ~80 mounts /proc/self/mounts is 7177 bytes, a single
read(2) into the 40K buffer in cg_find_root() returns 4035 bytes, and the
cgroup2 entry starts at offset 4953.  cg_find_root() therefore never sees
the unified hierarchy, and all ten test binaries that call
cg_find_unified_root() exit with SKIP "cgroup v2 isn't mounted" without
running a single test.  The same truncation hits proc_mount_contains(),
so a mount option listed after the first 4K is reported as absent.

Behind that there is a second failure mode: if the buffer really is too
small and the cut lands inside an entry, strtok() returns NULL for the
missing fields and cg_find_root() dereferences it, so a short read ends in
a segfault rather than a plain "no cgroup2 entry found".

The series fixes both: read_text() reads until the buffer is full or EOF,
and cg_find_root() stops parsing as soon as a field is missing.  The write
path is untouched and files that fit in max_len - 1 bytes still return
identical bytes, so callers that read a prefix on purpose, such as
cg_read_strcmp() and the 1-byte read in test_zswap, behave as before.

Tested with the mount table above: test_kill goes from
"1..0 # SKIP cgroup v2 isn't mounted" to "1..4"; with BUF_SIZE forced to
6, the old code segfaults in cg_find_unified_root() where the patched one
returns -1.

Shaojie Sun (2):
  selftests/cgroup: read the entire file in read_text()
  selftests/cgroup: don't crash on a truncated mount entry in
    cg_find_root()

 .../selftests/cgroup/lib/cgroup_util.c        | 45 ++++++++++++++++---
 1 file changed, 39 insertions(+), 6 deletions(-)

-- 
2.50.1

