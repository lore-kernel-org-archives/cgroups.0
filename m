Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793950515;
	b=SxSE+62g9R/J7C4fWsy3+pFsIgBtwgrcpx3u66pL/7JepuyFSQgwCAIDbTNiEsdBQhZ2
	 Bwnr+mgKoEJryK70EgtbUmBIx5WInmKbRSs3g74KDM/wqV8WToN6gPeeG1FuV/0CLeWAS
	 ZCVbr29uRRqeh6VFjlt/0xgU/556p61HxC2aDnZ3rSEP03Gy1PDkIxYNa+biN7FHwEsOP
	 8y4VRrGjCSRiBd8q5E38eCHFXlq3zCJywnltK3v2imJXEecVHsmX1NUgOn0qxKvsx6DV3
	 O9zi8prq+gDcvhlCmRjd99I1LGmGn5c/WIQaAqvD3F7F1Jk+NmdqpPkEEvgEaeg5mPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793950515;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=j6no1/Vpu6L+r0wRbefNhL88soVjvlfqiBGBjbBAWNo=;
	b=aE3FpQTFGFykVPgcfzWSBCuJ+cfi7P6KCa80fLVIRcdP6GA7zQ7o+p+PHRX/IH+eRnpv
	 Mp3r1wUDImCMu+4VPNzDcu3TBVQ9tRufQFMyk0E8btfKJ3hwOphDK7mbCKIkjEdD2WJ9S
	 fuuwqxjXPMH2BzlsADD/uZz0o+crsHPQV6BnsMnzk3IDkd++SJSpSe36ZjtgPRPgZxoKK
	 z70qtiGuKjDtfwrXgAgf7N8QPTlbXPasIlmEeWa0DG5VJpMnFNKcF03xk9XYcqkmszcPW
	 aXp0F5rtEZkGF6BwDQxZTc6joA/Ot9aBG2RlSvVeddzHi7ekc2PyE3HWfMqaSB2eFig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IAkUzVFQ;
	arc=none smtp.remote-ip=95.215.58.7
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A840F606A326
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 07:35:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A840F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IAkUzVFQ
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HiRolt3GBwHkqyoypDw0ynRAMEkeBRNLheBJrN0mHK0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793950512; v=1; x=1794555312;
 b=IAkUzVFQRvjRz9B0aOPIqxzr/BSHwMsk91EMTzM2B3CRoekgktP/4Y1mpOSgAoiavtazc33j
 aytN3ePjAhZOAs+SE9FgRtAX8vpefjtYU7gs3Jn1uFqW1/5vaTCFyD0wiDRk0XWr5CH2PMR+7yW
 nZxv5Q9PtZ3rMBztcS0HDwdQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9d770d7a1c0543d0;
	Fri, 06 Nov 2026 07:35:11 +0000
X-Mizu-Trace-ID: 9d770d7a1c0543d0
X-Migadu-Flow: FLOW_OUT
Message-ID: <7b661a26-70b5-47fd-af58-19e110c4b950@linux.dev>
Date: Fri, 6 Nov 2026 15:35:03 +0800
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
Subject: Re: [PATCH v2 3/3] cgroup/cpuset: Release isolated CPUs when the
 parent is invalid
To: Ridong Chen <ridong.chen@linux.dev>, longman@redhat.com, tj@kernel.org
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261105130344.664336-1-guopeng.zhang@linux.dev>
 <20261105130344.664336-4-guopeng.zhang@linux.dev>
 <41a6de2b-e7eb-4574-a698-b4ff8af316fa@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <41a6de2b-e7eb-4574-a698-b4ff8af316fa@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/6 12:35, Ridong Chen 写道:
> 
> 
> On 11/5/2026 9:03 PM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> An isolated partition can be invalidated after its parent has already
>> become invalid. update_parent_effective_cpumask() then skips returning
>> CPUs to the parent, but also skips removing them from isolated_cpus.
>> The invalid child continues to isolate CPUs that no longer belong to
>> any valid isolated partition.
>>
>> For example, on a 32-CPU system with all CPUs online and without
>> isolcpus= or nohz_full= boot parameters:
>>
>>    cd /sys/fs/cgroup
>>    echo +cpuset > cgroup.subtree_control
>>    mkdir A
>>    echo 0,2-31 > A/cpuset.cpus
>>    echo root > A/cpuset.cpus.partition
>>    echo +cpuset > A/cgroup.subtree_control
>>    mkdir A/B
>>    echo 2-3 > A/B/cpuset.cpus
>>    echo isolated > A/B/cpuset.cpus.partition
>>    cat cpuset.cpus.isolated
>>    2-3
>>    echo 0 > /sys/devices/system/cpu/cpu1/online
>>    cat A/B/cpuset.cpus.partition
>>    isolated invalid
>>    cat cpuset.cpus.isolated
>>    2-3
>>
>> Release the invalidated child's isolated CPUs when its parent is no
>> longer a valid partition. Use isolated_cpus_release() to preserve CPUs
>> still covered by a valid isolated ancestor and by boot isolation.
>>
>> After this fix, cpuset.cpus.isolated is empty for this reproducer.
>>
>> Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index fc5454c2740f..f3b808cea51c 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1976,10 +1976,15 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>           /*
>>            * Make the current partition invalid.
>>            */
>> -        if (is_partition_valid(parent))
>> +        if (is_partition_valid(parent)) {
>>               adding = cpumask_and(tmp->addmask,
>>                            cs->effective_xcpus,
>>                            parent->effective_xcpus);
>> +        } else if (old_prs == PRS_ISOLATED) {
>> +            /* No valid parent will release these isolated CPUs. */
>> +            cpumask_copy(tmp->addmask, cs->effective_xcpus);
>> +            isolated_cpus_release(cs, tmp->addmask);
>> +        }
>>           if (old_prs > 0)
>>               new_prs = -old_prs;
>>   
> 
> Hi Guopeng,
> 
> Thanks for the fix. Could you try this patch to see if it fixes the
> issue?
> 
> https://lore.kernel.org/cgroups/20261105125215.2205892-4-ridong.chen@linux.dev/T/#u
> 

Yes, I took another look at the code and tested your patch. It fixes the issue, so I'll drop mine in v3.

> I'm concerned about whether the related issue has been fixed in all
> the places that need fixing. In your reproducer, CPUs 2-3 are already
> wrong when A becomes invalid: partition_xcpus_del() only updates
> isolated_cpus when the old state differs from the parent's state, so
> the CPUs that A gave back but had distributed to the isolated child B
> are left in isolated_cpus. This patch only cleans them up later, when
> B is invalidated with an invalid parent. Other paths that give back
> CPUs of an isolated descendant may have the same problem.
> 

Haha, good point! I missed that again.

Thanks,
Guopeng
> My patch makes partition_xcpus_del() always set the isolation state of
> the given back CPUs, including those of the descendants, to the state
> of the parent that receives them. With it, isolated_cpus_release()
> should no longer be needed.
> 
> It would also be good to add your reproducer to test_cpuset_prs.sh.
> It can be expressed with O1=0 in the test matrix.
> 

