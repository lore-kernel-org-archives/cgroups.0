Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795692722;
	b=Ka0UmrWVVHG1k8pJBcWim6Mlj+2Ya8jZX+Xm5tIFu3O/PymRuyaMweXiCAlhY/0Wn2V4
	 gSe8JzSi5PWbNOiGuaMOJeqsMioqRECQm+aYPbo5XBlQBhKU+QhOQvbW72yCHvNq0mdD0
	 8+X103wHUiVFlcp0SASWzEK6R1S5TMBB/28Ypi+q8eP2D7w1XUuzvfS7BpVoeIolCVjoh
	 Z44JyU8bRHbBtLzOwhB5bcehJcI4W9n+vTAkN2U1ta3yWbiOfh8Mw5yAsYZyxloMycYuv
	 kZOPu0gknTlh79gTNKc6Bm4rJeo0KFh4+uuJT/J7wkR4X0XQiOTEJooet9hGWc3O/dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795692722;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=8JlQuJluBUtkrYV8BvIj6qg2BuXgVw0g5oW69a2Xuvo=;
	b=0iGhkgsW60HKOe2Sn6K65B0d2ri8Ld4WrjtSMV1sWuuJiQPFxb4fbPETQspuvr6AYHpn
	 6XBYo4XmOR+LygIhmgSCBqsIEspRa8ALHvMvGzQk85/Hpb+MDiPxrc7565VeKg9cxIpZk
	 eoGLc/iRDOl8CHbOfFefbfDU2e9fz9fcUwK5jhC2lbwu8uuthL7XBE+5gsRlVFX473Txq
	 LRAcpUthwBvt6LZZVRoBvOX6jkgEsd3kqyopIYYIle90hDo1Gby7yhcNcRlHAr8L1v6tf
	 mczVXn1fqHYK9+OOXG08jgeyJF+XqDefJHvqm5K1m3NMNLRyj06Qbc09JO+FHxgLAYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YB1YqoUl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0373F606A321;
	Thu, 26 Nov 2026 11:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YB1YqoUl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B38E1F000CF;
	Thu, 26 Nov 2026 11:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692721;
	bh=8JlQuJluBUtkrYV8BvIj6qg2BuXgVw0g5oW69a2Xuvo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YB1YqoUlAO8fZWDJDroTUHBtaaQ5kH+mnRD5G3+H6ZyIQwdH+tLQ2DflPsIHGa4l0
	 OaitcI8rXxNZSMAsae80v4OHtC8CByq9ZOQ7ZnpARNRbF313/idPhnd8ZsDvYh9bCV
	 1SgVTXtjqT7KmrXX4FSb7yVGMwFMQ+stErx7763ywIis84NkwOBlwo/grI4JQVdXNZ
	 f1xyudiarBVK5dcMrtvw+OlMcdxtAeHXvrzoB0QzVmD5G3yhpnVp+ytzBvmPMaq97/
	 WqsqnbENkR0pmZxS5p1rCDKJxotqZIjnRpD9xQozzhy6YFnktC3CFyk/Yfkp4PK8LW
	 Dp720y+oHfg3Q==
Date: Thu, 26 Nov 2026 01:32:00 -1000
Message-ID: <fee78323e2cd763594b0eaaefbb1ee50@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] cgroup: Fix cgroup_mutex deadlock through cgroup_parse_float() oops
In-Reply-To: <cover.1795671629.git.chris@chrisdown.name>
References: <cover.1795671629.git.chris@chrisdown.name>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

> Chris Down (2):
>   cgroup: Fix divide error on long fractions in cgroup_parse_float()
>   selftests/cgroup: Test parsing of long fractions in cpu.uclamp.min

Applied 1-2 to cgroup/for-7.4-fixes.

Thanks.

--
tejun
