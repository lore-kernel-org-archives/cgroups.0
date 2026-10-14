Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A633253D9CC
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986587; cv=none; b=E3l6jDKtUyNPxW13fJJ2L3NbRE0IEyC2z59n308tvdPeDCpCxW4GWzYH+lYeYPuhULGsH28vT7c7QH7h+vsUBc1TfRkBRucAt3uwwvdEo5lRL0E+xUUqQxd8uqWQL+TtNmktlhAFirbguD1Cqy/J7cyFGvzIPDlcs8ddUpl+Oxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986587; c=relaxed/simple;
	bh=tUXs/YfqDGtc+vaUL4NHfIvxoxfeyn6z6DlvNKLELR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rKBgCx37F27LOBGPpm04ZA3ljM4gZoe9V+Cip9f1m7w3m8W6tMtgJEKI8ULN+xSFJ0MHbwR7x+JFsjXxLde/x8pIADqclVazcq2ODBeL2gOscSNMi4jxjLp5pFzKL3G7O7/MzO02LDXb5EI86md0tSrrERLZoGtX922CbRuYSPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E3BtSzlU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E3BtSzlU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Abj49UQVBm8izzorvcotuu43aueefKUzQuGS0GJdECg=;
	b=E3BtSzlUopd/DbC8lOSD7Dzxr3B0UrdYnvZIk4pIe2Z475Nl+F9RAF9stQFBXLfx4GHgLs
	InfCEFw+j0ztFAV98E0cEw48pM9WfkGFLUggU8/tJAeZNR45YAxf+LHzkjAAl6rRI7TUjF
	LgGRslNjYHKK0pDgAXXoMU/l8wLP68A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-381-3DXY-s0eOz2Znc2bFfm28w-1; Wed,
 14 Oct 2026 14:02:54 +0000
X-MC-Unique: 3DXY-s0eOz2Znc2bFfm28w-1
X-Mimecast-MFC-AGG-ID: 3DXY-s0eOz2Znc2bFfm28w_1791986572
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 016B71955F00;
	Wed, 14 Oct 2026 14:02:52 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 460421800347;
	Wed, 14 Oct 2026 14:02:50 +0000 (UTC)
Message-ID: <3d648916-92ac-4c8d-85eb-0bf8c1aa2799@redhat.com>
Date: Wed, 14 Oct 2026 10:02:49 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 5/6] selftests/cgroup: Add tests for housekeeping
 check
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>
References: <20261010221938.243859-1-longman@redhat.com>
 <20261010221938.243859-6-longman@redhat.com>
 <c7bf4584-0a47-445b-af10-4b1a29e9cdec@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <c7bf4584-0a47-445b-af10-4b1a29e9cdec@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 10/11/26 4:48 AM, Guopeng Zhang wrote:
