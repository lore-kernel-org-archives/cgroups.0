Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622352;
	b=qks6OZ8ssnR81n4zW6BMiQRf8rYRNUFD8mws29TfzmMInw/GM55LlfuckQN+VhtVOo/c
	 +VPEK8mc2kjsmcoeJrHFwZNeqPdstzoWH1/N5SM1CZcIAo7+3GkMJGVFGjNXjIQfRCN1r
	 LWaC4QwwGsF8xSFk97JSJtx3yRrLVA2Mg3+arLBzNQucrl/okzY6sf83vIyYl2kJfqcfM
	 +Qq2HER3VivQt7KkN3OmcO2vftGoOn4PhFKrKBM9nG8gB5GNFr4JnzOPayuScXgGLtBST
	 qmlHeFCKVzpA42+lEUgLapIFwbhPzcwm0f3zs3i0uKUVfzkoRdyCbz7nZIxlckicpvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622352;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nhXQ2Ame5+daf54wfwzPP3l2P6rp0yUdRpVe3pvTfes=;
	b=iIWyWcgm+dSKJ/1mo+FD/jF5ONsOU97XbHzitw+e3n9UafjAT/vs/3bjPGRadIDjlcAZ
	 MrOsnVlg7Xhvvm9HqXNElty6HYas8yqKeHy4e+b6zythVD1Ld/KgaVpPV19P/l78Gm5vH
	 SFJti/ojMfk5Jr60REbDem3vG44k2YhMVTXKW+9LxGrunEf6XMVsala0nw6hxiJ2NgFlv
	 /CqestyrmNN+M6rrZZN2prUO5PVlJ86xjM3juOhbkyLtAZ/GVLDBb3yEJlcEYrRtCIqqM
	 4pPl9cobEYbYID7mmFn62RLhf3g5zCKaTaQ90HkMXjVMViLy7aaK2dlQIqxqw1Gd4OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731EF606A785;
	Mon,  2 Nov 2026 12:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 731EF606A785
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 836a81b8d6b811f19a56ed5b684f684d-20261102
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
X-CID-O-INFO: VERSION:1.3.19,REQID:ea2e17f3-a9d6-4002-8a3c-1a5447129d31,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:ea2e17f3-a9d6-4002-8a3c-1a5447129d31,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:639da65dbf4e7f0356cae5a58ab4b3f1,BulkI
	D:261102202544SBVQ7N2X,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 836a81b8d6b811f19a56ed5b684f684d-20261102
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 721082814; Mon, 02 Nov 2026 20:25:39 +0800
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
Subject: [PATCH 0/4] samples/cgroup: fix issues in the event listener samples
Date: Mon,  2 Nov 2026 20:25:24 +0800
Message-ID: <20261102122528.1498193-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
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

The two event-listener samples in samples/cgroup mishandle the
lifetime of the monitored file and poll() errors in several ways.

Patch 1 fixes the poll error guard in memcg_event_listener, which
tests "errno != EAGAIN", an error poll() never reports, so an
interrupted poll (EINTR) from a signal exits the listener instead of
resuming.

Patch 2 makes memcg_event_listener exit cleanly when the monitored
cgroup is removed.  Since eea5d2bb34ba ("kernfs: Send IN_DELETE_SELF
and IN_IGNORED") kernfs delivers both events on rmdir; the sample
warns and keeps polling, so a supervisor still counts it as alive
while the monitored cgroup is gone.  Verified against a real
container lifecycle: the unpatched listener stays alive across
docker rm -f, the patched one exits.

Patch 3 arms the inotify watch before reading the counter baseline in
memcg_event_listener, closing the window in which events were lost.

Patch 4 stops cgroup_event_listener from letting dirname(3) modify
argv[1] in place, which truncated the path reported in every event
line and made the two-listener setup taught by
Documentation/admin-guide/cgroup-v1/memory.rst produce
indistinguishable output.

Patches 1 and 2 were verified against a real container lifecycle
(docker rm -f) in a QEMU/KVM virtual machine; patch 3 runs on every
listener start; patch 4 is compile-tested only.

Song Hu (4):
  samples/cgroup: fix poll error handling in memcg_event_listener
  samples/cgroup: exit cleanly when the monitored memcg is removed
  samples/cgroup: arm the inotify watch before reading the baseline
  samples/cgroup: don't let dirname() clobber the monitored path

 samples/cgroup/cgroup_event_listener.c | 18 +++++++---
 samples/cgroup/memcg_event_listener.c  | 50 +++++++++++++++++++-------
 2 files changed, 51 insertions(+), 17 deletions(-)

-- 
2.53.0

