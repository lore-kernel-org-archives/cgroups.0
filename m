Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C08041DDEC;
	Tue,  8 Sep 2026 16:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788885706; cv=none; b=d21UtuFWMVwl8iknOXqTvAzsM9Mg1D6S3euF0e65GPsN/Wm9OV5vNhn4ilGixnCYqWOf5VZOV/wm3DhUV0EJzRkLsXfoN/IHqk0I2krqhPA56RJwg5bN6TjLwrH4oYZn0K5ueafVKtcQFVx1Tnpb0N9zDbwwA4T0m/P65iZiE8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788885706; c=relaxed/simple;
	bh=I4ogTQ+5l87g2/OcBkKvMT6alyq1M/vo10Xyi4ou+Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJj2uk/ZRQxzo3tLD9tLpmW+xqBRZYTLyT3X0zK5gXfp8umVtmfz3ztYDhc64T271zdGxiMLS1DIh/Zhw6Khp51r0AfMUL2bW3Tl1ESB7hWUKD3ZC5wQQYJzXlbRmFmcakVpBuuk5F6jmUyOise7WrscOwxBHcSObT6a3lkjleo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkKMX3GO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkKMX3GO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5BF1F00A3A;
	Tue,  8 Sep 2026 16:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788885704;
	bh=gOLrZji3QBtUsmg+BXKQX/vZgwGaebmRkiZFIaYI4y4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WkKMX3GOf/cXFjVt9XIDG3xpIZbt67mN78v9Q0fkhu12yxHeO+DDYufaGnJQpWAqh
	 hIflj5U1W6kCJ1XmX3YVv3YJ7VxGVr/nA3eEclDkb2WxmaeHA5ANz0Uh4XvR1QKHs/
	 24I5qqApt9mWbufGB8aU1STy8Oe4RbLfcL8nwHdchyrwPhOr7gg8jj75uyz72Nrzlg
	 zVIMlEX7dRQKUn4dAzh40RSxXGN0NYac/7/elxcVKkerz0PxLwnw1GyJU1BnX1mxmH
	 2KMWMx54i7bDqRDYGq5Z2P6AjAPSXnTZLTR1sE+2y+0OkBePt4A8fYuwMTjmPfeu/w
	 ISRrVztwtUVFQ==
Date: Tue, 8 Sep 2026 06:41:43 -1000
From: Tejun Heo <tj@kernel.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Junnan Zhang <zhangjn_dev@163.com>, cgroups@vger.kernel.org,
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	sunshx@chinatelecom.cn, zhangjn11@chinatelecom.cn
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in
 cgroup1_pidlist_destroy_all
Message-ID: <aqA6x_8E3Xiewoso@slm.duckdns.org>
References: <apU1sXYP_QhsQFcB@localhost.localdomain>
 <20260901033923.40420-1-zhangjn_dev@163.com>
 <ap_3u9i1n8mQrObY@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ap_3u9i1n8mQrObY@localhost.localdomain>

On Tue, Sep 08, 2026 at 04:13:11PM +0200, Michal Koutný wrote:
> Your patch looks correct to me, although, I'd rather not nurture the
> venerable code at all. And I've never liked pidlists, so I'd like to
> take the opportunity to retire them a bit:
> 
> https://github.com/Werkov/linux/commit/8c3d45be95841ede16ceac29d48be59e59ec5a82

I'd rather not touch them at all and eventually retire the whole v1
interface.

Thanks.

-- 
tejun
