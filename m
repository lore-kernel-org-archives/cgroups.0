Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795850713;
	b=QqyQ4s3B6+7CIfrLjwzNnS5V2nNhm/y0ZDKA3Gm8N4C6VXioEvfCPVnlanv8t8gXd8m0
	 O/22z2YJVgddzMDsGFON6KUIz/VOJJT/vXhaX+A7tL6PBRA4JDLC4UfAm/AQXNadYPlVd
	 sigj2YJ3tRgyJLT4cQGLzR9UYVsV618hdmbfI5wVdNo1H9garYBbDNDeWsAcvzT5mvRS+
	 sKoEcRAfPJ2d3AC7YFMlNfr/36xMJ+t7guIl2MIQLNCcLi4mcb1HOyitk73laMQ5rZXaj
	 BiglhysBk0m1EGizrj5VG21okGAGS+uP1/fOB2D8l5jUpZ882QsF5rM7SgqzuDuYgjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795850713;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=kAle+7NZBTIl79CF3givLyoKSv2EiRPgCMErVUFxeRk=;
	b=epXF6KwkQHLCG4AP5E06Bi5RWB7F3Glt0fTJwGfUoyhwncaFZydQqDiv7Ier6GW7PQ0D
	 8QK9RqKcLm5R6uDmXmp76lLvOrXYSv4RJAr2OKp6dOjo3JTpx171fiFFDK5VwG0zzWiBi
	 DEtC2LNT37+/PkGrYaGpOGRrumBCi4mdVSXjxXRMd7H3bA/Ysb31Evl4rJxy6dSPUKw+B
	 pjmOffJC8LC29vlfh+616YnMifFhLBCMHrbgrcaN/m33zTx+V2gnFh4HJtYGOFcoY5G7o
	 dO/KY6ViSDFB1IlD8zaq3iCrQ2T0o7u++uMsum0iMeCOk7IaPKJKw+2I9joGEmxtlEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGw5XaVh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02501606A324;
	Sat, 28 Nov 2026 07:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGw5XaVh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F421F00923;
	Sat, 28 Nov 2026 07:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795850712;
	bh=kAle+7NZBTIl79CF3givLyoKSv2EiRPgCMErVUFxeRk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iGw5XaVhKz9ntYOCqIAMvaUzExvkI1RJWgHIordOo9CHeHNHgaoMRmX+l3/agVMGg
	 cbUxmQnRtPGdJUjskvfzDexfh4A/+z1wIOFnTGgBVJJkdITW+CqmDFrfJbCpUb1TwY
	 7n/xqQip6i/j+VOV0mcTK/4ipmK9MvTMAoE1q9gmE7qazCzIAZFbAUHZ2m9YrOh9x5
	 Hdtg/pxv8AejP3FWagb5ujxjuEDpESft3TWfcXZUi/5ZTcjo3JfcZ15z9VAzJlzZUL
	 FTOke0cR22mB0lEvz5MqT/LIJ5qUkuzEv2KZV6RPM72zewYlAEeGskLUnMYwSR9LuS
	 XZcxDmazIdBFg==
Date: Fri, 27 Nov 2026 21:25:11 -1000
Message-ID: <87513dc16e601c1b980a25934b3dd35a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Frederic Weisbecker <frederic@kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 cgroup/for-7.4-fixes] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask under cpuset_mutex
In-Reply-To: <20261128010535.1831141-1-ridong.chen@linux.dev>
References: <20261128010535.1831141-1-ridong.chen@linux.dev>
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

Applied to cgroup/for-7.4-fixes with a stable tag for v7.0+ added.

Thanks.

--
tejun
