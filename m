Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.234
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794315766;
	b=bb6oTHRWKkb3OELv30fQ16f1GSO90Z/Bpgd2aX13ECWSvXCOgtV6eZvTxhpDF9J60B6C
	 EH87Bn0Ufv7jND+fFxsyToY/9FdtXXzg+gnQw+R+nY1m55GdRyO7uZ1QZrsFtmD07xsuT
	 Q3UlDi046lfblQRNHjx0bZPY1dYyeW47va1c2nUInei7WrEEvmNGvvttRCFnrS8gdIIn5
	 zqWL0ZfzGp0B4XR4zEioLLcoQ19cGGBw4dJ55a07GtDNwAwzTqI7nkaOQLP7KQYFkUE09
	 RoQGwjT6m8fPkQWORi0qlsf6QeASDYdDVBKdj97n5iWq1ZXIchfHe0dPxvyBMECFT1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794315766;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:Cc:References:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=fKChlBEsU0BxCgu+4U4m0i58+OuS3b4o6yf14XxYTIE=;
	b=4nJxf3FGu7Q2ijD2ZhhHQwYqDRaeePGKdOOKw8nmAWxHBqdLDjqEHhdwP3X16ZMsSn7g
	 oIRG5x1ENQT9tL2Tx8+16TalhLMaopTClzKUIby3S1YEtnW6Tqx20uu7khb3KPbcjAHCS
	 NYbKxuckKDf2ZMcrOWVL2C5vzYWZ+PBjejcqSb7sgJOa0EHmnxaD4sCjvwAKUQodGGMYb
	 yGBHSMvHDqPB9YsFmIVaOiCbgpkZCdWVjD9y9Wepbn7wyAByLi8stP4hcD5+1egA294i3
	 FpbOikXc3BU0OU+/Js6XA4o7B4Ev3T+11nHmyjxTf6vbgQQMRwBCSCFr6rpg7K5AjqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JEEUT+2q;
	arc=none smtp.remote-ip=95.215.58.234
Received: from mta1.migadu.com (out-234.mta1.migadu.com [95.215.58.234])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC97606BFE4
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 13:02:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AC97606BFE4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JEEUT+2q
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=h3CnaYUIR0Ew3TSmYVNV9po6Qt82ur42Pr7VtBnbcdc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794315762; v=1; x=1794920562;
 b=JEEUT+2qKaNDcbfg+z+dVDwiDTip56+0MmXLPW4RbGOnIzTE8nxAO7iTwP0SyW833T6JOBpR
 teFtNLGkhYrHInar9FMCIM1QJ7BgFg4Qlv9uTHqrxb3oBUmIPsn4o0b1riagC7w+oSDNpLsVLHC
 15nKPExQBrowE5MB+JKamNNc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a32e94bda5463846;
	Tue, 10 Nov 2026 13:02:42 +0000
X-Mizu-Trace-ID: a32e94bda5463846
X-Migadu-Flow: FLOW_OUT
Message-ID: <2e28d0a0-e0bc-422b-857c-226bcea62ffe@linux.dev>
Date: Tue, 10 Nov 2026 21:02:34 +0800
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
Subject: Re: [PATCH-next v2 5/5] cgroup/cpuset: Correctly set isolated_cpus
 when switching partition state
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20261109190955.1398611-1-longman@redhat.com>
 <20261109190955.1398611-6-longman@redhat.com>
 <aedd01b8-3f49-4916-b891-38e9c4ff3b06@linux.dev>
In-Reply-To: <aedd01b8-3f49-4916-b891-38e9c4ff3b06@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/10/2026 7:40 PM, Ridong Chen wrote:
> 
> 
> On 11/10/2026 3:09 AM, Waiman Long wrote:
>> When update_prstate() is called to switch the partition state from
>> root to isolated or vice versa, the whole effective_xcpus is passed to
>> isolated_cpus_update(). However, if there are child partitions present,
>> some of the effective_xcpus are dedicated to those child partitions
>> and their partition states will remain the same or get invalidated in
>> the case of child root partition with isolated parent in the latter
>> update_cpumasks_heir() call. In the latter case, their exclusive CPUs
> 
> update_cpumasks_heir

Sorry, it should be update_cpumasks_hier.

