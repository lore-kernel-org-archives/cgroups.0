Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A0323E342
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 21:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787780760; cv=none; b=fBa/FCByBm/cA8dSyoONl5GsWqyjYFByGOxUzaeUDfC+QuiESux/9U6n3rKGOORXp8WMgo2nrz3Ki8hPizZcUJCJwkoV7j6w9lTTHGCjvQX5dZ4oL1cC+I11PjiiX7N70DRqvGrGzqRGegjqwNP2JXfFirsVEYJqzR+94wkJmhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787780760; c=relaxed/simple;
	bh=im1e6ev29SXlYnnNiPx27R6n+npPS4nBwC4ipXAS5IE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgRN43GAadSGfFYiqNLGSHExvBExoeI+OwkJZnbrb1saZVBhQ4aQZXp4nvzvn/b0gvVYeq5f23EgxlpOKZWQhaMHCDs5RomNJ5GI/O5V+WyXy8Btbkzg8VlVz/ZdWWZN8eTHr/cIJWnWxDvuCeOShZxyQX6w43ly6yecDIRSRv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jtxGFWwL; arc=none smtp.client-ip=91.218.175.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jtxGFWwL"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=im1e6ev29SXlYnnNiPx27R6n+npPS4nBwC4ipXAS5IE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787780756; v=1; x=1788385556;
 b=jtxGFWwLlLdnV9VOVSCx7zF6ZU4EzNXUFWB9UzvLJEMI7oyKysVM4PvRdfhxq7yfnM9ClIuZ
 +ak0djNo3e34We5TMtGsCsLi4QDPpwQ/HsyzFdKi5LxcIUrmYVHCjgn8VQqmiLvOV/3AuHz0D4a
 m7mZ2bU244UtnKoK1wfjlIuo=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:42::)
	by smtp.migadu.com with ESMTPS id f36f976b6e63a41b;
	Wed, 26 Aug 2026 21:45:56 +0000
X-Mizu-Trace-ID: f36f976b6e63a41b
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 14:45:54 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, akpm@linux-foundation.org, mhocko@suse.com, 
	mhocko@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] docs: cgroup: document empty-write behavior of memory
 limit knobs
Message-ID: <ao9eZmOucnSWS9ID@linux.dev>
References: <20260826021753.197871-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826021753.197871-1-cui.tao@linux.dev>

On Wed, Aug 26, 2026 at 10:17:53AM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> A maintenance script on a cluster wrote an unset variable into
> memory.max of a workload cgroup; the variable expanded to an empty
> string, the write succeeded, and the workload in the cgroup was
> OOM-killed.  Nothing pointed back at the write, so it took quite
> some time to trace the OOM kills to that script.
> 
> The memory controller documentation does not say what an empty
> write does; the cpuset controller documents its empty-value
> semantics.  The actual behavior is that the empty string is
> accepted as 0.  Reproduced on a k8s cluster (v1.29, cgroup v2,
> two-container pod, 384M limit):
> 
>   # LIMIT=
>   # echo "$LIMIT" > $CG/memory.max
>   # echo $?
>   0
> 
>   m6demo   0/2     OOMKilled   0
> 
>   Memory cgroup out of memory: Killed process 339529 (sleep) ... anon-rss:32kB
> 
> State it where the interface files are introduced, alongside the
> existing notes on units and page rounding.
> 
> Link: https://lore.kernel.org/all/aoVUlFdZYLFn_gvJ@tiehlicka/
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
