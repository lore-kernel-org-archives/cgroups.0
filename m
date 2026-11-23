Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795469942;
	b=yq5Ap9kj+4LEq1h7zVii2S3X/1w5U3kU5zWb0k7AFWHgINmFcNKTnGiEkQN1xoWet3an
	 SCRKcAwOTBU0a4jinx/VsxcKmUvFXjHlfW0187ASp/2BpRYkDSf48RGmOEBOQygYmw7yO
	 Pa9bBEM99PluumxFNA6jAYj+SuEu65DLwRu22KTpZ32+avR/EdxDRrYAAbjk9BVlbz84R
	 UEfDZqRDJdelfID1yUePuu3v3OoCwoCrZDvJurddeBfdicLGCcER9T/KPP11ZKaVClgoe
	 IdaYgt81KpFUN9LawHVHXNQCYSbjsUXik63PT3bZ7NwfdfCCDV1KPN6dgHV6Ub+ceAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795469942;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=nbmQkIvRLVdFOAYiJIL6uBw5exqgidSk3FRXW7G0kUg=;
	b=O6OmctkTyhgaUTlM9jOZ+9Fo212H7lc/ZHJsFDrHoMs8N0BykKDUZwKTukHw2vYuVxh8
	 ZNwRFGd0s51Z7Yi/eIMxoPrsVzS68DMrLI6cLpGvTxdskhUIKQqg8fBWBRZVjajz+3+7p
	 71wgKN2JsHBGs840D9uijn9E8Y/bieDogffH/qCSiMUmx7i4hn1LJOn1aBaE2SPae135m
	 w7IBjF8DuejDtU73V2WuuuSiYyS51lVj0HbP8GSnPEKQCevTtgYBjb66cF6AXsBp4pWN/
	 UWvNQ74ZvRBt7i7E71B6rlkB9jNcKpiGuvhega6ZJSxf38FGhISGHZGIdHESlGH6ZAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="V/uPvUDG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6D2606A31E;
	Mon, 23 Nov 2026 21:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V/uPvUDG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175BA1F000C6;
	Mon, 23 Nov 2026 21:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795469941;
	bh=nbmQkIvRLVdFOAYiJIL6uBw5exqgidSk3FRXW7G0kUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V/uPvUDGe3d7Iejc9m7zVVeqthtSO0u3ULTbckgTSDH5hhELZv81g7qzyy5zMiUb3
	 jP9+HHOCR7T62GV52L+k6xM8rKKEr4qoUEZLIWGKjrHa7M9Yi8YNARSKBhUtQiJqQh
	 alcdM32Gk9oE32PLLB8iTpIMIK7y+6l39eT54YULqjsltS77gSQP3Kx/YBDmt+NTvG
	 GdNXVH44v8YYARN5z6CGQ8tDw9CzbfnJGA+3i+Jm9114fbJZw7ZwByZa+B9X6o3F5q
	 ae7ElLqCV5zy/yU7j6+BI23u770OoOs1WCNwBtnEkMoCYq5yPrxe2HEt5ikTqPZSvc
	 ZxakFqfeoR7dA==
Date: Mon, 23 Nov 2026 22:38:59 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ridong Chen <ridong.chen@linux.dev>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH-next v2 3/3] cgroup/cpuset: Disallow CPU 0 from being
 used in isolated partition
Message-ID: <awSyc640SLALQvLZ@pavilion.home>
References: <20261123041209.382726-1-longman@redhat.com>
 <20261123041209.382726-4-longman@redhat.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261123041209.382726-4-longman@redhat.com>

Le Sun, Nov 22, 2026 at 11:12:09PM -0500, Waiman Long a écrit :
> Domain isolating CPU 0 can be problematic and may even cause panic in
> some cases. In the near future, we are going to enable dynamic change to
> the nohz_full CPUs to include the CPUs that are in isolated partitions
> via the CPU hotplug mechanism. However, CPU 0 can't be made offline
> for some architectures like x86. IOW, putting CPU 0 in an isolated
> partition may not have the same degree of isolation than other CPUs
> in the isolated partition in the future. For all these reasons, it is
> better to disable its use in an isolated partition.
> 
> Add a new partition error code to indicate to the users that CPU 0 cannot
> be used in an isolated partition. The prstate_housekeeping_conflict()
> function is modified to return the partition error code directly as it
> can be either PERR_HKEEPING or PERR_ISOLCPU0.
> 
> Some existing test cases in test_cpuset_prs.sh are modified to remove
> the use of CPU 0 in isolated partition setup and explicit new test cases
> are added to test that. The NOHZ_FULL test cases also modified to run if
> the "nohz_full" parameters includes all the CPUs except CPU 1-7 instead
> of 0-7. Though it is not recommended to put CPU 0 in the nohz_full boot
> parameter, it is the only way we can test that the cpuset code is able to
> correctly disallow isolating the last nohz_full/domain housekeeping CPU.
> 
> With CPU 0 likely not allowed in the nohz_full list except for powerpc
> and with CPU 0 also disallowed from being domain isolated and offline,
> we will likely have CPU 0 being an always present online housekeeping
> CPU for most kernels. For those kernels, we will not be able to trigger
> partition invalidation due to using up the last nohz_full/domain
> housekeeping CPU in an isolated partition and the NOHZ_FULL test cases
> in test_cpuset_prs.sh will not be run.
> 
> The cgroup-v2.rst documentation file is also modified to indicate that
> CPU 0 cannot be used in an isolated partition.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs
