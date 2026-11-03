Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714490;
	b=uFq0y87qdiGcoMe+F7AmGDOgrrTebojDZFD3lCIlWPw+HzsSw2AhKAsZ44wP33wgMMBR
	 stuWFbJ6P6BRFl/DmvUbXk2DcbpCEM5dlBapr/qzjh61USKRGEL/mnWGj8AJUfoiOMcT6
	 lvWNCBjSFMFhPlQ5Tp3SDqtmbbDMO5yMoL3I0gXEMYho7yFhAX5y1dXyforA3+dV9nZN9
	 q4Z/oYV0GlOCPPRMfKxr1+CsY2O+Z7akMGYCisRp28QX6WaQ1qvS1uECbhISVa8GEFP38
	 oiV0Zec0cGpE75Bq9yD0q+Yy6wE8xMkJI1b1L51wxlpPmTIwlIgW0/GZkirdJaWQ1XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714490;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=bPRbykHolawBfCGnDVRos5HJS/K/9CLK+rvFUUZN+bY=;
	b=CU9ZuKwDn3jWa0VfRFp0Eo0t3Th5igYQgId9jtQooV6lzTSUqxdJ5o+7lL8TXy2S+cBO
	 i8QE7xrTxgBz+WTTN0a8STjkQxLHJjCdZbv/mo47XX0PqZanwmhGaVKEtwC6iOLK00OM/
	 bsnMd+3HAytcGCMijbR9NozUvsZXiYXnTPe/7I54JtBxoB1zqhABSRsVrl2stcFVFtSb+
	 RmwquSY5KdkkVPPCSL0XjsECq4YzgaPWauSWX4ldz5s8xOY1Gsb3DyZQzkzH1L0jEgN9R
	 jLxLIvDCJQa/lLB2RzJKtbp96EFm89FiHICNp+La3/U8tLVzvpxe5QFsypNKSwIG6/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNvyMkl7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46AC6082BFD;
	Tue,  3 Nov 2026 14:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNvyMkl7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2871F00A23;
	Tue,  3 Nov 2026 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714489;
	bh=bPRbykHolawBfCGnDVRos5HJS/K/9CLK+rvFUUZN+bY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RNvyMkl77/wB+TKUhO6X/Vsf2i8uYfQQHsCp2e6sIBV03LbpJ6GxqHxSUHPSpQTNZ
	 CI6rBm9JwRP2j7gDDaJ0y/HQLz6p+tN7IqgT+BVC7+kA4sGZS8K1SVjiC3OitAdmCZ
	 dnSjPivgNrMVhBrtEPnov1DXrYT1RLN0jluXjbTdgArGhwCYXQcu+Pz/M94xSpesUV
	 d/U62dXS00RO3dSOT8j+AIg5KMJ+kMga7RIMhFbTJK4cDrD0a0vHQOgN49kKEUz48R
	 RJ8/1JIm3uiZD5egP7DXyHHDKOftJyx91tyK/sOGckJ/q6Udv88hpE2LDUjFPp4fko
	 py1IrVmFnuSjA==
Date: Tue, 3 Nov 2026 15:01:26 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH 2/6] kthread: Keep unbound kthreads off nohz_full CPUs
Message-ID: <aunpNqPV38FG94-f@localhost.localdomain>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-3-matthew.ruffell@canonical.com>
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
In-Reply-To: <20261103075940.110308-3-matthew.ruffell@canonical.com>

Le Tue, Nov 03, 2026 at 08:59:36PM +1300, Matthew Ruffell a écrit :
> From: Caron Wills <caron.wills@pulsar.com>
> 
> Since commit 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for
> preferred affinity management") kthread_fetch_affinity() only removes
> domain isolated CPUs from a kthread's affinity, assuming that nohz_full
> CPUs are always domain isolated as well. Up to v6.13 every kthread
> inherited kthreadd's affinity to housekeeping_cpumask(HK_TYPE_KTHREAD),
> and from v6.14 the preferred affinity was filtered with HK_TYPE_KTHREAD,
> so nohz_full CPUs were always excluded.

This was done on purpose because on all setup we have met so far, it didn't
make sense to run nohz_full with load balancing. After all the point is to
run a pinned single task on a single CPU. We have seen too many misconfigured
CPU isolation workloads due to that constraint not being enforced since the
origins.

I'm open to counter-arguments of course but you better have a good case.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
