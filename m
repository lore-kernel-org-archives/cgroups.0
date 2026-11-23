Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795432407;
	b=z19Qa4cK+O6Kh2oIOSOMUUde+jPV5rraHgeRsLgD6BkOrrUdTB6oV56898yh1fQob3Eb
	 1k5JnjqVQ56whjmfrOEM0hqybTcAI3p4WasGKdjOT24k5w8t73ChtLplKG8MRQWNx68g1
	 ZvKipuc4MXlJ0uzA90+C14FxJx9NQ6qckzi4H4xh/Ruu8gIK0vUb5wfcUxz27zncvykLh
	 H1Pdjk2Bn0CUXhKJXBoFlrgDTMXFBRur+/Mal538+64Ng1z5IQXKarthrSPrYEYUz5i9v
	 C979GOxbnX78YJlghUU5MWAnasBu3sXrpGdcY3ZDq+90DXmXDeX7CPaHt6YxWm2txKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795432407;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=FSNPqJ2wns2AgHtQuJTveAPlZdwvlJJAYiPAVLO7n6w=;
	b=HxmG3SS1gRTLGw89Ydyq9y6rTEz6DMXgtYI2yPeNtnXfCsRY6HtH0bB2CcdW/0s1RQNU
	 rOIynWQAYGQfNtJyuJHp+NjMzngqwuYIzB92bJb1SQdtwOXu4T4CkgHS7sz08YSjyPXxA
	 vB7LBbWixCW5aXCJCze6zYJ5KALuP/6iAjjVGAZkd25iMZc7jM4LinWtLhE016N06RY7/
	 9JVrRFTqxu5HwC7v6n2CXWf+wekGeayQXB/VSjOZdzt3aCnGAB2+T0z8nK34LaqO6ok+o
	 7LPmw3HjJ5evTOMVU27usTOAKHkqc7u9+5OGDQ/it94z7WsWKdwsI06VwAwzR2NNdWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IpMah2Ts;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8E7606A31A;
	Mon, 23 Nov 2026 11:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IpMah2Ts
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAFD1F000CA;
	Mon, 23 Nov 2026 11:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795432406;
	bh=FSNPqJ2wns2AgHtQuJTveAPlZdwvlJJAYiPAVLO7n6w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IpMah2TsMZXWQGbxBbVtoMVRvzKKgY5TUI+7S5hzuVspiJkOSMgC6069CBNRxbWlf
	 +FwwxKYKTg+K9NB0e/SLP0XvcwUjk6RhzDdnDxBKwG97bQacxHsYibYeu7aI8AvyA3
	 ytxRK01EN5fypqN/gzAPM7AnqFH0+ssbzHQlPZ41qmNfNQqV43iFqkzgpycCwNFB21
	 0+4C0p5w0OTTl3RwCFzL+4sh0DFZs/QI77MMWjvDkZWtigi9ptTNQVIrqw3N2lmbqE
	 F/nihpuJXymI3GgwxdWoaqv1eiuozJ0J10Tq4RTiXC4aCQLcBL9EoAjrU0btyHc/rD
	 KVcVR9YIvldEw==
Date: Mon, 23 Nov 2026 01:13:25 -1000
Message-ID: <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, akpm@linux-foundation.org, hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, penguin-kernel@i-love.sakura.ne.jp, mkoutny@suse.com, chris@chrisdown.name, cui.tao@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
In-Reply-To: <awQRT7InNqEF-K8-@tiehlicka>
References: <20261121073222.834282-1-zhanxusheng1024@gmail.com> <awQRT7InNqEF-K8-@tiehlicka>
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

Hello, Michal.

On Mon, Nov 23, 2026 at 11:11:27AM +0100, Michal Hocko wrote:
> Tejun, is there any strong reason to keep the exiting thread group
> leader in the original cgroup? This makes CSS_TASK_ITER_PROCS iteration
> really tricky and error prone as above examples show.

No, and I agree that the leader should follow the rest of the process on
cgroup.procs migrations. It's this way because controllers primarily care
about resources and exiting and zombie tasks don't matter much in that
regard, so migration skips them and controllers don't have to deal with
them. I don't want to change that. It doesn't make much sense to teach
all controllers about them.

That rules out the full migration path for the leader, and moving it
without one looks fragile. If cgroup core switches its css_set without
involving the controllers, ->release() sees a different css from the one
the task exited in, which breaks e.g. pids uncharging, and that still
doesn't work for a leader which is exiting but not dead yet as it's still
running.

Maybe the leader can pretend to be in the new cgroup instead. On
cgroup.procs migrations, record the destination css_set in an exiting or
dead leader without touching the css_set it's actually on. When a
CSS_TASK_ITER_PROCS iteration finds the first live thread of a process
whose leader is exiting or dead, it looks at the leader and visits it
there if the recorded css_set agrees.

That leaves the leader's actual css_set and everything that the
controllers see as they are now. Only the iteration changes, and exiting
and dead leaders are handled the same way.

Thanks.

--
tejun
