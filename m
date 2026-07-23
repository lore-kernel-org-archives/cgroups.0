Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CC72147E6
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 11:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806223; cv=none; b=cuF1PFQaFNlON2mwcBOET0VtDAzYwligb68/SII1d9keXAAL8wQIuqrvOGKNTjlsx9gm98c2WOjirztu2OIC/D+k87lb4O4P7ByeNrK6bw2DQe1WJf7JJLn7vsxM5EcdwaWPXBWvSv1C6b5WBfkWqjB2zcndD3sOKBWZpVXPa1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806223; c=relaxed/simple;
	bh=KVvXnlom761ipVYZcOegXZymxEPEWbLjbtfZNz58Fbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7EWX0CgFee5mQgmd1aFhAhT5DzZ6QY1DawcRx7RcH0kEwOSl3C2zKBONpHKFIwR9vbmCgTFmev3WMXCbZQlfX9sAMpBFpdfuGSWO62+iMM4+j4yLorpSxviyMEfzD4wGhdL11rs5RgozXXgavtxLCvZ/btdXip/5N0FisXWfJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S+CxPn4V; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S+CxPn4V"
Date: Thu, 23 Jul 2026 19:29:54 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TlMXS0ReEa1Jcg5Kw/12F9RUMNxQ8FVd9z21BkuydjE=;
	b=S+CxPn4VeSNyIfb3s0ABJkkUNzNutt68r9nqps6I/lyAtvkSCQnLvPld/W+kKaNpsYjWg4
	d8mxCwLHUTJWLe1QHnM59lyqfVjxrsqlcQrxlTSBqNxCROwWnKVAEA4422DjU/UVCaLskT
	OZFnUjxbOo+xE63T508iZlC0nKXtdPU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 04/13] mm: move struct slabobj_ext to mm/slab.h
Message-ID: <amH7GSSZNliu1vWt@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 20, 2026 at 04:16:18PM +0200, Vlastimil Babka (SUSE) wrote:
> Users of include/linux/memcontrol.h don't need to see this internal
> structure. Further changes to the struct will reduce recompiling.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
