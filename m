Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792704122;
	b=IVfarpcgb8dx9v7ZA4VcyT3866UksMOXOzwYTldtW3P89kItHN+/lw87RSyFLWtBoe5B
	 tx6RrmD0sYYet2xbES/cB04/nCr0Q+NtjLvcm3XN/hCh9SMzqpmPNCODJt/PXVTgR/kzG
	 Tqt4xAyISXDF/6LPZv85IH1kBCinExo0M7JxDiZW72jvX8fNgNaybHzLmmS0rarGo8jSu
	 0ki4od6CY65ojZ09hwnxECy+CzqWc1ncHQYkJ9htRoEPom2pAWMjFVInFp8D9hHb9WZQh
	 RrcQ1Wg5DYZ/QTIH9KrpWIN5WqkXh9c/LAbDSzbkKQ/B/FmbYeHq+QlKIsVFOgGSn8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792704122;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=4LHkfkw9eYCKRE1Ovy2OT1wG/BuLdxLosSSy54r1sgQ=;
	b=AK9oqstzguBpH1EfkjzcrRKzpeVs/3wjQVEfYSrrVJGB+TsNKHaDQT8/88dUi+pb3Z3/
	 uwscXIBi8dRHzvjzOZR1T7JWuEkNkC0yVNtNbUFW71YqZdFl47Mbr+Mqyk54BIC5GKkLk
	 v1Q4rVSNIfHRdWHCcPoEFw7sFqvi0hapStKwkKN86azZf2xEtN1NNqN8ZSe4b5pbZiZAY
	 ssFmXPtYi43zTe3SbiKzZOtdmP71dp/TqPSildwN3Bptk/tL7wW5TJ6N+YYmoXG4rFUlW
	 hf7J83aQS93mAL2bLgkIuAKEkCpOBOFLF4D2H0RUww9heYT5U51EmU/2zFfwvQ43K1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=sSEiDXa3;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3970606A31A;
	Thu, 22 Oct 2026 21:21:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3970606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=sSEiDXa3
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4LHkfkw9eYCKRE1Ovy2OT1wG/BuLdxLosSSy54r1sgQ=; b=sSEiDXa33sUi7DeL9M7WrVgs83
	HJUt+5KkCuEQR7NfKVim6nP1bbskEhYnNz5TYh1GR41hc9bpmb5WHVbsDX4bQzwMp9cn0VXpTZK8C
	t1BwbmWJws6vWZTBbov+ZKgVYSEF+yj+Rwo1cKDj7KAfPhmjINCZuv3wymn0j4UbJtYLnjSouUuq1
	QXI78KRls6be0oyuDXZTfi77F/QessKi1P+AD/fWycbTsHqbYSsKk52dPuOtsJb1ZaNd0tN64THpt
	xFl4oRx/9kH0Te1Czx3Holnp5xNhft/yBojWB0y3dbVnDdsD04M3g0z35r1jSHtuFnAzuaphyTXGW
	mQ0Sf39g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xK0ER-00000004d4s-1JSC;
	Thu, 22 Oct 2026 21:21:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 46580300720; Thu, 22 Oct 2026 23:21:50 +0200 (CEST)
Date: Thu, 22 Oct 2026 23:21:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Don <joshdon@google.com>
Cc: Kayra Cizmeci <kayracizmeci@gmail.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, mingo@redhat.com,
	juri.lelli@redhat.com, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org, jakub@okonski.org, longman@redhat.com,
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
	cgroups@vger.kernel.org, jstultz@google.com, qyousef@layalina.io
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
Message-ID: <20261022212150.GW2823843@noisy.programming.kicks-ass.net>
References: <20261019182622.1584454-1-vincent.guittot@linaro.org>
 <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
 <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>
 <ati_o5c-SoiOp529@scheduler.schedules>
 <20261021145042.GQ2823843@noisy.programming.kicks-ass.net>
 <CABk29Nv2ZzB1KGEuPmx4VmxTJ6pKmikGMr8cvzzDhHZSKpkgvg@mail.gmail.com>
 <20261022114705.GW88198@noisy.programming.kicks-ass.net>
 <CABk29NviVUAK6B_deQ7qah8eABiCikbFpTwDEO2hdproGLdLwQ@mail.gmail.com>
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
Content-Disposition: inline
In-Reply-To: <CABk29NviVUAK6B_deQ7qah8eABiCikbFpTwDEO2hdproGLdLwQ@mail.gmail.com>

On Thu, Oct 22, 2026 at 10:49:36AM -0700, Josh Don wrote:
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index b5546cd27dba..779fcd5a2830 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -15767,6 +15767,40 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
> >         return ret;
> >  }
> >
> > +struct tg_set_idle_struct {
> > +       long idle;
> > +       int cpu;
> > +};
> > +
> > +static int tg_set_idle_up(struct task_group *tg, void *data)
> > +{
> > +       struct tg_set_idle_struct *tsi = data;
> > +       struct cfs_rq *grp_cfs_rq = tg_cfs_rq(tg, tsi->cpu);
> > +       struct sched_entity *se = tg_se(tg, tsi->cpu);
> > +       int old_idle = grp_cfs_rq->idle;
> > +       long task_delta;
> > +
> > +       grp_cfs_rq->idle += tsi->idle;
> > +
> > +       if (!!old_idle == !!grp_cfs_rq->idle)
> > +               return 0;
> > +
> > +       task_delta = grp_cfs_rq->h_nr_queued - grp_cfs_rq->h_nr_idle;
> > +       if (!task_delta)
> > +               return 0;
> > +
> > +       task_delta *= tsi->idle;
> > +
> > +       for_each_sched_entity(se) {
> > +               if (!se->on_rq)
> > +                       break;
> > +
> > +               cfs_rq_of(se)->h_nr_idle += task_delta;
> > +       }
> > +
> > +       return 0;
> > +}
> 
> Took me a bit to parse this double traversal. I think this is broken
> for the clear side?
> 
> root
>   |
>  A ( 2 tasks)
>  |
>  B (3 tasks)
> 
> If we start out with A marked as idle, then we have
> root: h_nr_idle = 5
> A: h_nr_idle = 3
> B: h_nr_idle = 0
> 
> When we clear, we'll first start with B and subtract 3...
> root: h_nr_idle = 2
> A: h_nr_idle = 0
> B: h_nr_idle = 0
> 
> Then we go to A and try to subtract 5 leading to
> root: h_nr_idle = -3
> 

Argh. Yes, I seem to have gotten it wrong. I'll try again in the
morning.
