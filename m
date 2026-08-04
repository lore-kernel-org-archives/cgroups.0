Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EE435C193;
	Tue,  4 Aug 2026 03:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785812677; cv=none; b=p7U0h0JidFw2YRL8vDNTpI5gDT8ToaeVE9dNkOacGzcEEr5gOf4qpceW89NexKtjCfhlBUpCd9I7rPD8JxxY05zvK/ledbbbRKsJfYg0Nl0n3yqqrAs3qaMgA2EttaitANuRz0th3yoflg1N0IyT1rrRV5RkxLhsO445IYhpibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785812677; c=relaxed/simple;
	bh=kRFK7580e1CcIoU2822dEAp+Pcu/IXB7M3lmZ6scRr4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DleZf0AmFNPdtpW3OG68uoTCmXaCJtUYSzH4Wa+ywnAoc6ECRwiOVt4Iv8b6OaJoINOj0h2GEfqHKzgoRd5a2kLTlCPEb3FtgiwIX2zpf9arnTgJms9Dpaeoy+kNfjRusLJ3aDIOTq+TrtNfaZt2//8QnZ3FPk5BSTl4/YN0C58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c/o3e5sB; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c/o3e5sB"
Message-ID: <1fab77c9-517f-4bc2-946b-faaa3c4c657c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785812663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iHxk3Q7e4n4R4q2FXGesDSAwgXhh1lLUhZaLTjv1OAs=;
	b=c/o3e5sBL6TgQJotiM9v4T+6iJOpAlfli95axyGN4uqQc10MvYFSLThSe9JQbCa+US7OSe
	lifgMm97M7RFlqjh87LHGHaleD3N7/F2Gdf6iAbi/Mbmp41XfJVoXy5br4gqFTxy8zWCiJ
	hw9AGdL1tykL6EmP7P23QED9GPhUyng=
Date: Tue, 4 Aug 2026 11:04:10 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, axboe@kernel.dk, josef@toxicpanda.com,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] block/blk-iocost: read ioc_pd_stat params inside
 ioc->lock
To: Tejun Heo <tj@kernel.org>
References: <20260803132201.135355-1-cui.tao@linux.dev>
 <anDGH6An5b_HI8pj@slm.duckdns.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <anDGH6An5b_HI8pj@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/8/4 00:47, Tejun Heo 写道:
> On Mon, Aug 03, 2026 at 09:22:01PM +0800, Tao Cui wrote:
>> @@ -3092,9 +3092,12 @@ static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
>>  {
>>  	struct ioc_gq *iocg = pd_to_iocg(pd);
>>  	struct ioc *ioc = iocg->ioc;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&ioc->lock, flags);
>>  
>>  	if (!ioc->enabled)
>> -		return;
>> +		goto out;
>>  
>>  	if (iocg->level == 0) {
>>  		unsigned vp10k = DIV64_U64_ROUND_CLOSEST(
>> @@ -3110,6 +3113,8 @@ static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
>>  			iocg->last_stat.wait_us,
>>  			iocg->last_stat.indebt_us,
>>  			iocg->last_stat.indelay_us);
>> +out:
>> +	spin_unlock_irqrestore(&ioc->lock, flags);
>>  }
> 
> There's nothing in this function that requires synchronized reads. Might as
> well just annotate them with data_race(). Otherwise, this can lead to a lot
> of lock operations when there are a lot of cgroups and high frequency stat
> reads.
> 
Agreed, there's nothing in this function that requires synchronized
reads, these are all stat values where stale reads are harmless.
Will switch to data_race() in v3.

Thanks,
Tao

> Thanks.
> 

