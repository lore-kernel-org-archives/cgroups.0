Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792648238;
	b=bBz1zMECgiTgDVk5oKS1zlGnCpG3SoXt7ZvQQJj8sjMp9T1DzzE5FAbiJgCRX7XoehqN
	 wj/TudpFfrVW2nC/4bIZWzXmfLwZk141/j7nL1FXiyDc95mTFsIBIMUu12fccSaRm8b7n
	 extTH11VT2tIWj5Z11ENz71cbKqfQM3YrlMAxNJ1momwiv2lbmhWLA4BQMA8Xi3roCvOf
	 BUDqmLxW5v+BigDfyUyb+ZXUcMf0VisYJBbFMHGOy7UKgiU2pajDBVyRq939WEjRnYcaR
	 Pr62G8Hx6H8PrGa1ysvTwxOuU3EjfLDyN2IoI+5jk7pYa+qiBg14h+0u4JXUofiADUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792648238;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=ehflWP/cfb3SeLIRWXb/gzDzyWPbV1lMgr0T0r9SCN8=;
	b=LYArQ2mMvP3ZWdtwxD5vrN6BBdM59mYVQUkwhdzplUxFcAA1U6aTkgEHVz5YrcJoF+IN
	 Zjnr/T87HPfI6pbWiMchRAnPc/q0S47CgRurNhuANoDQg3A2bzGsRx162K/QRG/d6zsVn
	 zZXHWSop6nvGAC/MGbSa7CyIewSOJg/uAa1O6r0IHF1mfxJF4i4BbIt3DSASRsME+rip+
	 fxwVJ6FddJ3N6PgJmGkLeRVQNK6oupsnUlU+AYMfh5D/2IKQnhHUq62ctx/wgpR/Sem9i
	 4CJfHZrMsaey2sumf4q/ae8LL33dCTz9evuKLmFIarFU/s3/c2dyOj23sSI56o0FuLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MSqEqIGa;
	arc=none smtp.remote-ip=95.215.58.125
Received: from mta1.migadu.com (out-125.mta1.migadu.com [95.215.58.125])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49F8606A319
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 05:50:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C49F8606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MSqEqIGa
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LQijZitfScP4O3BlAnhn6TsBqQiTt58EcetEfGwmwI0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792648234; v=1; x=1793253034;
 b=MSqEqIGavKMN4+Q9RPp6F86JLAaxsNb40VU4XJl8eVXW2mxs0+3gpVAj0MGVnY00+whcJqlH
 rg9/+FvlVFM4iCNt3R6WOD+zmueiEWJHnZ4OXORfDoPTrOYZib85zeS145n30puRxY3cG8VAb4M
 V8CQMTGrtZ3cF5O5hQ+8542I=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fe7f562c755d7731;
	Thu, 22 Oct 2026 05:50:34 +0000
X-Mizu-Trace-ID: fe7f562c755d7731
X-Migadu-Flow: FLOW_OUT
Message-ID: <6bbd6b27-a417-436e-aeba-1199626c3c6f@linux.dev>
Date: Thu, 22 Oct 2026 13:50:24 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] cgroup/cpuset: Fix cpuset.cpus update in a remote
 partition
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261010075947.333549-1-guopeng.zhang@linux.dev>
 <20261010075947.333549-2-guopeng.zhang@linux.dev>
 <0514f986-c125-4a2a-8079-cbbfe5cdc273@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <0514f986-c125-4a2a-8079-cbbfe5cdc273@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/22 11:23, Waiman Long 写道:
> On 10/10/26 3:59 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> When the CPU list of a remote partition is reduced, a removed CPU may
>> remain unavailable to the top cpuset.
>>
>> This can be reproduced on a cgroup v2 system with CPUs 0-7 online:
>>
>>      cd /sys/fs/cgroup
>>      echo +cpuset > cgroup.subtree_control
>>      mkdir A
>>      echo 1-7 > A/cpuset.cpus
>>      echo 1-7 > A/cpuset.cpus.exclusive
>>      echo +cpuset > A/cgroup.subtree_control
>>      mkdir A/B
>>      echo 1-4 > A/B/cpuset.cpus
>>      echo root > A/B/cpuset.cpus.partition
>>      echo 1-3 > A/B/cpuset.cpus
>>      cat cpuset.cpus.effective
>>
>> The last command should show 0,4-7, but CPU 4 is missing.
>>
>> update_cpumask() calls partition_cpus_change() while cs->cpus_allowed
>> still contains the old mask. remote_cpus_update() first releases CPU 4,
>> but the hierarchy update revisits B and compute_excpus() still sees the
>> old mask, so CPU 4 is removed from the top cpuset again.
>>
>> Move the cpus_allowed update before partition_cpus_change() so that
>> the hierarchy update sees the new mask when it revisits the cpuset.
>>
>> Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 0ebba2d646c3..de7553459adc 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2478,10 +2478,13 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>>        */
>>       force = !cpumask_equal(cs->effective_xcpus, trialcs->effective_xcpus);
>>   +    spin_lock_irq(&callback_lock);
>> +    cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
>> +    spin_unlock_irq(&callback_lock);
>> +
>>       partition_cpus_change(cs, trialcs, &tmp);
>>         spin_lock_irq(&callback_lock);
>> -    cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
>>       cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
>>       if ((old_prs > 0) && !is_partition_valid(cs))
>>           reset_partition_data(cs);
> 
> Sorry for the late reply.
> 
> Thanks for reporting this problem. I suspect similar problem may exist with change to cpuset.cpus.exclusive as well. The root cause of this problem is the recursive call to remote_cpus_update() with the second call missing information leading to the revert of the first call. I have posted another patch to address this recursive call problem. Please take a look to see if you agree with that or not.
> 
Thanks for the explanation and for looking further into the root cause.

I'll take a look at your patch and run some local tests once I've taken care of some urgent work.

Thanks,
Guopeng
