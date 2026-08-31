Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D0E49B20E
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 14:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185919; cv=none; b=VhqGKa05CsbbuASi+xHnGlq8Dm9iuc5PZ9AvIT52sXTA/RCWDs767mj3FGxy7sqW7egxLiuiLXMTPovC2IvvjgznbTkxNP9RudeIjkF1yyBQLYO7i9L4ERoNoAoO17fr3yJmx5tJCHTZxS/wFJi58gEbpctx5ptG7WMDhLRvh1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185919; c=relaxed/simple;
	bh=vYBviZ8qxTaZEtZPI5+yfWbrOubRpi6mu8bpiFysg3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=psQBgj+xwRNLQMqulSdP4RYQNcwHzkTSgE9W062WrpixwpMWejeIxiWa84ve+SrkyUTAgU3LCl58u23aoer8QQZD7WANxbMFQcwZMZNomgXf5rNb2oKdsiBk0n+Zde6dALLRmobAAVSi5uz69cHvexADAC6rIGBsBvDaHEihd6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PNawpicM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PNawpicM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788185916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nF8nh3XQuPEovJAqq8vzKoZJ9wpuaGASP0IlMlHRhbs=;
	b=PNawpicMQFbGwXH5KjufDEM6+KRFCLDF4GxvMBFNW0Hbt/KTgIYTyN6fqomfili5HOmGN7
	lkIxk5Ee/lFewZ7vADwUxZacq8w60vTEa4GZAAvFIjIQHLscPlDfC9uHjtwcze/tq2nVPg
	LsGqRKLy6yTbpcTtnykXh/iFLYKCd/U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-rh2aV7Y6NTye1wh31zqNnw-1; Mon,
 31 Aug 2026 10:18:31 -0400
X-MC-Unique: rh2aV7Y6NTye1wh31zqNnw-1
X-Mimecast-MFC-AGG-ID: rh2aV7Y6NTye1wh31zqNnw_1788185909
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E7D21933FAF;
	Mon, 31 Aug 2026 14:18:28 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 607A640E;
	Mon, 31 Aug 2026 14:18:26 +0000 (UTC)
Message-ID: <6cb9d419-fc2d-410a-9362-527e2bd9b33b@redhat.com>
Date: Mon, 31 Aug 2026 10:18:25 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] cgroup/cpuset: Concurrent WARN_ON_ONCE triggers during
 remote partition stress-test
To: Zhang Qiao <zhangqiao22@huawei.com>, ridong.chen@linux.dev,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: jifa@huawei.com, Hui Tang <tanghui20@huawei.com>, cgroups@vger.kernel.org
References: <0a897510-8d80-2d8a-5b7b-800aea5f1d23@huawei.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <0a897510-8d80-2d8a-5b7b-800aea5f1d23@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 8/31/26 5:05 AM, Zhang Qiao wrote:
> Hi,
>
> While stress-testing cpuset partitions under KASAN (kernel 7.2-rc1,
> dc59e4fea9d83 "Linux 7.2-rc1"), four distinct WARN_ON_ONCE() in
> kernel/cgroup/cpuset.c fire within a ~1s window. They all concern the
> remote partition / effective-cpumask invariants and are triggered by
> concurrent CPU hotplug, cpuset.cpus/cpuset.cpus.exclusive/
> cpuset.cpus.partition writes, task migration and (un)partitioning of
> nested subgroups.
>
> Environment
> -----------
> - Kernel : Linux 7.2-rc1, generic KASAN enabled, x86_64, PREEMPT
> - server   : Intel Xeon Platinum 8380 @ 2.30GHz, 2 NUMA nodes, 160 CPUs
> - Cmdline: ... cgroup_disable=files apparmor=0 	systemd.unified_cgroup_hierarchy=1
>
> Reproduction
> ------------
> A pure-shell self-contained script (attached below) runs several concurrent
> "disturbance" loops. The issue is extremely easy to reproduce; the script
> consistently triggers the WARNs within seconds of execution.
>
>    - CPU hotplug toggle of a helper pool (CPU online/offline)
>    - random writes to cpuset.cpus / cpuset.cpus.exclusive
>      (single CPU, empty, or range)
>    - random root <-> member switching of cpuset.cpus.partition
>    - migrating burner tasks between subgroups via cgroup.procs
>    - creating and removing nested sub-partitions under S0-S3

Thank for reporting the bug. It is recently known that there are bugs in 
the handling of nested sub-partitions. We are in the process of getting 
it fixed.

Cheers,
Longman

