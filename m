Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D203BB67F;
	Wed,  1 Jul 2026 20:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782936659; cv=none; b=faHDzZBqAYeWMn2i4xE2+uNvBmE5x96mrg4MKNIcDvER0iuNvs6fsIdObLiYcg2fw8GksfJlgXrWNHZyjzkp77p9naDEKdeXde+u2sXwpXy+qzFFwPBzW6dEuc85M8L+pP+RQjtw+7VhxWAlhuJKaAfqL6Q//NQ5ooTsZgQS+lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782936659; c=relaxed/simple;
	bh=jS7TB0HUTcuMj/hqMgFibYlZ8/MRJH92GYaNUUPWBp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dadIMo482anYvFLoR+L1NH7RQvYZy+QpwhPYvVIoRABqMrQScyjeVYpey4HHapw4Kk+jLtFgGo37PKWInCt+efBoKZRoNEBM2iXMb/j1qMo2jw3M/CtXqqkLsmYe1bY7anG5pGZmGmItGM4sHJ+UXXTVrKCqUTD8ae0yqfaZuHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZq/fP/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZq/fP/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10381F000E9;
	Wed,  1 Jul 2026 20:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782936658;
	bh=VUOJ0y9LDh3g3+h8oNdNTGK21keh5KSbMCa0j+HDbUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZZq/fP/OuuU3nOOPrmSRpiEpngyZc+7MOlJUdbptmQfQsvX6YgqszY+07WIJQiuP/
	 1+HRyhIqy+Y8/Rp46ejix+9elqfJ6cDlzGyAv7sCe7yAUtJep6zAErEe3hmR/B8lCm
	 4+NctwxONV5HqeFIdWImiP1jiCzpYI4e2Ev3Ylb2EwHZFXByOKr/aMHVlD1Av6m+kT
	 zM19j4teCgyWZriUE35mbCOavUGZf1YrVLlrGsEwvoUC5B9sX1mlXBzK9/XfgM7EBG
	 3pRD7kUackf2q99YyaRt6jGQFDmfVvXiV7BU7bdhsWJgeG4SVh8I/jIgtv4azPY/I0
	 Wrt4u2KvzgdlA==
Date: Wed, 1 Jul 2026 23:10:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Gregory Price <gourry@gourry.net>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: gfp_types: fix __GFP_ACCOUNT, GFP_KERNEL_ACCOUNT
 documentation
Message-ID: <akV0Skp68nDUsny9@kernel.org>
References: <20260701182102.1586784-1-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701182102.1586784-1-hannes@cmpxchg.org>

On Wed, Jul 01, 2026 at 02:21:02PM -0400, Johannes Weiner wrote:
> Gregory points out that these descriptions are cursed and confusing,
> considering what these flags actually do. This is mostly due to
> historic implementation choices and cgroup1 baggage. Improve the
> description of their actual effects.
> 
> Reported-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.
