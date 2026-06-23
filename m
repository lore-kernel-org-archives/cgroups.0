Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A562E2663;
	Tue, 23 Jun 2026 09:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205338; cv=none; b=ju2ZjKew2JKMq41AyPiORju4ubuK5E3xIFc0iUBDRY/pC7UKzEL0B4Dd1Nfqa6MzD/QHrE2u3sm84ziN+cyOqpQaPuWx5N6W2apoRH8Fl6XKASeTbYgx6uk8acYtSGX8749zHYusIHMTS8YJ0R3PfTw/X8mkmKJObgnEKBg2obQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205338; c=relaxed/simple;
	bh=vpkGUKQEaQ4lWuSYSj/1vBp14XgwamsVm3quZ9DP8og=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RHEineNABniY0Djz53nijPZtR0f9YtJDEBtr4+0Oe0tLgzY4gYiwauqfLgh33RKJbEMo5ZQQtA4wxcSDoN4VMNQz7TG3BMmIyAHExQnDMTaW/au3YW2k1DQD8Wp/9wROWgCIpjy9PTHb6gC7GueCPTP9OaiSGm9a0OkUuh22uPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3740d6f46ee211f1aa26b74ffac11d73-20260623
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ac3a88ad-107b-4d39-a542-fe20c4c244f5,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:ac3a88ad-107b-4d39-a542-fe20c4c244f5,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:96aa78bb5b78416de3ee6f8223da1cd9,BulkI
	D:260623164252SOOOWG2W,BulkQuantity:1,Recheck:0,SF:17|19|38|64|66|78|80|81
	|82|83|102|127|136|841|865|898|1209,TC:nil,Content:0|15|52,EDM:-3,IP:-2,UR
	L:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SP
	R:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3740d6f46ee211f1aa26b74ffac11d73-20260623
X-User: zhangguopeng@kylinos.cn
Received: from [192.168.109.140] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1118971230; Tue, 23 Jun 2026 17:02:09 +0800
Message-ID: <5be54565-00be-4c05-91ca-0825fa925167@kylinos.cn>
Date: Tue, 23 Jun 2026 17:02:04 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
To: Harry Yoo <harry@kernel.org>, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260623082614.81621-1-guopeng.zhang@linux.dev>
 <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
In-Reply-To: <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


在 2026/6/23 16:42, Harry Yoo 写道:
>
> On 6/23/26 5:26 PM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> A patch filename was accidentally inserted into the comment describing
>> the nr_bytes field of struct obj_stock_pcp. Remove it.
> nit: perhaps add something like
> "Fix a typo in the comment (target -> targets)"?
Hi Harry,

Thanks for the review and the Ack.

Yes, I also fixed the "target -> targets" typo, but missed mentioning it
in the commit message. I'll be more careful about describing all changes
clearly next time. If a respin is needed, I'll add it to the commit
message and carry your Acked-by.

Thanks,
Guopeng

>> No functional change.
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
> FWIW,
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>
> Thanks!
>
>>  mm/memcontrol.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 6dc4888a90f3..3eedfc4e84a0 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2039,7 +2039,7 @@ struct obj_stock_pcp {
>>  	/*
>>  	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)
>>  	 * keep nr_bytes to unsigned int as uint16_t cannot represent the full
>> -e patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch	 * sub-page remainder. Such archs are not cacheline optimization target.
>> +	 * sub-page remainder. Such archs are not cacheline optimization targets.
>>  	 */
>>  	unsigned int nr_bytes[NR_OBJ_STOCK];
>>  #else
