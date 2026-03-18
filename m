Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DF03019AA;
	Wed, 18 Mar 2026 22:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773874619; cv=none; b=c2tuhJrX0LXwaXi11pxGjcXQ2Mv2dwG9M1x+b0eScuL4krfSLEznxhpixcCoU4mizA+aD9Z6evZKUM3tOwsESStjBgteRRTcsRwgTKXawYWwg8IjiRXt78P4EzlaIWJPCMjFOZi7eKUEuHag0znuBNYuy9kOxMunSgLBc5AvtM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773874619; c=relaxed/simple;
	bh=ObfiedzrwsT34Y8biasL83aWxVvgU9ByOpIkysicBaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOPTxFUkqFS65ULtUJK1LVVUXkKeoOII5tIkq7bJcOcbpcWzkydSH0TdH1qdDP5ofstnArRQr//oQWfiodA9uSuACWeL0Dz1A52m8MCsLcysK7/7aeFrnAUeXUc/WCnvwg6t4S+P7pYGCWbBSUxnrGXnuFkqw9mGs2EaH828O1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2yStBZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2yStBZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1719EC19421;
	Wed, 18 Mar 2026 22:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773874619;
	bh=ObfiedzrwsT34Y8biasL83aWxVvgU9ByOpIkysicBaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f2yStBZe2+vQHXAU97dz9MtvegAKXsuZUAxqH+mDtFLlNP/8TYDcD1AHgZoXTTTvO
	 KnQ2ioQ574gvQnL4AzSUmQhhRj5g/UWA091Reybt+i7aRaFe5j3oS9jLeCMw2fh0fS
	 D/GN3wge8/ByiLaBT2OvkQeDuUqvzIlTACOvbzQfUn6c5C50JNAVEedQG9PsAGgAvX
	 IjsV5pg2NusfKkR52Mq0p5i/amUZep0A34rn+r+RkTCw/I1/yS9sfyJ1mjkAHntq1Q
	 1H+AqekIERYMikOLJYCMGx50jNayfuXvZMupL3/C1S5hhH6CSBQCM3P3n3w/ar/wz2
	 dkBgIf9sBO4jg==
Date: Wed, 18 Mar 2026 12:56:58 -1000
From: Tejun Heo <tj@kernel.org>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <natalie.vock@gmx.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Subject: Re: [PATCH] cgroup/dmem: return error when failing to set dmem.max
Message-ID: <abstuhuD4FJ-RMcc@slm.duckdns.org>
References: <20260318-dmem_max_ebusy-v1-1-b7e461157b29@igalia.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318-dmem_max_ebusy-v1-1-b7e461157b29@igalia.com>

On Wed, Mar 18, 2026 at 04:34:17PM -0300, Thadeu Lima de Souza Cascardo wrote:
> page_counter_set_max may return -EBUSY in case the current usage is above
> the new max. When writing to dmem.max, this error is ignored and the new
> max is not set.
> 
> Return as soon as setting one of the regions max limit fails. This keeps
> with the current behavior of returning when one of the region names is not
> valid.

Ugh, I don't know why dmemcg_limit_write() is trying to handle multi-line
inputs. After this, there's no atomicity w.r.t. failures either, so this
seems entirely pointless. I'd much prefer to strip out the multiline
handling.

Thanks.

-- 
tejun
