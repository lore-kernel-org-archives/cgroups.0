Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793839134;
	b=Ii1IDkeBSvyEfCfqa8Zk4/ikatgM423PZDbpCKBt3ih7zOm0HLk7a3CQwxwqDMJVvvyT
	 Zzb/Aq4Mup6kcYJbowcgCYHarqknVM5L9x0Bf+/2itsttrX19NJ05EiuLArd37D16z03S
	 zYU1g29/kH6g3XlnVPhXTKz4s2K+cY6ckD+TseXu2dbkmhXH1JX8TpQTb0olDRKIm0yuR
	 HuzsT04nOm3lZZBUIiLkuIitLfVQhQaPkmkSh7ZP0v51F3GORrBmQE+/QWNWh/tF99XgF
	 8hHz1CO6h04h2JbcirTa0aEvQUNCuP1C2w9JeeQOf41j5OwVAhaQvxcomIMXkofs/GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793839134;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=5Pxa+8WmY5aWMvQp4MOIKPhDhZ93O3CM2MNQsb3Ea3w=;
	b=YgXwyR0jbKSHEJc33t6SKRM6DkPcjYatunB9OSPy7Gw5hqJvG8SFGjRsWLVbsMxj3L7R
	 ev0Xk3k1y7pM4oh/vXGnLDEeHpaTJg9fIQoQXASZsUx96H7WEODDsP1G5Z+h5QQJKVymZ
	 +K+Bf5xniaSDXyAaqhUvhiSTHS/TT3/XkhDooDU/wBIvPAoMTeKdSEUeHGVKVIts3saNF
	 xlyErTWgBDDPjBw80dhhA9MviIgTk+wFGzlCvDH8IrH/7iwMA7xZyk1RC0xQL7lmxIy64
	 7H6yHshWUOfwNrJVEz0BzH4WLeu1MMoxHQkwOnzOeWEN1KKCRmg8SDTVjl15AbtD3lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j+UwyjoE;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0DA606A331
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 00:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B0DA606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j+UwyjoE
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48b001cd92bso606299f8f.2
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 16:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793839132; x=1794443932; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5Pxa+8WmY5aWMvQp4MOIKPhDhZ93O3CM2MNQsb3Ea3w=;
        b=j+UwyjoEO+2q1E+nBxP9Wr7NweSOXMWefGF8bJYdheLbXwnW0MJ4MZk/3VPcuD+MeA
         sWRG1QNOF+upgGBClSVfoImblhO9ufDyl28bv1DAyCPDtFGY+nzJrxI1U9zRHoyPD9WN
         JWUUmtUAuauJLGUQM8T/xWhyKwADMrDlJcKez/Zyt3HRjNvquncBkMz8uQk7CUETT+t/
         PwX4AwGZcHpwVNlw22kjIRd6pYGzNJmpIA0QJLYtAO00R//2nX9O8CQKhdPE9sg7r0Nl
         sWddnnI2coLnTikwp0qWB+8L/kLbpaLf4aY8ls1WNhvbjfqchplJUx40eJAKFMXx528U
         nbNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793839132; x=1794443932;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5Pxa+8WmY5aWMvQp4MOIKPhDhZ93O3CM2MNQsb3Ea3w=;
        b=J/LuBjPkycqcZVE+ct2vuJvyM0zfwamTonwbWuRX9L7u66WJLcCnwQGIl+ftTHgJpX
         fGtiHBgWXq+G86qrSbZPx8EV7rdp+aFdmKvXsqDZPKBdgTie0LHrFBWENSDPFymml0yC
         M+Edx94MYfgPBNwG3hPHKFW95BVJ0AqRiQ/ARM9esri/o1CTOlGK20cnHhLmS5VIwBmK
         /xyTur7QBkPlivrVxOwSqVQP4DXJaJQcpjGgAoL43QrpzOmvFPaMMfh9dbyasszkkwrJ
         sOeUZ628nRpAWLu56wijHSzpQq0fBEgV+A6xcLjQVVmZfu/kT9cnvAs4rRazXnxDOW+m
         e+8g==
