Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB40317715;
	Mon, 27 Jul 2026 03:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785122418; cv=none; b=Ct5DOyGHsv296xz3QBH7z/NyVxnbfUPsZbMDRBOLCVUZThVrtp6d3+RJEEn25zXCvp/DSIouRP0N4cHNNc4/8ASa3Px4ZQDcJlykACdJoyHIOnb9wmlgpRpU27mFggSm+GJWHEpq1QCZAFNzBfEoR6Yb2cy8N5IYzgjA4Eh4wtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785122418; c=relaxed/simple;
	bh=9/7UxVeoeJ7B6K6+Qx+V9js9R0EaL5PAagkoNR7cizg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=usOaH6/q/WFgqGR/5C1dUxx+T+tdOdXRdvM0usDSbzbsqofMai3rm7r6jRNmWZM39YDUQWaerbRJ/DMZHYS0CmDI6Y+KqLC42PC1jFOzLU85DVY1njO7tLvOClIR5sZbVAnQc6FxqwKUyBvmBOrY1Vrro4YzXRfHoJ8AMNCaWGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 104743e2896a11f1aa26b74ffac11d73-20260727
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:621dd92a-fb72-41ba-bcbc-17dc64d14437,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:621dd92a-fb72-41ba-bcbc-17dc64d14437,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:160f49203bc80cbfce275a43904d57ed,BulkI
	D:260724192158HERI0N81,BulkQuantity:1,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|841|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:ni
	l,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,
	DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 104743e2896a11f1aa26b74ffac11d73-20260727
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2070163307; Mon, 27 Jul 2026 11:20:05 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: mkoutny@suse.com
Cc: cgroups@vger.kernel.org,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	sunshaojie@kylinos.cn,
	tj@kernel.org
Subject: Re: [PATCH] Docs/admin-guide/cgroup-v2: document hierarchical cpu.max throttling behavior
Date: Mon, 27 Jul 2026 11:18:55 +0800
Message-Id: <20260727031855.63653-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <amNJyZQj0p38zlDe@localhost.localdomain>
References: <amNJyZQj0p38zlDe@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

Hi, Michal.

On Fri, 24 Jul 2026 13:21:46, Michal wrote:
>On Fri, Jul 24, 2026 at 06:25:00PM +0800, Shaojie Sun <sunshaojie@kylinos.cn> wrote:
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 14b8c571c0d1..3572d3e7f688 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>
>> +	                                       and the resulting
>> +	throttling may reflect the combined effect of multiple levels
>> +	rather than any single level's limit alone (this differs from
>> +	other Limits-type controllers such as memory.max and io.max,
>> +	where the most restrictive limit along the hierarchy is
>> +	applied).
>
>I'm not sure from the description what the "combined effect" is.
>Can you give an example where the cpu.max differs from that Limits-type
>semantics?

Here is an example to illustrate the difference. Consider:
  Parent:  cpu.max = 50000 100000 (50%)
  Child:   cpu.max = 20000 100000 (20%)
With cpu.max, when the child's processes consume CPU, throttling can be 
triggered by either the child's own limit or the parent's limit 
independently — both levels participate in enforcement. This is visible
in cpu.stat : the throttled_usec counter can accumulate non-zero values
at both the child and parent level. Even when the child's quota is 
smaller than the parent's (20 < 50), the parent's limit still
participates; conversely, when a child's quota is larger than the
parent's, the child's own limit still participates.

Compare this with memory.max. If we had:
  Parent:  memory.max = 50M
  Child:   memory.max = 20M
The effective limit for the child is simply min(20M, 50M) = 20M — only the
most restrictive limit along the path applies. The child will never see an
OOM triggered by the parent's 50M limit before reaching its own 20M.

In short: cpu.max enforcement is per-level independent — every level with 
cpu.max configured can independently throttle the group, and cpu.stat 
counters at multiple levels can all accumulate throttled_usec for the same
workload. memory.max only enforces the tightest limit along the path.

Thanks,
Shaojie Sun
