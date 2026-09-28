Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44512F7F01;
	Mon, 28 Sep 2026 06:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576321; cv=none; b=qiiD6yoFeBLPJA97Ol5ReFVcqrBtCE4/PIVvXPJIG9tt6PlVtoOp/rghxw7ZUFAGBfUSLP/J4Y2bwI167Rawcd1L/DLnUUlfpHwWngKG278sXZ5yzdPA5nePGP3hEadJ3lLrTRsKVXX2qSvODf1SIh8d7WJi7iOKGePfXHkjRT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576321; c=relaxed/simple;
	bh=3WqnC8QeF/22I4hjBjjKyNPJNYc+XwpgESRAB3xbV0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hq8XB0LuUBHcXZ9+E9AaANsIV3Td2EcUfSO4Z3yEfO2SVRVBq01bj7e8ZhirKVmNAYzqVd4t2CTBxTRSHVdo2qH9LcLqrmk5iM4wEfe2/fr8BU8+L4sSFknYvTpR4+D3uO8Aad5LUVB9y9nWtdQ6nehRPgjUkdP/yc5nwvDJkRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dXVNrCtP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dXVNrCtP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m6JBH5OzCgBGbSotaYYctgten26WJi6XRQg5zFg6ET0=; b=dXVNrCtPGbkF9j3ctYx+03RvEY
	EwulYd4k5qcGz9GapQu8q18TbyaDo0GB/48MdJMmKRNeJhuKfmdsIxnuVtakJYak1cXrkE7Rf5wQY
	CWRQ+sblT/4HTAM5d5I2VZvl0fQ9xt/XCOVCMld3ttwaaN5QcL5/KM48w6J1I3Exygz6bvBg2tdqT
	GEqIlA5AvkQRr2rg9ENTdjlOexNOzMThHpjeFsHWMolXTOahdH+kPQ0fWWZ4MiESYtAjfpm93zQdc
	Gx8zVu9NfUFq0ptaVi/niMV7BCc2W7lMXp1QJVoEkOvTPz49SG4rGNo7ld/zPUyFViWeDQ0Ty4O2M
	oD76BipA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB4hB-0000000HRZD-1bQF;
	Mon, 28 Sep 2026 06:18:37 +0000
Date: Sun, 27 Sep 2026 23:18:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, willy@infradead.org, jack@suse.cz,
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v9 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
Message-ID: <aroGvQSFpj06a_to@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-3-sunjunchao@bytedance.com>
 <arYa1DbKNeAN-PLl@infradead.org>
 <87e10baa-13a8-4766-8d6d-9173a4b0c5c5@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87e10baa-13a8-4766-8d6d-9173a4b0c5c5@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 25, 2026 at 09:00:28PM +0800, Julian Sun wrote:
> Yeah..Andrew and I discussed the naming in another thread. The idea was to stay 
> consistent with the existing naming and keep this patchset focused on the functional
> changes, leaving a broader naming cleanup to a separate patch.
> 
> https://lore.kernel.org/linux-fsdevel/20260917065759.2643940-1-sunjunchao@bytedance.com/T/#m0d196c3b8376c9b51276f6c5d26ab9f29e170169

Let's not add more of this, even if fixing up the previous ones belongs
into a separate thread.

> > 
> > Instead please fail the boot.  If we can't alloc a workqueue at
> > boot time, we're toast anyway.
> I followed the existing memcg_wq allocation handling here, which also 
> warns and continues. Would it make sense to change both allocations to
> fail the boot in a separate patch, so the policy is consistent? 
> If you prefer to address both in this series, I'll make that change
> in the next revision.

Leaving dangling pointers during catastropic boot failures and then
dealing with them at runtime isn't a good idea.  And yes, the code
above should eventually be fixed up as well.

