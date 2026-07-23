Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2CB470131
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 11:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806241; cv=none; b=KiitKFESpaJQIkiFr5MfJbeNnqlFQlXjTH1Ha9Ng7CzDuQZl84GazDgKsR5fWFQrTk+9+QqEZ4FDlX1G0VU719Jugg3YC5IGjqY/hHSbRBFCNxaBAba6niDP8v1u2ds5g2bokOI4l18XQ/00OWp3IqHAlXNMEBfUSnUTWrvN95U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806241; c=relaxed/simple;
	bh=YRdBILewMpo6OFyXoh6VceZYQDpoFHt18pz9vghiEpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mImFPFNcRpNEqCPPyocnqDYY5VKyMmOqBY6KvKciFL92izsCnSmwhpFL4NuVeGxMzFB55AW7PA0dMpeLHRyod1vBCNm0CRf0XVIC1Szz/Lx/QeBIOY5rVHZKdrEv59qrB8IIyc4G75cKXdTYmqRI30hF96wKSHtHtfbIKYAkX/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GoUae43X; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GoUae43X"
Date: Thu, 23 Jul 2026 19:30:26 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZC7L0HZBSSBFm17jYwEmeIieyNJcmoqfrgZhjSok9hg=;
	b=GoUae43Xjonc4DcNTjzHA93JSBkg6hHt+SWUCUVrHOIKOQJm+eYyqzu26Z7Wd9C408DAuO
	7gwZOlFmYC2nYqR7H1enXuVZ/jEFOlHUet+5Ftg77v/C1ZbDuVbg0HLL7fGx4TwE937uM1
	JsdwSMgj86xisBjw4x8dsyZOk0xJ6mU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 05/13] mm/slab: make slab_obj_ext() determine object
 index
Message-ID: <amH7RRa2lG51viwo@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 20, 2026 at 04:16:19PM +0200, Vlastimil Babka (SUSE) wrote:
> All callers perform the same obj_to_index() calculation to pass the
> index. Simplify by passing object pointer instead and determining the
> index by slab_obj_ext().
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
