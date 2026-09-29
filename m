Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5860C46D09E
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 03:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790651791; cv=none; b=oFFD5h2EAnNyCpISYh4nzj9mrFxHdxga225d6biyvHhsRvysAowVLXmzE1aY11xGwkf0pQhAJI1NRQV9F+9QhmKOd0HDM3fG+apCO2pwbUvlAc8HiUgCvwJLNQGwO0ZzGKYNXmESeAmGw9UW7/sUiCbqYtvPlaWOHHEFuFMnw2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790651791; c=relaxed/simple;
	bh=NQUWQekraRK2R+oQCbO6bqaq/zm+kPTsDnaShbnYVKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UnQHVkcQKJWAf9/ocze1BR4EXWQXyL2MZoDCljeB9qEjnpVeFyMUQtio2PiNr4sOB4nRyBatmKBiuukkGB02UYuTC4FfJKyZ2T4EY1CWQ9gkZmew+0vvbqPQwAK4trts0PN/XmfX3vlrVgzVR1c2gWf9uICvxPS4tvJ0w0WEHLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQ0qnyjV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQ0qnyjV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790651778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1bJx4NmG9aDPkafQVKf9yGMg66Bh8HADH48d93MDLfk=;
	b=IQ0qnyjVMFXHphVXzkkARgkizvxtq46hAwv5xYTjOAVvPd3SeVIcCtHat+bbknP/by3LoB
	NaupcULV1rIYbRn+bJx1RMof6y7B0Mum8BOj87Ct8vz1N2+ixLAg1Ac5Zrx8Ywnc1Y14uY
	xY6PlU7RvHqyow6l3GIBn0MCUI484dc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-Ti8NtgbCPsuFN5HK_C_xKA-1; Mon,
 28 Sep 2026 23:16:12 -0400
X-MC-Unique: Ti8NtgbCPsuFN5HK_C_xKA-1
X-Mimecast-MFC-AGG-ID: Ti8NtgbCPsuFN5HK_C_xKA_1790651771
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 484E81840C74;
	Tue, 29 Sep 2026 03:16:10 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 857541956045;
	Tue, 29 Sep 2026 03:16:08 +0000 (UTC)
Message-ID: <07403332-9fc3-41cf-ba2c-63a1f83a231c@redhat.com>
Date: Mon, 28 Sep 2026 23:16:07 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Properly disable partition when partition
 state switching fails
To: Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Hui Peng <benquike@gmail.com>, Guopeng Zhang <guopeng.zhang@linux.dev>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260928235159.515654-1-longman@redhat.com>
 <941e5affde16b803741ddaf87b937f3d@kernel.org>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <941e5affde16b803741ddaf87b937f3d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 9/28/26 10:07 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> The following is a Claude-generated review.
>
> On Mon, Sep 28, 2026 at 07:51:59PM -0400, Waiman Long wrote:
>> Before commit 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full
>> don't leave any housekeeping"), the partition state can be freely switched
>> from "root" to "isolated" and vice versa. After that commit, the switch
>> from "root" to "isolated" can fail if it exhausts all the housekeeping
>> CPUs. Later on, the switch from "isolated" to "root" can also fail if
>> some of the partition CPUs are boot-time isolated by "isolcpus".
> The isolated -> root failure came from b1034a690129 ("cgroup/cpuset:
> Ensure domain isolated CPUs stay in root or isolated partition"). Maybe
> add a Fixes: tag for it too?

Commit b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in 
root or isolated partition") comes after 103b08709e8a. From my point of 
view, the first commit is the one that introduces the bug. The second 
commit comes along assuming the existing code is right. That is why I 
didn't tag the second one even though the second one is easier to 
trigger than the first one.

>> The partition is made invalid when the switch fails. However, the
>> remote_partition flag for a remote partition can remain set and the CPUs
>> from the invalidated partition aren't cleared from subpartitions_cpus.
>> Fix this by properly disable the partition in this case.
> The reproducer below is a local partition and the fix covers that case
> too. The CPUs weren't given back to the parent, which is what leaves them
> in subpartitions_cpus and isolated_cpus in the example. Maybe describe
> both? Also, "properly disable" -> "disabling".
OK, will update the commit log.
>
>> In the case of remote_partition flag, it should be cleared for a
>> invalidated remote partition. To be safe, the reset_partition_data() is
>> now enhanced to always clear the remote_partition flag. So there is no
>> need to explicitly clear remote_partition in remote_partition_disable().
> After the update_prstate() change, every path that invalidates a remote
> partition goes through remote_partition_disable(), so the other
> reset_partition_data() callers never see the flag set. If one did,
> clearing only the flag would leave its CPUs in subpartitions_cpus and turn
> the WARN_ON_ONCE() in partition_xcpus_del() into a silent leak. Maybe drop
> this part?
Yes, I can drop this part.
>> On a x86 test system with boot option "isolcpus=10 cgroup_debug" set
>> and more than 16 cores, the following commands was executed after boot.
> "a x86" -> "an x86", "commands was" -> "commands were".
>
>> @@ -2946,27 +2947,32 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>   		 */
>>   		if (((new_prs == PRS_ISOLATED) &&
>>   		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
>> -		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
>> +		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus)) {
>>   			err = PERR_HKEEPING;
>> -		else
>> +			disable_partition = true;
> If a root -> isolated switch fails isolated_cpus_can_update() under an
> isolated parent, partcmd_disable hands the CPUs back to the parent and
> partition_xcpus_del() adds them to isolated_cpus, which is the state the
> check just rejected. Switching to member ends up in the same place, so
> this may be fine as is.
If the parent is a valid isolated partition before the child partition 
is created, it had passed the isolated_cpus_can_update() check. So 
returning the CPUs back to its parent is fine.
>
>> +	}
>> +out:
>> +	if (disable_partition) {
> The early goto out paths never need the disable. Maybe put this block
> before out: instead?
Yes, that made sense though the current placement should cause any problem.
>
> Also, update_cpumasks_hier() below gets force only when switching to
> member, to update effective_xcpus. Now that the failure path disables the
> partition too, should it pass disable_partition?
Yes, it should.
>
> Separately, a partition invalidated with PERR_HKEEPING can become valid
> again through partcmd_update without newmask (hotplug, or
> update_cpumasks_hier() from an ancestor), which doesn't check
> housekeeping. A failed member -> root enable has the same problem, so it
> isn't from this patch.

I need to take a further look at that.

Cheers,
Longman

>
> Thanks.
>
> --
> tejun

