Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793235157;
	b=nOEXfkC4Mwlv6t3EkFvnh1kW4Ace5/jRVffDadRm1HA1ZA72MMYWBe5g99ZnhSdRFU92
	 2Le8egNot8rS69OEXRclr+qLPNyciCO2V1O5oZ2zzf6fEQiBYEjiEQAaSsKNqYE4V0KH7
	 1Hkejd4nbz4oCWjyBrdwFG5WZ+9vaSG2VAWvN2QaPS3uTUy5erP7T89HO6pyyMsaG/3KU
	 t4T4HE+Q2CJuTZaXkbfTk4Bvg5k7aFlBJ0CL0ROAt3vBwpgbbvemutWFTBmayXncEHx3a
	 cfSrYO6XbQiqrjhMIwz2tVWXw6BOyqcWJ3zXo3mh+IB9KNCzfLU3SDeyovfwNrt7hZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793235157;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=RHPQoGuLDHaF2k2LL7mqI9My3qPyz/yrNCTublPv5XM=;
	b=2kpZ6XejT9IrdjMJ88DpgCt1owogpcWqxgi4dzSeDy5LslPPOBArEhfymDO4ceIc3vEy
	 cd2UTIhrIwh0VTuRyxkxFnOhGFFN3Z1E6Q+WHTGuA8lrarTbOgzuvHzs3ulbE1utWWciQ
	 ebBfCNNmrexTFNQ9qYpS19YaGEI8YwAJFaD9XnP+jQ89fO0xphGOxKcvAnXNMxkRCibiT
	 sR1sKyyUCa/k3iKN9NvBAa6iI9G4L8MobbJ/vbpATp8M9yQqRfJcZIgQl2+fvRUXumpyQ
	 Uaxjki35vP3BZ7WOFowdlZMTtqbEjQ0+tL/ZREBi6mkyXC7t9q7F5qWSS+17AXSX29g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IQ7nupdB;
	arc=none smtp.remote-ip=95.215.58.143
Received: from mta1.migadu.com (out-143.mta1.migadu.com [95.215.58.143])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9C6606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 00:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F9C6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IQ7nupdB
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=H4+49ktcnrUz5wU1B741UzVopkyPlV0rkJlT+s//CUQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793235153; v=1; x=1793839953;
 b=IQ7nupdBNTFnK8Bi0t2XEmSuof8HmZFAco9zgUtV/ensirH5+GOgI/14Ki8c06uGTVu8j4Tj
 m6DmoTVBmjWAlR6Oe6O0X5uCE0B5phxi6MfCnOWefN42NBp/OIEIRru4DF0lPGzIRtXzubNfI1P
 nAc0+5IwEXyPu3LJY0e9r5ao=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8fac3c08d8046dd3;
	Thu, 29 Oct 2026 00:52:33 +0000
X-Mizu-Trace-ID: 8fac3c08d8046dd3
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 17:52:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, yosry@kernel.org, 
	joannelkoong@gmail.com
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
Message-ID: <auKYs_ucslI-tdar@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
 <auKSeCFvsWzP-XYy@linux.dev>
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
In-Reply-To: <auKSeCFvsWzP-XYy@linux.dev>

On Wed, Oct 28, 2026 at 05:41:04PM -0700, Shakeel Butt wrote:
> On Wed, Oct 28, 2026 at 06:50:12PM +0000, Kuniyuki Iwashima wrote:
> > On our production fleet, we saw mem_cgroup_sk_charge() spent over
> > 3x the cycles of try_charge_memcg() although the former should be
> > a thin wrapper of the latter.
> > 
> > Looking at perf during tcp_rr, most of the cycles were spent in
> > mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
> > due to cache line misses. (see patch 4)
> > 
> > Also, tcp_rr w/ 20000 flows throughput often degrades by ~50% on
> > many core machine. (see patch 5)
> > 
> > This series adds nr_sock[] to struct memcg_stock_pcp to batch
> > mod_memcg_state() for MEMCG_SOCK and move heavy operations to
> > out of local_lock(&memcg_stock.lock).
> > 
> > With this series, tcp_rr w/ 10000 flows achieves 31% more
> > throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
> > Processor (Zen 2 Rome, 2 sockets, 256 vCPU)
> > 
> >   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> > 
> >   Metric                     |       Baseline |        Patched |    Diff
> >   ---------------------------+----------------+----------------+--------
> >   Throughput (RPS)           |     20,884,499 |     27,466,490 | +31.52%
> >   Latency Mean (us)          |         478.46 |         363.71 | -23.98%
> >   Latency p50 (us)           |         453.96 |         356.68 | -21.43%
> >   Latency p90 (us)           |         669.00 |         479.56 | -28.32%
> >   Latency p99 (us)           |         969.38 |         617.80 | -36.27%
> > 
> > 
> > Changes:
> >   v2:
> >     * Rebased on mm.git/mm-new
> >     * Add patch 5 for flaky throughput issue
> >     * Patch 4:
> >       * Benchmark again after rebase and update numbers
> >       * Check in_nmi() in __refill_stock()
> > 
> >   v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/
> > 
> > 
> > Kuniyuki Iwashima (6):
> >   memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
> >   memcg: Reduce nesting in consume_stock() and refill_stock().
> >   memcg: Annotate slow paths in consume_stock() and refill_stock().
> >   memcg: Batch mod_memcg_state() for MEMCG_SOCK.
> >   memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
> >   selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.
> 
> Decouple the 4th patch (batch MEMCG_STOCK) from the remaining and send the
> remaining patches separately and upfront.
> 
> For the 4th patch, I would prefer we first try to move the network sockets
> from memcg to objcg path. Then I would prefer we optimize the stats update for
> all stats instead of special casing for MEMCG_STOCK.
> 

MEMCG_SOCK instead of MEMCG_STOCK
