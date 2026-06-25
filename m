Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0102FB969;
	Thu, 25 Jun 2026 21:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782422408; cv=none; b=qGuAzK/dQCRVPXDDfXrujY8Fmwp7ChAO406XrALOLDMQgTgslexZrNf3zJkhJ0KWFxTpHrbHmnjLWq+wJmfffNDGfW8ZRG6C2c75CZ7LxU0bU6UvTucOkA2DIeRzCQ0iIVrlAIBCDyPYzSevIQZIY+WXPD42iJejd6qKathw2Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782422408; c=relaxed/simple;
	bh=vls/tKxHm+vtJXpLSCupj9CJuOfDIMd53MxJyoF4900=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=oPmcTGiMBn29cERlOYRbHWSnq1T0gTu9ICd4PJ75C6nAqWzRzSHp599mynq5jLE09HRdMT//UkQRJTWzQrs8s/46K4fc/kXhNxzxdqbKvF+HhrTo9CZo2ftLNJ55Y4n3crDF1eFljULU0ZTPsUwcF2NbnU80Zv/eSWGSnsji0Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AeaCb3Ik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeaCb3Ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601D41F000E9;
	Thu, 25 Jun 2026 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782422407;
	bh=vls/tKxHm+vtJXpLSCupj9CJuOfDIMd53MxJyoF4900=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AeaCb3IkItCRXGWBcH9YwLD/KxQFytL/hPasOQa70GOanIGGyPFzhCesbS3nOkbns
	 yQ6yodMsOKmnv6q546Oztuagu+By7H1s48qu9xLLlFu/5fOsLW7Oro/m5DJILP5sWb
	 oDnqEEMt4HZThgUvYLYkYwjWHLohfLuhGyHrZk0ehZV8gupIHXkMh4/5ApceogcQOi
	 Cnb8qubRerAcH5VkX0Q9DxubOqgeQH0fUPdEgvL+DjwCYUav3TG092UiXq/c0H7hIi
	 6Ic54kP7tJaDJgaMgnAGeifX5v7+0LP+qUiU01pYtE8/axJr1dOa1QOy92wvfRzuI5
	 elaOnJZI4rOYQ==
Date: Thu, 25 Jun 2026 11:20:06 -1000
Message-ID: <1a3026eaf111b5d4761ec941d031e48b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutný <mkoutny@suse.com>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH v2] cgroup: Use data_race() for task->flags in
 task_css_set_check()
In-Reply-To: <20260625013944.253318-1-guopeng.zhang@linux.dev>
References: <20260625013944.253318-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Thu, Jun 25, 2026 at 09:39:44AM +0800, Guopeng Zhang wrote:
> task_css_set_check() uses rcu_dereference_check() to verify that
> task->cgroups can be dereferenced. One accepted condition is that the
> task is already exiting, tested by checking PF_EXITING in task->flags.

Applied to cgroup/for-7.3.

Thanks.

--
tejun
