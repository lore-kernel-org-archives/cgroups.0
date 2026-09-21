Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AA74DA9B6;
	Mon, 21 Sep 2026 17:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790012033; cv=none; b=SOT1D6MmwNkcHx5/DKjF379vejvgtmGMuaI7Qr36p6YLsEh3GqPhtEYSAItsiJHWVLw6iNZGI64sGod6CXoJdyF3KPy0pjBQJtJtNGXkjntRNr9xzJlohwqjyk6wRh5Or3313g0VAnPRAWQLjL/Ej0crpyNXDA8JXR3DSutDVn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790012033; c=relaxed/simple;
	bh=uR7wV36xAa8iPqPouAh4nJajwisvFjBFYaA5qZKz864=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=mSfWLJd7Uiev4hOw2uuLL9terIGqo91awuwhNY8eIdKK5jd5MxmMQ8FrwRBuKqmOWLGweL9EOmljxrKXpppZMy5QjHLQDvGbBlA/hjZ757YYyLgG5+0jGQU8ZkSGHFE5RHIQpRws4qeyQrLSy1hXHd3ZToPVlQIRzHLe3sGblBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1nYUKKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1nYUKKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F251F00893;
	Mon, 21 Sep 2026 17:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790012032;
	bh=uR7wV36xAa8iPqPouAh4nJajwisvFjBFYaA5qZKz864=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f1nYUKKADbDxvyTGIvuLqeMi6GTZQ3oRCtcLuiunGUURq9/FssEI75Pi209WogUEx
	 rRCR+xPa1C0uoG1hf2sr3imM+wvIEdWcSC1DFmLB53yXlh4WL3bdV8uI07wwregggP
	 cc67IVeJ2Flf87UWEW2+kSAbdq3bOb9xbEhxEcd47mP0OhV87hWQfOuaNPw8LnBOow
	 Q4HF7El8VO+KOZjauX9BkHbS0YvQ+3lbw95iLIXbGbdMP0A16OCpa0Sjt74eRngzP/
	 n7CtoYT37osoV3AUYfqStZWBEvH+wBL4hxwNRBHpHCNBOvvjUy+mt2gFgvjb8rAGOL
	 IxwOO7Fonpkng==
Date: Mon, 21 Sep 2026 07:33:51 -1000
Message-ID: <ffbe8ebdff9cf70efdec0eed8b37c107@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH v2] cgroup/cpuset: Remove redundant sched domain rebuild
 from update_prstate()
In-Reply-To: <20260920025256.24991-1-guopeng.zhang@linux.dev>
References: <20260920025256.24991-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.4.

Thanks.

--
tejun
