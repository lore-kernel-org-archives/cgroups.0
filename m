Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6411BC08F;
	Mon,  6 Jul 2026 22:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783375772; cv=none; b=DispSUbbQNFw5PRLg2sa6n/B+j/UcQOfMk5y7DSfzg1MQolysYZFi/SHLWfJ54chN+KmlM0+QTYqkYA1Eq8v6tKqGUdYwIpWUtykfKTyleEHuiRcDNwFKJ6n9YCWZ3GCWAkDkVJAI4M5/JfHTwpvCMmL5VO3LBo/ZZQVCCtXeqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783375772; c=relaxed/simple;
	bh=M6J8rmo74YDrXmogw0vI24lrkohvz1jMylSnzHCFxoE=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Tr5hKiG1ydDcqI3EB/b+dlO44hJJbA6279UTt2/9uYMNLiRhytBptiay1phlK1TmtHq+Ba8mbPrWel9k9YCMQrI3zr4HEP6VIrjFxn48v6m56UacJJDu93sjb4pJM7eBTaMUg7zaIIAKAVP5UasXJpAnMLcSDZdy4AVXymwcpPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dd13GMsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dd13GMsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359DE1F000E9;
	Mon,  6 Jul 2026 22:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783375771;
	bh=M6J8rmo74YDrXmogw0vI24lrkohvz1jMylSnzHCFxoE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dd13GMsjz+V68AoYcFSkxKjX9vuQjKuPGTosAbHMWekrMvv5wa0NLPShtkKLLNmn8
	 GAoD8Qk0HrBF6122V2795T8BDX2P7CCCxsomh7/f9tKnyqr/N7iGrs7+oBnDQfLVs2
	 EMPy93w5CGSDBvIWxIRjzDDdPOXd80P6NlHAsIiaGfwvqoxyEddYSOAvNDlptktnyH
	 fMdQcGLtBUCsLuzeTL0XZ/XY5wGeG2MYheXIutoOfpYJzQ+qrXTpG7jKJwF6yj4tkw
	 DviJlqMuiNhqjww6jO6sBHHGhYGU4nwU97ZApTFuMJ0GXnYFwObHc34RlXURbaniMl
	 c4CesxPnQ3MQw==
Date: Mon, 06 Jul 2026 12:09:30 -1000
Message-ID: <1e27d727c3c35d11f6e19eca769478fc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Gregory Price <gourry@gourry.net>, Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, Byungchul Park <byungchul@sk.com>, "Huang, Ying" <ying.huang@linux.alibaba.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Zi Yan <ziy@nvidia.com>, Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, "Michal Koutny" <mkoutny@suse.com>
Subject: Re: [PATCH v3] cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
In-Reply-To: <20260706082023.60832-1-david@kernel.org>
References: <20260706082023.60832-1-david@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.2-fixes.

Thanks.

--
tejun
