Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EC031196F;
	Tue, 27 Jan 2026 12:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769517909; cv=none; b=lSaDGX+vfHBP5n5Pq9+3wdY0jj5gTkKrSdKnBkT22eVxosjmYrX747N1J7hONcm3HhopVBxy7dX9lO5IphbQi8vKDCxRGS2kGEOFR47iXNsa3WtxMff+RQ2/GrM50PS8I7qDjhc5VB3tf4UrmZKNIG098uVx9EoPgS7MEXLcIDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769517909; c=relaxed/simple;
	bh=ofe10jGZoPAqJE9FQOSEtDptbVaYpx/CGbuhre/HHNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sY28Rn/e1mXjEU2LhmjdcPJH81QrLEnSpQwoivZDBNh1UzjSHjL5Mgvd9+5s/Pm5peJ4cEO5ywkCytNg0Gw0v/+rEhP/gncGyNmEfbfOV3rrRcmC+KF8P6h2NsNi5Ovd0q3QMmrvB/uZsq1ItPJe7UiUWBi/thOktr2/LO/ICjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqptSIfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqptSIfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACFEC116C6;
	Tue, 27 Jan 2026 12:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769517909;
	bh=ofe10jGZoPAqJE9FQOSEtDptbVaYpx/CGbuhre/HHNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZqptSIfLm29TLryUzU52GQpI9Y5j/egT2jG8/oQhaPPiFuy2brZcTTjX8upURbbwK
	 O2avXbgCiqu9oze4K2pbYNChHpLvtm1Jz9vMFgmPsvm1Qg+qCGw0xz/oS/xiGbbAQa
	 SpjcCq8AzzyIPMh00tl2Kgj9nT4Pwz/av8vbzs9TI8IvS0TbBOA5TPk5EJhldEKCd8
	 z9JwUU8X8St7FkUL33asPHS0EmzbQdBqKLrg7pOsDN/QpZKsgStUPPRJtFFRc43nWE
	 6CsKod/Uczqk8wBl9Y2/65PFXOSK8XPZjs8cgK1siNQjv5//Rrl9afMnIDi/jt4EBR
	 gt2lbSbmoncAQ==
Date: Tue, 27 Jan 2026 13:45:06 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Michal Hocko <mhocko@suse.com>
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
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 03/33] memcg: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aXizUsfywjtIIN50@localhost.localdomain>
References: <20260125224541.50226-1-frederic@kernel.org>
 <20260125224541.50226-4-frederic@kernel.org>
 <aXeZQoSHJ9QX7B6W@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXeZQoSHJ9QX7B6W@tiehlicka>

Le Mon, Jan 26, 2026 at 05:41:38PM +0100, Michal Hocko a écrit :
> On Sun 25-01-26 23:45:10, Frederic Weisbecker wrote:
> > The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
> > runtime. In order to synchronize against memcg workqueue to make sure
> > that no asynchronous draining is pending or executing on a newly made
> > isolated CPU, target and queue a drain work under the same RCU critical
> > section.
> > 
> > Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
> > workqueue flush will also be issued in a further change to make sure
> > that no work remains pending after a CPU has been made isolated.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >  mm/memcontrol.c | 21 +++++++++++++++++----
> >  1 file changed, 17 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index be810c1fbfc3..2289a0299331 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2003,6 +2003,19 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
> >  	return flush;
> >  }
> >  
> > +static void schedule_drain_work(int cpu, struct work_struct *work)
> > +{
> > +	/*
> > +	 * Protect housekeeping cpumask read and work enqueue together
> > +	 * in the same RCU critical section so that later cpuset isolated
> > +	 * partition update only need to wait for an RCU GP and flush the
> > +	 * pending work on newly isolated CPUs.
> > +	 */
> > +	guard(rcu)();
> > +	if (!cpu_is_isolated(cpu))
> > +		schedule_work_on(cpu, work);
> 
> Shouldn't this in the guarded rcu section?

This is what guard(rcu)() does, right?
Or am I missing something?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
