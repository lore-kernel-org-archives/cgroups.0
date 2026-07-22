Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D11938F642;
	Wed, 22 Jul 2026 03:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784691180; cv=none; b=WbuRD14kxJjBJufvxhsNPhPJJXJhCO7hsJJKRt4LiqE2qzoriL7xO4im1e8mVXSIA4obQ7rp7Xi66zRTFBEniE1+RM3Wsj0YBq5vv+/D5dJuM0ymi+sagYxaTBpE0L7yZ/dEvRyUq5bPdGEl0KDiHsRCSuZy5C99016F3ezjh0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784691180; c=relaxed/simple;
	bh=QhNyKKBFfgTpbJew3FS/R0Y91szT85yfiI2KeIC+ib8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ipu67exF9hAjI77aDKPQdjPAGRgJIsiZHgmw44/PRzq9bEqXjQtjMRS00uhdGRP8U4yx4vAm2LT2/8c4GEf2Ll5OryTtrJ4MWb2AcBxnszwii0BLenlAO8UxfohBsp2fsM+gOKNias0cX8ITzrjfnX9rqgGH3U6ddNchE8ULyos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aEDNjOm2; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aEDNjOm2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784691171; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IymiIrNVW1FFlvdve8LqbI7PLCHhrb0shwE+ClAe7nU=;
	b=aEDNjOm20OHQHoF2Y4xjKAp9WkvIL3+kWk8Lgi6HqlDfPRzRG87i+vjPby4ZY1hbZwZ18p0kuOj1vRWSV+TEsQ1ZHKIj9MkRhOeCVDsXT4vmx35E9Pt3p3PcrUOBrB6qgs7d++pjk4rLlm5IgPRPdNrnPQUeWwJwxMzveJPFZgU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=lulie@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X7c1i-9_1784691170;
Received: from 30.221.129.41(mailfrom:lulie@linux.alibaba.com fp:SMTPD_---0X7c1i-9_1784691170 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jul 2026 11:32:51 +0800
Message-ID: <25b7479a-f594-4ca0-884b-309758bf1b52@linux.alibaba.com>
Date: Wed, 22 Jul 2026 11:32:49 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6.y 0/2] sched/psi: fix race in pressure_write
 (CVE-2026-52991)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, eadavis@qq.com,
 surenb@google.com, akpm@linux-foundation.org, dust.li@linux.alibaba.com
References: <20260715084256.43412-1-lulie@linux.alibaba.com>
 <2026072145-living-december-c5ac@gregkh>
From: Philo Lu <lulie@linux.alibaba.com>
In-Reply-To: <2026072145-living-december-c5ac@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 9:09 PM, Greg KH wrote:
> On Wed, Jul 15, 2026 at 04:42:54PM +0800, Philo Lu wrote:
>> This patchset is same as that for 6.12.y.
> 
> Where is the 6.12.y version?

It was sent as a new patchset:
https://lore.kernel.org/stable/20260715083245.32115-1-lulie@linux.alibaba.com/

As Sasha said in that thread. The patchset is waiting on a pending Tejun 
fix (deadlock risk with cgroup_mutex). He'll queue 6.12/6.6/6.1 together 
once it lands.

Thanks.
-- 
Philo

