Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A74E33374F
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 11:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806361; cv=none; b=ezLf0iktQLFk0MTOo4JBsadX3t1Upi2XoHMXEQdCnIteF2at2kbPuW+5uOdUiUTt64iEGHqHRS8nGTfnbUfhc2Zh1fE1Y5iGUCOyqb2z9dbqMh7SoEeXfC3SvP7KwYKy8drVybdoN+7HNtPvr7pngvXcB5pwGcF/lzv8dwMCyNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806361; c=relaxed/simple;
	bh=0iOWGFfzG/Ab3nbA1nCjU1wrTxjs4BLGTwcZa/X1V4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NGKinCgd1caa+vvlaqSZ9DiaUeAx9EcYyPma3Jt2bfhc9zUOXH1hTLydHdjfO0sh+V2G3ZvM0vOBxbMQmpnIBh+fLekQ1Df9eXlGhhzg0L12HWM7UxfP6WKOZtjrE+LJxls41bvOIV41aM8fbz37lNthPszQ8VckXtuGppPzYFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M8EU4Cgi; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M8EU4Cgi"
Date: Thu, 23 Jul 2026 19:32:21 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iUNsv6F3BRPV+HsqzTlYvS5WqAvohT5slA1cbOMhU4U=;
	b=M8EU4CgijEd5DCerVoGnYh+RGtbQdjnraBJPaghjurMDVh2IzLzv9YfWhsgRGwAgegVrde
	G/HUYHHc1xzsB/JupdlLmAJGa5/pljUpwi84RyKtfVCfQE75DJlkc5gNow3rt/6abL8Vbo
	baUINkUifWh+dm94p7eBnhyOwlIDHyw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 07/13] mm/slab: abstract slabobj_ext.ref access
Message-ID: <amH7u3qrEBZ5jREH@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-7-2fa7c6f60dbe@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-7-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 20, 2026 at 04:16:21PM +0200, Vlastimil Babka (SUSE) wrote:
> In preparation for changes to the structure, abstract access to the ref
> field with a slab_obj_ext_codetag_ref() function. Rename the field to
> _ctref to make an unexpected direct access a compile error.
> 
> No functional change intended.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
