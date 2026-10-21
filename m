Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792617876;
	b=Slw/YCsgHrV2gFlJ3QUUF9GZ018rGVJHnMzGG145RS+lqVn5XxQ8OqqkH0pQvpnHpSxM
	 F+6LMV+093wvK0C3TvlxIw2aDPL0xxz1zm6s/e3y2GVs+89vlFaY8/z/bNb2UvGtovkiK
	 BpbDmfZMvl1BDYReDhkRMhho4oTQOXc5n9MbN3CaAHYRTXN9k8KoklJkdzFfSA3g82Ylt
	 7H43CV8Bx3YYPNz2Ko1DWBzG1E1QFpEZxeBJ30nSXHQhyEI4O7H2OkjC6hjfymG08VUmQ
	 LuSyVBS2IypqdNrxzCmyj/ULzMjmPl98Kuy5d3p3txbo2T6WTjj0sIU11SnGx/Suv3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792617876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=8IEZ9olq160T2eeN056hVBHNHsrJXJMeuGcg8w/hmqY=;
	b=cxhXaIb5CVqt78qe8Ya8bQzlrgMadoBJadkhibR69DKY/o9ZxAe3PaqA2gGO/7LP5v5y
	 c+CBwqh7tTiohvwUwBQ2ryhecFWR2eRewxIDIA6AT0WOW+uzXlDOJDdvQ8DvBHZTcpZ4d
	 eJ+CidISW5cTkMP14HPvZF5LeQY7LMSjWjaMy05eFv2UlmL5K0HDLqOVC3FlgXz1LZFO6
	 gpAnPy7eaHgbLCkqwUX127Kh+/oPUM5Q7NBUe+9PIQZkFB1kNkTMGmYlJqnO7ymVUcNwR
	 fb47UolkSC2gDb/CpAkjqxbVRiKpKFanCBc4+IICpfcOr6DeAOOr7HaRWrkbuZvMKqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=TaisdxF7;
	arc=none smtp.remote-ip=209.85.222.178
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C2B606A31A
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 21:24:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67C2B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=TaisdxF7
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f1e5d7450so113494785a.2
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 14:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792617874; x=1793222674; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8IEZ9olq160T2eeN056hVBHNHsrJXJMeuGcg8w/hmqY=;
        b=TaisdxF7bL6oVi+T0MnL5svDJyrfja+UU17YMr3PigM4Ru03zOtsr//PovAO1RxFGg
         e47haOHhuqUs+p3irN46GBdxDAp4qZoF37PgHBZQvLIxroKgrQPyJqKnrvvkkL1Mlami
         oTLEH6l3CV34DV/zkanFJR9qlJmg68wzkwpc27lSxCJb97pF+OeMPPH5UVpMBcmLWUp3
         5JkHQkySopq9buZEGrPIRQ3gyADpRdoARQJMPp5Je4W4igzpE21P5KxR16jlhdD9jAlE
         a/gb45n5rdSFhAouOCoG1rXTOfO6auFRXBoNxWweBFkVqje9AcwnWt9m3BXaZYZLEr/c
         TyUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792617874; x=1793222674;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8IEZ9olq160T2eeN056hVBHNHsrJXJMeuGcg8w/hmqY=;
        b=MkZUVZnhC8fITTA4lc+vr+eDB5LPauB/RpqbGoT4ApVW6AmMK98F8ELA8GZp/PGPO/
         a840XOiOl5/WuV7AhYdqMa3WIC/labQmZ9lgOm7YS7R2O10vQap6sEzcheFWfSXjHNL/
         KCScqlWMgxRjXUVuFfQe67xBS4vYb2ErDmQcSI+49/DzhBJph2WWFm/5L/W1YxdAgOKT
         ZB+RWct+7ugoC4AxZVNMROGj2H4JHWQPtAoCWHSf3DPm7hDUJl3/VagflclvQpU+0bac
         hddz+e1/4Qp50wM/Bj+fqPvh0GdbJtXSibS/YTu1CXMWHvsG7EuYB3h1+h+9cCLfzCV1
         e8Cw==
X-Forwarded-Encrypted: i=1; AKwUvBxAcvKU+GdJIwdhvaDjtUZbMJ0oyJEPQPDGfNsGbCdKVVAv3IgINi+RyJ+5HLxLGuqkL2hhVH32@vger.kernel.org
X-Gm-Message-State: AFq9FYJPYkHWSPVI89uAJW8GNZ12mo/DJuRuQa0+SD16l7VoGh8rrnmZ
	PBFdbjiRDCz5MDYfQGVfgcdfDkPNSARlFCLSi8fO/Cc0btIwbgfjYWZxgLh5sWwfx4A=
X-Gm-Gg: AYBFou2MzuiZfNMYDnEBhVOqbN9tqM8W3+qd/UoQH2DSGzEgHg5hjNUgXN+I8Sj2OsQ
	bipAYPu1mzz+VgBPUsf7WtehtYuvAbPOLC4MWnwMXR0bgL+bZsYkYni0v28JIolTQ2quTfdWf5z
	RUD2SFVTvPEX4vKwVMECJ64dNJRTodnaoa2MVyVBk9xRC/UEOJXzYxJvz1HJkfmp5JBTPXpFHGc
	i1/TEDXOIyPo5LseobHiEfJEnylmcipUBxUNECCxcLKLx4zJTU05TpyACnmN3ONb6w081faecYp
	eS5AeKQ9E27xUhDFQHuyiYHtVsipAcaDxgq0nBvnXjoc0S+vyShJA5FzzqRrKELYAygnsDoDEC+
	DecFen3Q2reI4P1OAXyOH+mcisw47WNSqNU7XaFHOgIlit+TKs7GeHpzCVs14HT77kdWKYBS1TI
	DX/KIPU7rdgMGOcfFx8mIipFoa8ePpgFOZL3Kkf1U36FWD5SZf239AxDUgyWftO0HAPMP8FKdSc
	DbOgMl9TjQ8MR5KE9lBfr30MWUE0Dv8ALoT8s+p5hFQHRnE94coTHWFpeENpeTMW0dZDjU58Y/U
	v530tEFDfm6mWp0JozLCePmE1Tpspa0O7L0p
X-Received: by 2002:a05:620a:4414:b0:93f:16d4:3bf0 with SMTP id af79cd13be357-93f57f23fa4mr670081285a.42.1792617874277;
        Wed, 21 Oct 2026 14:24:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56df2ad5sm349884785a.27.2026.10.21.14.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 14:24:25 -0700 (PDT)
Date: Wed, 21 Oct 2026 17:24:20 -0400
From: Gregory Price <gourry@gourry.net>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Down <chris@chrisdown.name>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/page_counter: use WRITE_ONCE() for emin/elow when
 parent is the root
Message-ID: <atktYGL3OP088D9P@gourry-fedora-PF4VCD3F>
References: <20261021204818.3431099-1-shakeel.butt@linux.dev>
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
In-Reply-To: <20261021204818.3431099-1-shakeel.butt@linux.dev>

On Wed, Oct 21, 2026 at 01:48:18PM -0700, Shakeel Butt wrote:
> page_counter_calculate_protection() runs without locks. Several
> reclaimers can update the same counter's emin and elow at the same
> time, and readers such as mem_cgroup_below_min(), mem_cgroup_protection()
> and the dmem eviction code load them with READ_ONCE().
> 
...
> 
> Use WRITE_ONCE() for these two stores as well.
> 
> There is no functional change. Readers already accept stale values, and
> compilers emit a single word-sized store either way: with GCC 14 the
> x86-64 object code is the same before and after this change.
> 
> Fixes: b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store tearing")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

