Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209A732E13B;
	Tue, 18 Aug 2026 01:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787016128; cv=none; b=asPwNjdoFyEi0b0cCT/xDh9LVj8yiLiL6Pde7w6NX/BNG0wTVGvV8UToqfwJrjey60yU0owVwBMSSlVp0Qmq2z4255rcm70qtJcbWPzxqE3v/Veu7WMKZ51+LEq8hlCVlJcIYoLcI1B6sxvpP++TdQTxo8vjZseHlfrUGV4OF+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787016128; c=relaxed/simple;
	bh=fI4XsC5BRQo9zG/wirUL6EJlTZeqgexhtkMwCr3WwZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsVIo6Jy3EhcSXa9mctzk5/Rxu9oILQb7pVpqx8y51phrTSYz2ZryvzE2ar12HOVScc/WNlnpB20xo/sA2nTqVgyzwBH+jMFBHlyrVemivDHt1Ijl/xoZ1B2HICFZLWKbsQMFoXbTzMHQfcpWqH+b4OtnlhviqwF9Z1HrOE36xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3386d1849aa311f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:95ddea70-7988-4cc8-adf0-a1985ffdd238,IP:10,
	URL:0,TC:0,Content:32,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:67
X-CID-INFO: VERSION:1.3.19,REQID:95ddea70-7988-4cc8-adf0-a1985ffdd238,IP:10,UR
	L:0,TC:0,Content:32,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
	ON:quarantine,TS:67
X-CID-META: VersionHash:7db8b62,CLOUDID:d9bb3ca6ae86ca470bf3cccdf54fcecc,BulkI
	D:260818092159OUBCKOM3,BulkQuantity:0,SF:17|19|66|78|81|82|83|127|865|898,
	TC:nil,Content:4|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,B
	EC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_ASC,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3386d1849aa311f19a56ed5b684f684d-20260818
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 621905450; Tue, 18 Aug 2026 09:21:56 +0800
From: Song Hu <husong@kylinos.cn>
To: joshua.hahnjy@gmail.com
Cc: akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	bsegall@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	dietmar.eggemann@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	harry@kernel.org,
	jackmanb@google.com,
	juri.lelli@redhat.com,
	kasong@tencent.com,
	kernel-team@meta.com,
	kprateek.nayak@amd.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mgorman@suse.de,
	mhocko@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	muchun.song@linux.dev,
	peterz@infradead.org,
	qi.zheng@linux.dev,
	rakie.kim@sk.com,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	rostedt@goodmis.org,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	tjmercier@google.com,
	vbabka@kernel.org,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry@kernel.org,
	yuanchu@google.com,
	ziy@nvidia.com,
	husong@kylinos.cn
Subject: Re: [RFC PATCH v3 09/14] mm/memcontrol: Make memory.high tier-aware
Date: Tue, 18 Aug 2026 09:21:15 +0800
Message-ID: <20260818012115.65838-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260807202059.2620949-10-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-10-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

(pre-existing, not from this series - mentioning it here because
it reworks memory.high behaviour)

The penalty computation in calculate_high_delay() can overflow:

	penalty_jiffies = max_overage * max_overage * HZ;

max_overage is a fixed-point relative overage:
calculate_overage() returns (usage - high) << 20 / high, so the
square times HZ wraps once (usage - high) / high reaches
4096 / sqrt(HZ).  That is roughly 130x at HZ=1000 and 259x at
HZ=250 - reachable when memory.high is tightened far below the
current usage of a large working set.

Most wrapped values are still caught by the 2s clamp in
mem_cgroup_handle_over_high(), but residues below the clamp pass
through, and some of them produce far less throttling than
intended - down to no sleep at all.

check_mul_overflow() with a clamp would saturate the penalty
instead of wrapping it.  Could be folded in while memory.high is
being reworked, or a standalone fix.
