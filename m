Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F165616D0
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 22:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791931434; cv=none; b=QqX0nw1hmGygXXqRUhR/TcdNrsQTXxZGKavlACpXyB8nOjBY8h2tHGr9IkNFm2k/noU77RcVbW3c9iNK5flhsgazQvdzi5xBkttNwsvNAVQKONIxrXyM6FfO/v12pC9HZhgIogww6ly7bJFfCYE1dd1YJ15ch3YJb881ZMvZv4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791931434; c=relaxed/simple;
	bh=IGuvyB5PbhIzeePVFzAtrlhGsL24P9yuKC8V+/pp3+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmWAxyoQsHVG9e42sGo43oUr2KALRoR2slhIvxzmdblvLMtwOLFoFMe0+HV0nuLaIzwrbBa9a02nAwSilTpdwWrqiRjo2pSMdorx75Hlb4+RI6TMI3YJDQaMWFlhyCenBqxzBcsQe4753mEjGNAZsPSp0YqlHb4I1WKyvZjRzZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VRNpuYE2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VRNpuYE2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791931431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tTgDO4Q2/ydtZMP24HXgy3ERsMnbYlaCJjw/o3smb7I=;
	b=VRNpuYE2Iaioq5Avo43tfGcyPXrcr+jn3DKAJ9omhdVB9+jN1jAFAFgLo49do6HMn1PsY0
	AxBBmAl591G3p+FQczCqvQ6gDeV7b8OO0sqPLAolpllWyN/sSboIoPAQDi/+hreK8uianX
	404tJAHQsK+TqMMFsUW+rwaFysfm+Hs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-8UUp0W2wPiGbeECf08Uxow-1; Tue,
 13 Oct 2026 22:43:44 +0000
X-MC-Unique: 8UUp0W2wPiGbeECf08Uxow-1
X-Mimecast-MFC-AGG-ID: 8UUp0W2wPiGbeECf08Uxow_1791931421
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 404061956077;
	Tue, 13 Oct 2026 22:43:41 +0000 (UTC)
Received: from [100.91.18.181] (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 314881800345;
	Tue, 13 Oct 2026 22:43:38 +0000 (UTC)
Message-ID: <4dbdc6ab-7c3a-4c8b-ba88-f5089f2b619b@redhat.com>
Date: Tue, 13 Oct 2026 18:43:38 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 6/6] selftests/cgroup: Skip test_cpuset_prs.sh
 test if some required CPUs are offline
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>
References: <20261010221938.243859-1-longman@redhat.com>
 <20261010221938.243859-7-longman@redhat.com>
 <27675c88-061c-4f84-9387-324071a16b45@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <27675c88-061c-4f84-9387-324071a16b45@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


On 10/11/26 5:00 AM, Guopeng Zhang wrote:
>
> 在 2026/10/11 06:19, Waiman Long 写道:
>> The test_cpuset_prs.sh test assumes that all the relevant CPUs being
>> tested are online. If some of them are offline, some of the test cases
>> may fail. So skip the test if the required CPUs are either offline or
>> not present.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   .../selftests/cgroup/test_cpuset_prs.sh       | 20 +++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> index 3d392e8c66aa..f57971ebb90e 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -118,6 +118,26 @@ TEST_ISOLCPUS=
>>   		skip_test "Current isolated CPUs ($CURRENT_ISOLCPUS) don't match boot isolated CPUs!"
>>   }
>>   
>> +#
>> +# This test assumes that all the relevant CPUs being tested are online.
>> +# If some of them are offline, some of the tests may fail. So we are going to
>> +# skip running this test script if some of the required CPUs may be offline.
>> +# The required CPUs include CPUs 0-7 and the first boot time isolated CPU if
>> +# present. However the check below is not exhaustive and can be a false
>> +# positive, but users should not run this test if some CPUs are offline.
>> +#
>> +ONLINE_CPUS=$(cat /sys/devices/system/cpu/online | sed -e "s/,.*//")
>> +ONLINE_FIRST=$(echo $ONLINE_CPUS | sed -e "s/-.*//")
>> +ONLINE_LAST=$(echo $ONLINE_CPUS | sed -e "s/.*-//")
>> +if [[ -n "$FIRST_ISOLCPUS" ]]
>> +then
>> +	LAST_REQUIRED_CPU=$FIRST_ISOLCPUS
>> +else
>> +	LAST_REQUIRED_CPU=7
>> +fi
>> +[[ $ONLINE_FIRST != 0 || $ONLINE_LAST -lt $LAST_REQUIRED_CPU ]] &&
>> +	skip_test "Some of the required CPUs are offline or not present!"
>> +
> Could this check run before the setup that creates the test cgroup and
> changes sched/verbose?
>
> skip_test() exits directly, and the cleanup trap hasn't been installed
> here. We have already created test; with -v, sched/verbose has also been
> set to Y. This exit leaves the cgroup behind and bypasses restoring
> verbose.

Good point. I am going to move the trap statement earlier to make sure 
that it will be run when there is an early abort.

Cheers,
Longman

