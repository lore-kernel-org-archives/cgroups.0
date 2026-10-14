Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C333C56853F
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 18:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792002320; cv=none; b=lbYkOoMaAty3P83Dy9v34s1lksQv2gK8OQxFABo6BUWCUSYA8m380+1DiHXbzoXaWdViQ8KV8otZWu8WOPbosdNpef1tfHayMjT941eV6eNbOh1oFdxHhQSCo2xhBwmDEX6/0vhuwzWp8SJWWw7Wl57x3QyrNZzmq6W6PiMMNNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792002320; c=relaxed/simple;
	bh=UfN8ZqWj05pIM5YKkJVUzL7gKRgIUqF/r9OZzNufKig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kuC7FzyaifA3iUJEiiSdDOJvgsZ9i1v/WJ7d52ZEz6eI4f0MT2L0FXVf6dLnzVJ5rxr3KX1icI4aRN2tF0GpHzaUSanIeclc9gEP+Nou03Wlv4SbgSNqnJ2kGUy52MHVFOc2QfBjYeI7owoTmEYfSFlDmeRaE516J2wU/gNrvzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F4kcBsuu; arc=none smtp.client-ip=91.218.175.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F4kcBsuu"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=UfN8ZqWj05pIM5YKkJVUzL7gKRgIUqF/r9OZzNufKig=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792002315; v=1; x=1792607115;
 b=F4kcBsuuZ4W2n1x039ZBV9EnzhnMB3gyiDXb3jvdpUyNbRLpheLiv1SomPNIWWDEja4+Efu0
 48oGSOObRjNS6Y9Y2j+7GgcxcaXD+0jfFot1I4omtNNSDNJD9TAVClOaiIO74Z30blw2Ng/Ss+Y
 aFbNxIJsufp7nV6T7G64couM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6dbda3fc00612143;
	Wed, 14 Oct 2026 18:25:14 +0000
X-Mizu-Trace-ID: 6dbda3fc00612143
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 11:25:12 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
Message-ID: <as_I8DoRCYpnTXJg@linux.dev>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>

On Wed, Oct 14, 2026 at 01:08:20PM -0400, Tal Zussman wrote:
> The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
> switch to native NR_VMALLOC vmstat counter"). Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
