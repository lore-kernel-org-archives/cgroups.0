Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC80F1DF980
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 02:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788229565; cv=none; b=GObXScKHK8MqqYKX/UI0noZUCvqNjykMWQPD7NC8e3VkwsvhVt6sy2HlRf4y57OAc22iF+rTC6g/oAGPX+scqaPd4v8NTywagS7u7nQg/ah34xTU8fXFc78u1jD2s82FXyP38UitHFq50Kl7y1y0HaVOA5vaM/ya89YGxk5bo5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788229565; c=relaxed/simple;
	bh=u5ZVkTKI9GV6qoCkeP2Hu/CRxAKLOcUItpeZND9q9Wk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AZvSe3TpWXG7pe6BAXsxDaxPSg7UimfNdIUTaGuMoooVcXWoQ2mo2lD0TBkFRiVex6BTgDNgipWyg6mDNzPv8x2fPTl7OTRwN9qkaOh9d6pZOOq7rWIEn3wnQfKariXxVw1/a2CW8ewPw1VAPfImBtR+7GOKgTqGEseUIQcwxvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xVUHGS+Z; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xVUHGS+Z"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Eb5hOj3kA5+fqUJLkLQCGL7nF4HETmtAbjDxGaGGuAI=;
	b=xVUHGS+ZV9j4lq4ogB53qomncbi+KcMxxMvlLw8S6B3e4t4/zbp+Nr27GKzm5t5qSV6B1M5EW
	ck6e3tW+ab4v+6GGVl9P8gqnxlTCuIK6l3klflTLjJYR3IsS2Ft2JZCRPAh3MGZ1eFjimfRlDq0
	0JD+K615jc21mRVKCI6ibTk=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hYqDx4fvmz12LF9;
	Tue,  1 Sep 2026 10:14:41 +0800 (CST)
Received: from dggpemf100017.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id AA75640561;
	Tue,  1 Sep 2026 10:25:58 +0800 (CST)
Received: from [10.67.111.186] (10.67.111.186) by
 dggpemf100017.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 1 Sep 2026 10:25:58 +0800
Message-ID: <9a6a4965-7ac7-d4e5-918d-4f1abb3dce9b@huawei.com>
Date: Tue, 1 Sep 2026 10:25:57 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [BUG] cgroup/cpuset: Concurrent WARN_ON_ONCE triggers during
 remote partition stress-test
To: Waiman Long <longman@redhat.com>
CC: <jifa@huawei.com>, Hui Tang <tanghui20@huawei.com>,
	<cgroups@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	<ridong.chen@linux.dev>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
References: <0a897510-8d80-2d8a-5b7b-800aea5f1d23@huawei.com>
 <6cb9d419-fc2d-410a-9362-527e2bd9b33b@redhat.com>
From: Zhang Qiao <zhangqiao22@huawei.com>
In-Reply-To: <6cb9d419-fc2d-410a-9362-527e2bd9b33b@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100017.china.huawei.com (7.185.36.74)



在 2026/8/31 22:18, Waiman Long 写道:
> On 8/31/26 5:05 AM, Zhang Qiao wrote:
>> Hi,
>>
>> While stress-testing cpuset partitions under KASAN (kernel 7.2-rc1,
>> dc59e4fea9d83 "Linux 7.2-rc1"), four distinct WARN_ON_ONCE() in
>> kernel/cgroup/cpuset.c fire within a ~1s window. They all concern the
>> remote partition / effective-cpumask invariants and are triggered by
>> concurrent CPU hotplug, cpuset.cpus/cpuset.cpus.exclusive/
>> cpuset.cpus.partition writes, task migration and (un)partitioning of
>> nested subgroups.
>>
>> Environment
>> -----------
>> - Kernel : Linux 7.2-rc1, generic KASAN enabled, x86_64, PREEMPT
>> - server   : Intel Xeon Platinum 8380 @ 2.30GHz, 2 NUMA nodes, 160 CPUs
>> - Cmdline: ... cgroup_disable=files apparmor=0    
>> systemd.unified_cgroup_hierarchy=1
>>
>> Reproduction
>> ------------
>> A pure-shell self-contained script (attached below) runs several concurrent
>> "disturbance" loops. The issue is extremely easy to reproduce; the script
>> consistently triggers the WARNs within seconds of execution.
>>
>>    - CPU hotplug toggle of a helper pool (CPU online/offline)
>>    - random writes to cpuset.cpus / cpuset.cpus.exclusive
>>      (single CPU, empty, or range)
>>    - random root <-> member switching of cpuset.cpus.partition
>>    - migrating burner tasks between subgroups via cgroup.procs
>>    - creating and removing nested sub-partitions under S0-S3
> 
> Thank for reporting the bug. It is recently known that there are bugs in the
> handling of nested sub-partitions. We are in the process of getting it fixed.
> 
> Cheers,
> Longman

Hi Waiman,

Thanks for the update!

I'm looking forward to the fix. Please CC me when the patch is ready, and I'll
be happy to test it on my end.

Thanks,
Zhang Qiao

> 
> 
> .
