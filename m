Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FF036F413;
	Sat, 18 Jul 2026 16:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784391410; cv=none; b=JVmS2/+JeLAQ7QaCT7XYG5rLeuiDidxDxNV41M5NBfPDVLPu6cyjfSHIXKs/YLpcdyPISBMa4hzdp1JYpTLAFw+3b0G62AzLAsACwEZqDtuJDOyl8PobVMDpnL6IF114BbJhVlUxawe4P9Yrh8xtVvmvDKVlHkTgPXg7KyKWp90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784391410; c=relaxed/simple;
	bh=kjQ7/0+ZT8g9vdn6mr3Dw4BH3bFjXIbonV0JcdOe5ek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nFUv8Mq0+WEQKWPbRh/3weOtFTDU2DU1KVO8h+RxhvP2ymnJaugi3QOdwLxAHD0xMAbV7UP7BEYKJJthcMIreJCGpoFfLNlTmECvqCWXuzQJ6NWp64F06xQnKUn1XCXKmhagQ+82usmTKgMQKR2JtbzIkjno3EN7pvkeHB38Rb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f2WTUMCC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f2WTUMCC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=2wm0KCjvknUsN7rvSg2gYfLyxWrV/upifmjDu1oUmAw=; b=f2WTUMCCI/n+Vgovu49GEYJh5Z
	Wj6eaeUugz3zAvqiiKPG7kWtt+CJ91W4X9wUIAttQSkEqVCls71+Jd5n6efgasZLeG5fnobyfkfq5
	pq0xEzUFX6+R+QqfGDYzONGVy31+5QBQhzgN1+AiDgjLiXxIC+sEqiAGa8nPXEpSlktmGVbUniv2G
	v2iHQOZYj0hnGvmFy1h/7RKVTAQzU/+1YmkqAZUW+Lncms/AgA359Dfem4hoCwCj/nCFbVO9CdpsB
	c7JLkRGHPa/DKC6ev/ortzS3WUQLOofO9XNl5pJtAwXCIn+nSYIybcHAV1/GkRW5X2Cc7Kk3ectXi
	dnn2JuPw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wl7iI-00000004FpO-31zU;
	Sat, 18 Jul 2026 16:16:30 +0000
Message-ID: <c8ef86b1-3ed9-47f7-9c1d-f9a0b0676bc0@infradead.org>
Date: Sat, 18 Jul 2026 09:16:29 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] Documentation: admin-guide: fix trailing whitespace
 in cgroup-v2.rst
To: Weijie Yuan <wy@wyuan.org>, Yahya Toubali <yahya@yahyatoubali.me>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260718151913.1892547-1-yahya@yahyatoubali.me>
 <20260718151913.1892547-2-yahya@yahyatoubali.me> <alumXzlDApA_iMbY@wyuan.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <alumXzlDApA_iMbY@wyuan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/18/26 9:14 AM, Weijie Yuan wrote:
> On Sat, Jul 18, 2026 at 04:19:08PM +0100, Yahya Toubali wrote:
>> Remove trailing spaces on lines 1335 and 2197.
>>
>> Signed-off-by: Yahya Toubali <yahya@yahyatoubali.me>
> 
> Hmmm, for a file that might be modified, I wonder if it makes sense to
> include fixed line numbers in the commit message. i.e. When the line
> number changes, your commit message will become meaningless.
> 
> I'd love to hear others' comments.

I wouldn't include the line numbers...

>> ---
>>  Documentation/admin-guide/cgroup-v2.rst | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 14b8c571c0d1..f15a613fed6a 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1,4 +1,5 @@
>>  .. _cgroup-v2:
>> +.. SPDX-License-Identifier: GPL-2.0
>>  
>>  ================
>>  Control Group v2
>> @@ -1332,7 +1333,7 @@ PAGE_SIZE multiple when read back.
>>  	cgroup is within its effective low boundary, the cgroup's
>>  	memory won't be reclaimed unless there is no reclaimable
>>  	memory available in unprotected cgroups.
>> -	Above the effective low	boundary (or 
>> +	Above the effective low	boundary (or
>>  	effective min boundary if it is higher), pages are reclaimed
>>  	proportionally to the overage, reducing reclaim pressure for
>>  	smaller overages.
>> @@ -2194,7 +2195,7 @@ of the two is enforced.
>>  
>>  cgroup writeback requires explicit support from the underlying
>>  filesystem.  Currently, cgroup writeback is implemented on ext2, ext4,
>> -btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are 
>> +btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
>>  attributed to the root cgroup.
>>  
>>  There are inherent differences in memory and writeback management
> 

-- 
~Randy

