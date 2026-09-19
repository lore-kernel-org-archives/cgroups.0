Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BE0224B1E;
	Sat, 19 Sep 2026 00:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789779373; cv=none; b=B5fm8y4Suu9zj94yqPY2bl5mniurTC94WgjOTxPrvEY4Mm+//dHL6vObqf3vPW9ssQikurWrELUM05JVg3nKd/xeEAOCvGg9NoOZY6ST+64PTM73JpVlmshkCFHZOM+AMR+d8wYUpWn//beonf3FP2kfjJF+n6moVn9TFXJRr38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789779373; c=relaxed/simple;
	bh=ZEe3qN8HRBObdSPlBohZtAfjNDxdYaqiRtmORA+7JO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvnkIbPKyDIg+HfFFZtU77SVWpKTJPFPyXj3dL8XCy8BLZBhWSmNTKPC6PURApEXIiOoeIpwoc+EWIY5HBHISqo0XJpKUtn5Z6I+z5BMVSDLOdahI1JGFzr255MT2+sa8yPi2lPHu26N33eMPNgpxo//JeseWkrfI52E2GqtQ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=koKWAmIM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="koKWAmIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDD31F000FF;
	Sat, 19 Sep 2026 00:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789779365;
	bh=WLSey5EwmTczQHfC6e3oURw6GECTJUovFx/5PEz81tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koKWAmIMGFrgR6e4punkJ0rHQ3GZ7gEbdrPdo87NikvO4TC8/dENCzrPHJl5M3T8s
	 u8zPcj0hZsixZOzJtiu9cYcviqrjA58gX2Nyf9tHMwMArgyVnqVVc7mKuamx7Id9BV
	 j0cXS5abW64bUyXkZOi1sh/yyo1e1Jy+8vsFspQiWO8+iJKYQINEb00XxL8AYRtWbO
	 VOnR9Mkk2yoPn+aEwbAMlxwlxKpauG5VlAMOXbgq7e8q0zhMR2Kg8av0T7NS0AHELm
	 30k2qYLXz8IQXe/lPFQ+4aJclxZJJCgG4N/ebdrUwQDXiKvDt3asq6Qh0tFOjTIl6t
	 ySQjcFvjt1Ung==
From: SJ Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH 2/2] memcg: remove unused mod_memcg_page_state()
Date: Fri, 18 Sep 2026 17:55:57 -0700
Message-ID: <20260919005558.87687-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918165601.1014666-3-ekffu200098@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 19 Sep 2026 01:55:58 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Since commit c466412c73c3 ("mm: memcontrol: switch to native NR_VMALLOC
> vmstat counter"), mod_memcg_page_state() has no callers.
> 
> So remove it.
> 
> No functional change.

Nice cleanup!

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
