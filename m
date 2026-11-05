Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793893951;
	b=mqDow0PlTbIbDrsEEy9geh1bl+0eUmC3OxwE6R4+ISZyLfBbZOObQ6cXcd5LR4mB+IOf
	 V/4p3JujQJkGwnbjleW0IudYmEht+0pN55UiBlSlr3GQv+ThlcedmYNjb28paZqQv1tnk
	 RGp8El7bBMlQKSJ7XJ7USNoYBjx4x9O/q520bD0clEEMVgJ1Wb38fNuFsG1G5cEXPPAXx
	 YSI5guLcLVjhlSniGtCrki0a1wdkN8e8YfpmbdAD+5ib5FxKuO59K12iZ2lJBpyDiw4oR
	 FVxepdgH3Ifhj319Fc6KCg5K+c/stujql6Co3tlwdrmjJbBdURogs84k0HrlznW68Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793893951;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WfgRPY/YU7G2OQ79c3MVCjhf2opOR2LJnv1zeXpVLvQ=;
	b=eIB64WbQAXm6VQfMDmPPqSCI78l5mc+CRhfmrrlid8pokhKGMRCK5oeMeEsQJokLaTVU
	 XhiEe9ZiY6GuC1GXiLUTL+e6q7w/C4JcrtvDI2Zqe0kT8IjukSq1vMzSqukCIrotfBErX
	 fXGbZqLgANT1tYaG7R8WV1jvv7JyDOcbGACcSTxQZnG6ME/8OWYRRIKPxeE9Ka1+s86eH
	 UHkn8aIhZmC59tX/wr4SKh0MCwbJ5rhTF5AnkXqeCkmWQsqu39okZPLsbkN978SicDpB6
	 FHORls03Ly75YYpbWM0JQzu0+a9pFIGxWS/x9ECIkcZRMni7F7Mne6ZoGM7Mrb9pzCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YZuriFzO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B0C606D807;
	Thu,  5 Nov 2026 15:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YZuriFzO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82D81F000C1;
	Thu,  5 Nov 2026 15:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793893950;
	bh=WfgRPY/YU7G2OQ79c3MVCjhf2opOR2LJnv1zeXpVLvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YZuriFzOLl6ZdHAC5cD6nUsgRhpTdrGdAtahBLYP0mihztxH74WKqktymoPWUe10S
	 tfDMCqH97lkS9ldarmWoYno/o8lzmYAovJAH7eBIhZ5dcjegVqZzkaX7Z53Vfsv75m
	 aDf1noCM/WjD/zOx12MBAURFcazz+c79+JzSImHvirJbaeTE56kCj84FdnejOz8BdU
	 +jFEeef9vTtkV/FclYG6e4MccIqNNbx20sBPY/1GGvon1ihSL5QHCHNRZ7cL+nd4HV
	 MHM6IP4PQcTNd2xXGPK9+Z5jpJO6qnfeY2HJ+S+QqGWHIi2A/rp9s8Q62ZGJt/UPVB
	 TGmduGcvD8tvQ==
Date: Thu, 5 Nov 2026 05:52:29 -1000
From: Tejun Heo <tj@kernel.org>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: replace BUG_ON()s in compare_css_sets() with
 WARN_ON_ONCE()
Message-ID: <auymPbeInX5BsUMT@slm.duckdns.org>
References: <20261105124813.862460-1-sunshaojie@kylinos.cn>
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
In-Reply-To: <20261105124813.862460-1-sunshaojie@kylinos.cn>

On Thu, Nov 05, 2026 at 08:48:13PM +0800, Shaojie Sun wrote:
> compare_css_sets() walks the cgrp_links lists of two css_sets in
> lockstep.  Both lists carry exactly one link per hierarchy root, so a
> length or ordering mismatch just means the two css_sets are not the same
> one, which is what the function already reports with "return false".
> The caller keeps walking the hash chain and allocates a new css_set if
> nothing matches.
> 
> None of these checks is a user-reachable error path; they are invariant
> checks on kernel-internal bookkeeping that are expected never to fire,
> and each one has a way out.
> 
> No functional change for a consistent state.

Why are we changing this now? These never fired, and if they ever fire,
we're in a very deep doodoo.

Thanks.

-- 
tejun
