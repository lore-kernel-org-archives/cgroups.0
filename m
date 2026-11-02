Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793582952;
	b=1EMnaCt+vB7zvzkgq9sMuTrsgDxPhr2Yd94yPUjeFpnYQJ1NXzTjgtZpzLBqZPzpcZFR
	 xB/HR1EKE4PQW+x7X8SZb5jqH8X4VC6TEN+8FxpILinp4NfFtYbzuFXfEBf43BiONZYCu
	 Z7kVIpW2eev/zqNlipN76Zw9ggCRBLuhguODeV2ncQ7tTkJDjkpzuS04FzneTR6vX29a5
	 1cFHDY0dkKiLShAwSwfuTEHnTPXCdr8hJtn/iqnVppR/BQka+HXm9vFojDoz0c5UojzFz
	 Ye5kI2DfQ6uCzyFPT5FcXhjvdQboVv0RpwS7br3LUKGlnCESSDOwqo2pRipBHJ/x00g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793582952;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=RfRd34hbQ3fNwbe9mZRyC1FUgyB8k24TDialm2Z8OBI=;
	b=Me/Zi9XdN5pmWT5xTn/Z5P6LWIBO5/G1iH/ZSn+0yJVd4uSa/mq1cHJZCgu5Jgx5dY0a
	 l1gGsKemaNb5D4g4AIF5X5gxodDn9SzBS0UEtOrtgO9WztUymsI0q4BjVPu/7devtjYEP
	 DT64ZrPJeLitUWWOD16+vl6YiJkzphTJ/01X7AOraH+TgdsiB94HOTajuLJU02ulg7V9r
	 AOIh6nsNRPDGVO0trtPJL/RZY/0LItLvMIKgWGUg4XUSyAB5Ciujz3uh43VT11ZgpitRc
	 /8uDtcZ1IN5UnuUixaqpWx9S7PrKbBWnN68UNp3z0IeDGAkDsGH+RYwrYzTNy7SR9dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pocw8uga;
	arc=none smtp.remote-ip=95.215.58.123
Received: from mta1.migadu.com (out-123.mta1.migadu.com [95.215.58.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B63606A327
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 01:29:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60B63606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pocw8uga
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=sX0hSFxSFmqYm4dEqA48I5gNAB/p57bOI6zGz5tQowQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793582949; v=1; x=1794187749;
 b=pocw8uga+BoaKmXcYnAVF2DaTlOUwclIuH84FHW0mcbDxiXKpehOt5AILeo8pavwiilb69aj
 XTkyZP2gCkQ7EL0k9fEa7k374PxANu+r77v/D3Fv5ivruVl2/V/bVIYGj79CMbI8NQ3aDKGwPiG
 CqO/lkFkhVaxWNY69BovGYP4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f967bc48abe79d33;
	Mon, 02 Nov 2026 01:29:07 +0000
X-Mizu-Trace-ID: f967bc48abe79d33
X-Migadu-Flow: FLOW_OUT
Message-ID: <c4b63601-ab06-4ee0-8d15-4c4acfa35f81@linux.dev>
Date: Mon, 2 Nov 2026 09:28:53 +0800
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
Subject: Re: [PATCH v2 2/3] cgroup/cpuset: Recompute effective cpumask in
 update_cpumasks_hier() after calling update_parent_effective_cpumask()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261030190701.78308-1-longman@redhat.com>
 <20261030190701.78308-3-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261030190701.78308-3-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/31 03:07, Waiman Long 写道:
> It is reported by sashiko that calling update_parent_effective_cpumask()
> may clobber tmp->new_cpus when update_sibling_cpumasks() needs to be
> called due to possible change in the parent's effective_cpus value.
> Therefore the new effective cpumask has to be recomputed after calling
> update_parent_effective_cpumask() to get a correct value back into
> tmp->new_cpus.
> 
> Fixes: f0af1bfc27b5 ("cgroup/cpuset: Relax constraints to partition & cpus changes")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 39c81a0a8ab9..ed014ecb770c 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2359,12 +2359,12 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>  			update_parent_effective_cpumask(cp, partcmd_update, NULL, tmp);
>  			/*
>  			 * Capture current partition_root_state as it may have
> -			 * changed. Recompute effective cpumask if changed.
> +			 * changed. Always recompute effective cpumask as tmp->new_cpus
> +			 * may be clobbered when update_sibling_cpumasks() is called
> +			 * within update_parent_effective_cpumask().
>  			 */
>  			new_prs = cp->partition_root_state;
> -			if (new_prs != old_prs) {
> -				compute_effective_cpumask(tmp->new_cpus, cp, parent);
> -			}
> +			compute_effective_cpumask(tmp->new_cpus, cp, parent);
>  		}
>  
>  		spin_lock_irq(&callback_lock);

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
