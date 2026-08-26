Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C0918C008;
	Wed, 26 Aug 2026 03:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787713256; cv=none; b=N7WDNBgg/BI68WMcnjexrwGtcEtxph+Z/qLg8HRdWf6S4sJR23nvpaK1UC3yJQ1sdCTjMbCmcwYfTdxXHPS6oDY8FMfA1D7uFmXbI1uwLc0wmofnPF8iZdDFNra5hNieyLzqAEBjffnCT5BQuMR9cT8xQt/IujCunWzWcA191Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787713256; c=relaxed/simple;
	bh=VA+AH5pJWPWmbh4QS86foyjWLvhMz5Hw8tan3ko3UQQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=la8l/lqYjSqZuNatbmxJVbN5ltNYCkbn5JOcjSo8ScIDS1ukyo2+gV1Q955v2pOWtfLlrI+hXinpJe4CFL8YVnC+j+B5B9Hi9b7QOZDCfOAeuOtTNpQ4VZCWVgL01OY8uIVHMDQ9+fKkgQtFvTotw2pdNN4z9U9f6kXJlBtCMQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 544bff2ca0fa11f19a56ed5b684f684d-20260826
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_UNTRUSTED, SA_LOWREP, SA_EXISTED, SN_UNTRUSTED, SN_LOWREP
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:8010ee7e-c882-410b-aab3-c3e0db6b12f4,IP:10,
	URL:0,TC:0,Content:11,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:21
X-CID-INFO: VERSION:1.3.19,REQID:8010ee7e-c882-410b-aab3-c3e0db6b12f4,IP:10,UR
	L:0,TC:0,Content:11,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:21
X-CID-META: VersionHash:7db8b62,CLOUDID:b600d1a7afe962d6c665d03961dabf92,BulkI
	D:260820194334S50I7KW6,BulkQuantity:3,SF:17|19|64|66|78|80|81|82|83|102|12
	7|136|841|850|865|898,TC:nil,Content:3|15|50,EDM:-3|-100,IP:-2,URL:0,File:
	nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:
	0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 544bff2ca0fa11f19a56ed5b684f684d-20260826
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 768919277; Wed, 26 Aug 2026 11:00:44 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: mkoutny@suse.com
Cc: bsegall@google.com,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	dietmar.eggemann@arm.com,
	hannes@cmpxchg.org,
	juri.lelli@redhat.com,
	kprateek.nayak@amd.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	liuzhe1@kylinos.cn,
	mgorman@suse.de,
	mingo@redhat.com,
	peterz@infradead.org,
	rostedt@goodmis.org,
	skhan@linuxfoundation.org,
	tj@kernel.org,
	vincent.guittot@linaro.org,
	vschneid@redhat.com
Subject: Re: [PATCH 1/2] sched/fair: Reset incompatible burst on quota change
Date: Wed, 26 Aug 2026 11:00:06 +0800
Message-Id: <20260826030006.171041-1-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aobnZEh1hfIBhswD@localhost.localdomain>
References: <aobnZEh1hfIBhswD@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, Aug 20, 2026 at 01:43:21PM +0200, Michal Koutný wrote:

> Why not clamp the burst_us to quota_us? That's quite natural to me.
>
> Like Sashiko said, the user configured values should not get lost, the
> resulting burst value (0 or quota or whatever makes sense) might be
> applied effectively (to allow configuration order independence) but not
> overwrite what was configured.

Thanks for the suggestion. I agree that applying the clamp at enforcement
time is a better fit here.

There is also a second ordering case to consider: when both quota and burst
are being increased, writing burst first currently fails with EINVAL because
the burst value is checked against the old quota.

For v2, I plan to remove the validation which couples burst_us to the
current quota_us. The quota upper-bound check will remain unchanged, while
burst_us will be checked independently against max_bw_runtime_us:

@@ tg_set_bandwidth()
 	if (quota_us != RUNTIME_INF &&/path/to/YOUR_REPLY
 	    quota_us > max_bw_runtime_us)
 		return -EINVAL;

-	if (quota_us != RUNTIME_INF && (burst_us > quota_us ||
-					burst_us + quota_us > max_bw_runtime_us))
+	if (burst_us > max_bw_runtime_us)
 		return -EINVAL;

The configured burst value will be retained, and the value used by CFS will
be capped when the runtime is refilled:

@@ __refill_cfs_bandwidth_runtime()
-	cfs_b->runtime = min(cfs_b->runtime,
-			     cfs_b->quota + cfs_b->burst);
+	cfs_b->runtime = min(cfs_b->runtime,
+			     cfs_b->quota +
+			     min(cfs_b->burst, cfs_b->quota));

This preserves the value configured through cpu.max.burst and
cpu.cfs_burst_us while applying the clamp to the value used for enforcement.
It also allows the quota and burst settings to be written in either order.

I have tested both write-order sequences on linux-next next-20260824. A v2
with the corresponding selftest update will follow.

Thanks again for pointing this out.
