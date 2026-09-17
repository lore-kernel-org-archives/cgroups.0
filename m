Received: from mta0.migadu.com (out-141.mta0.migadu.com [91.218.175.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7F8318EC7
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 17:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666900; cv=none; b=le1TOIdSra2l5ggHGB6IgGF29gy3HBGGXcP+Thed2oIm1m6fTbf8Mw5bfx10/aN2mXaGvWrDshD01YLwOuuYzBt5j8fwYRICwQD1+w7cnYeZuMJWwrFCSbxN4S78P8Qv5hXPhptJg/aQdNrkSz1MlaixVPITU2FVN3s3Usps6eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666900; c=relaxed/simple;
	bh=+guZnFTM+M/5i9rrqq4ZVstz7/uElKhJ8UAetROi8VU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j6/X6wdK5I1N6RKrRRqdEFwXDPhOcRM3kM4k816Uq7kADDMxdc5iqIC+odfscnKgYQxk8EdTWb04Ya1LnuFJ3LfbRqRN+pDUJfu6B/ciIb/F3iRGS6tWwDwmfWIhBVVrhgRgZ81D5S91SONfG1NJ8Mp7kHeW3ZtkyWFWX75Juxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JWeAO2sj; arc=none smtp.client-ip=91.218.175.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JWeAO2sj"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+guZnFTM+M/5i9rrqq4ZVstz7/uElKhJ8UAetROi8VU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789666895; v=1; x=1790271695;
 b=JWeAO2sj2b6aMQlEZYJiXhoJ4h4i9XP0fDHk8sCRNVczW05g3IkWuY/Avykzu36TdiNOvLDd
 e0bBrSXfW6B5RinQELMYJLGyUJ5j1V72QfwwbBfAG+/xs3519/JQOj2tePrSbEskSTx3IflWzMC
 aldudO9UHkkcJRs6+R6qkHL0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2e90bbb2c356c51a;
	Thu, 17 Sep 2026 17:41:35 +0000
X-Mizu-Trace-ID: 2e90bbb2c356c51a
X-Migadu-Flow: FLOW_OUT
Message-ID: <7d5f54bc-6daa-45c3-b57b-23d3204d3e7e@linux.dev>
Date: Thu, 17 Sep 2026 18:41:32 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-cgroup: skip rstat flush for cgroups without blkgs
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev,
 riel@surriel.com
References: <20260917161020.4139163-1-usama.arif@linux.dev>
 <aqwV9cjg7Yj2OtBG@slm.duckdns.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aqwV9cjg7Yj2OtBG@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 17/09/2026 17:31, Tejun Heo wrote:
> On Thu, Sep 17, 2026 at 09:10:20AM -0700, Usama Arif wrote:
>> Non-root io.stat reads flush the blkcg rstat subtree before walking
>> ->blkg_list. This takes the subsystem rstat lock and checks for pending
>> updates on every possible CPU, even when there is no per-device state to
>> print.
>>
>> Blkg creation is hierarchical. A descendant blkg implies an ancestor
>> blkg on the same device, so an empty ->blkg_list means the subtree cannot
>> contribute any output. Return early in that case.
>>
>> A concurrent first blkg may be deferred to the next read. This is
>> consistent with the existing non-atomic flush and list walk.
>>
>> This is not rare: 340 of 969 io.stat files were empty on a 316-CPU host.
>> In a 16-vCPU lockdep-enabled guest, the median
> 
> Can you please test on a kernel w/ lockdep disabled? It doesn't make much
> sense to compare performance numbers with lockdep enabled.
> 

The updated numbers without lockdep are:

                             before    after
      empty io.stat           7.02 us   5.47 us
      populated io.stat       7.84 us   7.83 us

    The median paired reduction for empty reads was 22.1% (20.0-22.4% across
    pairs). System CPU time per read fell by 22.8%. Populated reads showed no
    consiste



>> open/read/close time over 35 batches of 20,000 reads changed as follows:
>>
>>                          before     after
>>   empty io.stat          49.1 us   41.0 us
>>   populated io.stat      49.9 us   50.2 us
>>
>> This is a 16.6% reduction for empty reads. Populated reads were unchanged
>> within measurement noise.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> That said, I don't see any downsides:
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Thanks.
> 

