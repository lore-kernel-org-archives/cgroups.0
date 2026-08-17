Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E371743F4BB;
	Mon, 17 Aug 2026 13:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975138; cv=none; b=hr4I/jvH/RmOKEZWUsnlZKH/q0ZO1Iq9tEnXU4BT1LceBty1L7tv9+OAoRBleYhQ67/JwckC8xIL0xJRIRn93U4Jg5IPAqpBx/tK5uRGVera4BH0stqra8TGt5ekPD/HbhSboT9ceYZ+3JBJhP2baj6kKFTacxPw+jhr4SBGI/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975138; c=relaxed/simple;
	bh=cNeWl7bw1HhGwmqI6ZFYpyg0msCEv6dN2DuuaGmXMpU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tmGOYsHmm4v1HcIagNduTi/kdLqdXs7vOVfxPzoQCw1GwUEnM6Yt0+VIxi3JLpNgpQOLty/8hEDjms6Cv8RyEbmQPKjY9AHR76Bzvh3JO+A6u5iRtliYeojwYwmahBxhDtqnAlDVhPwLP4pjaOj3QWdGnrPKrtWkTAqjJdrhUsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c261060a9a4311f19a56ed5b684f684d-20260817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:615dd124-44dd-40ac-983f-4f78e53b0429,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION
	:release,TS:28
X-CID-INFO: VERSION:1.3.19,REQID:615dd124-44dd-40ac-983f-4f78e53b0429,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION:r
	elease,TS:28
X-CID-META: VersionHash:7db8b62,CLOUDID:ec1081a26d84b2229a074b656afc1cbe,BulkI
	D:260817111225XMIBG1F7,BulkQuantity:10,SF:17|19|64|66|78|80|81|82|83|102|1
	27|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:40|20,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_OBB,
	TF_CID_SPAM_FCD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c261060a9a4311f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1866070750; Mon, 17 Aug 2026 21:58:43 +0800
Message-ID: <eef3b61a-a8c2-4b2e-b560-c2dae129bb7a@kylinos.cn>
Date: Mon, 17 Aug 2026 21:58:39 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, akpm@linux-foundation.org, audra@redhat.com,
 bingfangguo@tencent.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 zhuhui@kylinos.cn
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
To: Michal Hocko <mhocko@suse.com>
References: <aoLGzZHS8kj53-ey@tiehlicka>
 <20260817131221.44761-1-husong@kylinos.cn> <aoMMr6kEX7pW1dSF@tiehlicka>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <aoMMr6kEX7pW1dSF@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,Michal

在 2026/8/17 21:29, Michal Hocko 写道:
> On Mon 17-08-26 21:12:21, Song Hu wrote:
>> On Mon 17-08-26, Michal Hocko wrote:
>>> Is there any specific reason why the memcg stays in the cache slot
>>> without any pages?
>>
>> consume_stock() doesn't release the slot when nr_pages hits zero.  It
>> is kept for the next charge of the same task and only gets displaced
>> by a charge under a different memcg or by CPU hotplug.  The problem is
>> that the offlining drain skips empty slots, so the css reference they
>> hold is never dropped unless something unrelated displaces them.
> 
> This doesn't answer my question, really, does it? Is there any good
> reason for this implementation? Why do we need to drop references
> remotely when we can do so when the last cached charge is consumed?
> 

Fair enough.  There is no strong reason.  Keeping the slot
populated after the last page is consumed only saves a
css_get()/css_put() pair when the same memcg charges again on that
CPU - a micro-optimization from the original single-slot
implementation.

Dropping the reference in consume_stock() when the slot empties is
the better place.  Empty slots stop existing, so the offlining drain
has nothing left to miss and is_memcg_drain_needed() stays as it
is.  This also makes Joshua's concern about the full-stock drain go
away entirely.  The cost is one refcount pair per emptied slot, at
most once per MEMCG_CHARGE_BATCH pages.

Joshua, this supersedes the css_is_dying gating you suggested and
that I said I would do - with no empty slots left, the check would
never fire, and the kill_css_sync() ordering argument becomes moot
as well.  Since you are reworking this code, I'd appreciate a
sanity check on releasing from consume_stock().

If this direction works for you both, I'll rework the patch
accordingly.

Thanks,
Song

