Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6E4488236
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787670727; cv=none; b=GE80s/SSCD68UVmVPn6rTHYbp8y1rQCdnNVB9uZHDJ5vaBnGDPKi8GFcB+dLPY7nnhV/e0JAwS1nVexZMEzvGMYt03yEPSgJ3M20GX4CtZIftqcigCgibUJ67kbv3mgVtVNrB8+N6xF1Ke/dpFS1pMflZqjHhMW31qlDpwuH+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787670727; c=relaxed/simple;
	bh=WUDlT8h3Go9lPCxtdoieLn+slLK6bIA4ZlWwqhAJnZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nwSsRUiomVBVq7moNsBvrmC6n9X+KaupRsGinla2pJ86E6IYmuE6bnsraxdEMnOsdonpmFn26g8Nd828GrSM1+fmW4hIUxd0UIhEM2wnwlXa4++bBTWbmR5C+0wOINLHJ78dGZGD4WV3+/9punDJgqTvtJXSoAOTlZLnNW8b/Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=facMiZJn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="facMiZJn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787670723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMXbbb6qzi+TDsaiXaiEp0j8Nn9DPrLc5hYurGJv7hg=;
	b=facMiZJnpfmCAf9PEX+E9RErf0BsPqC+57sX/1WkcD5riM229skHJaF1KzFeoWuslBOT8f
	YWb1pgjoBFS73ot99zowDSN70HBj2MmwUbLWFJrY4cSXvN1URXeC87KLvZhBjXROBiaDgv
	0DvvQuD2Oo0QcWbYEeRplxQYtr4Xj+c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-575-pXuj-XJNMSOzUQmElwclWQ-1; Tue,
 25 Aug 2026 11:11:57 -0400
X-MC-Unique: pXuj-XJNMSOzUQmElwclWQ-1
X-Mimecast-MFC-AGG-ID: pXuj-XJNMSOzUQmElwclWQ_1787670715
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 85C9C18454ED;
	Tue, 25 Aug 2026 15:11:54 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 83C167DB;
	Tue, 25 Aug 2026 15:11:52 +0000 (UTC)
Message-ID: <3bf50da2-f13a-4cef-bfb8-cd592f862164@redhat.com>
Date: Tue, 25 Aug 2026 11:11:51 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/17] cgroup/cpuset: Invalidate children outside the new
 CPU mask
To: Guopeng Zhang <guopeng.zhang@linux.dev>, cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
 <20260820124202.517160-13-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260820124202.517160-13-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 8/20/26 8:41 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> When cpuset.cpus changes, compute_partition_effective_cpumask() builds a
> new exclusive mask but checks child partitions against
> cs->effective_xcpus. That field still contains the old mask, so a child
> that no longer fits can remain valid.
>
> Use new_xcpus for the check. A later partcmd_update() may revisit the
> newly invalid child. Report PERR_INVCPUS if the child CPUs are outside
> the parent effective exclusive mask so that this visit does not make the
> child valid again.
>
> Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b9faadf4af6d..b3e749ede7d1 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1987,12 +1987,16 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   				adding = cpumask_and(tmp->addmask,
>   						     cs->effective_xcpus,
>   						     parent->effective_xcpus);
> -		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
> -			   cpumask_subset(xcpus, parent->effective_xcpus)) {
> +		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus)) {
>   			struct cgroup_subsys_state *css;
>   			struct cpuset *child;
>   			bool exclusive = true;
>   
> +			if (!cpumask_subset(xcpus, parent->effective_xcpus)) {
> +				part_error = PERR_INVCPUS;
> +				goto write_error;
> +			}
> +
A invalid partition means part_error should be set to some error code. 
This change only makes sure the error code is PERR_INVCPUS. Other than 
that, I don't see any other tangible change here.
>   			/*
>   			 * Convert invalid partition to valid has to
>   			 * pass the cpu exclusivity test.
> @@ -2144,7 +2148,7 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>   		WARN_ON_ONCE(is_remote_partition(child));
>   		WRITE_ONCE(child->prs_err, 0);
>   		if (!cpumask_subset(child->effective_xcpus,
> -				    cs->effective_xcpus))
> +				    new_xcpus))
>   			WRITE_ONCE(child->prs_err, PERR_INVCPUS);
>   		else if (populated &&
>   			 cpumask_subset(new_ecpus, child->effective_xcpus))

This hunk should probably be grouped into the same patch making change 
to compute_partition_effective_cpumask().

Cheers,
Longman

