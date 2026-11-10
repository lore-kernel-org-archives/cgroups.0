Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794326808;
	b=2HsUQNEBJAehoOmYckb7VWjrbL2cgLVfe7TKNgLxvrpsHfZKFahz1P1TCOGBmk476wgS
	 9HpICSGbYSEJi+3LwhuSKoC9rQ4lmrFb18wDJAAFGh7njoCtGig031YaKz4kj6n4ndG8D
	 HZFB55we2FF2D9beoZaDFZL4aLcXVkApD5HdGHPl74t+Kd8w5V27QCT3YBO49TGbsK8eG
	 0IEwQeVVn7E8SBnaDeL92Rpx6o6N9BUM6lYiVWu7AlZUDpnRqOWy8C5eB8LsgOpVx61em
	 wqhdLD6TC6AMN25Cv7SXop+8U2jWclylNL/sztwEupdXh4VNzJf+yiCWR+Up38jdEzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794326808;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0DDeYZpHzzROguF9lyPuaY1CHJCR9h3uzMreqdW2gJs=;
	b=o7SOtXIntS/EHsmn05zC4xS/k/roNCg/7G9ehZASrRsNTCD6BSdEtOBcZWt7gqVnhGhB
	 APmHNLleQHqJ5MdwgTyIwbDofAhWD1XRjauE5XWyy2+82+eq3pR0SEDLiQWNMiNvszMoA
	 aNzSu5KCUHOz001/w7HXp0mDlA/1iA37cWWoF2ZoMYdERsB3g2R2GI+3qEQVHC8IGk7zE
	 pFcB4/0u03fQQfdf1FTvQx1vt7FKKbyyoh40iEClaFGBGKUoxcQifZ4rU2G1ZJpjpTK8Q
	 MtTIfp8D16+dFljyQrX4tp1NgVdEN5vT954RxrSi51UA+4n9deW8ufAabMewMGq+RsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fBNURoF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697D6606A31C;
	Tue, 10 Nov 2026 16:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fBNURoF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7F51F008A4;
	Tue, 10 Nov 2026 16:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326807;
	bh=0DDeYZpHzzROguF9lyPuaY1CHJCR9h3uzMreqdW2gJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fBNURoF3SpIQ+1u/L/vJH9yTi7jjpF/LfGmCnCS4ZlB43sq325sk25Xln1uDyKGm0
	 lOuDjlBdR2vc4gxKnWLP4FZr7KWMvp1KCcuInFw+KgGwJTPcQ/DckxtStIy4hvaIn8
	 uBB9SiYySA5YEGXwT1YwT3B3Qjxr14x/B2roBES2YBfPYQ9WUVy7hY3fALkNo3vCA8
	 i/6Ng50rzinheI71+x8dM2Y6sTh91nyPuwmBqt+BeKDusgGngDpBsRb3nhevl2UuNC
	 aQnayy0nanbgbQQEpcDLau3rWsVH3hGrNNDPZG90a4lNdQUeNnqxGw7RngHtXRSVEb
	 OBzz5ffKARBBQ==
Date: Tue, 10 Nov 2026 06:06:46 -1000
From: Tejun Heo <tj@kernel.org>
To: Zhe Liu <liuzhe1@kylinos.cn>
Cc: axboe@kernel.dk, josef@toxicpanda.com, yukuai@fygo.io,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH 0/3] blkcg: decouple cgroup v1 I/O accounting from
 throttling
Message-ID: <avNBFpWArSrjv6Qv@slm.duckdns.org>
References: <20261110103201.762861-1-liuzhe1@kylinos.cn>
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
Content-Disposition: inline
In-Reply-To: <20261110103201.762861-1-liuzhe1@kylinos.cn>

On Tue, Nov 10, 2026 at 06:31:58PM +0800, Zhe Liu wrote:
> Commit a3166c51702b ("blk-throttle: delay initialization until
> configuration") deferred throttle policy activation until an I/O limit is
> configured. However, cgroup v1 accounting still lives in the throttle
> policy and is performed after the activation check in blk_should_throtl().
> Without an activated throttle policy, v1 statistics such as
> blkio.throttle.io_service_bytes remain zero even while I/O is issued.
> 
> This forces cgroup v1 users to configure the throttle policy just
> to obtain I/O statistics, even when no throttling is needed.

Maybe just add a module option or sth to blk-throtl to initialize eagerly? I
don't think it makes sense to update cgroup1 significnatly at this point.

Thanks.

-- 
tejun
