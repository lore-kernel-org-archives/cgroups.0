Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2B9388885;
	Mon, 12 Oct 2026 22:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791845592; cv=none; b=a85gv8+XOhvprBWaphivio2jR3xXt9VYRk1BBuztj33SehztO/3qguAYXra+kRIE2eUtOLjVM7KHHEhD5Sb5B4359+SGt9pPpI8XeXB6i/5TiuuHEDnK1Yyq13std0ZCLemUsb+gYEr5I6PF7OixIYVL7ItiABWqWQIke84zNuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791845592; c=relaxed/simple;
	bh=cbd5SLGpd3ZKm/a2Lpt19vkp+xfOccTC/a4ukIGNaz4=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LO7eGb8FSMutbJmx265KDCvjD456L2GzpvLy7lwxkNPhOEOMyTfkuHj59Z3SY2Erleb21aZ0bBMm8Abhze8eANxp4QMpSk3lXlVWTe2oRUu5nNH3n/MnzHeS0Ok6FqSnyU2jbYJyt5owKka0OiHOi5/oehw4pDbWhvx59dogLr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHYk4izD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHYk4izD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87511F0089B;
	Mon, 12 Oct 2026 22:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791845591;
	bh=ra4bGU5hjwPdP+O85KwoDbWT6OIIoUm9wMyIS+2xy2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHYk4izDt9ut7uMMQpqWFwr56Ny20zA5aNpsnVE3JP7S146WcTtj8NZLl6qrbCfcK
	 I30FzqJsWyw9VgXv1XREvExc3ExyDxAw0a0tLj2vnTLYIsWl4b3/i7PLj0CrmyNggd
	 Sus5H2PWC9+0wvB2SMO+Gtet7yb13kbMBTPWGpmHQ5YJBM/J8N3ZGUtrDTGMnrlZ+P
	 l8LV7e71V3RrMBBQjfdepLAjRWT3VYZt+FM8cv40M9nk++qpcWhdHwNbJbVonkFd6u
	 BRxahkrflxFkJvj9bPfYnG+vKBXN02SGU6+RHmpXjfzBmq2WtIEoiJxmRxagD9IWBW
	 6MsljsI7Rr3vg==
Message-ID: <f9a890bf1642c63d27ce516cde0eec15@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] selftests: cgroup: fix the flaky and vacuous test_memcg_sock
Date: Mon, 12 Oct 2026 12:00:55 -1000
In-Reply-To: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
References: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Mon, Oct 12, 2026 at 08:59:04PM +0200, Konstantin Khorenko wrote:
...
> Konstantin Khorenko (2):
>       selftests: cgroup: skip test_memcg_sock under cgroup.memory=nosocket
>       selftests: cgroup: make test_memcg_sock check flushed sock stats

Applied 1-2 to cgroup/for-7.4.

Thanks.

-- 
tejun
