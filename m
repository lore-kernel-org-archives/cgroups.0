Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77698568530
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792002346; cv=none; b=KOubrH7mTnqhxg5OZUFkt9YLeW2C1GQCUVAVQVF9Zggy4CVwmGwT2WPfRy1J7P6p7+IHZCpyctgum2QKp42yQ+fvMXm0UyiuPhTYK7/3NAmyI5tMa4BB1qRrsSMYIzs5VytQXROnDqi2u8ZRQDtpxPfrCNdIYXBoV9WvLVuXo5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792002346; c=relaxed/simple;
	bh=5UxX2FiFo5VA5ijcKXQz6fPD7Az4Sc58UOdLO4SLUNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVJGi0YEykDIP7qKtibTIIS+sI4hNoC4ul26i8FuCm3watshtVXVkqMN8LRHp/231l2G1PBwHJ6rQT15A0xTs/rm0txeKo0Atpz2CeNdPxsydIWTBEe4suUYBwO1f2DtisylBva+OA5UYP/k0svHqUrZICIbtVAJ5KzMS2UMWXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=COUrGZPV; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="COUrGZPV"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5UxX2FiFo5VA5ijcKXQz6fPD7Az4Sc58UOdLO4SLUNA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792002342; v=1; x=1792607142;
 b=COUrGZPVzyJPUy7oI668mCbm7HAtCt5fA1ZL1JwLDZfBO9NZjRaRbVC+VehuGZmq/NymELHH
 GkSJf4JjqBk+q2sLKHFI5GQEkW0weDF5AVYXg0yAsO4cp13FjuWFyP1J9eCuSmMp112Vl9ZHqs/
 +xOLP55AlT9quqo5PuPuatnI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 15e0d1628d62c846;
	Wed, 14 Oct 2026 18:25:42 +0000
X-Mizu-Trace-ID: 15e0d1628d62c846
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 11:25:41 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
Message-ID: <as_JE-NHoUr07Mgz@linux.dev>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>

On Wed, Oct 14, 2026 at 01:08:21PM -0400, Tal Zussman wrote:
> The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
> Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
