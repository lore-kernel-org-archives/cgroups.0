Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2E44AEBC0
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 20:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790107524; cv=none; b=dc1Qqq+Gn9+e8yykXNRAiBECBSrEa5zRVK6nozzWVjypyn1WlGG7ORyU5QavDkuaJ700aLtTv4AQ3tI8ZcaoXjL+29rQt5zoC2+0IgSjjYr632rdWdVRL1R08M5z19lVn831O2IioMAOwnURbj51CQwR5BnaF7PZmoFcRnmHljc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790107524; c=relaxed/simple;
	bh=ArxUN+/9pfC4hG4H3grWTfc+M2ghfiKdgldr3ZLnKtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BqJ7rO3Ak8DiP2fx6KStrf8frDiIDGLyryKQnpSCltF1TeuDLdKWwhCp2Pc3dfqmRBe2aBwqRWWB1Dsoz2KFS2u3G46NGLxrGv+Z+uNlRlZ6MlYOvYu1yELnVs3EukCHv0kSWpAK8e90Qn7x2+W50s8RCaFSFLRhI2mS5UtZm6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P80hcwK6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P80hcwK6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790107507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vN+rJGhvEGaW8JpupN3umxegO512Crr3oYXFFGJHCjA=;
	b=P80hcwK6oBpab5Du3Puz1C6FdRmOYFV+Gs/vb0aoEzlLFUfpSVdp9kFKSfir2Sx1Ae2GiA
	kM/erOLMHdOWZ14lz/a/bKQeQcTcO8X30LIPQtIENSleds/id6cUNreyA88BZQ0VhPLCHn
	XFSfR00HsTsoJi+9wQLQhIyg00CMuDE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-UPZExEZCOCOSRycqXhRSiA-1; Tue,
 22 Sep 2026 16:05:00 -0400
X-MC-Unique: UPZExEZCOCOSRycqXhRSiA-1
X-Mimecast-MFC-AGG-ID: UPZExEZCOCOSRycqXhRSiA_1790107497
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 519641800EFE;
	Tue, 22 Sep 2026 20:04:57 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D4C89180056E;
	Tue, 22 Sep 2026 20:04:54 +0000 (UTC)
Message-ID: <eb8c557c-83a6-46d4-ac53-0aa73163cce4@redhat.com>
Date: Tue, 22 Sep 2026 16:04:53 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] cgroup/cpuset: return PERR_NOCPUS in
 remote_partition_enable()
To: Hui Peng <benquike@gmail.com>, Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, stable@vger.kernel.org
References: <a00dbaaa-99f1-4172-b337-911ff45ae71e@linux.dev>
 <20260922080054.3895080-1-benquike@gmail.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260922080054.3895080-1-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 9/22/26 4:00 AM, Hui Peng wrote:
> On Mon, Sep 21, 2026 at 03:08:55PM +0800, Ridong Chen wrote:
>> What is going on here?
>>
>> Please do not reply with a new series. And I think the changes should be listed
>> in the cover letter. Otherwise, it will get very confusing.
>>
>> ...
>>
>> I cannot apply this patch. It seems quite different from v2.
> Hi Ridong,
>
> Sorry for the confusion and the noise. Two mistakes happened when I
> prepared v3 after splitting patch 2/2 per Guopeng's feedback:
>
> 1. I mistakenly passed --in-reply-to pointing to the v2 thread and
>     omitted the 0/3 cover letter.
> 2. Patch 1/3 was accidentally overwritten with a broken diff instead of
>     the remote_partition_enable() hunk from v2 1/2:
>
> @@ -1591,10 +1591,11 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>   	 * above it or remote partition root underneath it is not allowed.
>   	 */
>   	compute_excpus(cs, tmp->new_cpus);
> -	WARN_ON_ONCE(cpumask_intersects(tmp->new_cpus, subpartitions_cpus));
>   	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
>   	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
>   		return PERR_INVCPUS;
> +	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
> +		return PERR_NOCPUS;
>
> Would it be OK if I post a clean, standalone [PATCH v4 0/3..3/3] series
> (as a new thread with a 0/3 cover letter listing the changelog and with
> the v2 1/2 diff restored in patch 1/3)?

That diff looks more correct. Please send out a new standalone v4 patch 
series with your patches.

Cheers,
Longman

> Best regards,
> Hui
>

