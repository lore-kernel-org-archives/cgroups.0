Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175732;
	b=VjGlIq9m7tc/eAAzYki8JNyyu68tgoTvVPcfaeeTDNdhkWhXKc0bvoMthSUmailXp2bI
	 2Sx/rr1FOtLqoAl3Pq8i0R+K439/AqDoomm2LwDXuYd8KwUG5SA6krkNeWpZxKyykuncr
	 PTlJNjQ+uuivEPGWxelR2mHIzbLok5P8CY6e7SIVhiFAilWe3h3Ycnd0aejnPaB/mBxk5
	 t0jW/yYg7mQ0uB1U/oSWMHFKj5+kaTxRgJcovvlwFiiO5K/stuuFvb5PfiLk0EgaH2Eiv
	 RO16Dsb9A4uKk3YVz0sBETcxsQrv9/nNlyTvVZ+eotG6SmPmLCAREntxdMPz2m/1X9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175732;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gXZGtUUKJlB0JAEvQjueae9grBIYVg16MV9B05CzPJI=;
	b=wOlQxEX4X1f2eisUcEgc1vfcNPeqfgMZGVesTKuFPboL0wPutyaiBdNcsbykB/Zdyt55
	 ekgxm+4+7gku410ifbXNB0XaorWyc1E6ScHZu8p1P53upM7t2vwsnuA1SutwNbKLQVFh6
	 Itm4kHPhNa2rhq4OvHoqXTSjhn6cc/Q0kiiBhWT7nxFk9tyynSEzX7D6mCA6UX5OIAkLd
	 usZbk2Qvk5EPS362O+p1rdcMlSnM+NmIyf7w5iCed9jMkuGTW9u2r7tpRa7PRA+IK5cq6
	 9qig7WrcMYUwwBP3tHC9o9KPuWALTnGl3AN7bpwT6ewV23T8L1VnaN+BSro72xyeV9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fDTnja3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D08606A326;
	Fri, 20 Nov 2026 11:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fDTnja3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC63C1F000C6;
	Fri, 20 Nov 2026 11:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795175732;
	bh=gXZGtUUKJlB0JAEvQjueae9grBIYVg16MV9B05CzPJI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fDTnja3xaysTL7sjgCdcE04GjF+K6DYVz/01WtDrfaXMpW1L2MtviUern5vw9RHhn
	 cFyFl2qswrSfsj8qgZ69JsSdEx7Ecv4XQZL4Pu4owytw0CZ28BfkUTjBqPv1WWqa3G
	 WO48Ze3W8KBpTYXSl79Zg2khrMASjuhq4u7JvIjDVJ7Hi2amH0Sq1O50jbDj6FriUG
	 F9vxn2Wy1CTg3f5GQz8xRtYX//HKR9ryfK2huhfvOFSzEt/h3g7UO00ND5zePQK2R8
	 2NIbckPUnN+VWRLPu0iA3cwo1PPVaukNVr02c8Jzt4J+VQ/H9zTFbmRO/csK/27s/l
	 me50+TD3yzlsg==
Date: Fri, 20 Nov 2026 01:55:31 -1000
Message-ID: <6fef47e08a37079c08806b3c57994778@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: luca abeni <luca.abeni@santannapisa.it>
Cc: Yuri Andriaccio <yurand2000@gmail.com>, bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com, hannes@cmpxchg.org, juri.lelli@redhat.com, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com, yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
In-Reply-To: <20261120120659.2e902463@linux.fritz.box>
References: <20261109163616.195264-1-yurand2000@gmail.com> <212c244d534ee1fdb0538a980789e16c@kernel.org> <20261111175657.250354-1-yurand2000@gmail.com> <58cb2cbaf82c0f671213eaca46465cd5@kernel.org> <20261119151416.33f90a64@linux.fritz.box> <471bf8d446becabfca00041fb2a78067@kernel.org> <20261120120659.2e902463@linux.fritz.box>
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

Hello, Luca.

On Fri, Nov 20, 2026 at 12:06:59PM +0100, luca abeni wrote:
> In other words, if tasks can migrate between cores, performance
> guarantees should be "per-cgroup", not per-CPU, which makes it
> difficult to mix "(runtime, period)" and "max" in the same cgroup.

Thanks for the example. I can see that the mixed config is difficult
to analyze. What I don't follow is why the kernel has to enforce it.
Again, this is purely from the interface POV, but wouldn't it be
enough for the kernel to provide the mechanism and leave what gets
built on top of it to the users?

> I do not know much about IO device and io.max, sorry... But maybe the
> difference is that tasks do not "migrate" between different devices?

Yeah, that's different, so the analogy isn't perfect. The allocation
side isn't different tho. One can construct an analogous, if
contorted, case with block devices. e.g. Imagine multiple disks
serving an identical read-only data set, with io.max used for
bandwidth and performance isolation. A workload which moves across
the disks would be essentially the same model as threads moving
across CPUs.

> I also fear this kind of solution can increase the probability of
> misconfiguring the system (ending up with the feature not being used).

I'm not sure baking the constraint into the interface would make
people use it more.

> Yes, I think this is OK. It means that hierarchical scheduling is
> disabled by default, and the administrator has to write something in
> the root cgroup to enable it.

That's not what I meant. With the root at "max", nothing has to be
written to the root. A cgroup can be given a budget right away and
the budget is admitted against the DL bandwidth directly. An entry on
the root is only needed to set aside bandwidth for cgroups up front.

Thanks.

--
tejun
