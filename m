Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792648921;
	b=XY0KPYCExKLBKqFXT3gQkSOoxDURG0rhAN3X59Z9rRK8QbcbgLsiUPgkGvUqYSF/CmtN
	 uC0eNHW82tHP4Nq8UNjgwtNIclXzk8Aeskmyo35qpQ05H4FzBVSiVuRMq36C1frEsl39b
	 rjQjdJHvFpjyaW12iEKFyA9AdvCrefIYWloP6Dmfh4+dNVkUIaXX8U/w1uiN3/fkLaBZE
	 lj/FvVWRrMvPTDjq+cwEHPYMBJSeSAb1E+K4lKueVH2Ekj8/0z8VoGeCCccdguBORqoHe
	 Ub0uctbXufvT7XRq4VGH5pmabIigqVUN4Cxm29KcRj7sr4jOhhGtB8Tdf0D8A8mY2ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792648921;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=aYOG0+2yMHEwlM5WXi+wtVEkUkFc7Rz+pgS8X+MUUx8=;
	b=Kkl9pdJriqKXFNyDvA4iVA6ySdTUJjO9Ad9nP4eBPGVGkm+AMWbk3hwZRQGoee6+aL1s
	 0Fka4n2qaAOwDTHj01f/VC47593CjV77jNXNuuoNxG9RIcGl1xxPnSJMudlMZejUcB03G
	 XoOV5KaxS7wPi75nUHqNSqQCDwCLampJGWCJ/MV9YEZtlZNC7T+LEl/6Vw0ljJxuDulmh
	 H+gvWXdEsJvbYGqmOnfxv24cDeAm3eMlojQ5deGW4tDUOeN85yq2A5j1sFsobvMkrAsfb
	 KSCQxuQSpXiLkJj+l3pK/lee/ww5YGO1LrTNBjqv67VyTbBzPS3hCsRHdfoJf37/GFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M7aVjHXF;
	arc=none smtp.remote-ip=91.218.175.106
Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8171606A31B
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 06:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8171606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M7aVjHXF
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WT+CIFhZntE5BE5eqiNouZOxVvcxtEu7JEGWI4ZMUMs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792648918; v=1; x=1793253718;
 b=M7aVjHXFu28T7XQJ40fE36+Tg7vjSogHkIOOSUHQVXqJfGcJ+gh54Uk+u1jk33naaI498NUi
 Ouj+iN2+o6VvqWhGQYv9+vCtrCHd50QDVTkkM08TrAOKZ5JfOjA5lpZBDbUjuHvdL13RUNiPSrI
 CZ3t7UcPi2zjDEJZzfaQpgtA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ef379f53ce47e711;
	Thu, 22 Oct 2026 06:01:57 +0000
X-Mizu-Trace-ID: ef379f53ce47e711
X-Migadu-Flow: FLOW_OUT
Message-ID: <96d314a5-09b8-42f1-bed8-a5e755cda982@linux.dev>
Date: Thu, 22 Oct 2026 14:01:50 +0800
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
Subject: Re: [PATCH] cgroup/cpuset: Fix partition recovery with unavailable
 CPUs
To: Waiman Long <longman@redhat.com>, tj@kernel.org
Cc: ridong.chen@linux.dev, hannes@cmpxchg.org, mkoutny@suse.com,
 shuah@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261020133315.123890-1-guopeng.zhang@linux.dev>
 <71bc8d63-456c-4dcb-9d03-c2881f41af78@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <71bc8d63-456c-4dcb-9d03-c2881f41af78@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/22 11:31, Waiman Long 写道:
> On 10/20/26 9:33 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> An invalid local partition can become valid again even when its
>> exclusive CPUs are no longer available from its parent.
>>
>> This can be reproduced on a cgroup v2 system with CPUs 0-7 online:
>>
>>      cd /sys/fs/cgroup
>>      echo +cpuset > cgroup.subtree_control
>>      mkdir A
>>      echo 1-4 > A/cpuset.cpus
>>      echo 1-4 > A/cpuset.cpus.exclusive
>>      echo root > A/cpuset.cpus.partition
>>      echo +cpuset > A/cgroup.subtree_control
>>      mkdir A/B
>>      echo 3-4 > A/B/cpuset.cpus
>>      echo 3-4 > A/B/cpuset.cpus.exclusive
>>      echo root > A/B/cpuset.cpus.partition
>>      echo 1-2 > A/cpuset.cpus.exclusive
>>      cat A/B/cpuset.cpus.partition
>>      root
>>      cat A/B/cpuset.cpus.exclusive.effective
>>      cat A/cpuset.cpus.effective
>>      1-2
>>      cat A/B/cpuset.cpus.effective
>>      1-2
>>
>> B is changed back to a valid root even though its exclusive CPUs are
>> no longer available and cpuset.cpus.exclusive.effective is empty. B
>> should remain invalid until A can provide its exclusive CPUs again.
>>
>> Shrinking A's exclusive CPUs invalidates B in
>> compute_partition_effective_cpumask(). The subsequent walk in
>> update_cpumasks_hier() tries to recover B, but
>> update_parent_effective_cpumask() skips the recovery checks when xcpus
>> is not a subset of parent->effective_xcpus. Since part_error is still
>> zero, B is changed back to a valid partition.
>>
>> Set PERR_INVCPUS when the subset check fails so that the partition stays
>> invalid. New test cases are added to test_cpuset_prs.sh for removing and
>> restoring the parent's exclusive CPUs.
>>
>> Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c                            | 8 ++++++--
>>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 4 ++++
>>   2 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 585a982249ad..be80763953ed 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1986,12 +1986,16 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>                   cpumask_copy(tmp->addmask, cs->effective_xcpus);
>>                   adding = true;
>>               }
>> -        } else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
>> -               cpumask_subset(xcpus, parent->effective_xcpus)) {
>> +        } else if (is_partition_invalid(cs) && !cpumask_empty(xcpus)) {
>>               struct cgroup_subsys_state *css;
>>               struct cpuset *child;
>>               bool exclusive = true;
>>   +            if (!cpumask_subset(xcpus, parent->effective_xcpus)) {
>> +                part_error = PERR_INVCPUS;
>> +                goto write_error;
>> +            }
>> +
>>               /*
>>                * Convert invalid partition to valid has to pass the
>>                * cpu exclusivity test as well as the housekeeping
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> index d04aad697b96..f1d517647ade 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -427,6 +427,10 @@ TEST_MATRIX=(
>>       # cpuset.cpus is allowed, but those extra CPUs are ignored.
>>       "  C2-3:P1   C3:P1  .      .      .     C2-4    .      .     0 A1:|A2:2-3 A1:P1|A2:P1"
>>   +    # A child cannot recover until its exclusive CPUs are available again.
>> +    " CX1-4:P1 CX3-4:P1 .     .     X1-2    .      .      .     0 A1:1-2|A2:1-2|XA2: A1:P1|A2:P-1"
>> +    " CX1-4:P1 CX3-4:P1 .     .  X1-2:X1-4 .      .      .     0 A1:1-2|A2:3-4|XA2:3-4 A1:P1|A2:P1"
>> +
>>       # Taking away all CPUs from parent or itself if there are tasks
>>       # will make the partition invalid.
>>       "  C2-3:P1   C3:P1  .      .      T     C2-3    .      .     0 A1:2-3|A2:2-3 A1:P1|A2:P-1"
> 
> Patch 2 of my series should fix this problem too. I do borrow your test cases in my patch. I hope you don't mind about it.
> 
Thanks for addressing this issue as well.
Of course, I don't mind. Glad the test cases are useful!

Thanks,
Guopeng

