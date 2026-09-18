Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE322514766
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 17:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789751635; cv=none; b=cVkmQwm6Jjz+S9Lnp1XJCS8BTnh8SE/nlnc7VZcqvL5g//Q5o1a3wdtSDSwxpkdBuEWV1CgZ9jmvniHxuCFWn6vTQozbq+V0AE6Clgcrd5PpGHmW1CrqULgrJ6xUv4Go/i1ODiPnea0MminTrO140ZezrCzmlE95POTQ130MBZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789751635; c=relaxed/simple;
	bh=ndCnKZX/bEAj9SYGxAyrtcS4Yu83eV0J3O5oABweiBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fGF8jjPVY++7spMP+bBOC6BDBeMWqRs77jjnp6fDAUo+v9ZyuvjOMxI7XrmMr3rVLsik3amAHcaxlDSsD+RsjJIT/UcBaSAiMCBp+GAukTlrIeda6caoqDW9YWb27cZJUB89NIMLQQZHYAf+sDYzsOhMQ8eLzF4dVwJExJRRWiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tIvxKBhk; arc=none smtp.client-ip=91.218.175.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tIvxKBhk"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ndCnKZX/bEAj9SYGxAyrtcS4Yu83eV0J3O5oABweiBw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789751630; v=1; x=1790356430;
 b=tIvxKBhkPyO7goTYX6PJmqef51HP2r+oLbI5JwBsiMhX/5IyxLK3YKKf+4Ax8qXsJXfTTWJQ
 TdOz7DvubI4E0BGpHsrbZUpgsVUG9kdnak8lYASp/wp0W8Xvv6ZI7pGiYzZ8uyHivEdkaztuPyy
 NMBTfUgdGYYV2T1AQ3GSehXc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9871b9beb432cad4;
	Fri, 18 Sep 2026 17:13:50 +0000
X-Mizu-Trace-ID: 9871b9beb432cad4
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 10:13:48 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH 1/2] memcg: remove unused page_memcg_check()
Message-ID: <aq1xPIhfzvUUINle@linux.dev>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
 <20260918165601.1014666-2-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918165601.1014666-2-ekffu200098@gmail.com>

On Sat, Sep 19, 2026 at 01:55:57AM +0900, Sang-Heon Jeon wrote:
> Since commit 90f095b816e2 ("mm/page_owner: use memcg_data snapshot to
> avoid TOCTOU in print_page_owner_memcg()"), page_memcg_check() has no
> callers.
> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
