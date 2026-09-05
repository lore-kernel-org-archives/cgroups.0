Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4B11B142D
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 01:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788572867; cv=none; b=nsEY/T9dDyzwbu64LE5jpayUFPR53eObOKloml5r0Hk+rV16nctOtbTSe9Xa2AJ6Dmxi0PPQqO6JpSETlxRaCcTQ2LMJXRC0KrfH3RFoOCt8m/WrCmE4DxBcPId5O+ftmVJOGAYuwY2KcDTmgy069jn7b/fdkHW4mXTFgVrL5fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788572867; c=relaxed/simple;
	bh=TUsToWMbWDdUPZfVfcX5WlBwFVjpp22QmIMA12UED+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kt9ls8jrnykwe/i9FTDxgQ3X1ILx+3IYcx4sXXlDXMF5zxwycym8ygyJ9DkVXj4upR8E14sMYES3mBMuA2pDpWtZocFKOpuG/y/HpSPnLIYMT2125G6usD0Zppgk0CdjEz3F1SqZbkm24Fv36bEQsDHg9PU12HJpu6bZ0cPJkJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dEfaFyt8; arc=none smtp.client-ip=95.215.58.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dEfaFyt8"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TUsToWMbWDdUPZfVfcX5WlBwFVjpp22QmIMA12UED+I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788572863; v=1; x=1789177663;
 b=dEfaFyt87tjrHMlPR8A/XXrKpSTHttGU7NHNkbSk2vGVXN37/gS97r+bfbBBWeVQk3w0Jqsq
 RhVKtqSGOJdbtQYi5k/MZzxhVfjoqlwbiYohG13cg5X2e2PqOpaBlctqwq0o3cE2FYG8nMNtKxQ
 fD42gJeZ/YdigOr4/92ZlqCI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6a96a44c2aaa9fd1;
	Sat, 05 Sep 2026 01:47:42 +0000
X-Mizu-Trace-ID: 6a96a44c2aaa9fd1
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 18:47:41 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	dev@lankhorst.se, mripard@kernel.org, nat@pixelcluster.dev, tj@kernel.org, 
	mkoutny@suse.com, osalvador@suse.de, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-team@meta.com
Subject: Re: [PATCH v5 2/7] mm/page_counter: report the number of pages
 charged
Message-ID: <apt0e6M99xvsxBrp@linux.dev>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-3-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163752.2193337-3-joshua.hahnjy@gmail.com>

On Mon, Aug 31, 2026 at 09:37:46AM -0700, Joshua Hahn wrote:
> Add an optional @nr_charged parameter to page_counter_try_charge.
> On success, it will be set to the number of pages actually charged to
> the hierarchy. Today this number is always @nr_pages, so there is no
> functional change.
> 
> Of the 6 callsites, only one user (try_charge_memcg) uses that
> information. The number of charged pages is added to
> current->memcg_nr_pages_over_high to indicate how many pages it charged
> to the hierarchy while over high.
> 
> Today, try_charge_memcg requests "batch" from page_counter_try_charge
> and adds that same amount to memcg_nr_pages_over_high on success, since
> page_counter_try_charge's only source of charges is the hierarchy.
> However, this invariant changes later in the series when stock is pushed
> down from the memcg level to the page_counter level, and a page_counter
> charge can be successful without growing the hierarchy size.
> 
> Plumb the new parameter to all callsites, passing NULL where the source
> of charge does not matter to the caller, and passing &nr_charged in
> try_charge_memcg to account the hierarchy size growth.

The terminology of "growing the hierarchy size" and "hierarchy size growth" is
confusing.

The code looks fine.
