Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794417972;
	b=vo3AC772J5S/HyRsI1IIU9e5EdhvkeEQBcBdQpYRY8rBJPmNbgxrTltnaNJru878GJjM
	 49BZlZMWkZqotDu46QMRXaVC6gTFUMq/FekfWh/6dI907UvxDm1kqtZDdfm65F4cUlwZz
	 VUjWFyDE0MHQ637uZ1oXyrHc/NZW5F2eE9/XYxWKLC+mwv+1+MKKcwBmxatDp2x/nl17d
	 qI4F+9EuvIE8MR8UdAwFV6xVR2D0/A3Hzba6O7bvNFfuAlZgYcNtbtrywMx41e2DDqhVQ
	 My8QoR07NFjPT8msyYH26uRPKblZMlvoiZwbcPANQ2I29A7f9XMq7A74MXnZ78Udjyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794417972;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=OThUgdRyvc4lxoTP3kBa0mIxxlXkQI4LfzUWh7TiP9I=;
	b=VUjQKpIK8/8+TWh41o9C+/yY+XDxpO2HlwIbLHYHnQHYgUSZuk9qsLHxWnyM+dm0N4id
	 P4Bb0JM+GMbhnv+9/ibYSqKkgp0rsQqDL/TKI80fCHSPiyBzeNQrXGqvcyhbN4Ci4gH6T
	 Z1+dhBoDlsn0xQZS2xlnN9k+yDCUBg5FxRx6ZOr/+sT7pMVrLrBhP06IMPEX76SIGey/H
	 1gStDqjHaYCGBubfVJWOyko4SFNQWizfZPOLnVndfubyY245ZyYYFLkHv11JLTN5GTZ+3
	 +OzxItFUcdMOl89547wKEY30WvCQ4NHZbz1WvxRjm2xUhiwCnEO/i0osrinpA+pBVaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CuXp2vwa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E07D606A32E;
	Wed, 11 Nov 2026 17:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CuXp2vwa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8651F00A05;
	Wed, 11 Nov 2026 17:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794417972;
	bh=OThUgdRyvc4lxoTP3kBa0mIxxlXkQI4LfzUWh7TiP9I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CuXp2vwaYFnHvfNywRg3wWKjb4pg7rf6DTlvmy2kChL21waa+Qs3rpbXeqk4SY93U
	 aLqrLB5KVP7zHn6jdmd6d+oFs3J8d09o1XTOT+/uILCmOe6hQ8uCmjGAF9NgGhmzqg
	 /TTGVjdDgrfknUdURdao5UDL5aBFCLRS9HEZ2kcaX71dO7/AvLtqCh3qToJphtwe46
	 3Jz7GSEvSyWadbi9gH8oJdb4s/1T6qk5+9YALe2lf8P1euYWwTZQ5wsAlmxpH/Y7xl
	 Uj96oQcMJRqkCUPswnYxqsn1GEYx+/BVxeyx5AZMA2B9t/J14hW8MxtzhDb+nfxBF8
	 b4gMlH7n+Vl9A==
Date: Wed, 11 Nov 2026 07:26:11 -1000
Message-ID: <e795d4feb4a4e7ca4cf24f3cde9e301b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Fernand Sieber <sieberf@amazon.com>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, bsegall@google.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, hannes@cmpxchg.org, mkoutny@suse.com, void@manifault.com, arighi@nvidia.com, changwoo@igalia.com, skhan@linuxfoundation.org, corbet@lwn.net, rdunlap@infradead.org, cgroups@vger.kernel.org, sched-ext@lists.linux.dev, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, nh-open-source@amazon.com, hborghor@amazon.de, fmubeen@amazon.de, dwmw@amazon.co.uk, karataev@amazon.com
Subject: Re: [PATCH v2 0/4] sched/fair: cpu.max.runtime and idle refill for CPU credits
In-Reply-To: <20261111122039.47687-1-sieberf@amazon.com>
References: <cover.1794303670.git.sieberf@amazon.com> <3bdd435fd868ed7ca7ea9061e5966b7b@kernel.org> <20261111122039.47687-1-sieberf@amazon.com>
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

Hello, Fernand.

On Wed, Nov 11, 2026 at 02:20:39PM +0200, Fernand Sieber wrote:
> The minimal viable bar for us is to never lose track of CPU credits.
...
> The one case it cannot cover is an unplanned exit, a BPF scheduler
> erroring out or killed by the watchdog and falling back to fair, where
> there is no window for userspace to hand the level back.

Where you set your minimum viable bar isn't an argument for a design
decision. Stating that this is the bar doesn't make it so. It has to be
justifiable in a generic manner.

This is a crashing scheduler. The kernel is going to be scanning all the
CPUs and tasks to abort the in-flight scheduler while pushing all tasks to
temporary dumb FIFO scheduling to make forward progress. Accounting wise,
the credits may not be lost, but how meaningful is that across such a
transition? If a machine is doing this regularly to the point where
accurate accounting on that particular transition matters, credit
accounting is the least of its problems.

Thanks.

--
tejun
