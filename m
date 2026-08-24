Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CD64334A6
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 14:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581561; cv=none; b=XRlf0caa1TlLDkPEQu5NoqLG/hIXoRYzbx4SqYyUIjshPFGdej2gOuQmooMNsCW8kxj56vi9wYseSnzQrMIG+p1J0pvIm7wzWP6Eg77PFNBRyrcvjRpII7vHDu6TO6EixAo8jJLlBtJGOfCKZis9E/VGKQ92JW6Bpwzif5RMdlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581561; c=relaxed/simple;
	bh=pMOi/g/hnsBOqyccmTLqKZKBwAPWG8IhQjO4FrFx6OE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gO+xDEwoaw1V+7hLkpGRc9Sq6AGnX9pv9t7mh+BiWWhi//EkSfXLsDRJzxlkGl98TLsZ+0mB2OU5ZcXn8ClpB6JiCCrsaH7+NXriGvKmkJXYGQDUJekWmSHzW1o6k2LsDoB+nE4yvSUc2NIsKtPm3wXCbu2DCwpWRyKqyY3ylOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XIebsqOu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XIebsqOu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787581556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KZdCzf5iE+LttP5RWRsb2LyzzIha1v8C2R1BieLu8ME=;
	b=XIebsqOuetl9m2NG4Eq1vwcEdc7vDTvcIDETL1u5A0+KNqt4b63AG99j5cnaQ0E02YAZPj
	apJ/BbUXFcUMrVxy8Dz+prBs8X6kpH0uZdCSwuALQ6Gncrcf4QFmN07eLVD8IS9X8tiXD1
	VsEJXfFqOpPxiIZ55BaQ9bnuGRr841A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417-1UvCtRPpM6a2WTbDF3xeJg-1; Mon,
 24 Aug 2026 10:25:51 -0400
X-MC-Unique: 1UvCtRPpM6a2WTbDF3xeJg-1
X-Mimecast-MFC-AGG-ID: 1UvCtRPpM6a2WTbDF3xeJg_1787581550
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B15FF18301FD;
	Mon, 24 Aug 2026 14:25:49 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B728F1955F70;
	Mon, 24 Aug 2026 14:25:47 +0000 (UTC)
Message-ID: <b782170f-2b8e-4b1f-bdc1-f8fa632aec98@redhat.com>
Date: Mon, 24 Aug 2026 10:25:46 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/17] cgroup/cpuset: Validate type changes against owned
 CPUs
To: Guopeng Zhang <guopeng.zhang@linux.dev>, cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
 <20260820124202.517160-7-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260820124202.517160-7-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 8/20/26 8:41 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> update_prstate() checks effective_xcpus against the housekeeping masks
> before changing a partition between root and isolated. effective_xcpus
> also contains CPUs granted to valid child partitions, although those
> CPUs are not affected by the parent's type change. A child-owned CPU can
> therefore reject an otherwise valid change.
>
> Run the nohz_full and boot-domain housekeeping checks against the mask
> of CPUs owned by the partition instead.
>
> Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
> Fixes: b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 468272baadb2..853942c1afeb 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3019,8 +3019,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>   		 */
>   		compute_partition_owned_cpumask(cs, tmpmask.new_cpus);
>   		if (((new_prs == PRS_ISOLATED) &&
> -		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
> -		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
> +		     !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
> +		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus))
>   			err = PERR_HKEEPING;
>   		else
>   			isolcpus_updated = true;

This can be merged into patch 4. This is basically the same change as in 
patch 4.

Cheers,
Longman

