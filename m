Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720408;
	b=Q9wr3fAPB64gEMzAPviOpO//wjdtYjhz2JAd8Qi/f1w5yp4h58N0wS6D5zV9QGqESEeI
	 LEV1iGgb6UgsDGstSKUiZv7kuLmuwsXQ0pK4xcBpeqyTptIiyVFuXeXXH5hzNHJu8rekR
	 8pjqyj6U9ZxoifcVUL62wAK7LuegCp7vtnfBNy/5hy0cQeBUPnajvdrBD9SpzAsKl8CtY
	 vJdH8YXPK4dqNtkKmkcRM6Gj8GJ7DUsJ8XOO5s8jsKosx8SBBQlgo37HVPcUslKDxPYR1
	 3Ue1RR7n7W6NE7E3Af+S0NZpjjv3JsCw3MrtbNUpoKm4m6iLaESqMZryf4S4/Fh1apg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720408;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=D07eyQXW6CyfYGV/GLKHH76F8XoU44KN7tbJsOmA9ec=;
	b=wkTUIfd9X3sL9FPAfSoVnDANaR22E07EFrKpgNBdU38gUcdIIgLxpuM3IyGaZVanzNKV
	 B8Y1ds6dZoCa52NZyy0/GVu5XsPu7dMPEA/KKIJ/SJ/zxcGHqVWuoNbJyy1+BGeE1k3Y9
	 DfNDldOQyCsAIMaNvhFoAVReh6ekBy9wAf0jQilMez3MP3xNwfukZPaNo8xQ6C5oiMP8r
	 FZwGNi816p7qHIcJRSG/0U0Zs6G6sDKV8YyOcnydMhkb8/uAonDm7rs7LknWuLZKGE8aw
	 Ku69z9Dr8HH4EDrJIpzQmOeEV5+RUlUThXeE7SaKHDbz9e/DY6nKMsJdYO0eZdy9VTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SB7DLNbz;
	arc=none smtp.remote-ip=91.218.175.149
Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C040606A32F
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 01:53:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C040606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SB7DLNbz
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ERNQcTMDaUHOgt1ezW5NchEKQ3p5W3gtHeKeBSygDso=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792720404; v=1; x=1793325204;
 b=SB7DLNbzQGdY6heJepkyIeeaXYgjdxfnMhQ33jYud6x20z0l0qP1fqURSHHlcwF9F0exzarz
 OAXwWqwglOXHhfXHW0ewCg8iV6DmZaPoHADNjnYRN4RZhC8tS4TY8Ht8hPy3FYU5gi6zavnaHvL
 Sdhc11rX+DrJ4Pxo/OZtbUVc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cd14fa31b589aab4;
	Fri, 23 Oct 2026 01:53:24 +0000
X-Mizu-Trace-ID: cd14fa31b589aab4
X-Migadu-Flow: FLOW_OUT
Message-ID: <776306f8-2200-486b-8c43-2b5fd9b5eeb5@linux.dev>
Date: Fri, 23 Oct 2026 09:53:20 +0800
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
Subject: Re: [PATCH-next 2/6] cgroup/cpuset: Properly compute effective xcpus
 in update_parent_effective_cpumask()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261022031643.1351877-1-longman@redhat.com>
 <20261022031643.1351877-3-longman@redhat.com>
 <c65208d9-aba6-4e9a-affa-4f7cd8794a0c@linux.dev>
 <a3caf0f6-da89-4b5c-b80f-3baf6c82a2c4@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <a3caf0f6-da89-4b5c-b80f-3baf6c82a2c4@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/22 23:00, Waiman Long 写道:
> 
> On 10/22/26 9:45 AM, Guopeng Zhang wrote:
>> Hi Longman,
>>
>> 在 2026/10/22 11:16, Waiman Long 写道:
>>> Since the introduction of cpuset.cpus.exclusive in commit
>>> e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2"), a
>>> compute_effective_exclusive_cpumask() helper which is later renamed to
>>> compute_excpus() is added to compute the effective xcpus of a partition
>>> root. However update_parent_effective_cpumask() is not updated in all
>>> proper places to use the new helper to check if a given cpuset should
>>> remain a valid partition root. This can cause a cpuset to incorrectly
>>> remain a valid partition root even if no effective xcpus is left.
>>>
>>> Fix that problem by using compute_excpus() to compute the effective xcpus
>>> into delmask in all cases except partcmd_disable and partcmd_invalidate
>>> and use it for tasks_nocpu_error() check as well as checking its
>>> emptiness. This enables us to catch invalid partition root more
>>> accurately in update_parent_effective_cpumask().
>>>
>> I re-tested the repro from the link below on top of this series
>> (applied on cgroup/for-7.4-fixes), and it still fails:
>>
>>    https://lore.kernel.org/all/20261010075947.333549-3-guopeng.zhang@linux.dev/
>>
>>    cd /sys/fs/cgroup
>>    echo +cpuset > cgroup.subtree_control
>>    mkdir A
>>    echo 0-7 > A/cpuset.cpus
>>    echo 0-7 > A/cpuset.cpus.exclusive
>>    echo root > A/cpuset.cpus.partition
>>    cat A/cpuset.cpus.partition
>>    echo 1 > A/cpuset.cpus.exclusive
>>    cat A/cpuset.cpus.partition
>>
>> The last command still shows "root invalid (Parent unable to distribute
>> cpu downstream)".
>>
>> In this case compute_excpus() returns the stale user mask unchanged.
>> user_xcpus() is gone from update_parent_effective_cpumask(), but the
>> dependency just moved one level down: the new code calls
>> compute_excpus(cs, tmp->delmask), and its first line is
>>
>>    cpumask_and(excpus, user_xcpus(cs), parent->effective_xcpus)
>>
>> Here user_xcpus(cs) is cs->exclusive_cpus, which still holds the old
>> 0-7 when compute_excpus() runs: update_exclusive_cpumask() publishes
>> cs->exclusive_cpus only after partition_cpus_change(). Nothing corrects
>> it either - the sibling trim is skipped as exclusive_cpus is non-empty,
>> and for a direct child of the root cpuset the intersection with
>> parent->effective_xcpus is a no-op. So the stale 0-7 mask still reaches
>> tasks_nocpu_error() and PERR_NOCPUS is set again. Please point it out
>> if I got the analysis wrong.
>>
>> I have rebased my fix on top of this series and the partition recovers
>> correctly with it applied. Should the fix be folded into this patch,
>> or is there a better way to fix it? Happy to hear your thoughts.
> 
> You are right. My patch series won't fix this particular issue. However, converting an invalid partition back to a valid one is done on a best effort basis. There is no guarantee that it will always happen. Just echo "root" to "cpuset.cpus.partition" again will make it valid again. So it is not a real bug from my point of view. It is just a nice to have feature.
> 
Thanks for the explanation. This helps me better understand the
intended behavior of partition recovery.

Thanks,
Guopeng
