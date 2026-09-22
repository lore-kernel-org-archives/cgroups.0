Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7249437130
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 09:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068303; cv=none; b=JjrP/EAfjB7/8XYl+a/cKGx4byiSJj70XF9CE14ZL4MW1/2tqmNCekWBJXuBaCk4nDnUsTt6sf+ClkFgrAs1gqtx/uWZosiaba6aFy3UX9XoRWFfz+pknni/YO7w+DcXtngcH3F4d3fPdjm+MMZZRHcQtf1nKF7gqHl+nU4/jMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068303; c=relaxed/simple;
	bh=J6YClhL09U96Pnf/dUgZ0SMNmNLWiuOji0oJGF3hLrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRaePImQYmp+5qt0+WpH6fyzDbj5wYfVS6DLTcuwfk84D28Loh2qo7E3+Ouplb8KowxLjnqRgUxXN6/3EDqoD7C880ladD7pmuvctjx3OOszInxU2J7IQjo+0uuLSQz3oDQH37pfInvNGs8I6SNM0JcBB29lwsZYUTERKA3cv1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q7lfbXkr; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q7lfbXkr"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=J6YClhL09U96Pnf/dUgZ0SMNmNLWiuOji0oJGF3hLrI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790068299; v=1; x=1790673099;
 b=Q7lfbXkrQV5QUoS39paLXroPUQUMlk9KsDcDQnci98esdy6KOv22r83wLEQoM5wPZOx/1oEl
 14x7ubFg35kw944ku6zpGFBJJNxDVSVZVXvKxyc5GZP4PgQJh2m+9Jpm9PtqA3U0NP4WUpYL/Iw
 KEOnlRofCiSxK5jUiY/OoTS4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2d28f15bda6b7b45;
	Tue, 22 Sep 2026 09:11:29 +0000
X-Mizu-Trace-ID: 2d28f15bda6b7b45
X-Migadu-Flow: FLOW_OUT
Message-ID: <19cb10f4-66c2-443f-aa11-6f43c0233b92@linux.dev>
Date: Tue, 22 Sep 2026 17:11:15 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] docs: cgroup-v2: Describe effective CPUs of
 partition roots
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260922032130.33777-1-guopeng.zhang@linux.dev>
 <20260922032130.33777-3-guopeng.zhang@linux.dev>
 <4c5c4ec8-ef44-47d7-99b5-355b5ffdfcf9@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <4c5c4ec8-ef44-47d7-99b5-355b5ffdfcf9@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/22 14:36, Ridong Chen 写道:
> 
> 
> On 9/22/2026 11:21 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> The cpuset.cpus.effective description says that the effective CPUs are
>> granted by the parent and are normally a subset of cpuset.cpus. This
>> does not always hold for a valid non-root partition root. Its effective
>> CPUs are the active CPUs in cpuset.cpus.exclusive.effective after CPUs
>> assigned to valid child partition roots are removed.
>>
>> If cpuset.cpus.exclusive differs from cpuset.cpus, the effective CPUs
>> may therefore be outside cpuset.cpus. Remote partitions also do not
>> necessarily get their CPUs from their immediate parent.
>>
>> Suggested-by: Ridong Chen <ridong.chen@linux.dev>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst | 56 ++++++++++++++++++++-----
>>   1 file changed, 46 insertions(+), 10 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 18a01ce4c334..d21bbae3312a 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -2505,16 +2505,52 @@ Cpuset Interface Files
>>       A read-only multiple values file which exists on all
>>       cpuset-enabled cgroups.
>>   -    It lists the onlined CPUs that are actually granted to this
>> -    cgroup by its parent.  These CPUs are allowed to be used by
>> -    tasks within the current cgroup.
>> -
>> -    If "cpuset.cpus" is empty, the "cpuset.cpus.effective" file shows
>> -    all the CPUs from the parent cgroup that can be available to
>> -    be used by this cgroup.  Otherwise, it should be a subset of
>> -    "cpuset.cpus" unless none of the CPUs listed in "cpuset.cpus"
>> -    can be granted.  In this case, it will be treated just like an
>> -    empty "cpuset.cpus".
>> +    It lists the active CPUs available to tasks in this cgroup.
>> +
>> +    For a cgroup that is not a valid partition root, an empty
>> +    "cpuset.cpus" makes "cpuset.cpus.effective" show all CPUs
>> +    available from the parent cgroup. Otherwise, it is a subset
>> +    of "cpuset.cpus" unless none of the requested CPUs can be
>> +    granted. In that case, it is treated like an empty
>> +    "cpuset.cpus".
>> +
>> +    For example::
>> +
>> +      P (cpuset.cpus.effective=0-3)
>> +      |
>> +      +-- C0 (member):       cpuset.cpus=1-2
>> +      |                      cpuset.cpus.effective=1-2
>> +      +-- C1 (invalid root): cpuset.cpus=4-5
>> +      |                      cpuset.cpus.effective=0-3
>> +      \-- C2 (member):       cpuset.cpus=<empty>
>> +                             cpuset.cpus.effective=0-3
>> +
> 
> That is clear. Thanks.
> 
>> +    C0 gets CPUs 1-2 because they are available from P.
>> +    None of C1's requested CPUs 4-5 are available from P, so C1 uses P's
>> +    effective CPUs 0-3 instead.
>> +    C2 has an empty "cpuset.cpus" and therefore also uses P's effective
>> +    CPUs 0-3.
>> +
>> +    For a valid non-root partition root, "cpuset.cpus.effective" contains
>> +    the active CPUs from "cpuset.cpus.exclusive.effective" except
>> +    those granted to valid child partition roots. If
>> +    "cpuset.cpus.exclusive" is set to a value different from
>> +    "cpuset.cpus", the effective CPUs need not be a subset of
>> +    "cpuset.cpus".
>> +
>> +    For example, if CPUs 2-5 are active, available, and not assigned
>> +    to a valid child partition root::
>> +
>> +      top (root)
>> +      |
>> +      \-- P (valid partition root)
>> +          cpuset.cpus=0-3
>> +          cpuset.cpus.exclusive=2-5
>> +          cpuset.cpus.exclusive.effective=2-5
>> +          cpuset.cpus.effective=2-5
>> +
>> +    P has 2-5 in "cpuset.cpus.effective" even though its
>> +    "cpuset.cpus" is 0-3.
>>         Its value will be affected by CPU hotplug events.
>>   
> 
> I would suggest offering an example where "cpuset.cpus.effective" differs from "cpuset.cpus.exclusive.effective", meaning that "cpuset.cpus.exclusive.effective" contains offline CPUs. This would make it much clearer that "cpuset.cpus.effective" does not contain offline CPUs.
> 
> With that, feel free to add:
> 
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> 
Thanks for the suggestion. I'll update the example in v3 to cover the offline CPU case and add your Reviewed-by.

Thanks,
Guopeng
