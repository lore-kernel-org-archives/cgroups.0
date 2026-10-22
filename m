Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792709578;
	b=n2UNHboUPZ5YsFF7q1JDr56oLEpZrd3sHwvSvXsKLDsmXxSxEqyYFLNbq1BGTCHbboCw
	 U0P2K3Y6RA+6uAlPlwpX7tDelyp9ISaaTrVDrqpeC1y52TGKT7ouNy2sNO/RHnpBugd1o
	 3fAtdbeL9iRVZXi6l2GUfa+EAOx7pSePXyOykfGlFu970GsspHS/QfeAFPDx2tjv5LKMo
	 q/Kl15t6sbyDjMFnFuDvhMWKFxTgnE7zTvA3bnIsq/dYMrrne404OD8Abxz/EN9uoUC/s
	 JCEppzsxfXMrFtxdmV/5u6Hawrp0OnAogHMUmmJFq/taKvDEEjSo4R9plwUY8yND8nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792709578;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=eFP7exUez9GGOtJ+smGmBVLg4Y3+zmrZrmNma5qSW4w=;
	b=b0bDsk7JiGGZejECZLrpvYIjgCdvoiEv+++DLh63XBNQUxn9BYYWDv+BM7R0n2qS/8jf
	 rt8zka0fJ6f8FxBPVATRrVoU+eTq+c6RqOI/I9oxWm0maz7Z/mk1JFGr86KQ2wRdhINPK
	 0ldsv+lXjiVIIYUtEYHCEYwlRO21rbs5DdJMiGDdktfFYpRuQMZg6TGUzjWT40q3dA87n
	 w2CpDYDaK4qEEovU53GvklJ7Xcd9DYeGM9Rs56+PXRf2HFO+aHq6uYukZOP/ASgHtt07I
	 zLbHW7VYrIMehRvYK92+eQRU27vjNgrpMGkzmWTNqN2Gov5tpv0ZExZ124z3tNW64yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AnSddiiG;
	arc=none smtp.remote-ip=91.218.175.1
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3305606A319
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 22:52:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3305606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AnSddiiG
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VuEHBkjmYNYLgKZ9YnKdlHZbNCNfQZmriQK22FO6a38=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792709574; v=1; x=1793314374;
 b=AnSddiiGBk015l6rIxyItypoyRc8nAMVaqeECu3YHpxKsNIhRQGvrx7fCVtbO4kKu0KsB8Mo
 nE63PIboSlE/dw/JzD97LKOzqOOhQKG2M9AwcIkxFBsQxN539l+RRdD0j3Dfj5xNWDiblZZ/60T
 EsQ6AhnpIL1n8Os1jXSPxaZQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3f89389d0b74c4ae;
	Thu, 22 Oct 2026 22:52:54 +0000
X-Mizu-Trace-ID: 3f89389d0b74c4ae
X-Migadu-Flow: FLOW_OUT
Date: Thu, 22 Oct 2026 15:52:53 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] memcg: don't go through the lruvec for folio and
 kmem lruvec stat updates
Message-ID: <atqTqvZRVHk0IVQV@linux.dev>
References: <20261022223930.138779-1-joannelkoong@gmail.com>
 <20261022223930.138779-3-joannelkoong@gmail.com>
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
In-Reply-To: <20261022223930.138779-3-joannelkoong@gmail.com>

On Thu, Oct 22, 2026 at 03:39:30PM -0700, Joanne Koong wrote:
> lruvec_stat_mod_folio() and mod_lruvec_kmem_state() already know the memcg
> and the node, but look up the lruvec with mem_cgroup_lruvec() and update
> the stats through mod_lruvec_state(), which reads lruvec->pgdat and
> mem_cgroup_per_node->memcg to get them back. lruvec->pgdat shares a
> 128-byte cacheline pair with lines that the lru_lock holder writes
> constantly (lru_lock or lru_zone_size[], depending on the alignment of
> struct mem_cgroup_per_node), so on CPUs that do spatial prefetching
> these per-folio stat updates contend with the lru_lock holder.
> 
> Pass the memcg and node they already know to mod_memcg_node_state()
> instead.
> 
> On top of the mem_cgroup_per_node rearrangement, on a 2-socket Skylake
> (80 CPUs) with threads faulting in and freeing shmem in a single memcg,
> this improves throughput by about 3% at 20 threads (5.59M -> 5.77M
> pages/sec) and 2% at 80 threads (8.66M -> 8.82M).
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
