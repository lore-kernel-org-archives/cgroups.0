Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795281878;
	b=CmfHcCm29MY1Qxu7nh82whxbmVjjF4s+dT2NYnpTU+7QUJIeEQ/lUZQ40df8Yvdul14/
	 /IyoQ19a3PRulzuI+QuBuBVDpii5q1hf+XY8dnkoDmB2GdTsTJB22AymZM3e0y0pGPNFZ
	 f3Cdm+wrB8TuQdZZZIJqAF1eg86L/QzoOE7RFNIRatqypa6Y+wTGny8OQ5pP8MeUCC34B
	 1AP5KcU1rWbbgTZrXz0KxJRAh1PpfNajdvT32HOHSVb2GXO4ehz2rm9lK/h19sLcimqPT
	 s/iAyglIg7yYFJwuQtfo7sCLGT/epHWByIaFMpwg0h6qQacZoKVZEXBiHpdnzyBiQAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281878;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=4TbwPYYnIM96JizHRnjnmQ2Ra7swQJ2dSto8I1+ORqc=;
	b=oKrTdJEG6eiHPVuvJGrqPkRydG0GwCWTl6x7jgBcDPKxnWs6T2/fiWx8dOFedfhzVSXz
	 6v+cfl0XceHTnrYPHA4j/Y+dsP4JRI8jRb300/KOrjvIXiusJFbNNeivw6T0qK1uJu/Vm
	 jodAABu6vCJsxHCGCDG7yyeIcmyYKTxPpamMv4/FAiK+OLkDrrRJbWvM/414xN4u6Lyfp
	 Sjx80eK76Cx+I1PTshsAPnl74HQJj9tMk4ht/9puZ9uLc64AGOqbd5+MxOm/jbiZMkfyk
	 FGWk76MenvtvQ8xqIaOzKEdLGln43idMhsOTtdufA07FkdVJV1CUX7brGzi+F0v0InA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n+W1TA7g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C673606A332;
	Sat, 21 Nov 2026 17:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n+W1TA7g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747D01F000C0;
	Sat, 21 Nov 2026 17:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795281877;
	bh=4TbwPYYnIM96JizHRnjnmQ2Ra7swQJ2dSto8I1+ORqc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=n+W1TA7gMPD5eX9EJijj3A8N6IGWH/FAK0dC9v+Cw7y0B8h1p6b/vXByDSerMKoEN
	 BnwV1Lh/5j7qrpSF1/ERAVM3mjxQnicd83Ma3w0/yKRqj1QMpQypzf74JmVWBObE3j
	 rQsIerlp6xAB5Pn5vMWwq8T2Lmaapyiib60nrKZC1sx7gqhJj5GHs2Qwox/HxPwMhd
	 m1DbbbbIgymUS+xDOmZYAyn9hOd4m0QJZA7qJalLnMb6jPU0/57EKUvPjgGchKTAOU
	 WnyWuZL1n9J3Y4zfDeaHAi3ZhwWhL6G2Tztj3gfWnploGw1KEkxgVmpkEWA0AvMG1c
	 BwK5T2SL/Mb2A==
Date: Sat, 21 Nov 2026 07:24:36 -1000
Message-ID: <06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: luca abeni <luca.abeni@santannapisa.it>
Cc: Yuri Andriaccio <yurand2000@gmail.com>, bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com, hannes@cmpxchg.org, juri.lelli@redhat.com, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com, yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
In-Reply-To: <20261120212418.10221f2e@linux.fritz.box>
References: <20261109163616.195264-1-yurand2000@gmail.com> <212c244d534ee1fdb0538a980789e16c@kernel.org> <20261111175657.250354-1-yurand2000@gmail.com> <58cb2cbaf82c0f671213eaca46465cd5@kernel.org> <20261119151416.33f90a64@linux.fritz.box> <471bf8d446becabfca00041fb2a78067@kernel.org> <20261120120659.2e902463@linux.fritz.box> <6fef47e08a37079c08806b3c57994778@kernel.org> <20261120212418.10221f2e@linux.fritz.box>
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

Hello, Luca.

On Fri, Nov 20, 2026 at 09:24:18PM +0100, luca abeni wrote:
> But the deadline entities serving the real-time tasks in a cgroup are
> pinned to cores (one dl entity serves the cgroup's RT rq for a core).
> So, they cannot just be added to the sum mentioned above (which works
> for dl entities which are free to migrate).
> This issue was solved by reserving a fraction of the CPU time (and the
> root cgroup parameters indicated this fraction) to RT cgropus, so that
> the SCHED_DEADLINE admission control is still the same (we just decrease
> "limit" by the fraction reserved to RT cgroups).

I see. Can the fraction be the maximum across the CPUs then? With the
root at "max", the kernel knows how much the cgroup servers have
reserved on each CPU. If "limit" is decreased by the largest of those
on all CPUs, every CPU has at least what its servers need set aside
and the admission control for tasks stays the same.

I'm not familiar with the admission test, so I may be missing
something.

Thanks.

--
tejun
