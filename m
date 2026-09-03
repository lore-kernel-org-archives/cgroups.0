Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9488185B48
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 01:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788400536; cv=none; b=J0b5CpA17KCRiC+9uTIxHSfsGO+FAuCKi6rM91boyQsqoQePYFBDJgT/bcVgF1WKYmPlewfKRMUhBC48LVAxp/P2XKMh231szHQVy3OVvtd1xWL7vNdZCBb6Ak+hUpVmVJ6C3u3AvAFXA3R9skiONRHv1W83cZJ6umZeHdiMMmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788400536; c=relaxed/simple;
	bh=u95HTJEg7cNpFs+sWFGUlBGCht8uh3N7jcGtlUx/htQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cdpaNwuBJrPbIaB+dY9z45cj72ZX1oFM4JDoy1S/GToRaDvrblzkwMSRmtOa7xU0Ff7DyaY/rDKRymRanyrfherYwHdoXLxCFry8Amgu7VOLudG4itojfdBa5wZtgtlRid2wk/766+kML+nxlxAByI54stMUb26QNsBTT/eG150=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v1pRj5hG; arc=none smtp.client-ip=95.215.58.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v1pRj5hG"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=u95HTJEg7cNpFs+sWFGUlBGCht8uh3N7jcGtlUx/htQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788400531; v=1; x=1789005331;
 b=v1pRj5hG932pY5tz2l8QSpN7XLRsTwtWrMMlkzoVttph4Db0sm4XClzfidcTV41x00wDv3cW
 IAIAK/a5lad4x+ObMe8s75er+ww5Viy/4xQuJ+ZtYzYJYevSmY5Wk8iDGWmZ5hoPZC8/m6Zor4z
 2+zymhjWafDwOZ6pmeOl76Bw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 45bc6b26ca2cf69e;
	Thu, 03 Sep 2026 01:55:30 +0000
X-Mizu-Trace-ID: 45bc6b26ca2cf69e
X-Migadu-Flow: FLOW_OUT
Message-ID: <12386c03-e7a1-4d7f-b829-1402d74a11fe@linux.dev>
Date: Thu, 3 Sep 2026 09:55:23 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] cgroup/cpuset: Respect child CPU ownership in type
 changes
To: Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org,
 ridong.chen@linux.dev
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260828095643.13395-1-guopeng.zhang@linux.dev>
 <20260828095643.13395-2-guopeng.zhang@linux.dev>
 <3c6f43e3-ca8f-4525-a147-68c35d856d35@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <3c6f43e3-ca8f-4525-a147-68c35d856d35@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/31 23:37, Waiman Long 写道:
> On 8/28/26 5:56 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> effective_xcpus includes CPUs granted to valid child partitions. Changing
>> a parent between root and isolated must not apply its new isolation state
>> or housekeeping constraints to those CPUs.

...

>>   +/*
>> + * Invalidate the highest isolated partition that contains @cs.
>> + *
>> + * A root partition returning CPUs to an isolated parent can consume the last
>> + * housekeeping CPU. Invalidating the whole chain returns the CPUs to a root
>> + * partition instead.
>> + */
>> +static struct cpuset *invalidate_isolated_ancestor(struct cpuset *cs,
>> +                           struct tmpmasks *tmp)
>> +{
>> +    struct cpuset *ancestor = parent_cs(cs);
>> +    int err;
>> +
>> +    lockdep_assert_held(&cpuset_mutex);
>> +    while (!is_remote_partition(ancestor) &&
>> +           (parent_cs(ancestor)->partition_root_state == PRS_ISOLATED))
>> +        ancestor = parent_cs(ancestor);
> That can be dangerous & may cause NULL pointer dereference. parent_cs(cs) returns NULL if cs is top_cpuset. So you should always check if ancestor is NULL or parent_cs(ancestor) is NULL. Assuming that the given cs is never the top_cpuset so the initial ancestor will not be NULL. Each ancestor reassignment can become NULL. So don't mix ancestor and parent_cs(ancestor) testing in the same compound if statement.
>> +

...
>> @@ -2998,6 +3061,13 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>            * Switching back to member is always allowed even if it
>>            * disables child partitions.
>>            */
>> +        if (old_prs == PRS_ROOT &&
>> +            parent->partition_root_state == PRS_ISOLATED &&
>> +            !isolated_cpus_can_update(cs->effective_xcpus, NULL))
>> +            invalidated = invalidate_isolated_ancestor(cs, &tmpmask);
>> +        if (invalidated)
>> +            goto out;
>> +
> You are adding a new exception here. You should update the comment above to talk about the exception.
>>           if (is_remote_partition(cs))
>>               remote_partition_disable(cs, &tmpmask);
>>           else
>> @@ -3025,11 +3095,17 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>       if (!is_partition_valid(cs))
>>           reset_partition_data(cs);
>>       else if (isolcpus_updated)
>> -        isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
>> +        isolated_cpus_update(old_prs, new_prs, tmpmask.new_cpus);
> As I have mentioned in my comment to your v1 series, this code can be reached from multiple places beside switching from root to isolated and vice versa. So tmpmask.new_cpus may not be the "owned xcpus". So additional guard should be needed to decide if effective_xcpus or tmpmask.new_cpus should be used.
>>       spin_unlock_irq(&callback_lock);

Hi Longman,

Thanks for the review.

I have addressed your comments in v3:

- rewrote the isolated-ancestor walk so that it stops safely before
  dereferencing the parent of the top cpuset;
- expanded the member-transition comment to describe the housekeeping
  exception;
- kept cs->effective_xcpus as the default isolation-accounting mask.
  The mask pointer is changed to the directly owned CPU mask only after
  that mask has been computed and validation has succeeded for a
  root-to-isolated or isolated-to-root transition.

I also reworked the trial ownership calculation after additional
feedback from Sashiko.

For example, suppose the kernel is booted with:

    isolcpus=domain,15

and the hierarchy is:

    parent root partition:    cpuset.cpus=13-15
    child isolated partition: cpuset.cpus=14-15

The parent directly owns only CPU13, while CPUs 14-15 are owned by the
child.

If the parent's CPU mask is then changed to CPU15, the child is still a
valid partition when validate_partition() examines the trial
configuration. The previous code therefore subtracts the child's current
effective_xcpus from the proposed parent mask. This removes CPU15 and
leaves the parent's trial owned mask empty, so CPU15 is not included in
the parent's housekeeping check.

After the new parent mask is applied, however, the child's {14,15} mask
is no longer a subset of the parent's {15} mask. The child is invalidated
with PERR_INVCPUS and CPU15 returns to the parent. The result is a valid
root partition directly owning a boot-isolated CPU which was hidden from
its housekeeping validation.

In v3, trial ownership no longer depends only on whether a child is
currently valid. It uses the common child-partition validation rules to
predict whether each child will remain valid under the proposed parent
mask. CPUs are subtracted from the parent's trial owned mask only for
children which will remain valid. This handles both PERR_INVCPUS and
PERR_NOCPUS consistently.

v3:
https://lore.kernel.org/all/20260902102615.79189-1-guopeng.zhang@linux.dev/

Thanks,
Guopeng


