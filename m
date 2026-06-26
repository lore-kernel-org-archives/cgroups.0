Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0363EFFAE;
	Fri, 26 Jun 2026 14:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782483841; cv=none; b=lDIF+t8Uf1AXnN89wq6ae1ihIOyTDmzkqui1mqeMVlrbpynkRAvgx432yfa/97ly96OCu/zJ7zsUqEo1o4j38zIEmjMQfD3T9UpXNOAufk28YC6LIrkIsG9EP66v0DA3pRDK6GXuabRNxDr28SyQCeiamiD0lSo8qC37EQWgHoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782483841; c=relaxed/simple;
	bh=GnX817I9Dn5YTTh2YnnLw/KGmBvjVUzH+Qx51nCzAQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NBykZpl/sF7teXQyUN+5Cejpi2Zo8ZueIjJt2XdWftGB6GJrcVzhKAF6T2zxGkAwBOcLyq4jFGF9dg1FLG7c46wSD/5hxMTNJcGDC9a1FA9hA5uPuHv8SVLQj1jmLEB4GnMfU7aAx7wzFPS/jHm6wAGaNzNt5QmEzmvpq5abi50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=uHabhH9I; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="uHabhH9I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GnX817I9Dn5YTTh2YnnLw/KGmBvjVUzH+Qx51nCzAQ4=; b=uHabhH9I316qhbMCfxGzmP2TIC
	9m6XaBd276OkV8dmxvQelKHMdkmB5WsEuAOm/WnOkBD7tUUWiYSKb0PNq1FBebLAG+kE9kZuaebES
	rYXcumoGRLjHBVxJW7vZRmrQxugV23OimSmn+Mts0EraNRGWhvbL6kvjYQ7JwqA+J08atLVM40DAO
	b7V0e/OjI01LNSSUvWWPpU7D6M+7LcDeavirD7KIBSsHlXzrV2CspO3eng8wu6wkfhkeENmXBnpfP
	f6p0ss+g19B8nXdzwEj0LMplm5B3q6BXDUprHTUpPkZ9tZJ4mBzJWRf+BteMwlWIUomyp5HJ1LHlI
	OiO98WRg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd7TE-0041xv-1W;
	Fri, 26 Jun 2026 14:23:52 +0000
Date: Fri, 26 Jun 2026 07:23:47 -0700
From: Breno Leitao <leitao@debian.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcg: initialize *locked in memcg1_oom_prepare()
 stub
Message-ID: <aj6LKHe0ONwelBmI@gmail.com>
References: <20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org>
 <20260626135612.3697893-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626135612.3697893-1-joshua.hahnjy@gmail.com>
X-Debian-User: leitao

Hello Joshua,

On Fri, Jun 26, 2026 at 06:56:11AM -0700, Joshua Hahn wrote:
> Part of me wonders if we should just initialize locked = false in the
> caller (mem_cgroup_oom) as to not make the stub have side effects,
> but your chnage looks correct and this is a fix so perhaps that is
> not so important.

Nice, your approach seems to be even better than my silly one. I will
wait for further review and respin with your approach.

Thanks,
--breno
