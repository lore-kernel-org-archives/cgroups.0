Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793795498;
	b=nGmUWx0//h9EPhO05HzVxFpr5xrcYaxyCUMoPaAogv48CoUhDa46FdkF1wln2eleLg6E
	 L1cPBdEiOSkPRqup8BSXa6/tbDqJEhB8wOMPNxIDHZ6aaEcNO1ucf1f6kt4m9/LAdG0q5
	 IfeGtL3lJJhxxxWQT2iemxtvVBza2JNeqFaXu06p/eMYbI38FWCXgk2vE8Y48mgyW+vpT
	 89IXejXxH7eeAMOaRTTYMpZ10wE158SSugtM4em9Rv8Xno18eCv6YJ9WEiNgroCSffplU
	 lDay8hZh3UNdHnl5k5312G2n4hNjzbazm/0/u5Nez7FxIYEsce0mze8cMtzr/9N9beA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793795498;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=d7N3s/Fk0FC0DIJXDd2TXVzu86yiov/bVF/UpU5EDxA=;
	b=pAOwdiNSXRVYZKrbF+yXqbsZItTT5iVweU0LCjL2+KDfuI5R9NoDoKlQY2SLdDJ7MmDq
	 vHvOLoPzYlMYZ4yMPkjpLYjoz6/HwUHrS9+z7DW6p5nFnK3hvF06bQjf4pKrYWwxNI8BI
	 JlqkAFjtFbm8CIZe5h47TwOmFBd/iwh5TN6d+U9uTlrewNQGFvtgWjP2pGMFoX//4B1nO
	 RGZte0uXctAKXhN9dDBIlLlbTBI8huwWP59MrZpJNzz67CB6ZrpCijuRB5VeGbwmMlQY4
	 osvlNPX/ttFlGLwnPGcT4aB7rPb/Y4/1kLS3DUfb97cGApj3Up/oUnLjKLiigEMZpsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j+JjsJAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67220606A31B;
	Wed,  4 Nov 2026 12:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j+JjsJAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9431F000C1;
	Wed,  4 Nov 2026 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793795498;
	bh=d7N3s/Fk0FC0DIJXDd2TXVzu86yiov/bVF/UpU5EDxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j+JjsJAYkPpZEw11dLp/jNcSe2cW7ZtaW501/o17Jebog2qcBPsZHeT2iz62r2ae1
	 WLk4RorrJUNOZk1wfUVtX0q/D2494vTsgA6m1EkyzcnRqumKVl5JkWhU/xmkSy6WqX
	 OOdehNRcyKKe4Wzk6WK50t2c7/27ovl2oC8hmpafP6aCD5rDynipvmry4fIUcYmpb2
	 tD0bdg5ktq+JKFY1K90H6FiBXm3qP5N7gf+YBI/gFda4CBZvVyPyG/wEgdhShr+/OI
	 xBB8dE+rAHcXcTnvsv+xYB4B9Vz8KDFpbsWF3dJxEfs64gbpZIUL1iT/IV5GQp1yRM
	 bqcbnsNEabvcw==
Date: Wed, 4 Nov 2026 13:31:35 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Matthew Ruffell <matthew.ruffell@canonical.com>,
	Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <auslp4kRazpwtlKZ@localhost.localdomain>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-3-matthew.ruffell@canonical.com>
 <aunpNqPV38FG94-f@localhost.localdomain>
 <c9b24dd9-8c6a-4d35-8f68-07274f06299d@redhat.com>
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
In-Reply-To: <c9b24dd9-8c6a-4d35-8f68-07274f06299d@redhat.com>

Le Tue, Nov 03, 2026 at 10:13:38AM -0500, Waiman Long a écrit :
> On 11/3/26 9:01 AM, Frederic Weisbecker wrote:
> > Le Tue, Nov 03, 2026 at 08:59:36PM +1300, Matthew Ruffell a écrit :
> > > From: Caron Wills <caron.wills@pulsar.com>
> > > 
> > > Since commit 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for
> > > preferred affinity management") kthread_fetch_affinity() only removes
> > > domain isolated CPUs from a kthread's affinity, assuming that nohz_full
> > > CPUs are always domain isolated as well. Up to v6.13 every kthread
> > > inherited kthreadd's affinity to housekeeping_cpumask(HK_TYPE_KTHREAD),
> > > and from v6.14 the preferred affinity was filtered with HK_TYPE_KTHREAD,
> > > so nohz_full CPUs were always excluded.
> > This was done on purpose because on all setup we have met so far, it didn't
> > make sense to run nohz_full with load balancing. After all the point is to
> > run a pinned single task on a single CPU. We have seen too many misconfigured
> > CPU isolation workloads due to that constraint not being enforced since the
> > origins.
> > 
> > I'm open to counter-arguments of course but you better have a good case.
> 
> I do see configurations where nohz_full/managed_irq CPUs are set at boot
> time without isolcpus=domain. But these nohz_full CPUs are there as a backup
> in case some latency critical workloads need a set of fully isolated CPUs to
> run on.

Sure.

> Right now, isolcpus=domain can be set dynamically by using the
> cpuset isolated partition feature and they will be used when the need
> arises.

Exactly. Whathever way you use to do domain isolation.

-- 
Frederic Weisbecker
SUSE Labs
