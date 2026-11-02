Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622353;
	b=P1aXVyIKZZHx8D2YLzp5dzsAfV3v3QXMIbRKxMaH56TNTt4/a1TvLiezFtOxlXuu63bI
	 HNgw765+jXaoCgmJHrqzDYcMYgi96MNgEWbNweFhzCgpEjBEo7yFNKFMSC12TzCPVgUsS
	 Ysag1Q/P926HJ1pdHS1DMFPL3BN0y52lxXYDbItXXOlb2uIt9VCqfpMFWzIwmfjQx0Mhm
	 wTaMTdeP9ATsaUqYkryouwM8d4AL6ICzwbylGL5gmCdAjsEtCyx8ROauB6dr1I6+mNI7a
	 vxx7sfZws4bAVE1QSVh3abwAZlmqTJbLDG7LjvtsXHs6IGyEgJpKB7yh+fFxv/ROapw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622353;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=LMJynhb5MPftogfmT9tk2MR+IArvvhmjJkMrR0rvjaw=;
	b=ym8YmwXna7ldYfNHv0pfFA8kxg6A9FEoYtgjKFDZ1PIXyrOoaAjjkdpU/ClcPagP8anU
	 9HvrhSATkK559dDFlr2fFm+sw6e28q61qpBJJfSsiMTk54oZb3GhcnAl+qa8EI9WuHj+J
	 ju8UuS2nAw5PxNVMU1eAKNGpHtWPqa4ui5kAE4gRJc3/4t57xkmM/ze4Ebt6pv+uAkz79
	 q3MESU0fNiWFxSJR9UfrIPZB3qLxj0tS9OriekhLs+08UGyVUBfMUlHXkdxBI/f3htukK
	 qLsr5AO2DoOV17ubmCczNhp/qIOhO5eQl2dqTL27LSEjuWSGtUj3ZBZ1UVff7w1s+cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C4B606A792;
	Mon,  2 Nov 2026 12:25:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72C4B606A792
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 86323e2cd6b811f19a56ed5b684f684d-20261102
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:4e2633df-6343-43c4-8e5e-81c356af623c,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:4e2633df-6343-43c4-8e5e-81c356af623c,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:77a413587497340d9a585fb3ded6dfa9,BulkI
	D:261102202547G39DAL8J,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|153|
	865|898,TC:nil,Content:0|15|50|99,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:n
	il,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 86323e2cd6b811f19a56ed5b684f684d-20261102
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1357426714; Mon, 02 Nov 2026 20:25:43 +0800
From: Song Hu <husong@kylinos.cn>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: tj@kernel.org,
	tjmercier@google.com,
	ddrokosov@salutedevices.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 4/4] samples/cgroup: don't let dirname() clobber the monitored path
Date: Mon,  2 Nov 2026 20:25:28 +0800
Message-ID: <20261102122528.1498193-5-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102122528.1498193-1-husong@kylinos.cn>
References: <20261102122528.1498193-1-husong@kylinos.cn>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dirname(3) is allowed to modify its argument in place, and the libc
implementations do: after building event_control_path, argv[1] has
been truncated to the parent directory.  Every subsequent "crossed"
event line therefore reports the cgroup directory instead of the
monitored file, and the two-listener setup taught by
Documentation/admin-guide/cgroup-v1/memory.rst (usage_in_bytes plus
memsw.usage_in_bytes) produces indistinguishable output lines.

Work on a strdup() copy so event reports keep naming the monitored
file.

Fixes: 60433a9d038d ("samples: introduce new samples subdir for cgroup")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 samples/cgroup/cgroup_event_listener.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/samples/cgroup/cgroup_event_listener.c b/samples/cgroup/cgroup_event_listener.c
index 3d70dc831a76..308cacec80a8 100644
--- a/samples/cgroup/cgroup_event_listener.c
+++ b/samples/cgroup/cgroup_event_listener.c
@@ -26,17 +26,27 @@ int main(int argc, char **argv)
 	int event_control = -1;
 	char event_control_path[PATH_MAX];
 	char line[LINE_MAX];
+	char *path;
 	int ret;
 
 	if (argc != 3)
 		errx(1, "%s", USAGE_STR);
 
-	cfd = open(argv[1], O_RDONLY);
+	/*
+	 * dirname(3) may modify its argument in place; work on a copy so
+	 * argv[1] still refers to the monitored file when events are
+	 * reported.
+	 */
+	path = strdup(argv[1]);
+	if (!path)
+		err(1, "Cannot duplicate %s", argv[1]);
+
+	cfd = open(path, O_RDONLY);
 	if (cfd == -1)
-		err(1, "Cannot open %s", argv[1]);
+		err(1, "Cannot open %s", path);
 
 	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
-			dirname(argv[1]));
+			dirname(path));
 	if (ret >= PATH_MAX)
 		errx(1, "Path to cgroup.event_control is too long");
 
@@ -76,7 +86,7 @@ int main(int argc, char **argv)
 		if (ret == -1)
 			err(1, "cgroup.event_control is not accessible any more");
 
-		printf("%s %s: crossed\n", argv[1], argv[2]);
+		printf("%s %s: crossed\n", path, argv[2]);
 	}
 
 	return 0;
-- 
2.53.0

