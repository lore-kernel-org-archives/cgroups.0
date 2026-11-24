Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795546047;
	b=T9nn+TNQfoucvDHdDSAqWIt0ebiswDJ5b0/F+Hn2+OS+6DG/ArkmPbjQFDKtkKyi9oQQ
	 ToKzi4pYFQwrD6PIG+oUTGZ+kp/1pY7Z+t5r6Hybp6ZxxWZq4JBHwjzNIeB9GD+2RwHzv
	 KPAa8GxGVFvDcDDmN9lD5HoNqpMd9qRSxwvtNvA/sxI8JMEi6yLd9012faUgWRqO04yTb
	 SnC7AGsTf23qNnB76flF5zP0DuCs7k8TClzL0DJsTdzLErywyOxSjFv+0MDuz6vwzf1K6
	 rYQXHhqMjqcY3KfSsJPxVrDZrQd2w7R2olutW2JIvt/5tYrQnt/2iyMe+SBt6Hy5Djw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795546047;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=z2Hsh7q0vkgnrZd8VrB7TvHooxViXh8npaot090DDvQ=;
	b=cMSdMzUTDhYqcoH35YZeisC03UylV8CrWlKoKJla8M7y+f0E+NYNyqLue37eOTyzUrP+
	 MbbDLnY2Eu9RnL18Ae4G9z+zXQ1kS/QMRx5DlICsx69OCC3/Zpg0gbiPtSDCl4Lfox9ix
	 vPKGmrEMvtuss8Zn+WgTEvY8m+P/yPd4WnHaKqs8SQIx41iILGBGls96cBnLAyAp8UZy+
	 JCs3ebMrBGDeAOWThoP0onnDVzcxPNize1lCmK8pXYL0U3eo3d8/Na/PUVE+P12ICQJIl
	 cNyIbds1fJ9nnkwYLgeqKwVN+6sHYGyO3vqQG7xeCSn+vEKHfUX9RvYyZOPRTLBaBZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUGYs84X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A20C606A321;
	Tue, 24 Nov 2026 18:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUGYs84X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2561D1F000C6;
	Tue, 24 Nov 2026 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795546047;
	bh=z2Hsh7q0vkgnrZd8VrB7TvHooxViXh8npaot090DDvQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SUGYs84X+rHx5Jhlz9tqODYGR3XBGKt5MJ8kY5HpsHzHjv+cAm2NKkVpcNcA1rdRp
	 vyRqt76aLpxH04KjUvcLxppU2kFsjMWsLKDOZaAaagXJRgBiqCiKU/gfk1sWYk/koz
	 axF9qE5lOPneSDvBXg/aX6IeFVHWI/ezOWUCD8BjIBft/9YScOEFnbyRgqfgB4ETp8
	 FhDjgcdZLmvRddCOdfP7xZzReN+Q7YuzhCOoulSO74vuuzt4Ixx318eWEsAhN8/rL1
	 wHVHWTiXddMGDC2kDJes3v6+MwX4pI73E3nMDt/yww+mNzmVVUEriFYZJHZ9Zqs3Hm
	 aSPO0B1SYYwvw==
Date: Tue, 24 Nov 2026 08:47:26 -1000
Message-ID: <837253372dc1b40de4e20924c1e4549d@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, kolyshkin@gmail.com, chris@chrisdown.name, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH 0/2] cgroup: list processes whose leader has exited where their threads are
In-Reply-To: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
References: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
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

Hello, Zhan.

On Tue, Nov 24, 2026 at 11:35:45AM +0800, Zhan Xusheng wrote:
> This implements Tejun's suggestion in [1].  Patch 1 makes PROCS walks
> visit an exited leader left behind by a cgroup.procs migration at the
> first live thread of its process.  Patch 2 makes the memcg OOM group
> lookup do the same.

The main problem I see is that it's difficult to keep the walks intact
this way. The thread that a leader is visited at is picked by testing
PF_EXITING, which isn't synchronized with css_set_lock, so, as the comment
in patch 1 notes, a walk can skip a process or visit it more than once. A
walk shouldn't miss processes.

It also looks fragile in general. AFAICS, only cgroup_migrate() sets
cg_leader_left, so when a cgroup.subtree_control write moves the threads
to a new css_set, a walk of that controller's css, e.g. the memcg OOM
scan, still misses the process. And as a walk can now return a leader
whose css_set isn't the process's, every user has to know to use
task_procs_css().

I'm trying out a different approach.

Thanks.

--
tejun
