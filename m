Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AFD423782
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 11:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785412797; cv=none; b=C8ytWSIgZ8g1lC1jWP+YwZPDuDmBCt+V+PpGOQZHEbnLEONsqDyrhmpiFQDftSLtkCIGrZpLAT6LrvepvwUQEHmbLjCo23y91nnKIJTd1lPthrJnbGTe1VvYh5Fs79pEc5koumrcpCeS8P6Yahf5bFYOImAlvYctBe9KEQ8yq6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785412797; c=relaxed/simple;
	bh=UBZ6J15JE8JOl/H/TJQQ3WEDucCLj4DhCS/3D25AmpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ori6gZJtYjduMApYZyaHtMQBIe4+6GwSpOl1cteVeP0QzTv25DbD4jGuhgntzh3wju1fInAvb9aTjCpdXPp6RTbjKXcbJUwj23LgBzENC43QeXeY8gPbX7ULchOXM6K+5DDDKSspI5hMpCemJwftgOihw+J3WbSCiMTv1uMmr7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H6fcX+V+; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H6fcX+V+"
Date: Thu, 30 Jul 2026 19:59:43 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785412793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tFyNfAcYv9RPgYotYZ60HIainFhyC9UXc9B2zptyL6E=;
	b=H6fcX+V+Zq+Tdlen2oRt4iHMVx1NYD6p/BkA43u0HK8EKE7Z5RJ24pck1jTyqQmsGiDTZI
	pnXhXGMBImTQby8sdSZsu5+k3ql23ZYX2dlrF12SkWghfKiw5KmzHH+KilqDA8L0lMpjoE
	85mDM69mmQUC564eY2GQuZ6dAHa2Yuw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 10/13] mm/slab: reduce slabobj_ext memory with
 allocation profiling disabled
Message-ID: <ams8mMMzBmu1AoLz@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-10-c29ef0f1f257@kernel.org>
 <11f5028a-3fdc-47b4-9712-559c065b87ba@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11f5028a-3fdc-47b4-9712-559c065b87ba@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 04:07:48PM +0200, Vlastimil Babka (SUSE) wrote:
> Per sashiko [1], a fixed up version below. Couldn't trigger the issue
> although seems to me it's real. Perhaps can happen only with SLUB_TINY
> otherwise the sheaf can't have obj_exts allocated from objcg charge path.
> 
> [1] https://sashiko.dev/#/patchset/20260727-b4-objext_split-v3-0-c29ef0f1f257%40kernel.org?part=10
> 
> ----8<----
> From 905c6500e597a8ecf123ad167698f0a0c1a764bd Mon Sep 17 00:00:00 2001
> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Date: Wed, 8 Jul 2026 17:04:36 +0200
> Subject: [PATCH] mm/slab: reduce slabobj_ext memory with allocation profiling
>  disabled
> 
> When memory allocation profiling is compiled in but permanently disabled
> on boot with (implicit or explicit) "never" parameter, stop allocating
> (thus wasting) memory for the codetag_ref parts of slabobj_ext metadata.
> 
> Do this by using the new slab_obj_ext_has_codetag() helper in
> cache_obj_ext_size().
> 
> Additionally add slab_obj_ext_has_codetag() checks in
> mark_obj_codetag_empty() and handle_failed_objexts_alloc(). The
> functions might get called with memory allocation profiling disabled,
> when the obj_ext array is allocated for objcg pointers only. Setting
> codetag refs as empty is unnecessary in that case, and with them not
> allocated anymore would now result in memory corruption.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

LGTM.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
