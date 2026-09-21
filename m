Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF65649BD63;
	Mon, 21 Sep 2026 13:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996607; cv=none; b=EE66yDxGgVd8DPonDC/omWtM0+GzjjB5rMCFxu7KrtvBsEpIQRqGWMDbeZmzl+qAsaaKAZY2vfEUQ2P0wEm82VaGnmIk0cXegasY4HzWi3hnGrK5gC8fXywDjNyYZf35eEUn7viXhOjcfpgnsjF9OoPPW8nkhyWZBg2KMLB1qAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996607; c=relaxed/simple;
	bh=jfEgzzZen26EchpDBQmyydmpyxyN6BZiRZaCn3jVPKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzODNCpammrZwgopGfFTY/Hr95ZDaZxqB61KpVV/4r+SvgyDDt9XvMaUjrOPnqr+Z0Y9HKE68smWjeJYvugfKXlaRS9rfXBMXIPZ3y0dvvGbrO8aJP3gdXYoWac03LZ6IbIa07wGBFcjCMX+WULM5sROcyVjShT/MXUqazrSixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: aaa5f0d4b5be11f19a56ed5b684f684d-20260921
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
X-CID-O-INFO: VERSION:1.3.19,REQID:32ebc048-be81-457d-ad2d-af7b6c7d7804,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:32ebc048-be81-457d-ad2d-af7b6c7d7804,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:d06918adbb67dca5aedbf38c7b7a0699,BulkI
	D:2609212116369AYVBUC0,BulkQuantity:0,SF:10|66|78|81|82|102|127|865|898,TC
	:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: aaa5f0d4b5be11f19a56ed5b684f684d-20260921
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1466259568; Mon, 21 Sep 2026 21:16:33 +0800
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
Subject: [PATCH 2/2] selftests/cgroup: don't crash on a truncated mount entry in cg_find_root()
Date: Mon, 21 Sep 2026 21:15:56 +0800
Message-ID: <20260921131556.444661-3-sunshaojie@kylinos.cn>
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

cg_find_root() parses /proc/self/mounts with strtok() and assumes that
every field group it walks over is a complete "device mountpoint type
options freq passno" tuple.  That only holds while the buffer is big
enough for the whole file: if the buffer is too small, the last tuple is
cut short, strtok() returns NULL for the missing fields, and the
strcmp(type, ...) and strstr(options, ...) calls that follow dereference
it.

The current buffer is 10 * BUF_SIZE, so reaching this needs a mount table
over 40K, but the crash is easy to hit in a sandbox: with BUF_SIZE
overridden to 6, which leaves a 60-byte buffer, cg_find_unified_root()
segfaults instead of failing.

Stop parsing as soon as a field is missing.  Nothing follows a truncated
entry, so there is nothing to parse after it either.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 tools/testing/selftests/cgroup/lib/cgroup_util.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 65cd85c467bb..cd73471e13d7 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -302,6 +302,16 @@ static int cg_find_root(char *root, size_t len, const char *controller,
 		options = strtok(NULL, delim);
 		strtok(NULL, delim);
 		strtok(NULL, delim);
+
+		/*
+		 * A mount entry is "device mountpoint type options freq
+		 * passno".  A field can only be missing if the last entry was
+		 * cut short by the buffer being too small for the file, and
+		 * there is no complete entry left to look at.
+		 */
+		if (!mount || !type || !options)
+			break;
+
 		if (strcmp(type, "cgroup") == 0) {
 			if (!controller || !strstr(options, controller))
 				continue;
-- 
2.50.1

