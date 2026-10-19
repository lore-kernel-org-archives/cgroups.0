Received: from mta0.migadu.com (out-223.mta0.migadu.com [91.218.175.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA8E49B44D
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 09:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792402731; cv=none; b=IJZu8b1m3Gr/RhfjTkQycNb1uPum9rf6tu5npwm+07FJ/cKCm4QSAd8UqyXTVvAvvqnIqsJVPt5a9j9gtN2JFX9XwTlv6q3o3gKU9ZIljcKLhwkAPj7EqkkXmDPIlnG/qoMdf8MnBdIKHZzqSCC4mxw5k1KwJ74m9qQk/ppKXBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792402731; c=relaxed/simple;
	bh=pCurOb3VbzjUyrGfUIzqpi6M8nOAvf7wjuF/7ks+AGI=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Fje3jEZQqH6+yK+VfxhCLlSCxZx2b32IM2x510VHGwquuW9f2KU6n+G9Q6+YOZz06hfJF2WDltcsiqo2WKZ5wRwSL5MafO6RG3S+VLV63kQhj1invg7gn9DP/hDFALisTXJD5bNnjhmnZCDYHllK3U5OMDPvCEJdnykTUH3k4Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lj08vzkB; arc=none smtp.client-ip=91.218.175.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lj08vzkB"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pCurOb3VbzjUyrGfUIzqpi6M8nOAvf7wjuF/7ks+AGI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792402728; v=1; x=1793007528;
 b=Lj08vzkBSc0GOoTwKr9QGN/XXr8XRenNQPeEKL4olD6mCq6l28qEsVzLg+EpuCh1w+D1sVmm
 fujO0S/+dpHLO8K9gejk2ntYtkUL5vGveJAzggY2FCJt7IwzerBrnVti7yj3qTJKwNPrVvLB+Ek
 7bfR6SEZH7j8T9ykgqD5pEqc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 26079291d9b31009;
	Mon, 19 Oct 2026 09:38:48 +0000
X-Mizu-Trace-ID: 26079291d9b31009
X-Migadu-Flow: FLOW_OUT
Message-ID: <e864121c-f5ad-4df3-b956-f412632db3fb@linux.dev>
Date: Mon, 19 Oct 2026 17:38:42 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>,
 ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v10 2/4] selftests/bpf: add iocost cost model test
To: Tejun Heo <tj@kernel.org>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
 <20261003124045.1289305-3-cui.tao@linux.dev>
 <47611e3e8a2bfbdce1dfd9a1fe2c5019@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <47611e3e8a2bfbdce1dfd9a1fe2c5019@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

在 2026/10/17 01:49, Tejun Heo 写道:
> Hello, Tao.
> 
> On Sat, 03 Oct 2026 20:40:43 +0800, Tao Cui wrote:
>> +	dev = getenv("IOCOST_TEST_DEV");
> 
> Nothing in the tree sets IOCOST_TEST_DEV, so both tests always skip in CI.
> The null_blk instance the v11 removal test creates could serve these two
> as well.
> 
Right, that was an oversight. All three tests now create their own
null_blk instance through configfs. The create/remove helpers from the
removal test are shared, the $IOCOST_TEST_DEV handling is gone, and
everything now runs in CI.

>> +		if (ASSERT_OK(err, "readback"))
>> +			ASSERT_EQ(strcmp(model, "bpf"), 0, "model_bpf");
> 
> ASSERT_STREQ() prints both strings on failure.
> 
Switched.

>> +		bpf_link__destroy(skel->links.iocost_2x);
>> +		/* cleared, or the skeleton destroy below detaches again */
>> +		skel->links.iocost_2x = NULL;
> 
> Without clearing, the skeleton destroy would call bpf_link__destroy() on
> the freed link. It wouldn't detach again.
> 
Good catch. The comment now says the link has already been destroyed
and the field is cleared so iocost_model__destroy() doesn't try to
destroy it again.

>> + * The cursor handling follows the builtin: a zero cursor means "no
>> + * previous IO", and the cursor is advanced for bios the builtin
>> + * prices (READ/WRITE with a non-zero size; the builtin skips the
>> + * whole update when the cost is zero), so flushes and discards
>> + * leave it alone and long merged streams do not drift past the
>> + * 16MB seek threshold.
> 
> The model advances the cursor for every merged READ or WRITE bio.
> ioc_rqos_merge() only moves it on a back merge into the request ending at
> the cursor, so a front merge leaves the builtin's cursor alone and moves
> the model's.
> 
Fixed; the example model now moves the cursor the way
ioc_rqos_merge() moves the builtin's, so front merges leave it alone.

>> +	} else {
>> +		base = randio;
>> +		for (i = 1; i < NSLOTS; i++) {
>> +			if (s->stamp[i] < s->stamp[victim])
>> +				victim = i;
>> +		}
> 
> A merged bio which matches no slot, e.g. a front merge or a merge into
> another stream's request, takes the LRU slot and can evict a live stream.
> Maybe skip the slot replacement for IOCOST_COST_F_MERGE?
> 
Agreed; a merged bio which matches no slot is now priced without
touching the table, so a merge can no longer evict a live stream.

Thanks,
Tao

> Thanks.
> 

