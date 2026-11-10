Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306770;
	b=42qJt8sOjpP8jXoP8YA9hoYHCbS+BNmYNLTnyz+V/R9vN+Rkbv3gM4KBYwqL3iUbC5Fg
	 CijOZJAkAtu32eZuQgimgO4wI+Im5c6jNnBbgGf4R87WwsTbw+tNqK4jTqgmHLsl05s9q
	 uGq0jZ5kFIL0DUKWzVLvv+p2UpNjTG4zNWcQToYQuBOJEhxDEU6PN3rK7ziXVn+JY1Ywe
	 n4PVV/8zDeypJgzehTdKcWm+6wT2ibtvuUp2dGQ8kB3WcSkaon+4i6j+/29xnw3xu9Dof
	 FTLAnNfcML9OCwTr/haa/2SBWAL4SxyjH0SNfkbRiPWvPHdirSC+1vmbvP52ZABPJYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306770;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uTuBZqTkCTsEEU+80LJmJIDLq+GQ1UT+vDvIO6jFFlw=;
	b=jlDHVtD93nrjo5U1gmRNr47xStz4XiWUtfJ5IM3PevFGNaFWR7D4MQY9VNred3H4iP35
	 p+dyHrcc02U4choBWUvYfiVT8d0GWgcli3qs2r4ZmGKcBp0rxv5nNhm51nFgwZeyydt4Y
	 FUqLQGTIsExg3fucFiEIz7Ki95U4xZgPnQDA1/ZUvcgYQxbAD5VJVl8+gXc0jwhZjEKdH
	 tIqTOoUO2uIc3135yob1E2p4LHshakL5vPKxsFMFmQvgCAnG1OyqUew9xKQ04Sm9koCtX
	 dYcYj1mPJEnXD7JN32rp0nG8FQTMLHKTIq7f1Affg0M/Iqb1Q98EcbGdWG2pWHK0kcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49BF606A32A;
	Tue, 10 Nov 2026 10:32:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C49BF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0b5e06bedcf211f19a56ed5b684f684d-20261110
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:3c1c8b24-5d8b-41a2-a320-8d206ebf0ddd,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:3c1c8b24-5d8b-41a2-a320-8d206ebf0ddd,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:f3d953bc796359c5d5a7f4434680fd77,BulkI
	D:26111018324134S4ID9W,BulkQuantity:0,SF:17|19|38|66|78|102|127|136|153|85
	0|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0b5e06bedcf211f19a56ed5b684f684d-20261110
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 684438741; Tue, 10 Nov 2026 18:32:35 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com
Cc: yukuai@fygo.io,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Zhe Liu <liuzhe1@kylinos.cn>
Subject: [PATCH 0/3] blkcg: decouple cgroup v1 I/O accounting from throttling
Date: Tue, 10 Nov 2026 18:31:58 +0800
Message-Id: <20261110103201.762861-1-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
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

Commit a3166c51702b ("blk-throttle: delay initialization until
configuration") deferred throttle policy activation until an I/O limit is
configured. However, cgroup v1 accounting still lives in the throttle
policy and is performed after the activation check in blk_should_throtl().
Without an activated throttle policy, v1 statistics such as
blkio.throttle.io_service_bytes remain zero even while I/O is issued.

This forces cgroup v1 users to configure the throttle policy just
to obtain I/O statistics, even when no throttling is needed.

This series moves cgroup v1 I/O statistics into blkcg and performs
accounting before checking throttle activation. It also moves
statistics reporting, reset and offline propagation into blkcg,
while preserving recursive aggregation and existing userspace
interfaces. With these changes, cgroup v1 I/O statistics work
without configuring throttle rules, while lazy throttle
initialization is preserved.

A/B-tested on linux-next (next-20261109) under QEMU (x86_64, TCG)
with the same kernel configuration. With no throttle rule, a 4 KiB
direct write accounted for 0 bytes and 0 BIOs on the baseline.
With the series applied, the same write accounted for 4096 bytes
and 1 BIO. A 1 MiB direct write split into 64 KiB BIOs accounted
for 1048576 bytes and 16 BIOs with the series applied.

Zhe Liu (3):
  blkcg: allow printing rwstat samples without policy data
  blkcg: move cgroup v1 I/O statistics out of the throttle policy
  blkcg: account cgroup v1 I/O before checking throttle activation

 block/blk-cgroup-rwstat.c |  18 ++--
 block/blk-cgroup-rwstat.h |   2 +
 block/blk-cgroup.c        | 188 +++++++++++++++++++++++++++++++++++++-
 block/blk-cgroup.h        |  15 +++
 block/blk-core.c          |   1 +
 block/blk-merge.c         |   9 +-
 block/blk-throttle.c      |  78 ---------------
 block/blk-throttle.h      |  12 +--
 8 files changed, 224 insertions(+), 99 deletions(-)

-- 
2.25.1

