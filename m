Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795157180;
	b=rVxWv83A8aFFKw1KTFrKt+8mkRwVsle6WSsSabz0pedRJmbWwXwzCTvbPQRz6snW5Ftl
	 gCAgh0XKUq7E9rzm6HQM5JmMnIw044Y+7dRb9jXMfk1Sx11CQyWC0GhejG4cf7Yk93NOT
	 nfbVsbH56guPlefW2Zb3iOSbylOPxTsK0ij8XX7DrmzFFtyjSjAFm2hjrI8AVNZQkyekM
	 j9QoUIZz1Ee7nuq+Kg5su2lIVu6qOcNv6kHKFP4pFkaD+NTVSudRiwI5i8hgnrfo420ru
	 PF0AZwaJta2Ob/IDvp63Lk7kKic4nYXnEVmdQcQcaQygPR98sMM1opBFZ5Oh+GT9lZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795157180;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=C/t50vXnTPfcyjVvUVpv2055G/DltYq6hFFmlA7ySbc=;
	b=pIOohR6jhe/Xg06BgXKwnu1qZTTriQr6HmawcULR1hipl+zr2qEebj9i0C3dGSoe68XQ
	 xx4zMkc71lecGnaL6p4Pc2zC3O629P96Rj5XQvp3g7fgOduF8DlQHdFKOc/QQUE88Gm1g
	 bmNUYiD3GibC+6ePzGPaEVI5wPdBUofcGhwOSq+nMg3pvWd2Q0kiAUbgXecwyh0tcxXov
	 o315Hh9MJ3pGfTklGDdrIeOpV+sTX12SWJWwGe1dthnqnsKYIpwpzoBaKmG5qCf0EdDxV
	 J14nWaoy63E3tiL6fnu0EPbfYYy6ja8fwC9bhvdJp4qDRZJ5Rb0RkX1Y5eUmM1ezYLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RdY3EZd3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D2F606A325;
	Fri, 20 Nov 2026 06:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RdY3EZd3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C489A1F000C6;
	Fri, 20 Nov 2026 06:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795157179;
	bh=C/t50vXnTPfcyjVvUVpv2055G/DltYq6hFFmlA7ySbc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RdY3EZd3eBixZBOjQSIcYYlFegr5hMOULP/6FDQ1hHnHusCBQbJXagTizh1FMHYtU
	 xnXrRKX1i/HGu159RWhHNjl7Wi+KyUEaQ3EbqVBvRwqk+nBDY2T4iu/4piIi1/RFZJ
	 Q7x8V5TH195HtZkPRghW0Yi94iNJpdPrBwpq3Zjn0u5ip059Jh5Q7HxqASirmo7PoX
	 l3CN8b6fWGEzB5BYwBTXq0DCwdN8Vj4grEuv1cN28xXGdCMT/Jiv4I1he5VeLOmL03
	 3kv0MJGuvRWfszIceDyzYOC+pCh/rK5JWjGzGOgKRHB3luW4a6xVi9bs0Urbb2TlQA
	 PEVm8nucWvKkA==
Date: Thu, 19 Nov 2026 20:46:18 -1000
Message-ID: <471bf8d446becabfca00041fb2a78067@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: luca abeni <luca.abeni@santannapisa.it>
Cc: Yuri Andriaccio <yurand2000@gmail.com>, bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com, hannes@cmpxchg.org, juri.lelli@redhat.com, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com, yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
In-Reply-To: <20261119151416.33f90a64@linux.fritz.box>
References: <20261109163616.195264-1-yurand2000@gmail.com> <212c244d534ee1fdb0538a980789e16c@kernel.org> <20261111175657.250354-1-yurand2000@gmail.com> <58cb2cbaf82c0f671213eaca46465cd5@kernel.org> <20261119151416.33f90a64@linux.fritz.box>
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

I'm only thinking about this from the interface POV, so please read
the following with that in mind.

On Thu, Nov 19, 2026 at 03:14:16PM +0100, luca abeni wrote:
> ... We believe that mixing "max" cores and cores configured with
> (runtime, period) in the same cgroup is problematic, for various
> reason. From the theoretical point of view, this would mean that when
> migrating between cores a task can "move" from one reservation to a
> different one, creating issues for schedulability analysis.
...
> So, what about a different idea: a cgroup can be "max" or have
> (runtime,period); when we set (runtime,period), this is set for all the
> CPU cores, but then we can override (with runtime 0, or different
> runtime/period) some cores (but we cannot override with "max").

If the interface is per-CPU, I think it should be per-CPU all the way.
What a cgroup has on one CPU shouldn't say anything about what it has
on another. That seems the most consistent in itself and with the
other controllers.

Take Juri's example of a top-level group which has an entry only for
CPU0. Its tasks are limited on CPU0 and not on CPU1, which is what the
config says. io.max works the same way. A limit on one device says
nothing about the other devices, and a device without an entry is at
"max". If the group shouldn't run RT tasks on CPU1, it can be given
runtime=0 there.

Tasks moving across CPUs doesn't change how the resources are
allocated. A task consumes from whatever serves its cgroup on the CPU
it's running on.

I'm not too familiar with the schedulability analysis side, so please
correct me if I'm missing something. Wouldn't it work if the setups
which need the analysis configure the group on all CPUs? That seems
like something which can be a convention in how groups are configured
rather than forced through the interface, which looks like it'd get
clunky whichever shape we pick.

> We think 0 as a default would be problematic, as it means "no real-time
> tasks", and 0 in the root means "no real-time tasks in all the
> cgroups"... Or am I missing your point?

Yeah, zero doesn't work there. How about defaulting the root to "max"
like the other cgroups? "max" on the root would mean that nothing is
set aside for cgroups. RT tasks which aren't under any entry run
without a server as they do now, and the budgets of top-level cgroups
are admitted against the DL bandwidth directly. An entry on the root
would be the total that cgroup servers can reserve on that CPU, and
writing one fails if what's already reserved doesn't fit. RT tasks in
the root itself keep running without a server either way.

Thanks.

--
tejun
