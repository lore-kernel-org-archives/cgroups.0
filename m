Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2944DD6C8;
	Fri, 15 May 2026 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862426; cv=none; b=F0E8VihCQJQDQaagI21MfG+eb6ZPnbg/voTD8CG+FWNWeUDMX6AM8zrmFHNLh7yMFghlnJ8RbKRJ3XMs0i1zrA/ID6+CofRqoTlQMjU6JAb2QSJh5oP8485NUbC8LeoCqzTJNbh9ZxuxYnKCj8ECdCNKq5DexMDNsBdmgjiNqLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862426; c=relaxed/simple;
	bh=9b7xa8M1FWL1YN6P6S//lcenqKg0CXkRU2RUhXjIF18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoDb0JN1XaLKBel3BoX8A0zBZzTInrpsdDOpcM+pFjPaxE6EFaZ7rV/jbQEGt3yXLNubAK7RthqiPee6k4+yx/Sl1TUdUuQq2NhLCKOYs29SLdW4cei1rfQje7T6OOrPonAhBryeRZSdBtnTmhR3bf2fpppIPOiddhqHo9k5MT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+LRn2NQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+LRn2NQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715A6C2BCB0;
	Fri, 15 May 2026 16:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778862426;
	bh=9b7xa8M1FWL1YN6P6S//lcenqKg0CXkRU2RUhXjIF18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k+LRn2NQT6s/VKfnmKYdXnrd9y35h/tpwVVRtroXyHjY0YWmBB1ZmUzP/yZukL/DJ
	 s8Lcu0k1pUO4/Q9qXPBYNYrPdIonZ6B2OcA4urkHlm3SQ0I5F/4zUZe35zU4pNoida
	 ScJvMF7CBfHAMTKYM6oHMLX70LeFeAmbL/UfmDzQB4J/B/K1L/a1u6XmhcEWjiwNE7
	 nN8syMY4e3x+inlgB/6Cxd1lW75r54U8PfM0pp8VtyYYlbn6LubfMGpf/J+T2a3wUU
	 mR+9QNEsEf1Qumhs0T51mHzNGI2+kkpB8FhwUwV5LRbxfy+UpOjSKBkCvMTmB1Cj9Y
	 uwXjLt1BuIQdQ==
Date: Fri, 15 May 2026 06:27:05 -1000
From: Tejun Heo <tj@kernel.org>
To: Qing Ming <a0yami@mailbox.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/rstat: validate cpu before css_rstat_cpu() access
Message-ID: <agdJWXRZF_pRgggt@slm.duckdns.org>
References: <20260515122952.59209-1-a0yami@mailbox.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515122952.59209-1-a0yami@mailbox.org>

On Fri, May 15, 2026 at 08:29:52PM +0800, Qing Ming wrote:
> @@ -90,6 +91,9 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
>  	     !IS_ENABLED(CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS)) && in_nmi())
>  		return;
>  
> +	if (unlikely(cpu < 0 || cpu >= nr_cpu_ids || !cpu_possible(cpu)))
> +		return;
> +

Can you please add this validation to the BPF kfunc that's exposing it?

Thanks.

-- 
tejun
