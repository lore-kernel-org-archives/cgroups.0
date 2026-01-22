Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10D338B7DB;
	Thu, 22 Jan 2026 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769081360; cv=none; b=mw2El3BDgpzay2O2o+mYTcfAPhXFy9fjHfwIoP+cg9nY5eXckIFzRv9wQxzUOr3JduWxdle0s3EKFev6yUiuVctwKZ611fZ7WImQ5/HhwBUPEmyEq/3gsD1w0SXztXfWx6GgpHgZ1Awjtko8sLk353Me3Qi0A53iGmDF4hGSBJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769081360; c=relaxed/simple;
	bh=WiogiOmlVrEBDmxiYq5jKojVlIXsrZ6n9wcQdU9VhMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OPgrPlq5QZpjrv9139Z3RQV2z/BUJarWMgpUK2SCK9gy7iqxbVpFGEtWqYgMcsPeYB3v7GT+K2NsRR05dbX0pbK3h7IZh3oesYdazyiY/fDVNx3Ndy2RteVJCQKruEaBBR4Hxi/5VCc/VEjdFBCe6npYN8TzIFgQJ2Phs1/fo4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hntVHlxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hntVHlxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAA5C116C6;
	Thu, 22 Jan 2026 11:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769081360;
	bh=WiogiOmlVrEBDmxiYq5jKojVlIXsrZ6n9wcQdU9VhMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hntVHlxvRLtZcEpsFecgcuy2/WeJl9lYH2mWE9f8dZGjyucvG1zCLlgF1anVNM8Mq
	 ATZwc6IftbgZO2kJLtftNKhMvBjvPvqfUNlH6JrZwPiiiEXtxPJi1HRA+GVlhwH0Xl
	 7jI4hCzwdhtpWuORobWzm0YF5J1jsS7gh1CwOGDB5EOeJZKzxHCuCd4SkLrzE/tlGq
	 JVFBs8UA8NYTjNB18RHp1AShNa5zdE3qLITZrz7qt2dsO/+/eP32L9P7IpEILF4h3H
	 3+SL3O++ddzf33ljYPKdsDd6l1rT8hde2RP+XyHB6xkPeaAyuWp9p0Q+aK9fItrNc6
	 XJd/YpjN6/DQQ==
Date: Thu, 22 Jan 2026 12:29:17 +0100
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
Message-ID: <aXIKDduX5qUXvOUX@localhost.localdomain>
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-30-frederic@kernel.org>
 <aW-cAlJCtI5Qtify@willie-the-truck>
 <aXEHf5nbZMI8LT4b@localhost.localdomain>
 <aXH0TZU7UNowTmwc@willie-the-truck>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXH0TZU7UNowTmwc@willie-the-truck>

Le Thu, Jan 22, 2026 at 09:56:29AM +0000, Will Deacon a écrit :
> On Wed, Jan 21, 2026 at 06:06:07PM +0100, Frederic Weisbecker wrote:
> > Le Tue, Jan 20, 2026 at 03:15:14PM +0000, Will Deacon a écrit :
> > > Hi Frederic,
> > > 
> > > On Thu, Jan 01, 2026 at 11:13:54PM +0100, Frederic Weisbecker wrote:
> > > > When none of the allowed CPUs of a task are online, it gets migrated
> > > > to the fallback cpumask which is all the non nohz_full CPUs.
> > > > 
> > > > However just like nohz_full CPUs, domain isolated CPUs don't want to be
> > > > disturbed by tasks that have lost their CPU affinities.
> > > > 
> > > > And since nohz_full rely on domain isolation to work correctly, the
> > > > housekeeping mask of domain isolated CPUs should always be a superset of
> > > > the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> > > > domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> > > > CPUs that are not domain isolated):
> > > > 
> > > > 	HK_TYPE_DOMAIN | HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
> > > > 
> > > > Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> > > > tasks and since this cpumask can be modified at runtime, make sure
> > > > that 32 bits support CPUs on ARM64 mismatched systems are not isolated
> > > > by cpusets.
> > > > 
> > > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > > Reviewed-by: Waiman Long <longman@redhat.com>
> > > > ---
> > > >  arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
> > > >  include/linux/cpu.h            |  4 ++++
> > > >  kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
> > > >  3 files changed, 33 insertions(+), 6 deletions(-)
> > > 
> > > tbh, I'd also be fine just saying that isolation isn't reliable on these
> > > systems and then you don't need to add the extra arch hook.
> > 
> > Hmm, I think I heard about nohz_full usage on arm64 but I'm not sure.
> > And I usually expect isolcpus or cpuset isolated partitions to be even
> > more broadly used, it's lighter isolation with less constraints.
> > 
> > Anyway you're probably right that we could remove isolation support here
> > but I don't want to break any existing user.
> 
> fwiw, I think it's only some Android markets using the mismatched 32-bit
> support and we're definitely not using nohz_full there.

Now that removal becomes appealing. And what about isolcpus= / isolated cpuset
which only consist in scheduler domain isolation? Probably not used by android
either.

Ok but is there a way to detect on early boot that the system has mismatched
32 bits support? Because I need to fail nohz_full= and isolcpus= boot parameters
early on top of this information without waiting for secondary CPUs boot.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
