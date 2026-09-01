Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496981A5B8C
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 00:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221338; cv=none; b=eVI/jdaLOeDK3eoYngU9B72zP3SwVrWfplM2M5KuhG/v0CsPwZbAS4gNis+yPPg/vkCcqx+/4ryAflWXieNPAVJam6BJLEQM7TJRNtix1zr4yl3FO1MGC2M+R00/3PNZdQ6agJW4+aRM+Llv42ZiB3KIMKea5rgu/asSm6CXbE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221338; c=relaxed/simple;
	bh=7C1mJL+d0RD9Sz8BFCniH1v8F4EmGh+fIvAplCZdQrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wf6WTFpV/THYVfGRzxrLlZjdA7TAe6QU5YjJd6AsOu6PNcOoJ0I0PWT2De2onPFQs/HFdhg0JEJ5X3vNcJxIjwRpSiCFxZL0AxGVEoFQkhLpJifxT1ypQy9qkiDsszZp/8QBilZNKLiDmRrry1x4+TRA4JUBZ3j6epK0jW8Pwvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VNtzPoKY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VNtzPoKY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788221336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cJFMEq80QkpWSaSDsjkZJUys8LK+Qc2YgMiiqzuhFRY=;
	b=VNtzPoKYyIAsaDflhDjof85QwANFiOxUUmnxTdvN6ZtCsDSGFFJyLI3GAIqCX7TRIqQpOA
	fD2mOh0MDmmSXmYwWNafHZ0PyaMCEsnVX383UxKtMvKCg90zfrnxnZs6P/BrkKlynHbwEE
	i6ayCL7IPULsqyRH8EOPxLW0cKuv8Gw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-392-uRIloH20MoSLK8j0_x_Lxg-1; Mon,
 31 Aug 2026 20:08:54 -0400
X-MC-Unique: uRIloH20MoSLK8j0_x_Lxg-1
X-Mimecast-MFC-AGG-ID: uRIloH20MoSLK8j0_x_Lxg_1788221332
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EED9E19540E8;
	Tue,  1 Sep 2026 00:08:51 +0000 (UTC)
Received: from [100.91.18.181] (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4BDF87D8;
	Tue,  1 Sep 2026 00:08:50 +0000 (UTC)
Message-ID: <85411b3f-bcbd-4a7e-99a5-49a465ca2df8@redhat.com>
Date: Mon, 31 Aug 2026 20:08:49 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Handle cpu hotplug race in
 guarantee_active_cpus()
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Farhad Alemi <farhad.alemi@berkeley.edu>
References: <20260828180322.730419-1-longman@redhat.com>
 <ba138f23-6972-44c8-8ce5-80de1f50891c@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <ba138f23-6972-44c8-8ce5-80de1f50891c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 8/30/26 9:50 PM, Ridong Chen wrote:
>
>
> On 8/29/2026 2:03 AM, Waiman Long wrote:
>> With commit 2125c0034c5d ("cgroup/cpuset: Make cpuset hotplug
>> processing synchronous"), the cpuset hotplug operation becomes
>> synchronous. That commit also removes the code that handles the race
>> between cpuset_hotplug_work and cpu hotplug notifier with the assumption
>> that race is now gone. Later commit 7a0aabd9ce69 ("cgroup/cpuset:
>> Always use cpu_active_mask") updates the cpuset code to always use
>> cpu_active_mask instead of cpu_ohline_mask in various places including
>> guarantee_online_cpus() which is also renamed to guarantee_active_cpus()
>> in that commit.
>>
>> In the case of CPU offline operation, cpuset_active_mask is updated
>> first in sched_cpu_deactivate() to remove the offline CPU before
>> cpuset_handle_hotplug() is called to update the effective_cpus of the
>> affected cpusets. The cpu_online_mask is updated after that near the end
>> of the offline operation to remove the offline CPU. As a result, the 
>> race
>> comes back and the top cpuset may not have any active CPU leading to 
>> NULL
>> pointer dereference during the race window when guarantee_active_cpus()
>> is called after cpu_active_mask is updated to remove the CPU to be torn
>> down but before cpuset_handle_hotplug() is able to properly update the
>> effective_cpus of the top cpuset.
>>
>
> Hi Longman,
>
> Thank you for the patch. I believe it should resolve the issue.
> Could Farhad please verify whether it works as expected?
>
>> Fix this by adding back the NULL cs check to avoid this problem. 
>> However,
>> the output of guarantee_active_cpus() will be unreliable during that
>> race window.
>>
>
> If guarantee_active_cpus() can return unreliable results during that 
> race window, should it instead return an error when it cannot 
> guarantee that the active CPUs are usable? Otherwise, callers might 
> use an incorrect 'pmask', which could lead to other issues downstream.

I am thinking about that too. However, the change will be more extensive 
and it is that easy to figure out if we are the in the race window. So 
more thought will be needed before we can make that change. In the mean 
time, we have to fix the NULL pointer dereference and it has behaved 
like that before.

Cheers,
Longman

