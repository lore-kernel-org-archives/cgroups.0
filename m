Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285F651121F;
	Wed, 30 Sep 2026 17:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790337; cv=none; b=cEjoe5JW8Ddi/HSH/BgGrYp8/e/wWq6rJRD5xmFK0ohamdwHV/nIXKf229MDZFP1evXZahL5y1QwkDkmOHIMOYqCQNXCAqrriLVq2GR2LgEzC0q4mrdPJRFyXJ7N3tfrvKpGAfk60uvGf0MqeM3hzUmPrEJKODHwwK2tMDM+gSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790337; c=relaxed/simple;
	bh=gynFLKHl5E2aap8yTp84N3eN1GAmPhSKUaaxf4Zlzzg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=VP0iE/v0umCYQWu70FJzzbOctKOkwGkP5JTi+MRJfSUmwzRKYBtS94IGK8F+fxyIxk84inugSewWbxhze82YFjPDLwgQjaoQhPncMU5dFp2eQcA/ufxniMvihrWgtG0GJuX6D4alLmrorxGGKbzZQ9oc/sGcdYR1f3/OAUhKBN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aR5Lxcso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aR5Lxcso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61FA1F00898;
	Wed, 30 Sep 2026 17:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790790336;
	bh=Kti0P5oaislqfizBwXLh5XdjsvDSunsQHh8CWkZwro8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aR5Lxcsofp1SEdoImdTGR6y8RHwhNo9zXJuc4+BmUKc9TbctT4wG5Z9AGWAIGGHvP
	 +rVb99oPT6dYu5pWaJWGY7yjEB8ay6sJdpof1lcfG2IqmvduOfnSgC25YvXzNUM42t
	 MbEk2j7JjxajbdfSC7mXI2vQbmT6wo0tkMC8A8TeYwagIq54Vmubb8UWFFCc8koa3b
	 NDrPiu3mX8IiqSb5uABSojS1cfoiHbcP7ScS5AOi8FGu/eBomWdahL+8lGZMnIEeii
	 NqAJlpIqdTj2+U1BaOy6ldjZD98R0QiADeBA9X1OlSz6XTJJICHgVE6MTXwOEZzVWE
	 xfaR7vlxVOPIg==
Date: Wed, 30 Sep 2026 07:45:34 -1000
Message-ID: <cb5a95ca6d9005464272684e861c253b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrea Righi <arighi@nvidia.com>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/cpuset: Don't access cpuset_cgrp_subsys.root in
 is_in_v2_mode()
In-Reply-To: <20260930031833.660267-1-longman@redhat.com>
References: <20260930031833.660267-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.3-fixes with the following tags added:

  Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
  Reviewed-by: Andrea Righi <arighi@nvidia.com>

Thanks.

--
tejun
