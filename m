Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498A8494A0E;
	Wed, 21 Jan 2026 17:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769015171; cv=none; b=S9sK5ih3pYzR/lnnfLQjZdBp06O5AtYMZasX3Fjxb5KbsXe4fpngUMbNtjp/NWpvBaUHuJ/iu3E4hoR38VsxD2/uSjOajTnGzznoqwMX52bwgP1uQVeLnSpdrCScj/yTnsJdmiwAgGfzw7c/2aVE+/qthFmT0aVWQqFifvU0C2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769015171; c=relaxed/simple;
	bh=ida7uC1+IcLm3mH5OnwxhdYHy+GE2IR1NjNzomFuB9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNQRhm7O2eSVBMjpyKOkwzg0ugFP3BsiXeiR52+8L5PH5+1POdegu3kR8P+EuRdHSSW3s1FzEaxvxDC9i3TgCDOmeIJg/9AKTeEkhxkFLEZQtRX3qGFdpB8yxe6am5VemxUYGcHHzpQPPOpridnsKDDNNBzzW1N8Vsc4YMdB8Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YurHeLrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YurHeLrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A976C4CEF1;
	Wed, 21 Jan 2026 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769015170;
	bh=ida7uC1+IcLm3mH5OnwxhdYHy+GE2IR1NjNzomFuB9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YurHeLrj0Kc1Z0kXwWObFZEVHgWtGcldhLnc/9rTtIWDrfOF5OHZhBDWWdjOE+462
	 fvExXn7KnbYEhXpWGo0kukD1NpS4gyjv+Pr7pHR+Giv+UGDKpFQR4jiFII2JYw6KuB
	 7Y8ozd5liCmajIIf/Gyx/RwYNYOZ5mWwJctr8S8J+TzMEv3rCWxOO3RhAdYzLaQL+n
	 6gnoTvdwYhSMdpeIgae4LwcnvIuh1RGjcBa0Uwy7/qPLVdXh1CzAp+l96r9ZaxuEan
	 Q0gajJnqRVo0ClKW8SRy7uN+F5eE04OGnRK255rIs66OEyyWUFcE6wDDLeD0IN5rPp
	 vKuYKaTb2eaLg==
Date: Wed, 21 Jan 2026 18:06:07 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Will Deacon <will@kernel.org>
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
Message-ID: <aXEHf5nbZMI8LT4b@localhost.localdomain>
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-30-frederic@kernel.org>
 <aW-cAlJCtI5Qtify@willie-the-truck>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aW-cAlJCtI5Qtify@willie-the-truck>

Le Tue, Jan 20, 2026 at 03:15:14PM +0000, Will Deacon a écrit :
> Hi Frederic,
> 
> On Thu, Jan 01, 2026 at 11:13:54PM +0100, Frederic Weisbecker wrote:
> > When none of the allowed CPUs of a task are online, it gets migrated
> > to the fallback cpumask which is all the non nohz_full CPUs.
> > 
> > However just like nohz_full CPUs, domain isolated CPUs don't want to be
> > disturbed by tasks that have lost their CPU affinities.
> > 
> > And since nohz_full rely on domain isolation to work correctly, the
> > housekeeping mask of domain isolated CPUs should always be a superset of
> > the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> > domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> > CPUs that are not domain isolated):
> > 
> > 	HK_TYPE_DOMAIN | HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
> > 
> > Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> > tasks and since this cpumask can be modified at runtime, make sure
> > that 32 bits support CPUs on ARM64 mismatched systems are not isolated
> > by cpusets.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > Reviewed-by: Waiman Long <longman@redhat.com>
> > ---
> >  arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
> >  include/linux/cpu.h            |  4 ++++
> >  kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
> >  3 files changed, 33 insertions(+), 6 deletions(-)
> 
> tbh, I'd also be fine just saying that isolation isn't reliable on these
> systems and then you don't need to add the extra arch hook.

Hmm, I think I heard about nohz_full usage on arm64 but I'm not sure.
And I usually expect isolcpus or cpuset isolated partitions to be even
more broadly used, it's lighter isolation with less constraints.

Anyway you're probably right that we could remove isolation support here
but I don't want to break any existing user.

> Whatever you prefer, but please can you update the text in
> Documentation/arch/arm64/asymmetric-32bit.rst to cover the interaction
> between the asymmetric stuff and cpu isolation?

I'll keep that path and update the documentation. I guess we can still
consider removing that support afterward. If we do so anyway, it would
deserve its own patchset and shouldn't be hidden in this pile.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
