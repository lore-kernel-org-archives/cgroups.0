Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042353E49ED;
	Tue, 22 Sep 2026 04:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790051461; cv=none; b=qMpezTbTTViPrhZgEbluKZtoievgpBtQr43ppL8cmiUVZDj4H6VLvgYQZdAQqXYo99xzZGNd6RbYQhG0b2L1PvC6yGzhs2V4Hf4srbojeSu2OU5JALJsp4cGi+USZyzbRJd6KIQ6ZwWz2N86qTjWsSMNJMX0MM0iJD8huudQKtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790051461; c=relaxed/simple;
	bh=B0w3NMcmiotTExoUt0aYhmBjhhim2osrYdENDXTORQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H7IcW7cnlaIFgdqc0sWcZB2X1sbPMDT3s9F34CR6isLY0zUg8jzJi7NxFqVHJH791fRn2rR8ClBtmPs4ujdRQ19bgvXK3JJ1XJcHi0byGOdGvgYw9XzHvdg1Eh5xUv5W90XyjYwOgoJSxAsRP43E3gq6mPdv42mmIeLIupo0ljw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hldADQWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hldADQWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FF51F000FF;
	Tue, 22 Sep 2026 04:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790051459;
	bh=Qdc5R7bjkdDuaNSCvOWojUk5Sg6yPCfSAhPuY0K7RNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hldADQWqF/hfs8SN4fmi7i5kP1AZdSlkfbJB/gbHkmwAWaZLmLnTQI0XrNAhIWA47
	 SIQ27wxt5GZOGMjM+hGvIcsLZezM0IfAan3a+ojz5ys8lj83KgGWDmo3+KNlosiyzO
	 Iv65CgDxWAjl4ThF2wf0R3YuxZCpJ5P/LEkbLGIUXyj+Nj6hTfyninHN9PxUboAXj1
	 tosch+L2yJ3SvcbfAHkwv4RzLjJ92Ixhf9ABr9fittTCBl8UBNAekwKHaURP1h7l+8
	 cgr/k6MDgrv2IhX8a+N7Sz1HfNWKEVCRVCwc+mMXm/CFrWUpFcBvyTD9y/BRWZU62b
	 BWhX3kD4uHg8g==
Date: Tue, 22 Sep 2026 06:30:52 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Hongfu Li <hongfu.li@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>, Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
Message-ID: <arIEfJXYpspgX4-G@localhost.localdomain>
References: <arIAyyjYcCKHFmyD@localhost.localdomain>
 <20260922042054.3264663-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922042054.3264663-1-joshua.hahnjy@gmail.com>

On Mon, Sep 21, 2026 at 09:20:53PM -0700, Joshua Hahn wrote:
> On Tue, 22 Sep 2026 06:15:07 +0200 "Oscar Salvador (SUSE)" <osalvador@kernel.org> wrote:

> > Why do we need the whole thing to be embraced by rcu?
> 
> Hi Oscar,

Hi Joshua,

> 
> I believe it's because now getting the memcg from the objcg requires
> an RCU lock to make sure it doesn't get removed while we work on the
> memcg. I think this is since Qi Zheng's "Eliminate Dying Memory
> Cgroup" series.

Yes, I understood that obj_cgroup_memcg might need the rcu-dance, but I was
unsure about the mod_memcg_lruvec_state() calls.


-- 
Oscar Salvador
SUSE Labs
