Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639424;
	b=a4+qb/JTmRpxON6RkR4clqo7wJnld4lG0KLC0vo9Z+3HcXyczM88z4BVFtsK/fLDSR35
	 Pzo4azIogKghqIWu6jB9BLDPMbrMCL8xkdmLpcWrHC6rswgkDVw8lBtDikAzmrHVQbSX9
	 hcI2zW24PrcLbxqqRa8zvoftbRfPCwgYqLkPWGSLxgt8h6vnbPpJ2oucyyu15lecSZr6r
	 PeGEo7e390GtoyDH8U75EZNPLuXph5Lt6dE3BCagprjtGxgzMqvCzrM6zmg39g5bTnK7c
	 rUIXGOS7g5LObMderqbRtZjEksMl2S3sDbBEYXUJKkp3hyVllFQLB6Hi0rW1VDYuXeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639424;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=Ccyz5/U4JdhiN3TobyhIUaa9LmfIlsxj9S6/np5ABxU=;
	b=tV/jMZ2TjaBsubiULW8HzINJEow3QpnBp45CaFp6b8vXwb/p3sYA50bwYNqbkEUZQ0LR
	 DxJmQSNwTS3orQPlHcDW8uNeaGeSKkKnWC4G18j79xZL0dV8K2zBmO9c/GccROPY34lmj
	 DIrFT2Dq3wfm63nzgWXvXx90rxnh24A3WWGbfaS9R/2RDdYzvGSOoox19zuzKyZGlm44V
	 +8lCqZt8xZA5dS7JJ7N+V+IIxGlmiCeofn4eFHMoPwcVg5uaSmKcgHYwz8Ru1sQay5pNC
	 haEz+8+si1JdfUMIHdv7CA02aekYi5SHBW1gO5zfRxzkwrCTtpotwnwr0E8hNUudzgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KLl30uv7;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E185606A31B
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 03:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E185606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KLl30uv7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792639422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ccyz5/U4JdhiN3TobyhIUaa9LmfIlsxj9S6/np5ABxU=;
	b=KLl30uv7cnO1aqeu6E35wzOe5UZY0KAFgFwi8CMnckONYyhO0YBQCLpcC5dyZGTwq03ri+
	9N3ZjZZllpczyiujsxNrEN2rgyla4WtWoNa54hCib6JADxd9cgWBuD8J1RobUZXtOjVlSl
	5TejTtiEtYSqpilJjFzgMKjKKIO4zOI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-182-GG9IS55XOyi__AyypsRQnA-1; Wed,
 21 Oct 2026 23:23:14 -0400
X-MC-Unique: GG9IS55XOyi__AyypsRQnA-1
X-Mimecast-MFC-AGG-ID: GG9IS55XOyi__AyypsRQnA_1792639393
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF24F19560B2;
	Thu, 22 Oct 2026 03:23:12 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 350B31800480;
	Thu, 22 Oct 2026 03:23:11 +0000 (UTC)
Message-ID: <0514f986-c125-4a2a-8079-cbbfe5cdc273@redhat.com>
Date: Wed, 21 Oct 2026 23:23:10 -0400
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
Subject: Re: [PATCH 1/2] cgroup/cpuset: Fix cpuset.cpus update in a remote
 partition
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261010075947.333549-1-guopeng.zhang@linux.dev>
 <20261010075947.333549-2-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261010075947.333549-2-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 10/10/26 3:59 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> When the CPU list of a remote partition is reduced, a removed CPU may
> remain unavailable to the top cpuset.
>
> This can be reproduced on a cgroup v2 system with CPUs 0-7 online:
>
>      cd /sys/fs/cgroup
>      echo +cpuset > cgroup.subtree_control
>      mkdir A
>      echo 1-7 > A/cpuset.cpus
>      echo 1-7 > A/cpuset.cpus.exclusive
>      echo +cpuset > A/cgroup.subtree_control
>      mkdir A/B
>      echo 1-4 > A/B/cpuset.cpus
>      echo root > A/B/cpuset.cpus.partition
>      echo 1-3 > A/B/cpuset.cpus
>      cat cpuset.cpus.effective
>
> The last command should show 0,4-7, but CPU 4 is missing.
>
> update_cpumask() calls partition_cpus_change() while cs->cpus_allowed
> still contains the old mask. remote_cpus_update() first releases CPU 4,
> but the hierarchy update revisits B and compute_excpus() still sees the
> old mask, so CPU 4 is removed from the top cpuset again.
>
> Move the cpus_allowed update before partition_cpus_change() so that
> the hierarchy update sees the new mask when it revisits the cpuset.
>
> Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 0ebba2d646c3..de7553459adc 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2478,10 +2478,13 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>   	 */
>   	force = !cpumask_equal(cs->effective_xcpus, trialcs->effective_xcpus);
>   
> +	spin_lock_irq(&callback_lock);
> +	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
> +	spin_unlock_irq(&callback_lock);
> +
>   	partition_cpus_change(cs, trialcs, &tmp);
>   
>   	spin_lock_irq(&callback_lock);
> -	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
>   	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
>   	if ((old_prs > 0) && !is_partition_valid(cs))
>   		reset_partition_data(cs);

Sorry for the late reply.

Thanks for reporting this problem. I suspect similar problem may exist 
with change to cpuset.cpus.exclusive as well. The root cause of this 
problem is the recursive call to remote_cpus_update() with the second 
call missing information leading to the revert of the first call. I have 
posted another patch to address this recursive call problem. Please take 
a look to see if you agree with that or not.

Thanks,
Longman

