Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CDB3C872B
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 23:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790552655; cv=none; b=BRbI9pRBuXl3Z/VzAe9sl32eklr9/F8zbHntjHKku+4g+MhtfbqeBiUuBAhFAjhklg45d7/1T79CUC7Gt2nBP7XC0DF0318Ef4RFNsLXmXBHSnMdQt6ah0V4lav5Y1QuWu7BCez7C5d69CEwni0orAvRrSu9jaagY2A7khkdvD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790552655; c=relaxed/simple;
	bh=Iw5uXV2RPPaOzfgwc/i+P7SjdRTEqKv1d6S6g5Cinp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tITzJyYvLFqBsaWeh4VTV69lrYIFbJD5AmJwcZKKKKdBOWgCbyxtTiPS/EiQ6n1Qm6+e8bWCYs0wmt/tgflev68YmaRHuFgUewQzEnPsBoc+EPF27BKL25aFoNQmKx9vo5YnxovGnRjf4cHPzu+TKWR8KKbkiN/Mg1eOOgA3Mfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a3PzBKle; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a3PzBKle"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790552653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aecDMSjhtbDX6tqMHICAMcY6aRfKnInfXugkr1qVLzo=;
	b=a3PzBKleQSk/oeiGJZB1Rtwh76lK4hcHV+J5DZleCXX5rSB3GevR0/UVIn1U/+FPQL6WPK
	QZQlNe0Z4u88JcxjhasPUGg2e4Mm+RVrq0ooXwtFcW6COwK2C3gbbsemNVLa0qiBqbAVH7
	A657pXfDfxfi0k8zjaLE4Y2QnqRCXzo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596--pPqdBVRMgaUegqMqO_Cww-1; Sun,
 27 Sep 2026 19:44:08 -0400
X-MC-Unique: -pPqdBVRMgaUegqMqO_Cww-1
X-Mimecast-MFC-AGG-ID: -pPqdBVRMgaUegqMqO_Cww_1790552647
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2901D1955E99;
	Sun, 27 Sep 2026 23:44:06 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A42A19560AB;
	Sun, 27 Sep 2026 23:44:03 +0000 (UTC)
Message-ID: <90088ec5-41a6-4034-a0fd-aaafebfe1083@redhat.com>
Date: Sun, 27 Sep 2026 19:44:02 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] cgroup/cpuset: check sibling effective_xcpus in
 cpus_excl_conflict()
To: Hui Peng <benquike@gmail.com>, Ridong Chen <ridong.chen@linux.dev>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Shuah Khan <shuah@kernel.org>, Chen Ridong <chenridong@huawei.com>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260924042729.1908863-1-benquike@gmail.com>
 <20260924042729.1908863-4-benquike@gmail.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260924042729.1908863-4-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 9/24/26 12:27 AM, Hui Peng wrote:
> In cpus_excl_conflict(), when a valid local partition A1 uses implicit
> exclusive CPUs (cpuset.cpus set without cpuset.cpus.exclusive, so
> sibling->exclusive_cpus is empty while sibling->effective_xcpus is
> populated), a sibling cgroup B1 can still set cpuset.cpus.exclusive on
> the same CPUs because cpus_excl_conflict() only checks
> sibling->exclusive_cpus.
>
> Fall back to sibling->effective_xcpus in cpus_excl_conflict() when
> sibling->exclusive_cpus is empty, and add a regression test case to
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
>
> Tested in QEMU on Linux 7.3.0-rc3 using
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
>
> Fixes: 2a3602030d80 ("cgroup/cpuset: Don't invalidate sibling partitions on cpuset.cpus conflict")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
>   kernel/cgroup/cpuset.c                            | 5 ++++-
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 1 +
>   2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 7c5b4a8f1f3a..f46a51f07938 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -713,7 +713,10 @@ static inline bool cpus_excl_conflict(struct cpuset *trial, struct cpuset *sibli
>   		return true;
>   
>   	/* Exclusive_cpus cannot intersect */
> -	return cpumask_intersects(trial->exclusive_cpus, sibling->exclusive_cpus);
> +	return cpumask_intersects(trial->exclusive_cpus,
> +				  cpumask_empty(sibling->exclusive_cpus)
> +				  ? sibling->effective_xcpus
> +				  : sibling->exclusive_cpus);
>   }
>   
>   static inline bool mems_excl_conflict(struct cpuset *cs1, struct cpuset *cs2)
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index f4d1822d4e21..f62155cf6162 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -445,6 +445,7 @@ TEST_MATRIX=(
>   
>   	# Changes to cpuset.cpus.exclusive that violate exclusivity rule is rejected
>   	"   C0-3     .      .    C4-5   X0-3     .      .     X3-5   1 A1:0-3|B1:4-5"
> +	"  C0-3:P1   .      .    C4-5     .      .      .     X3-5   1 A1:0-3|B1:4-5 A1:P1|B1:P0"
>   
>   	# cpuset.cpus.exclusive cannot be set to a superset of sibling's cpuset.cpus
>   	"   C0-3     .      .    C4-5   X3-5     .      .      .     1 A1:0-3|B1:4-5"
Reviewed-by: Waiman Long <longman@redhat.com>