> 
>> will be returned to their parent.
>>
>> Therefore isolated_cpus may be set incorrectly with child partitions
>> underneath. Fix that by excluding their exclusive CPUs in computing
>> the correct cpumask of exclusive CPUs used by that partition alone.
>>
>> Add new test cases into test_cpuset_prs.sh to test for such cases.
>>
>> Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c                        | 30 +++++++++++++++----
>>   .../selftests/cgroup/test_cpuset_prs.sh       |  7 +++++
>>   2 files changed, 32 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 7aa614c6ac4d..41048997a955 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -3054,12 +3054,32 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>                             cs->effective_xcpus, NULL))
>>               err = PERR_HKEEPING;
>>           else if (parent_prs == PRS_ISOLATED)
>> -            err = PERR_ISOPARENT;
>> +            err = PERR_ISOPARENT;    /* old_prs should be isolated */
>> -        if (!err)
>> -            isolcpus_updated = true;
>> -        else
>> +        if (err) {
>>               disable_partition = true;
>> +        } else {
>> +            struct cgroup_subsys_state *css;
>> +            struct cpuset *child;
>> +
>> +            /*
>> +             * Need to scan child partitions, if present, and
>> +             * exclude their effective_xcpus from cs. In the case
>> +             * of switching to isolated partition with child root
>> +             * partitions, those child partitions will be
>> +             * invalidated in update_cpumasks_hier().
>> +             */
>> +            isolcpus_updated = true;
>> +            cpumask_copy(tmpmask.new_cpus, cs->effective_xcpus);
>> +            rcu_read_lock();
>> +            cpuset_for_each_child(child, css, cs) {
>> +                if (!is_partition_valid(child))
>> +                    continue;
>> +                cpumask_andnot(tmpmask.new_cpus, tmpmask.new_cpus,
>> +                           child->effective_xcpus);
>> +            }
>> +            rcu_read_unlock();
>> +        }
>>       } else {
>>           /*
>>            * Switching back to member is always allowed even if it
>> @@ -3093,7 +3113,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>       if (!is_partition_valid(cs))
>>           reset_partition_data(cs);
>>       else if (isolcpus_updated)
>> -        isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
>> +        isolated_cpus_update(old_prs, new_prs, tmpmask.new_cpus);
>>       spin_unlock_irq(&callback_lock);
>>       /* Force update if partition is disabled & update effective_xcpus */
>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/ 
>> testing/selftests/cgroup/test_cpuset_prs.sh
>> index 2d4744f2d6ac..741a13bbeda7 100755
>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>> @@ -556,6 +556,13 @@ TEST_MATRIX=(
>>       " C2-6:X2-5:P1 CX3-6:P2 \
>>                           .      .   T:X4-6    .      .      .     0 A1:4-6| 
>> A2:4-6 A1:P1|A2:P-2 ."
>> +    # Switch PRS state (root <=> isolated) will properly update 
>> cpuset.cpus.isolated
>> +    # even if child partitions are present.
>> +    " C1-6:P1 C3-6:P1 C5-6:P2  .       .    P2      .      .     0 
>> A1:1-2:A2:3-4:A3:5-6
>> +                                       A1:P1|A2:P2:A3:P2 3-6"
>> +    " C1-6:P1 C3-6:P2 C5-6:P2  .       .    P1      .      .     0 
>> A1:1-2:A2:3-4:A3:5-6
>> +                                       A1:P1|A2:P1:A3:P2 5-6"
>> +
>>       #
>>       #  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs 
>> Pstate ISOLCPUS
>>       #  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- 
>> ------ --------
> 
> We hit the same issue in our testing earlier (an isolated child partition
> loses its isolation when the parent is switched from isolated to root),
> and this is the same fix I had in mind. I also ran a few 3-level nested
> cases (root/isolated combinations, switching the parent and the middle
> level) on top of this series and cpuset.cpus.isolated is correct in all
> of them.
> 
> Nits: The first line of the two new test cases lacks
> the trailing "\" used by the other multi-line entries. It still works
> as the newline is just treated as a field separator, though.
> 
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Tested-by: Ridong Chen <ridong.chen@linux.dev>
> 

-- 
Best regards
Ridong

