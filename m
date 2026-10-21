Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792594254;
	b=kSyqZXw7AS4vROKhATTJXw9c9m00bSzRJFEZ/YHmzEHCBdm5q3g1mkB62aim01IM0yPB
	 yVyjLQP5Kml0V/mfyYkUmd9rIXVzkCR0x9IOENVU3LrVPupgQI8g+ftOmIXKqD2zwpL3F
	 3VjVQij9H8ZpwdqNWh0mSeWRSXjTUr9ery/JsacLhtBYsHms65sBwtz60kOtmunIxF+Gu
	 7NkmLvcLheIhC++16xFpqG6l0lOKpEk2ct537+g8ESXvdNSS0gUHFSaH3fdEunLK+jOL2
	 h651kesFtbLEU8X+q+bB/A2N4gCpTjXZ8JRqUTHT7KByhO1o7S8YiVJkPBKz/W4NTwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594254;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=3CXGE6uQNqOP5XlCXJkmbw1nlPdxgjruItNfYf0wKJI=;
	b=VprhsbID9rPxZ0h1bwrgLwTN5L6RI/H6X/s0H+QZw09jZ49v4w3klK35IW6juuYlaOph
	 LLFiW7d5g3LvgFz4i8N03zRXbfFMJymlL7nS96OfuOwIVLcTEE8km51RFrK/+WG1Xb2+1
	 qs8chomVE6LIgAmdKpXkA+MTuc8UmVTeeEQaDIHozttVPPZ0Z58RfBTKMTiLv+4MaWqsZ
	 fZIVgV1yEj/tuNutNzOjmONqr/KAI9C9zGoKQ6u6dUuQe5G2qUwCoUxWG1VcAcb1DIH5I
	 6l4Q2TqidtIY9Bps0IN1eT626YFHaBxWDYkK2HtsIwJ71GnGfoP6OEgVedKhschetOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=JqG46tBe;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E749606A319;
	Wed, 21 Oct 2026 14:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E749606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=JqG46tBe
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3CXGE6uQNqOP5XlCXJkmbw1nlPdxgjruItNfYf0wKJI=; b=JqG46tBenZGHmQpwtRV2L8cCN8
	ZNm8SckU/UFm9hAY4Yf/mnKd9tUdK+Oxkq1u4/ex/bsUQkLPtCa7fz6pT+VIYXNtV6D1ng43P2Owy
	+qWtfPIqHcHl8E4PaGgQ7LJag8JVzQu1i9yS8MBO72C79pn0nwfjnBaoLUwID90GC724K8SDtEN+v
	0HcrSqlLG+tBFmMyyDyNFouWrwfwLTeCKo3aLaQNyHhqkeop3CdXDL+09KTPJuxoqgNE9DMsV9TSS
	exb4rQjNocIP4mzOBK0uEe38yrpCIzYcSm/xF8Ld6Qe2Hs18UVmlFI4Is48ewdbFpNvlj8I3f8ZAu
	ZSVzvEIA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xJXeO-00000005vUk-0wye;
	Wed, 21 Oct 2026 14:50:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7961D3005AA; Wed, 21 Oct 2026 16:50:42 +0200 (CEST)
Date: Wed, 21 Oct 2026 16:50:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kayra Cizmeci <kayracizmeci@gmail.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, mingo@redhat.com,
	juri.lelli@redhat.com, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org, jakub@okonski.org, longman@redhat.com,
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
	cgroups@vger.kernel.org, jstultz@google.com, qyousef@layalina.io,
	joshdon@google.com
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
Message-ID: <20261021145042.GQ2823843@noisy.programming.kicks-ass.net>
References: <20261019182622.1584454-1-vincent.guittot@linaro.org>
 <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
 <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>
 <ati_o5c-SoiOp529@scheduler.schedules>
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
In-Reply-To: <ati_o5c-SoiOp529@scheduler.schedules>

On Wed, Oct 21, 2026 at 04:41:52PM +0300, Kayra Cizmeci wrote:
> On Wed, Oct 21, 2026 at 03:32:59PM +0200, Vincent Guittot wrote:
> > On Wed, 21 Oct 2026 at 15:13, Peter Zijlstra <peterz@infradead.org> wrote:

> > > What is the actual semantics of cpu.idle nonsense? Why do we care about
> > > this common ancestor?
> > 
> > AFAICT, cpu.idle applied to one level and against entities at the same level
> >
> 
> Yeah. Like on here:
> 
>     ROOT
>      /\
>     /  \
>    /    \
>   GA*   GB
>    |    /\
>    V   /  \
>   TA  GC*  GD
>       |    |
>       V    V
>       TB   TC

(marked GA and GC with * to denote their 'idleness')

> If GA is idle and GB is not, while GC is idle and were looking to TA and
> TB we gotta choose TB. But if we just look to GC and GA we would choose
> neither. .idle just applies to one level as Vincent says.

Yeah, that's what we used to do, but the more I think about this, the
less sense it makes! 

Josh added this (added to Cc now), but we have a number of Google folks
on Cc already. It would be good to hear how this is actually used.


So in your example TA and TB are both inside an idle group, and
therefore one can argue their behaviour should be like !idle. But their
common ancestor is root, and so the fact that they're contained in idle
groups gets lost (which seems crazeh).

But worse I think is T{AB} vs TC. In that case none of the common
ancestors (root,GB) resp. is idle. But T{AB} being inside idle should,
IMO. definitely matter vs TC, which has no idle anywhere.

So I think I would very much like to change the semantics here. The
current stuff makes no sense.

Anybody, please chime in with how this idle crap is used and expected to
work.
