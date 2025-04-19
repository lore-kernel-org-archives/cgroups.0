Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B771EC5;
	Sat, 19 Apr 2025 03:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745031982; cv=none; b=e667oN2m6HGz/Xo0SALlIcuf6FPlGTVjd9rISGcxyeN9F1Qqz+W/hSkZKcJtQXrfK6u+vDiX7jj4pkAOTsOQ4/0pZ/OfdR3m/qebXIqAES0hnFhAgfJ9RVbUObqtGFTdmjqbFpyBN4vF1yKz6AdCw3MdVzqJ57yFWzdVtaej7KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745031982; c=relaxed/simple;
	bh=M1+LRyvWE1k+yZk6eS0NB7H7ludbBSzUMV6n2DD1EOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOWxQTn8S7gLs74FUOqSaGSUT+wd0+O0gFrUFsvNywRty+CffbqcG0ffIakHtsc3c/OEpdoac9/KpuYJ+fEX44mlAntv9x0sSnz7za5cbQQ19U538X9CADE0jRu9Z7JfT+Ha0rXIizRDEJFla0OPPiXBeZmFcTqKbMaPYHU6QcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IO/uXds7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IO/uXds7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98197C4CEE2;
	Sat, 19 Apr 2025 03:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745031981;
	bh=M1+LRyvWE1k+yZk6eS0NB7H7ludbBSzUMV6n2DD1EOE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IO/uXds7p/Cj04S1GA3k/BYjFn4fdOOOQhCfDdH1QbQPUrexRBRRi+SV+wkHwRfHL
	 GNGG6sJxqyM0LM9YVG8k+pepr0vrL8TRRlfM8lPLwhJ7bfTBAIBl0x348nGeSt/hrZ
	 ldvUMSHi/kLxW8dSLpsn5/foWY8+svb81i3fE5nkdtwYmBemrH1bsvmjwPpP4Y/rhW
	 lPwEYobl73jQgawkbMESh3ppiVFHtwcgDtaAbb0+x50s6Q0f9pIAUdWNK8wPNLy4Lv
	 fLEO9a1R6xmNCUYoHloxM5PXoI3GC1ZgiyKU04J+bWLK1Jbq/Ud9fqWha1ttPPOQvA
	 4w4Jmz+U4eNTA==
Date: Fri, 18 Apr 2025 17:06:20 -1000
From: Tejun Heo <tj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	hannes@cmpxchg.org, mkoutny@suse.com, longman@redhat.com,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org
Subject: Re: [PATCH v2 2/2] vmscan,cgroup: apply mems_effective to reclaim
Message-ID: <aAMTLKolO0GWCoMN@slm.duckdns.org>
References: <20250418031352.1277966-1-gourry@gourry.net>
 <20250418031352.1277966-2-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418031352.1277966-2-gourry@gourry.net>

Hello,

On Thu, Apr 17, 2025 at 11:13:52PM -0400, Gregory Price wrote:
...
> +static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> +{
> +	return memcg ? cgroup_node_allowed(memcg->css.cgroup, nid) : true;
> +}
> +
...
> +bool cgroup_node_allowed(struct cgroup *cgroup, int nid)
> +{
> +	return cpuset_node_allowed(cgroup, nid);
> +}
...
> +bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
> +{

What does the indirection through cgroup_node_allowed() add? Why not just
call cpuset directly?

Thanks.

-- 
tejun
