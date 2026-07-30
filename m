Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33021643B
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 12:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785415287; cv=none; b=LH3zGWD5a+KAyhKI/WRmTqI57fbmlTu3+/pl88OUowcRnjURQewG1IHqP8NoLNf2ouuLZKHxQ/v6P8wcDrYTSxlstz2XeCz/EEQ7STMpsU/veNPM5mbaK2xOnag54t4X7KiAWfORC0bjUQsmTrV0o7cEeqjLucCqFL1FYx1h17k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785415287; c=relaxed/simple;
	bh=hS3IKyTqTg/hpHB+jNKR49p7frx5eoDh7PZqLLCO/EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGBS4JBztH7E99MOGU6hri/cLTcnBGtC7VKoXlYMAFyRY0ExBZkq3fJjyQiA97ZP014fvu/Thwa0QKvt7dx29yts/ExZsZiYtWLSmgnWgv9Y9thk3yRbFPClZnX6LR1GCRyd7xscl5E9IneSoHDwH1+SulUZDxVNWHzRHrwF8HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KmNYeTuB; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KmNYeTuB"
Date: Thu, 30 Jul 2026 20:41:14 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785415283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Yn6zB4FyaoOlg1O+5S/R+uP7IqARiMq9a6Q5IJKpbk=;
	b=KmNYeTuBY61Zd8qBvi5I7WRr5XPb7xsUl3E3K8/7mKm7457Qb0FUwKaz9ZsvAaWizpNg9l
	ayDE0CAq8tIY57qHQL9Xf3oqg5Cj+4+7sbYMD5psOO+kk3UNCYAWIEk+vNOSinQvUR1AIg
	E2dTua96p66XoI2NTAImSv4NHgVXBEU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 13/13] mm/slab, kfence, memcg: completely remove
 obj_ext for kfence objects
Message-ID: <amtGQIpVU4WoWiXf@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-13-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-13-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 02:54:07PM +0200, Vlastimil Babka (SUSE) wrote:
> We have already disabled memory allocation profiling for objects
> allocated for KFENCE to avoid complexity. KFENCE allocations are rare
> and there can be only CONFIG_KFENCE_NUM_OBJECTS (default to 255)
> outstanding ones at any time, so they are among noise in the profiling
> stats.
> 
> For the same reasons, we can stop memcg_kmem accounting of kfence
> objects as their memory usage will be negligible wrt any practical
> memcg limits.
> 
> This allows us simplifying the code and getting rid of
> is_kfence_address() checks in various places, including slab_obj_ext()'s
> usage of obj_to_index(). Instead we rely on the fact that slab_obj_exts()
> will now always return 0 for a kfence object's fake slab, which makes
> those places unreachable.
> 
> All we need to do to keep this assumption valid is not to allocate
> obj_exts for kfence objects, so the checks need to guard
> alloc_slab_obj_exts() where necessary.
> 
> Suggested-by: Harry Yoo <harry@kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

LGTM.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
