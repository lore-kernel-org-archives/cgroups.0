Received: from mta0.migadu.com (out-245.mta0.migadu.com [91.218.175.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B76202F70
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 05:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787723505; cv=none; b=PLaFGfu8Pj8AmXS0AItsOIWPIyGjnEr5+Fp5vzQWZ9uNUX9t7qTLob2EDvNliIdOqcFAvlxJorB1k6iVXr/f8X1Oa0waqKNhxQfn4YaXc0YLZ2t+k2FDDryN9jvhJNS3NRBHQcf/ozsMAkf+ZgRQm6u3U0Yx7kD/0jIVi6rZ3XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787723505; c=relaxed/simple;
	bh=K164evGuZTXUEMLXuHvAsyAjbm7V1+PI6jyAq8+zZSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IpgL1OV/vVJnTGlTOzBwEFpfYiIJEUQmQ0V2FnkUBJ8YSy9dRH+9h8Dz0T4CCEVag+pgBcYWyUe+Cg2scG3DMPgPmlYSviQe/EySQKoGKcoskimMpXx0fhEeLAEkZsLWsNnIz2pGAGRRGUFcryTGHxo3xzu3d/wBw4AwLSjaCoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RC2eG/kK; arc=none smtp.client-ip=91.218.175.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RC2eG/kK"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=K164evGuZTXUEMLXuHvAsyAjbm7V1+PI6jyAq8+zZSk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787723501; v=1; x=1788328301;
 b=RC2eG/kK5vD4mzZGd/35Uh1CPaGY0MeNj1L8B2yD6BO726VkvSz2/tRmPFduR2lWbAEz0CIR
 1MkkeS7OaSgg6ywTOdWGWopvUtPvLoSt7ACwGYRtMPwSTB5BpB6sHGA394ZS7AroUHNKgdMiYE2
 J8/U2tqEaTCGlaKsjFeg9HXw=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.109.140] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 8c2da48d361714db;
	Wed, 26 Aug 2026 05:51:41 +0000
X-Mizu-Trace-ID: 8c2da48d361714db
X-Migadu-Flow: FLOW_OUT
Message-ID: <f51b7b7d-c2e3-4366-8d87-f298d98f5753@linux.dev>
Date: Wed, 26 Aug 2026 13:51:33 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/17] selftests/cgroup: Test type-change validation with
 child-owned CPUs
To: Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
 <20260820124202.517160-8-guopeng.zhang@linux.dev>
 <54caabf7-45eb-4113-9838-61d12e131c91@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <54caabf7-45eb-4113-9838-61d12e131c91@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/24 22:31, Waiman Long 写道:
> On 8/20/26 8:41 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> Create an isolated child which owns a CPU isolated at boot, then change
>> its parent from isolated to root. Check that the change succeeds without
>> altering the child or its isolated CPU.
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   .../selftests/cgroup/test_cpuset_prs.sh       | 47 +++++++++++++++++++
>>   1 file changed, 47 insertions(+)
>>
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> index 9a1cce4807b4..bc8dbb724d5c 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -1214,6 +1214,52 @@ test_boot_isolated()
>>       echo "$TEST_NAME test PASSED."
>>   }
>>   +#
>> +# A parent's type change must validate only CPUs owned directly by the parent,
>> +# not a boot-isolated CPU owned by a valid isolated child partition.
>> +#
>> +test_owned_cpus_housekeeping()
>> +{
>> +    TEST_NAME="Child-owned CPU type change"
>> +    get_boot_isolated_cpu "$TEST_NAME" || return 0
>> +    echo "Running $TEST_NAME test ..."
>> +
>> +    cd $CGROUP2/test
>> +    echo member > cpuset.cpus.partition
>> +    echo +cpuset > cgroup.subtree_control
>> +    echo 2,$BOOT_CPU > cpuset.cpus
>> +    [[ $(cat cpuset.cpus.effective) = "2,$BOOT_CPU" ]] || {
> 
> You are using the same BOOT_CPU set up in get_boot_isolated_cpu() in patch 3. That creates an hidden dependency on the order of the tests. I will suggest that you set up BOOT_CPU and  BOOT_CPUS as part of the initialization so the data is available to all the tests that want to use it.
> 

That makes sense. I will move the initialization of BOOT_CPUS and
BOOT_CPU to the setup stage in v2.

Thanks,
Guopeng
