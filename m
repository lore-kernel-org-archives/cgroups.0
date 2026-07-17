Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D3022A80D;
	Fri, 17 Jul 2026 02:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784254348; cv=none; b=mBw8HzbbIKVP15mpg4VbFupT56SSmv+4jl8+rnbeT1qT3Nv3kPrrRozl7sm6gN/jWNgNXJ++a9A7tcVWPIReHdzrx+ecbjl8CNjeysjQCRee6z5Wn3MxxQWzfnkqS9J14S8d+Pp3A8irOn11yBdXtpuTpt0WntUye+jIrI5F0B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784254348; c=relaxed/simple;
	bh=/mBKJ1WaOWsE1Aer14ncCZqR/GNzcH2rHpbVnnJNpD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GkRDeDjQgEbz7NtinBalV/cbWQgkVvR3ZoOBz6L6NyA+stCsAP+ASMp0GIH3hcqzJW3zpIodVklZussuy9iHyip6DwnxwG2HRWKRGn8S9xI6ue5Jd92Iw0TJx2hZMstoflsLfvk2DC6gkhDf4u+lqkz+yekPF53Au6KLZhXPJhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bXz2GryQ; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bXz2GryQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784254337; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bWKodYEWA49vBwhUw8/2NF7Ttdi94lkflxNwpPEUuEk=;
	b=bXz2GryQDF75s95nY9TUp2dhgSQf85+pF+IEusCSdKxk9px+qNTO1sWvNBRcX27YxAhQcOmAb6DGGdO4jWoVCwpctb5uRx7b0AvaTfqZr7p0xsSjHL52qqeQxWBdXGLy04xWJdhH3TGmWdNTCb+LGec7VRCU+kPcCMj3WIA6pbI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=lulie@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X7Fu1J-_1784254335;
Received: from 30.221.120.252(mailfrom:lulie@linux.alibaba.com fp:SMTPD_---0X7Fu1J-_1784254335 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Jul 2026 10:12:16 +0800
Message-ID: <9805cccf-91d8-4766-a79a-035e5de39857@linux.alibaba.com>
Date: Fri, 17 Jul 2026 10:12:15 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12.y 0/2] sched/psi: fix race in pressure_write
 (CVE-2026-52991)
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: chenridong@huawei.com, tj@kernel.org, lizefan.x@bytedance.com,
 hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 eadavis@qq.com, chenridong@huaweicloud.com, akpm@linux-foundation.org,
 surenb@google.com, dust.li@linux.alibaba.com
References: <20260715083245.32115-1-lulie@linux.alibaba.com>
 <20260716232340.0009-stable-reply@kernel.org>
From: Philo Lu <lulie@linux.alibaba.com>
In-Reply-To: <20260716232340.0009-stable-reply@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/17/26 9:37 AM, Sasha Levin wrote:

> I'm holding off on this series (and the 6.6.y/6.1.y ones) for now: a5b98009f16d
> moves the psi trigger write path under cgroup_mutex, which means the psimon
> kthread gets created while holding cgroup_mutex and introduces a deadlock risk.
> 

Thanks for the heads-up, Sasha, and sorry I missed the patch you pointed 
out.

BTW, I have an unrelated question. I'd like to backport some stable 
patches to earlier LTS trees (e.g. from 6.18 down to 6.6). For patchsets 
like this one that apply cleanly to multiple versions (6.1, 6.6, and 
6.12), which of the following is preferred?

(1) A single patchset covering all three trees, with subjects like 
"[PATCH 6.1.y/6.6.y/6.12.y] ..."

(2) Three separate patchsets, one per stable tree.

Thanks.
-- 
Philo

