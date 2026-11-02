Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622353;
	b=MA5t32qICNqO7Y3dSKIHoHNZXQwtBcXkAp1TOlLEkhTi/2FfE+6sOp/Ok2+Su27ZRSe1
	 HQOQ0rG9+JJsvqRA2Q7J5B2oCffHe/2HQjw0q5xFBiox4nbVnWTR2Pv9AesDH1LtRhxXg
	 03hZ1W6GDl8Ni0Akbi1NRnBnLpl0/71slWPhoQR+P+JwnLxZsXJZkMDSod+ZfPymHfP/l
	 N6t/cgkrqvnmq0/x0QiaP6vt/PE+8NGG738P4n1CutkRN7K6hS/awDe3vp+H6JEQN5GP1
	 AfRLVmKLZ74Gtly+BQ5lFIwnM3M/pmDVZmRU2k7sRfkz4XX1UrBPDfk0JkzVfGZTf8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622353;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=N/e8F7vO1qlhJjWmiyga+ERkoaVaWC5pSbm4ZBAVLeM=;
	b=pCztKouUuurrjUcsdKjRnyhgLh26+jq2CXFY7oLWz4aYHafuB3ohSsLpaca9cj/ZmeJk
	 aApwLdsBOufAn360Fm50IWvBJR3xrXyWYA0s2uWUjmvm5fzqPoSSlNbruRmVAFV1VPBBh
	 77eSy4nS4iTYfqUABp/SSUmfpLq802mZqoEp1VVWHMYb4VsNM8ns6Qv7NebH+DSDYGrth
	 1v5ibQFnQFZsr18IkdRtpxSz3kAglkiXJiBW/7zO8ZSZcQc1bGXhB3uQAhBtx/9UXGglp
	 V7FiVioE6+1DuxuRmvRzVvAu1++kv3DE5gXpw96djEDnICaizoWXgUETIKcshcrDEBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FAD606A786;
	Mon,  2 Nov 2026 12:25:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3FAD606A786
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 858d10bed6b811f19a56ed5b684f684d-20261102
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
X-CID-O-INFO: VERSION:1.3.19,REQID:c03703fe-cec2-447d-b4f6-b032501b1e87,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:c03703fe-cec2-447d-b4f6-b032501b1e87,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:ba1fe32e8b8323372cef97d932a82e0e,BulkI
	D:261102202546DIMLN7R4,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|136|
	153|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 858d10bed6b811f19a56ed5b684f684d-20261102
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1779435450; Mon, 02 Nov 2026 20:25:42 +0800
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
Subject: [PATCH 3/4] samples/cgroup: arm the inotify watch before reading the baseline
Date: Mon,  2 Nov 2026 20:25:27 +0800
Message-ID: <20261102122528.1498193-4-husong@kylinos.cn>
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

The listener reads the initial counter state first and arms the
inotify watch afterwards, so any event firing in between is lost:
it is already included in the baseline (no diff will ever be reported)
and no watch existed to queue a notification.

Arm the watch first, then read the baseline.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 samples/cgroup/memcg_event_listener.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/samples/cgroup/memcg_event_listener.c b/samples/cgroup/memcg_event_listener.c
index 996bf6fb117c..c23af43bf6cc 100644
--- a/samples/cgroup/memcg_event_listener.c
+++ b/samples/cgroup/memcg_event_listener.c
@@ -293,12 +293,6 @@ static int initialize_memcg_events(struct memcg_events *events,
 		return ret;
 	}
 
-	ret = read_memcg_events(events, /* show_diff = */false);
-	if (ret) {
-		warnx("Failed to read initial memcg events state (%d)", ret);
-		return ret;
-	}
-
 	events->inotify_fd = inotify_init();
 	if (events->inotify_fd < 0) {
 		warn("Failed to setup new inotify device");
@@ -313,6 +307,17 @@ static int initialize_memcg_events(struct memcg_events *events,
 		return -EIO;
 	}
 
+	/*
+	 * Read the initial state only after the watch is armed, so no
+	 * event can slip through the window between the baseline read and
+	 * the watch creation.
+	 */
+	ret = read_memcg_events(events, /* show_diff = */false);
+	if (ret) {
+		warnx("Failed to read initial memcg events state (%d)", ret);
+		return ret;
+	}
+
 	printf("Initialized MEMCG events with counters:\n");
 	print_memcg_counters(&events->counters);
 
-- 
2.53.0

