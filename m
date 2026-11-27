Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790941;
	b=zycCzhTJow6IP95xbup1qBqWp8N9gI6i/4T1+HtMLvDippWYOhsHH+fEfOuEAWO3B91m
	 X/aJ4+LANFAPPkqBbjFJjoXP7nDOwjoPph31BS4d3r4YmHrsESASQ5UxinQh0LGLNj/+U
	 +mgkNrDm1dyggyhYZToewf1/axha8Kq9BgA+qRyTpC6C9DwfPb9QEPBZOlP/cAG9Lg52q
	 ihoCSpyrG6aY+8kZFT9fA0vrAJ/u+zoGP/flCui4HzD/53ms3Bm06wogWUVg107VQv7K9
	 7NjPFboT9h7dKmYLvZ1pOBM9z0osTm9INAFEmIORqvkflkyrE2uxoNSy4Ww9iHJTDbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790941;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=3vfbFq558XoogCMN92GIlkkY4kUmYBbaW8/lJSqcfKo=;
	b=v3dPlniCy6zSPcc8OaOm80KqhlfCi0M3bZw/oEbQ0XRaOh+qGn2WSGepLdOOPuApOrt8
	 hdt3nOqIv88HxQOmKvV6Qe9tv3Rj0GoHqEKo8O1RJ5+4kpYJHNQOS4eJHTE6IycfMdJON
	 bGUy1tgiQwyYiAbPm5VSAF2qSH/lxeMJfjZ/ITrldLLH0oacePrtqaVX4Eye7JblrIJE7
	 NQEfmeRdrdcxg4yVlaCr//Bp4yq+jkHLcyuMZRG7qcgTLKYRl69RfLTyT8kgSsGPxAF0y
	 5zPgFs376FkzPOxAvHW86Cu5UlcCIE0jqSsnm/5AmQBdNdxU1mzYoPfw0NwFeOxxmaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l5A0j5dM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD69606A31E;
	Fri, 27 Nov 2026 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l5A0j5dM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC9B1F000C1;
	Fri, 27 Nov 2026 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795790941;
	bh=3vfbFq558XoogCMN92GIlkkY4kUmYBbaW8/lJSqcfKo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=l5A0j5dM5x3kj4BEiKyH7WWdnRg6wC0e+4HQjtaKQtrsrnmrbjfvbFDmC6PAnPzvV
	 n6MuzrdrKvtFF2kG775OcWZBoxI9R2ncZRe/ZE9DBbHD3ZKi6F/fxS5j4Sobey4PAy
	 mqL5DVyn2Skdf60o8I84Z1pNY6cRwd4R2j9DvpiaUEJKdoSAmRj2LtcATFopX3ZtF5
	 tk6GcKJSYSehZ4JxAmNfYumATBCIa6wVsD+GRBkvgNRCYoZ2EnABN2zIYQDwUC+BXL
	 7rx6N3wvUGLxcemdZR33UJbNaDgGWjQQC7dAP3JYzUZ8JhVwOK6xKILFqhenGa1zsE
	 3/WNT+nJoSbDg==
Date: Fri, 27 Nov 2026 04:49:00 -1000
Message-ID: <c8b240516272e7a805ef030b0945f52a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Zhiqi Zhang <zhiqizhangg@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: Preserve sign for fractional input
In-Reply-To: <20261126065958.89207-1-zhiqizhangg@gmail.com>
References: <20261126065958.89207-1-zhiqizhangg@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Zhiqi.

On Thu, Nov 26, 2026 at 02:59:58PM +0800, Zhiqi Zhang wrote:
> cgroup_parse_float() parses the whole and fractional parts separately with
> sscanf(). The sign is only carried by the whole part, so inputs whose
> whole part is zero, such as "-0.5", are composed as positive values.
> Inputs such as "-1.5" are also composed as -0.5.

This no longer applies. cgroup/for-7.4-fixes now has 4ac4766e93f3 ("cgroup:
Fix divide error on long fractions in cgroup_parse_float()"), which rewrote
the fraction parsing. Can you please rebase on top of it and resend?

Thanks.

--
tejun
