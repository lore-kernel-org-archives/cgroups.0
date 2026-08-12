Received: from mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A363741D221
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 09:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786528574; cv=none; b=UQY3Lm6CKNNzUuGmoxMhpwda3wrE1UrEOT4XLg4CBPJz5BlbLIPEFu3TWdl8VxOQ/BFlW92QijwdknuQ1nuaHgclNsGY67lAUPdyMNpY0/pU6nxhjm2Ex0/8iRcjk9gZwI87y6XFRlSBuA1iXbkO1lPx3nqaj3q/YHMUrRHtIOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786528574; c=relaxed/simple;
	bh=YBnyvyc75sBYBQiEBfOzBDUagZL06PaEKMK/eukkudM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IMxEUPDOQIPtAQ1jL4R9BFpir8qvfF3nQt7p+hvnM+z6aMgSp/FZw5RhbiOjO7CO7HVFc/bFZiw6W2i0GHd6QKQvybnEVC1Q6Yu3gjzk93b8XRXzepE36zrP95rzc8pfu2kgUzsuCil0X5UIWm96L/xQwwuhh0cchxvldGNIjbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OT0ff2fZ; arc=none smtp.client-ip=91.218.175.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OT0ff2fZ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YBnyvyc75sBYBQiEBfOzBDUagZL06PaEKMK/eukkudM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786528569; v=1; x=1787133369;
 b=OT0ff2fZCfFdSktLAlVqlOqYofb78NwJQ0vpAxIswGQdvoD+axqyaWMrdO72/7n++HuoRHHb
 o+RhjFQ51tiOBVkU3/LJm2HSH9t5hq0ArRvRzi5fmfCLKTFhGtPcrgI/bFy3N/8deccLoNo/nUV
 9orFarMLEcVTBjaatSYGmZQA=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [IPV6:2a02:6b6f:e75b:1900:855:edd6:ce7b:4965] (2a02:6b6f:e75b:1900:855:edd6:ce7b:4965)
	by smtp.migadu.com with ESMTPS id 7f9ab11aacc6e042;
	Wed, 12 Aug 2026 09:55:59 +0000
X-Migadu-Scanner: mta11.migadu.com
Authentication-Results: mta11.migadu.com;
	none
Message-ID: <25b34f95-ca45-451e-9efe-3509788b37ce@linux.dev>
Date: Wed, 12 Aug 2026 10:55:50 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] blk-iolatency: clear delay state when freeing policy
 data
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260806183742.946953-1-usama.arif@linux.dev>
 <20260806183742.946953-2-usama.arif@linux.dev>
 <anodES1Ht7shMCTr@slm.duckdns.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <anodES1Ht7shMCTr@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 10/08/2026 19:48, Tejun Heo wrote:
> On Thu, Aug 06, 2026 at 11:37:18AM -0700, Usama Arif wrote:
>>  static void iolatency_pd_free(struct blkg_policy_data *pd)
>>  {
>> +	struct blkcg_gq *blkg = pd_to_blkg(pd);
>> +
>> +	/*
>> +	 * Groups throttled as collateral have min_lat_nsec == 0, so
>> +	 * iolatency_pd_offline() leaves their delay set.  Drop it here, where
>> +	 * no in-flight bio can re-arm it via check_scale_change().
>> +	 */
>> +	if (blkg)
> 
> When can blkg be NULL here?
> 
> Thanks.
> 

Not in the normal case.

pd->blkg is only set when the pd is attached to a blkg.
blkcg_activate_policy() pre-allocates one outside the queue_lock when the
GFP_NOWAIT allocation fails, and frees it through pd_free_fn() if it ends up
unused — both at the retry and at the out: label. That pd never had ->blkg assigned.
It reads as NULL rather than garbage because iolatency_pd_alloc() uses kzalloc_node().

Good to keep as a guard in this case?
