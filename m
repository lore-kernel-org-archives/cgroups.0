Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAC121CC58;
	Sat,  4 Apr 2026 04:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775278624; cv=none; b=sqSp7V/x4Q7XinlfI6zcqhRQLRFr8r1urr0+XBfJ9yKIeelwCgf0g6zKoWW4qrdQLzPgi1hY2ACGrzoTJ0ocLBxldkgN9C9RHvjgs0IzQLwtYQBUKBKeA8EMrv0FNDNa2dceP9Y31Wg28nU2GlDO4shspi9+KZEU+atO9zVyrvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775278624; c=relaxed/simple;
	bh=sgw8Wj60r42pOFY5siLpwGwPlFHXm49nAzFlyKb96kE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pII/BBlcEm8Afdz0VZNDIfg1MWNZEcVQqYpu1DUQOFcNbLyI/SqFmVeceDO5JKBpM0MpFJoZp4q6ZVhV12RSfwd+5SpwmnnlqeXB8DpEki+IjREr0V9ee8LuQQp2Si8fAnWzwV4lI99YDAeg6KxbT5vck2jYuZgss/emZNOyAzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AeXI/xXU; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AeXI/xXU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sgw8Wj60r42pOFY5siLpwGwPlFHXm49nAzFlyKb96kE=; b=AeXI/xXU6jUJ2aqueVw1zo1ch2
	IzYDFwm/ZFG37UTIbOii+YOAL+wVhmJUJ3qoK0KfX1HHQRCgLSEReehfypZIPjh5setCCqsaXok6c
	qDa5l5Q4S83P47f/rWZkgvZKpi+nOCVDQflPxIbCAO6XvbEEokHM+0kohMcpANNF6KHjbpRoEsK/n
	AEqVijqozTpaZNqkkqFYshaw2moYjMzZ97E0TNqff512fpyerbe5kcFdAWgSGb5mRxvL/n3aN38LI
	uL6SIg0S1y26gPszBhuZtEEz8PZmSSkpq01TC4W/xZwaHNXCgxVTb+JVZ/w4zCkt24dKHx3j4mL2i
	WnO/FJ6w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w8t43-0000000FVB7-1rqE;
	Sat, 04 Apr 2026 04:56:55 +0000
Date: Sat, 4 Apr 2026 05:56:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu
 accounting
Message-ID: <adCaF0jpayWn6-FR@casper.infradead.org>
References: <20260404033844.1892595-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404033844.1892595-1-joshua.hahnjy@gmail.com>

On Fri, Apr 03, 2026 at 08:38:43PM -0700, Joshua Hahn wrote:
> +EXPORT_SYMBOL(mod_memcg_lruvec_state);

What module uses this symbol?
