Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7039B427F8F
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 09:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774502; cv=none; b=uskA8X0LBS6EXCrXfTJHkafqKQmiSfieo3lfg9x3SYi52aBglK5nV2rBmT44fq0LNnKFQgVlB7Jg411EI+6HKwzLnG7TZdE+23W8Vf+r7T3fA6JzEuPpIVGgh5TV6ie2nhXokWcABPqjXjjcpIjrsh096K82EGK+6AIvTC2VDlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774502; c=relaxed/simple;
	bh=SfCvDOt1m+OeT9sy0/9OG1/B26Xs/Ch2DcCWnVWF7Ns=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=CZUItYCs1J8tdN/4mYq09NNTwRpRwyXrvAhEqcnFkyy327YDKSlTwoXaofmch4HoAyDNXQR98Z7CiTatv13jrpE+6xxgmy21US9FzwmiXMBVIhGDycn8MPy2B+7pDN1zsiNWCn/se5VlfYe7ywWyoYA54jr6HeiSBhumid0C4sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pWShir7Z; arc=none smtp.client-ip=91.218.175.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pWShir7Z"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SfCvDOt1m+OeT9sy0/9OG1/B26Xs/Ch2DcCWnVWF7Ns=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788774498; v=1; x=1789379298;
 b=pWShir7ZItwJhoxRkTllROB/u34q2Lwafl3yV2WQe7rb0l3F7TXzDYMI4LZToypQYJUyQ1Oc
 zAzroZrx6wS+YQZzw8vVPLrzvPg59J38VBSmtErhj7WIwQsgkt50rZwkaKgv0VLBkwYFMN5g3NT
 NbiVmmOy6s+UUkPs+LuEaZ88=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 56f2a83ee2b9f73d;
	Mon, 07 Sep 2026 09:48:18 +0000
X-Mizu-Trace-ID: 56f2a83ee2b9f73d
X-Migadu-Flow: FLOW_OUT
Message-ID: <ff4122db-2ea4-4121-8d6a-022d492d2b4d@linux.dev>
Date: Mon, 7 Sep 2026 17:48:09 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Guopeng Zhang <guopeng.zhang@linux.dev>
Subject: Re: [PATCH v3 1/7] cgroup/cpuset: Factor out child partition
 validation
To: Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org,
 ridong.chen@linux.dev
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
 <20260902102615.79189-2-guopeng.zhang@linux.dev>
 <5842edcd-9283-4a87-afc9-50e51962368e@redhat.com>
Content-Language: en-US
In-Reply-To: <5842edcd-9283-4a87-afc9-50e51962368e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/4 02:33, Waiman Long 写道:
> On 9/2/26 6:26 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> compute_partition_effective_cpumask() checks whether each valid child
>> partition remains covered by the parent exclusive CPU mask and whether it
>> would consume all remaining CPUs of a populated parent.
>>
>> Factor these two checks into child_partition_error() so the same rules can
>> be reused when evaluating a proposed parent configuration. This is a
>> preparatory refactoring with no intended functional change.
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 38 +++++++++++++++++++++++++++++---------
>>   1 file changed, 29 insertions(+), 9 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 8f24171b6055..6994dc75d940 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2085,6 +2085,26 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>       return 0;
>>   }
>>   +/*
>> + * Return the error that will invalidate a child partition under a proposed
>> + * parent partition configuration.
>> + */
>> +static enum prs_errcode
>> +child_partition_error(struct cpuset *child,
>> +              const struct cpumask *partition_cpus,
>> +              const struct cpumask *remaining_cpus,
>> +              bool parent_populated)
> I think you should add some functional comments on what "partition_cpus" and "remaining_cpus" are supposed to be so that caller knows what to pass into this helper.

Thanks for the suggestion. I will add comments in the next version.

>> +{
>> +    if (!cpumask_subset(child->effective_xcpus, partition_cpus))
>> +        return PERR_INVCPUS;
>> +
>> +    if (parent_populated &&
>> +        cpumask_subset(remaining_cpus, child->effective_xcpus))
>> +        return PERR_NOCPUS;
>> +
>> +    return PERR_NONE;
>> +}
>> +
>>   /**
>>    * compute_partition_effective_cpumask - compute effective_cpus for partition
>>    * @cs: partition root cpuset
>> @@ -2121,6 +2141,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>>         rcu_read_lock();
>>       cpuset_for_each_child(child, css, cs) {
>> +        enum prs_errcode child_err;
>> +
>>           if (!is_partition_valid(child))
>>               continue;
>>   @@ -2129,15 +2151,13 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>>            * partition root.
>>            */
>>           WARN_ON_ONCE(is_remote_partition(child));
>> -        WRITE_ONCE(child->prs_err, 0);
>> -        if (!cpumask_subset(child->effective_xcpus,
>> -                    cs->effective_xcpus))
>> -            WRITE_ONCE(child->prs_err, PERR_INVCPUS);
>> -        else if (populated &&
>> -             cpumask_subset(new_ecpus, child->effective_xcpus))
>> -            WRITE_ONCE(child->prs_err, PERR_NOCPUS);
>> -
>> -        if (child->prs_err) {
>> +        WRITE_ONCE(child->prs_err, PERR_NONE);
>> +        child_err = child_partition_error(child, cs->effective_xcpus,
>> +                          new_ecpus, populated);
>> +        if (child_err)
>> +            WRITE_ONCE(child->prs_err, child_err);
>> +
> 
> You can ignore the inital PERR_NONE write and always write the child_err value into child->prs_err.
> 
> Not big issue, just some nits.
> 

Makes sense. I will update it.

Thanks,
Guopeng

