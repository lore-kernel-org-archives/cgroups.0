Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701224;
	b=fCjw9HBZ5KD5W95SSdgGdHmNYBwVW2a4qBLuMDSzUbFtexnQoWOKEtt+hT/FAI3nJ8zF
	 Cnh3UREIscC6Vz+/D2R3JYzdWIAs8R+0/XPqJLgxiqu8dhSMQkLEjKJWFQFtndN9KTwhV
	 JPFnsYtbP5rqxbvD0N0j+ZYj7GvVzPMmrOuTbtBYOF4j0cNYpFF0Ff6DJjfGqeZTlf4nD
	 2CCiB9zaOmjrB3qAl350d0mwg3MECje0UJnCLqypeejTpGEET3Xy2fTCGPFbb58jddRub
	 IiUFZ6+0xN15/TC4h7+ESV7PvdXjx9bbyAxjTz8z254L+VyLlVeD1TXMC/njHVGkmqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701224;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=h/kSx3u3vVCVPli1ZFb8nfYbCpLt1xTWZmMpPKWCjIw=;
	b=QocJ0vWoaQUQM3RBUyNXsF9IMqwW5dAak84fKMrBpJBtiC3XoZzl61kQc5Q3KlkMxkSl
	 qB9CHEo+9EpgFx/yJj9hSzCITKSA1enOcAcuxBN+r9+I4GASJunhOKq+4l5uUHN/toFJb
	 yCo89qQ+Zs8OcXAfV56bqM21Dz8jDI4sbtMoLnvAxgORnGnI/sVjd+o8CIW+9QgcpLmYp
	 lIY3XxaZakiUJtkhRHTnsYPZEAYE0bFxfNjxwHnY+dnhTQCRbVhIbr7/qMJ8rwnFMb2HM
	 Nu7dV6/hD7uO35FTheW9SYo95Svj5rTDdb0piVWyQ3qGFGBaYIb764t/N6U7yjqixjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=91.218.175.111
Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553DD606A326
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 10:20:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 553DD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=f2gnUeKq2RDNsn2I0tV8LaUqGPSf8U/2kQeBdioZDaQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793701210; v=1; x=1794306010;
 b=LaCzVBMkxMlc28V6nDp23xhcn5kzSxXXC7+wlr6+cmEqFFG0OoaRsFwiLCsMYUx6DdnI1+v3
 G38KW02vo6aquE2h2dhLmi3JNddQ08YFeIQW6BO/CeBpOH3Xx+zvJmoifjQNYPwm9dAg/qfdOsD
 C2oklDW0AdqtlrbwsOs3+eWo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d775d7131cdd61bc;
	Tue, 03 Nov 2026 10:20:09 +0000
X-Mizu-Trace-ID: d775d7131cdd61bc
X-Migadu-Flow: FLOW_OUT
Message-ID: <6808ff6c-d331-4f1d-9bb9-25f7a6b1f3ff@linux.dev>
Date: Tue, 3 Nov 2026 18:20:00 +0800
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
Subject: Re: [RFC PATCH -v4 01/22] cpuset: add early empty cpumask check in
 partition_xcpus_add/del
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutn? <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chen Ridong <chenridong@huawei.com>, Ridong Chen <chenridong@xiaomi.com>
References: <20261101114206.2434398-1-ridong.chen@linux.dev>
 <20261101114206.2434398-2-ridong.chen@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261101114206.2434398-2-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/1 19:41, Ridong Chen 写道:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Add a check for an empty cpumask at the start of partition_xcpus_add()
> and partition_xcpus_del(). This allows the functions to return early,
> avoiding unnecessary computation when there is no work to be done. With
> these changes, partition_xcpus_add() and partition_xcpus_del() can be
> called even if xcpus is empty. The caller no longer needs to check whether
> xcpus is empty, eliminating many conditional statements.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  kernel/cgroup/cpuset.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3219f927c35e..72e1df1295e1 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1315,10 +1315,13 @@ static void partition_xcpus_add(int new_prs, struct cpuset *parent,
>  {
>  	WARN_ON_ONCE(new_prs < 0);
>  	lockdep_assert_held(&callback_lock);
> +
> +	if (cpumask_empty(xcpus))
> +		return;
> +
>  	if (!parent)
>  		parent = &top_cpuset;
>  
> -
>  	if (parent == &top_cpuset)
>  		cpumask_or(subpartitions_cpus, subpartitions_cpus, xcpus);
>  
> @@ -1342,6 +1345,10 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
>  {
>  	WARN_ON_ONCE(old_prs < 0);
>  	lockdep_assert_held(&callback_lock);
> +
> +	if (cpumask_empty(xcpus))
> +		return;
> +
>  	if (!parent)
>  		parent = &top_cpuset;
>  

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
