Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12481329C6A
	for <cgroups@vger.kernel.org>; Thu,  5 Feb 2026 05:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770271138; cv=none; b=OQ7Gm7VrdM/NMIqInQPlIZOJdBvgQPbLQ/rEpVyepctti4jucckoa5Jdap5GMcMIofTm3ZmKM2OSNl4tmpjffi3YLN/sxrFTts2iDBgltX87GXxnovXND3vzy93LwFduD/XlXbDKwJCYIVyVcBbKy0beBrVc2W7/04izAJU+Ors=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770271138; c=relaxed/simple;
	bh=KsFAUIGqOIR6akrxYf/9i0nV5ppZYU3No8Xq1UBaBsk=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=gZaVv0O5YmCIXZ58YGyld5dSLkCrDczyvJEe5GpBT42n9Hi/V+Ul3P45VPxPCZW1HVDeZbtCokGseSQfrDL8w9EUfX+LSIxoLKiUrHxTRMIWz9zQsE1bTXgDXraRkG4Z7g6ub3wA7N0ZIYI/bnH1FIIQ5rG5AwQktoaAwY3UuOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t53RKWK7; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t53RKWK7"
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770271126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Do4oFfIEa50WSzHZOziS8xFG9v2IcUGA8qMR6h8p3qQ=;
	b=t53RKWK7ghUmThH4yywVf5BqCpKuImQbWh+x4YlyjNNRKA1sUVB80ttIheKlspymzRkzYn
	+fMDqbdiLTSnKt7iGKswbYBeBSukxDJWubiomyD0WtWl+EEdlWB65Q+XIrb6lqPfaMHlJg
	29JuTeHt0UqyAj4/NIrXUJ8Djui63U8=
Date: Thu, 05 Feb 2026 05:58:44 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Shakeel Butt" <shakeel.butt@linux.dev>
Message-ID: <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: "Harry Yoo" <harry.yoo@oracle.com>, "Dev Jain" <dev.jain@arm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "Qi Zheng" <qi.zheng@linux.dev>, "Vlastimil
 Babka" <vbabka@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Meta kernel team" <kernel-team@meta.com>
In-Reply-To: <aYQuj6Ot-JS4tXvY@hyeyoo>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-2-shakeel.butt@linux.dev>
 <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com>
 <aYAmGc6lu973jRwu@linux.dev>
 <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com>
 <aYOuCmjQ5lGm8Mup@linux.dev>
 <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com>
 <aYQuj6Ot-JS4tXvY@hyeyoo>
X-Migadu-Flow: FLOW_OUT

>=20
>=20On Thu, Feb 05, 2026 at 10:50:06AM +0530, Dev Jain wrote:
>=20
>=20>=20
>=20> On 05/02/26 2:08 am, Shakeel Butt wrote:
> >  On Mon, Feb 02, 2026 at 02:23:54PM +0530, Dev Jain wrote:
> >  On 02/02/26 10:24 am, Shakeel Butt wrote:
> >  Hello Shakeel,
> >=20
>=20>  We are seeing a regression in micromm/munmap benchmark with this p=
atch, on arm64 -
> >  the benchmark mmmaps a lot of memory, memsets it, and measures the t=
ime taken
> >  to munmap. Please see below if my understanding of this patch is cor=
rect.
> >=20
>=20>  Thanks for the report. Are you seeing regression in just the bench=
mark
> >  or some real workload as well? Also how much regression are you seei=
ng?
> >  I have a kernel rebot regression report [1] for this patch as well w=
hich
> >  says 2.6% regression and thus it was on the back-burner for now. I w=
ill
> >  take look at this again soon.
> >=20
>=20>  The munmap regression is ~24%. Haven't observed a regression in an=
y other
> >  benchmark yet.
> >  Please share the code/benchmark which shows such regression, also if=
 you can
> >  share the perf profile, that would be awesome.
> >  https://gitlab.arm.com/tooling/fastpath/-/blob/main/containers/micro=
bench/micromm.c
> >  You can run this with
> >  ./micromm 0 munmap 10
> >=20
>=20>  Don't have a perf profile, I measured the time taken by above comm=
and, with and
> >  without the patch.
> >=20
>=20>  Hi Dev, can you please try the following patch?
> >=20
>=20>  From 40155feca7e7bc846800ab8449735bdb03164d6d Mon Sep 17 00:00:00 =
2001
> >  From: Shakeel Butt <shakeel.butt@linux.dev>
> >  Date: Wed, 4 Feb 2026 08:46:08 -0800
> >  Subject: [PATCH] vmstat: use preempt disable instead of try_cmpxchg
> >=20
>=20>  Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> >  ---
> >=20
>=20[...snip...]
>=20
>=20>=20
>=20> Thanks for looking into this.
> >=20=20
>=20>  But this doesn't solve it :( preempt_disable() contains a compiler=
 barrier,
> >  probably that's why.
> >=20
>=20I think the reason why it doesn't solve the regression is because of =
how
> arm64 implements this_cpu_add_8() and this_cpu_try_cmpxchg_8().
>=20
>=20On arm64, IIUC both this_cpu_try_cmpxchg_8() and this_cpu_add_8() are
> implemented using LL/SC instructions or LSE atomics (if supported).
>=20
>=20See:
> - this_cpu_add_8()
>  -> __percpu_add_case_64
>  (which is generated from PERCPU_OP)
>=20
>=20- this_cpu_try_cmpxchg_8()
>  -> __cpu_fallback_try_cmpxchg(..., this_cpu_cmpxchg_8)
>  -> this_cpu_cmpxchg_8()
>  -> cmpxchg_relaxed()
>  -> raw_cmpxchg_relaxed()
>  -> arch_cmpxchg_relaxed()
>  -> __cmpxchg_wrapper()
>  -> __cmpxchg_case_64()
>  -> __lse_ll_sc_body(_cmpxchg_case_64, ...)
>=20

Oh=20so it is arm64 specific issue. I tested on x86-64 machine and it sol=
ves
the little regression it had before. So, on arm64 all this_cpu_ops i.e. w=
ithout
double underscore, uses LL/SC instructions.=20

Need=20more thought on this.=20

>=20>=20
>=20> Also can you confirm whether my analysis of the regression was corr=
ect?
> >  Because if it was, then this diff looks wrong - AFAIU preempt_disabl=
e()
> >  won't stop an irq handler from interrupting the execution, so this
> >  will introduce a bug for code paths running in irq context.
> >=20
>=20I was worried about the correctness too, but this_cpu_add() is safe
> against IRQs and so the stat will be _eventually_ consistent?
>=20
>=20Ofc it's so confusing! Maybe I'm the one confused.

Yeah there is no issue with proposed patch as it is making the function
re-entrant safe.