X-Forwarded-Encrypted: i=1; AKwUvBxnnT0xjG9TFKUkY8YaitnVomA6cKjoG58clxqrMs2K7j0eXrIoMA55QZLYFccLieCA4akHuQI9@vger.kernel.org
X-Gm-Message-State: APuU4Z/9N/NizWApDwaSFZHczSeF6b/vbrcw5aECDvaDiXsOjJvhvxo4
	AvSa9wC8cvtoJPI+f+4t2qBansITdKKlTKRKe2jM98ArnPwZYW3JFNz8
X-Gm-Gg: AYBFou2TLcEPUEP5m/QwQ1RKw1guHvSyFMY56ReXA08S1rZlaWFoYq2zpPb5IQKbn7g
	MGT2WU5iKFbD0LkEQJGkKOd1KRnI/5NvU/t9KU7GGeSlHxStH3VMsrofzdV15W0aTLhrbeUGJB5
	cC/0jc9SCREkVb1Z3sdZUyVE3Qcm8X3+zp3FfPiopQ4d2PnCeFqpb45ddg7JaZBPUjeKsl9QvFi
	6xcVMlyFGfeuCAyOS9R1BAafWAYNMcxjIjgPrfZ5EfYmi0Tlk0H64XZ/xxC41EBGB+ghl9rQG0A
	5eX4OkO7yN0hifBJd/va/qhgV8IOKgfLM0NkiwWUlioB9HkmGTGBiuA9tcZC4N0Uj/xr8toktMY
	7AKTmHXd0FKpf6Brx5Q7JlfNQOiwa+YofKLGsjavij7+wTMzndwvHFQLTPnYDuj/+j1/w3UKVH8
	+t/zytI41oKxXWVsrbV0U3MdRVumqs9VSPWKYQNqyJmyuzKC0VtGnRzljgBivdxtL2Gb5nHtFqF
	7jAyAxdjD9e8m6KZ8QEA21y/dtnxquAWJYfQrwNgltcTiKt9HEpBM968ljVv+dqNTwqrbOWJ7+T
	u2rNtnAGuk8KinDKozq4cnPjlbOWt/YPqNZlY9FZy5J1OgjaksQrkX9UNWQ=
X-Received: by 2002:a5d:5e8d:0:b0:491:49c2:3b3 with SMTP id ffacd0b85a97d-49149c2043fmr821244f8f.51.1793839132301;
        Wed, 04 Nov 2026 16:38:52 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed553441sm5988761f8f.43.2026.11.04.16.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 16:38:51 -0800 (PST)
From: Leonardo Bras <leobras.c@gmail.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Matthew Ruffell <matthew.ruffell@canonical.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH 4/6] sched/isolation: Drain per-CPU LRU batches when CPUs become isolated
Date: Wed,  4 Nov 2026 21:38:50 -0300
Message-ID: <auvQGQs-2DXQ2Brf@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aunrTtH00__Xi7PW@localhost.localdomain>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com> <20261103075940.110308-5-matthew.ruffell@canonical.com> <aunrTtH00__Xi7PW@localhost.localdomain>
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

On Tue, Nov 03, 2026 at 03:10:22PM +0100, Frederic Weisbecker wrote:
> Le Tue, Nov 03, 2026 at 08:59:38PM +1300, Matthew Ruffell a écrit :
> > From: Caron Wills <caron.wills@pulsar.com>
> > 
> > Isolated CPUs no longer batch folios in their per-CPU LRU caches, so
> > that __lru_add_drain_all() never has to queue work on them. Boot time
> > isolation (isolcpus=, nohz_full=) takes effect before any folio is
> > batched, but a cpuset isolated partition can be created at runtime and
> > the affected CPUs may still hold folios in their batches from before.
> > Those would linger until the CPU happens to drain locally, and the next
> > lru_add_drain_all() would fall back to queueing work on the now isolated
> > CPU, which is exactly what must be avoided.
> > 
> > Drain all batches once from housekeeping_update(), right after the
> > HK_TYPE_DOMAIN mask has been updated and next to the vmstat and memcg
> > workqueue flushes that exist for the same reason, so that newly isolated
> > CPUs start out with empty batches.
> > 
> > Link: https://bugs.launchpad.net/bugs/2165410
> > Signed-off-by: Caron Wills <caron.wills@pulsar.com>
> > Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
> 
> There was this patchset:
> https://lore.kernel.org/lkml/20260519012754.240804-1-leobras.c@gmail.com/
> 
> Leonardo, do you plan a v5?

Yeah, working on that.
Hopefully should be tested by the end of this month.

Thanks!
Leo
