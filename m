Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795158719;
	b=J11A/B/obWCtD58rW4ueV/xHK2tmXhNM743dbztHQpUmx9KFbsd3p8YG1WrNZc+omJ2k
	 gzJJZ84yNgMivqhWBncsrEKsW0UmzYD0VA8v5FUwt6IuRThEiYvFU0ZHuKenkY0H1mWj0
	 fP4CfCGxpPBQfIPTysrhwDE3MRoZyGo0qNw8AsXzqX4f7k0egbRKH1hveG1uPA43QZXQ8
	 e3C2PNgwSdDXFAz27l9q5O9We6cElWdiVN+gqQUKWpNkxccOr9ElV1xBNqYpkYZvxB9b2
	 8P9T94Qz9rgflHoD7Rem7izETiirxVfcOPpkBdTFnbJE0mScBWwe9OKw3XBQoP/cG0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795158719;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=mx9jCoyCL35kZcFJj4eE8mVv6yBQ3TyEebvwewA9a4g=;
	b=M26yAey1UZUe2IpAR4/XmXQ6d6zzF4rH9H7TUq+YJzL79YuRW3wIXC+RxF9L9jl8xudn
	 qXsf6+I+HgSSLx6yN5VPmMsWfix3nA7BG93bOVR26r6tOdLlEoLF2kCPgNquyRDUN+l5R
	 CuGS2UiveL7GJfrfEdVArMD3XViB/YSC4Kt2HE7gl2ZrfWneiY1ykOJllqaFJSQ8lkazF
	 PivLuy8u0TplHw5LVhcmsTtE/4/nPXrjvOg41T4dOmzTZIAkqtwKsTKDiqRLFzruKFGyp
	 ZrJ1Ho4kZ22m7HB0cnN2zYdi0CTsdJ++uibOMgiaMnb9ADCJUSzG32Jl63Dn7kgD9VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e9U250e2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B6D606A320;
	Fri, 20 Nov 2026 07:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e9U250e2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC081F000D0;
	Fri, 20 Nov 2026 07:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795158718;
	bh=mx9jCoyCL35kZcFJj4eE8mVv6yBQ3TyEebvwewA9a4g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=e9U250e2Gzb07Ntri6FU1jyd1iOeaWowp9mJogUIquiqBmVzVbZWTHY2hyPWe2gd3
	 nyai3xuBcqofgbzO/TpuSQ4cJ1S9qVY5RPYUucXTX3f9omHsgxg7z8epdEontApjuo
	 h1y3niP9km8nnrGQbV8ziWpUeLaRLqmRHem7uE6OOAc+vakPoFbroCNBE6dfDrpE/U
	 5RLYW743BIl6KNhDl2vreez9mItgH/CSGRZaguFN5Y2gun04lNjJQoBDdDf5I/fJ9G
	 m81eyRxobsGLGxZ+G29pbFCIDt6A7cKCNo8RK3KfsR0J1zVq94tLqkd3SP/Vi18nE2
	 E9NszsnlyEHCA==
Date: Thu, 19 Nov 2026 21:11:52 -1000
Message-ID: <e64643aed76382fd9adc3b616cb76948@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jori Koolstra <jkoolstra@xs4all.nl>, Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: allocate in open before taking the active reference
In-Reply-To: <20261119191923.2223993-1-shakeel.butt@linux.dev>
References: <20261119191923.2223993-1-shakeel.butt@linux.dev>
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

On Thu, Nov 19, 2026 at 11:19:22AM -0800, Shakeel Butt wrote:
> kernfs_fop_open() allocates the open file, its seq_file and the open
> node while holding the file's active reference.  The seq_file is
> charged to the opener's memory cgroup, so in a cgroup at its limit the
> allocation reclaims.  Removing the file waits for active references.
> cgroup rmdir does that with cgroup_mutex held, so every cgroup
> operation on the host waits for that reclaim.  Deleting a netdev waits
> the same way with rtnl_lock held.
>
> Allocate them before taking the active reference.  kn->flags already
> says whether the file has ->seq_show, which is all seq_open() needs.
> If the file is removed in the meantime, open fails with -ENODEV as
> before.  Only the prealloc buffer, whose size comes from the ops, and
> ->open() still allocate under the active reference.
>
> In a VM, eight tasks in a 256 MB memory cgroup at its limit, with swap
> writes taking 500 ms, open and read small files of a cgroup that
> another task removes and recreates every 20 ms (60 s, worst of four
> runs):
>
>                                            before    after
>   reclaim with an active reference held     5.0 s        0
>   rmdir waiting for it, cgroup_mutex held  377 ms   6.3 ms
>   mkdir/rmdir of other cgroups             382 ms   125 ms
>
> The rest of the mkdir/rmdir time is waiting for kernfs_rwsem.  Opening
> and closing cgroup files in a loop is as fast as before.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
