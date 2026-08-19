Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F29A396B9D;
	Wed, 19 Aug 2026 13:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145754; cv=none; b=k2X0RWrVT7eyqys6jNUWch7Ki6f21IjX5lWDtjoAcqClwIYj5H4vROF6oOdzjcYs0gT8sZ0o6Bc771EKA6CX2CipVaSfB3sSt1RR7ckIIqI8Br+bb7emY1Liy8y0eG6ihEXNzhDKgBwc4PtfVbSAD9MMuJnm1WF3bdS0iGCsRFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145754; c=relaxed/simple;
	bh=0B+MY6T4G46mvzSbsdpm6pM9o7FAKPKaDqjKbz525Ik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ed4N0dkXq8PFpV1QYTPOfu7pV3YeqxX2WFtr78mhWV3SMBiM42akEU2YlXX4vdkJRLcG4NxD8nWTqFX/NTgBuEJvdhnca+1DPZ/YU5i5pdWyJbJHRprqQ5FqlmRtqZfh+lf7mvhuPwJaQIpQXEy+3UmAcpiOkfvMWdbPHehYFX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 011ad8569bd111f19a56ed5b684f684d-20260819
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d9e7c4d5-9b1d-4595-9b93-d731a7ebd762,IP:0,U
	RL:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:11e6ee3dfcb512015faf57493ec09a9a,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|123|136|850|865|898,TC:nil,Content:0|
	15|50,EDM:2|44|-100,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_EDM_RNO,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 011ad8569bd111f19a56ed5b684f684d-20260819
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 982613573; Wed, 19 Aug 2026 21:22:19 +0800
From: liuqiqi@kylinos.cn
To: joshua.hahnjy@gmail.com
Cc: Qiqi Liu <liuqiqi@kylinos.cn>,
	mhocko@suse.com,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory accounting and control
Date: Wed, 19 Aug 2026 21:22:11 +0800
Message-Id: <20260819132211.366064-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260818154954.805958-1-joshua.hahnjy@gmail.com>
References: <20260818154954.805958-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiqi Liu <liuqiqi@kylinos.cn>

Hi all,

Thank you all for your replies. I am not very familiar with the
community's workflow and should have reviewed the mailing list
archives and existing implementations more carefully. I sincerely
apologize for any inconvenience this may have caused.

My work is based on
https://lore.kernel.org/all/20260528134212.240492-1-liuqiqi@kylinos.cn/
aiming to develop memory tiering limits for cgroups. During
development, I referenced Joshua's v2, but failed to notice that
v3 had already been posted when I submitted my series.

I have studied Joshua's v3, and our core mechanisms are largely
consistent. However, there are two differences:

1. Read/write per-tier interface (memory.tier): each cgroup
   tracks its memory usage by tier (e.g., DRAM, CXL), exposed
   via a new memory.tier control file. This file reports
   per-tier usage and accepts per-tier high (soft limit) and
   max (hard limit) settings. By default, these limits are
   automatically derived from memory.high/max based on each
   tier's capacity ratio, but manual overrides are supported,
   allowing administrators to constrain specific tiers on a
   per-cgroup basis.

   Its advantages are:
   - It can express allocations that fixed capacity ratios
     cannot.
   - Latency-sensitive tenants can be given a larger share of
     the fast tier.
   - High-capacity tenants can have their soft limits removed
     for the slow tier.

   Whether or not to constrain a specific tier should be a
   decision made by the administrator on a per-cgroup basis.
   This serves as an answer to Michal's earlier question in
   the thread regarding "do you intend to limit memory
   consumption on particular tier even without an external
   pressure?"

2. Per-tier stock: I have implemented and tested per-tier
   stock -- it batches atomic operations on tier counters from
   per-page to every 32 pages. Joshua's patch (moving the stock
   down to the page_counter level) takes a more generic
   approach, and I believe we should continue with his
   direction here.

Memory hardware is becoming increasingly diverse (DRAM, CXL,
and further remote tiers), and the performance gaps between
tiers are significant. Different workloads have different
requirements -- some demand low latency, while others need
capacity. When the fast tier cannot accommodate the working
sets of all workloads, it should be the administrator's
scheduling decision to determine fast-tier allocations. I
believe tier-aware control is a direction worth pursuing, and
the differences above are where we can contribute.

As Shakeel suggested, and given that Joshua's v3 already
contains the core mechanism, I am dropping my current
standalone patchset. I would like to ask if Joshua would be
willing to collaborate with me on this, treating memory.tier
as an extension to the patch series and proposing it as
follow-up patches based on v3.

PS: I have already subscribed to the mailing list to avoid
such misunderstandings in the future.

Best regards,
Qiqi Liu