>
> 在 2026/10/11 06:19, Waiman Long 写道:
>> Whenever a partition is enabled or the cpumask of a valid partition
>> changes, a housekeeping check will be performed to ensure that the
>> change won't violate the imposed housekeeping constraints. One of the
>> constraints is that a boot-time isolated CPU will not be used to form
>> a non-isolated root partition.  This requires the presence of boot-time
>> isolated CPUs when a test is run.
>>
>> The test_cpuset_prs.sh test script is now updated to run a set a
>> special housekeeping check tests that will only be run if a suitable
>> boot-time isolated CPU is present. This will enable us to detect bugs
>> or regressions in the housekeeping checking code though a "isolcpus="
>> boot parameter with CPUs beyond CPU 8 must be present.
>>
>> Adding test to check for exhaustion of all the housekeeping CPUs is
>> much harder and so will not be attempted at this time.
>>
>> This patch also includes a minor fix to the REMOTE_TEST_MATRIX to avoid
>> test failure when the -v option is used.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   .../selftests/cgroup/test_cpuset_prs.sh       | 109 ++++++++++++++----
>>   1 file changed, 87 insertions(+), 22 deletions(-)
>>
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> index 7efd5e645767..3d392e8c66aa 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -86,26 +86,37 @@ echo "" > test/cpuset.cpus
>>   
>>   #
>>   # If isolated CPUs have been reserved at boot time (as shown in
>> -# cpuset.cpus.isolated), these isolated CPUs should be outside of CPUs 0-8
>> -# that will be used by this script for testing purpose. If not, some of
>> -# the tests may fail incorrectly. Wait a bit and retry again just in case
>> -# these isolated CPUs are leftover from previous run and have just been
>> -# cleaned up earlier in this script.
>> +# /sys/devices/system/cpu/isolated), these isolated CPUs should be outside of
>> +# CPUs 0-8 that will be used by this script for testing purpose. If not, some
>> +# of the tests may fail incorrectly.
>>   #
>> -# These pre-isolated CPUs should stay in an isolated state throughout the
>> +# The current set of isolated CPUs (as shown in cpuset.cpus.isolated) should
>> +# be the same as the boot value. If not, wait a bit and retry again just in
>> +# case these isolated CPUs are leftover from previous run and have just been
>> +# cleaned up earlier in this script. If they still don't match, we report an
>> +# warning and skip the test.
>> +#
>> +# These boot isolated CPUs should stay in an isolated state throughout the
>>   # testing process for now.
>>   #
>> -BOOT_ISOLCPUS=$(cat $CGROUP2/cpuset.cpus.isolated)
>> +BOOT_ISOLCPUS=$(cat /sys/devices/system/cpu/isolated)
>> +CURRENT_ISOLCPUS=$(cat $CGROUP2/cpuset.cpus.isolated)
>> +FIRST_ISOLCPUS=
>> +TEST_ISOLCPUS=
>> +
>>   [[ -n "$BOOT_ISOLCPUS" ]] && {
>> +	FIRST_ISOLCPUS=$(echo $BOOT_ISOLCPUS | sed -e "s/[,-].*//")
>> +	[[ $FIRST_ISOLCPUS -le 8 ]] &&
>> +		skip_test "Boot-isolated CPUs ($BOOT_ISOLCPUS) overlap CPUs to be tested"
>> +	echo "Boot-isolated CPUs: $BOOT_ISOLCPUS"
>> +}
>> +
>> +[[ "$BOOT_ISOLCPUS" != "$CURRENT_ISOLCPUS" ]] && {
>>   	sleep 0.5
>> -	BOOT_ISOLCPUS=$(cat $CGROUP2/cpuset.cpus.isolated)
>> +	CURRENT_ISOLCPUS=$(cat $CGROUP2/cpuset.cpus.isolated)
>> +	[[ "$BOOT_ISOLCPUS" != "$CURRENT_ISOLCPUS" ]] &&
>> +		skip_test "Current isolated CPUs ($CURRENT_ISOLCPUS) don't match boot isolated CPUs!"
>>   }
>> -if [[ -n "$BOOT_ISOLCPUS" ]]
>> -then
>> -	[[ $(echo $BOOT_ISOLCPUS | sed -e "s/[,-].*//") -le 8 ]] &&
>> -		skip_test "Pre-isolated CPUs ($BOOT_ISOLCPUS) overlap CPUs to be tested"
>> -	echo "Pre-isolated CPUs: $BOOT_ISOLCPUS"
>> -fi
>>   
>>   cleanup()
>>   {
>> @@ -202,7 +213,7 @@ test_add_proc()
>>   #
>>   # ECPUs    - effective CPUs of cpusets
>>   # Pstate   - partition root state
>> -# ISOLCPUS - isolated CPUs (<icpus>[,<icpus2>])
>> +# ISOLCPUS - isolated CPUs (<icpus>[,<icpus2>] or .)
>>   #
>>   # Note that if there are 2 fields in ISOLCPUS, the first one is for
>>   # sched-debug matching which includes offline CPUs and single-CPU partitions
>> @@ -444,6 +455,35 @@ TEST_MATRIX=(
>>   	"   C0-3     .      .    C4-5   X3-5     .      .      .     1 A1:0-3|B1:4-5"
>>   )
>>   
>> +# Test matrix with boot time isolated CPUs present for housekeeping check testing
>> +ISOLCPUS_TEST_MATRIX=(
>> +	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>> +	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
>> +	# A local isolated partition containing boot isolated CPU cannot be
>> +	# switched to root partition.
>> +	" C1-2,I:P2  .      .      .      P1     .      .      .     0 A1:1-2,I A1:P-1 ."
>> +
>> +	# A remote isolated partition containing boot isolated CPU cannot be
>> +	# switched to root partition.
>> +	" X1-2,I CX1-2,I:P2 .      .       .    P1      .      .     0 A2:1-2,I A2:P-1 ."
>> +
>> +	# A local isolated partition with a boot isolated CPU distributed to a
>> +	# child isolated partition also cannot be switched to a root partition.
>> +	" C1-3,I:P2 C1,I:P2 .      .      P1     .      .      .     0 A1:1-3,I|A2:1,I A1:P-1|A2:P-2 ."
>> +
>> +	# A remote isolated partition with a boot isolated CPU distributed to a
>> +	# child isolated partition also cannot be switched to a root partition.
>> +	" X1-3,I C1-3,I:P2 C1,I:P2 .       .    P1      .      .     0 A2:1-3,I|A3:1,I A2:P-1|A3:P-2 ."
>> +
>> +	# The cpumask of a local root partition cannot be changed to include a
>> +	# boot isolated CPU.
>> +	" C1-2:P1    .      .      .     C2,I    .      .      .     0 A1:2,I A1:P-1 ."
>> +
>> +	# The cpumask of a remote root partition cannot be changed to include a
>> +	# boot isolated CPU.
>> +	" CX1-2,I  CX1-2:P1 .      .       .   CX2,I    .      .     0 A1:1-2,I|A2:2,I A2:P-1 ."
>> +)
> Could we add two invalid-root revival cases with an explicit exclusive
> mask here? For example:
>
>          # An invalid root must stay invalid when cpus grows but exclusive
>          # still contains a boot isolated CPU.
>          " CX1,I:P1        .  .  .  C1-2,I   .  .  .  0 A1:1-2,I A1:P-1 ."
>
>          # Growing exclusive must not revive it either.
>          " C1-2,I:X1,I:P1 .  .  .  X1-2,I   .  .  .  0 A1:1-2,I A1:P-1 ."
>
Sure, I can add these two test cases.

Cheers,
Longman

