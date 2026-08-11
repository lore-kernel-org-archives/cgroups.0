Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAB539F174
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 03:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786418753; cv=none; b=DoASFsFg2paTGyQ/G8mqCW72mxLjzIEk66tSeuCf7EV+NqvX9pJX/Pd27/zdUMOoOz10fVWEhTV3OlNgKCUjvvkPX/9Yox57YJ5UFMuN/S8lRgudC4zZq/HE8+WbOg2Y0Mhl3PF6aZQUGiwFZWUy5jjJgHxYp2QWwv0TuwPTzzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786418753; c=relaxed/simple;
	bh=kECOHwHKQgh4B5VkySFLF0/IRGMolKmIBslP/P0gRqY=;
	h=Subject:Date:References:From:Mime-Version:Cc:In-Reply-To:
	 Content-Type:Message-Id:To; b=ukrc1QfnusEIMzLuSjxqEFONwOz2ccTl9CdzMuIpwRjysTwBp3daQR5reYTslKyu/TUTuejx5NfwBAwqql10RZBHaYHfugtNFigSLAPn2e6heMcy2/3sBEqJ3k4AL0cdqqzaoNbM5MSz7LwhjKo0Q17B9AmRKdiD7GgLp8U8JSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=N5sHtGGu; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="N5sHtGGu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786418741; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=qPR1rYC4fKK5DIdoWCF2oZpyWzNVREt+yryVJfl8CQQ=;
 b=N5sHtGGu+XQmLBoqlVJPvWbuH61PlNCcs9nL6KWe0W4Miy/oK3Yxipxyp8WbfodSTJFR7L
 fkZZ7C1gv/mZZ8HsHyBlYogxAPPIlPKDBIyw02F9QZU68BS1QoXWxiRjfbglGX0pvKIw2E
 i71IupOqi+N9YM0+rY5qeJVKRVSYuLQTQOchPEhuEZV8G6QBbkIwjXh6tXg0W3LT3uVA1e
 avS58TxwVGGLN+fAZJ2mNSPQj2Apk+7CZaeXTPpOkc92Jy97VexfVc3aMU3IqecYrBFS0J
 ABXbajf/ChJ+l2s3Ml0+pL1VgLaAOTXZidB/DYsMzapremPa0i5P4s8BoVDbGg==
Subject: Re: [PATCH 2/2] selftests/cgroup: Preserve CPU hotplug write errors
Date: Tue, 11 Aug 2026 11:25:22 +0800
References: <20260809082111.3827531-1-qirui.001@bytedance.com> <20260809082111.3827531-3-qirui.001@bytedance.com> <1ddd2e4a-ef12-4e9d-b589-28ddb4f46fb3@redhat.com>
From: "Rui Qi" <qirui.001@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Rui Qi <qirui.001@bytedance.com>
Cc: "Ridong Chen" <ridong.chen@linux.dev>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Shuah Khan" <shuah@kernel.org>, <cgroups@vger.kernel.org>, 
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Lms-Return-Path: <lba+26a7a9632+bd6603+vger.kernel.org+qirui.001@bytedance.com>
In-Reply-To: <1ddd2e4a-ef12-4e9d-b589-28ddb4f46fb3@redhat.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Message-Id: <45c558ac-8397-46a7-b3c9-755f272be685@bytedance.com>
Content-Transfer-Encoding: 7bit
To: "Waiman Long" <longman@redhat.com>, "Tejun Heo" <tj@kernel.org>

On 8/10/26 10:53 PM, Waiman Long wrote:
> On 8/9/26 4:21 AM, Rui Qi wrote:
>> The cpuset partition root state selftest checks several CPU hotplug
>> transitions. If writing to a CPU online file fails, the helper still
>> runs pause afterwards and returns the status of pause instead of the
>> failed write.
>>
>> This hides the real hotplug failure and can make later checks run
>> against expectations for a transition that never happened. Move the
>> write before the bookkeeping and return when it fails, so callers can
>> observe the hotplug error and the test does not record a CPU as offline
>> unless the offline operation actually succeeded.
>>
>> Fixes: a8c52eba880a ("kselftest/cgroup: Add cpuset v2 partition root state test")
>> Signed-off-by: Rui Qi <qirui.001@bytedance.com>
> 
> I am aware that on x86-64, cpu0/online may not exist. Other than that, 
> under what condition will the write fail as only root is allowed to run 
> the script?
> 
> Cheers,
> Longman

Hi Longman,

Right, the failure I wanted to preserve is not the normal permission
case. Running as root only gets us past the sysfs file permission check;
the write can still fail in the CPU hotplug path.

For example, cpu_down() can return -EBUSY when trying to offline the last
online CPU, when CPU hotplug is temporarily disabled, or when offlining
would leave no housekeeping CPU. cpu_up() can also fail if the CPU is not
possible/present, if hotplug is disabled, or if the CPU is not bootable
under the current SMT control state. Arch or registered cpuhp callbacks
may also reject the transition and return an error.

The current helper hides all of those cases because it does the write and
then calls pause(), so the function returns the status of pause rather
than the failed sysfs write. It also updates OFFLINE_CPUS before knowing
whether the offline request succeeded. So this change is mainly to avoid
continuing the test with bookkeeping that says a CPU was offlined when the
kernel actually rejected the hotplug operation.


Thanks,
Rui

> 
>> ---
>>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> index 16c38eb11e63..a2f7208633bc 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -412,6 +412,7 @@ write_cpu_online()
>>   	CPU=${1%=*}
>>   	VAL=${1#*=}
>>   	CPUFILE=//sys/devices/system/cpu/cpu${CPU}/online
>> +	echo $VAL > $CPUFILE || return 1
>>   	if [[ $VAL -eq 0 ]]
>>   	then
>>   		OFFLINE_CPUS="$OFFLINE_CPUS $CPU"
>> @@ -421,7 +422,6 @@ write_cpu_online()
>>   					sort | uniq -u)
>>   		}
>>   	fi
>> -	echo $VAL > $CPUFILE
>>   	pause 0.05
>>   }
>>   
>> @@ -493,6 +493,7 @@ set_ctrl_state()
>>   			eval $COMM $REDIRECT
>>   			;;
>>   		    O*) VAL=${CMD#?}
>> +			COMM="write_cpu_online $VAL"
>>   			write_cpu_online $VAL
>>   			;;
>>   		    T*) COMM="echo 0 > $TFILE"
