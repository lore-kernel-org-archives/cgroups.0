Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF494245012;
	Mon, 26 Jan 2026 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769435535; cv=none; b=BrfM0dmAti2cZ1bT4uVYA41NG0Xg9jG6BpeuzBD2Q2YTgjioq9OO2k87ovuciQpVXxReL0TlIUxN5qPpCGMCHYVqBLAxgnsPQV1yhA8rpsOsaYl7KMeeDAMZI0+gqwgTTtxhQccHczUckcMIpTPPpLBfHy3DfAvjM5HL2TQjQqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769435535; c=relaxed/simple;
	bh=kcA2cPiJEC19HBEstbYBifZWvAw98I0XK00+8H10mco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COy4BX2RBRqXVkb24tlUo0n3vroEDHvCudZtWO78gOb0D85lnYqkY3ZygHyc1xIMzo7ud47dAUDOKRLtr85aNuMxEv53JsRIsDwRsjNse4eM7lLzyE5BGR750OXgq8mw2EHrAoANxugkzz/gc+5JO9HCJFh7gTlK5Uf92+eJ9IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kVVmZvFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kVVmZvFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D689CC116C6;
	Mon, 26 Jan 2026 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769435535;
	bh=kcA2cPiJEC19HBEstbYBifZWvAw98I0XK00+8H10mco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kVVmZvFr+CRLz0dBd5XLWyUavbW8nCgjkNtfsZ68viSoUlQzfs77mgqO6yT/jpeN8
	 pg7kQkZ+GT9I3gBbH5KSW1N19v6LZBDwYGLOWXiqcQylBZ5g4+KO6kKGQcqEiAcp10
	 ausowbCOUHsZ9bfKrKj7R3xBLNET1yxkp9J+5MLTEWX7f4No1SfT5XTL6aSPrTfT+N
	 bCZy9asASdQMt42TI+gLu+rK/RLraHfA4D5BqFAPeAolk0a/hyw0wdylU0k19HWyrL
	 x4wXKWwVwt8GOfxwvDBurrXf2OyecnDAn/Q+0+zLdQYHvjvwQgg6PufPEP9PU1/i/q
	 WOFYplVNvnCcg==
Date: Mon, 26 Jan 2026 13:52:05 +0000
From: Will Deacon <will@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 29/33] sched/arm64: Move fallback task cpumask to
 HK_TYPE_DOMAIN
Message-ID: <aXdxhfVLqyv-2SDX@willie-the-truck>
References: <20260125224541.50226-1-frederic@kernel.org>
 <20260125224541.50226-30-frederic@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125224541.50226-30-frederic@kernel.org>

On Sun, Jan 25, 2026 at 11:45:36PM +0100, Frederic Weisbecker wrote:
> When none of the allowed CPUs of a task are online, it gets migrated
> to the fallback cpumask which is all the non nohz_full CPUs.
> 
> However just like nohz_full CPUs, domain isolated CPUs don't want to be
> disturbed by tasks that have lost their CPU affinities.
> 
> And since nohz_full rely on domain isolation to work correctly, the
> housekeeping mask of domain isolated CPUs should always be a subset of
> the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> CPUs that are not domain isolated):
> 
> 	HK_TYPE_DOMAIN & HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
> 
> Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> tasks. Note that cpuset isolated partitions are not supported on those
> systems and may result in undefined behaviour.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Reviewed-by: Waiman Long <longman@redhat.com>
> ---
>  Documentation/arch/arm64/asymmetric-32bit.rst | 12 ++++++++----
>  arch/arm64/kernel/cpufeature.c                |  6 +++---
>  2 files changed, 11 insertions(+), 7 deletions(-)

Thanks, Frederic, this looks much better to me. I also chucked my old
tests at it and it looked good, so:

Acked-by: Will Deacon <will@kernel.org>
Tested-by: Will Deacon <will@kernel.org>

Will
