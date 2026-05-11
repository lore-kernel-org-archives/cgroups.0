Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1E03BD64E;
	Mon, 11 May 2026 08:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778487511; cv=none; b=odhe8XJQwnQ0Qfm4xuA5w02TO+q+zbkFOe/LCzRM0Um3gtxd6k+BZkbawb1Hzz3OcdyMjmOfHzqoKs8RmjagfMJPw0TfYt3b2v3YYTHJkDwyT+RLkZT2sHXNuOiepBTAl0KcQLG8x0H5TiJShioeMvrOWmhGo8/PChYs1rX7BhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778487511; c=relaxed/simple;
	bh=XKpDscIRtiV2SKDAxFnyBPB4+eiP7Y2B0hmmz8ILKQI=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=KzBO2dCR77bTJZCtox6ld1KdVsdxSAo3i/GH04cRyDYo0T0WwhDzqaVehgSfmdM4D7hr3lH+QkDqkz2kWPbI5A9FQQ40eiBa11u1xcgplvATJ4mD13s92hDjIJi4CY2k+MFaV23L7j+OTglArVVQvpOi1DMZtISwRDG+gfNvSPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBJJRewk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBJJRewk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BD3C2BCB0;
	Mon, 11 May 2026 08:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487510;
	bh=XKpDscIRtiV2SKDAxFnyBPB4+eiP7Y2B0hmmz8ILKQI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DBJJRewk4WLRF+yiy4yChajgnFp2H3ZJ16DKoXYuQewdX4CJg8mplc89AzO2p0Ktu
	 E/QBTBfFoKh5Y7EeZkiqJVhbJoQwKebFt++cq8zG0zr++JCvUlyHl4JhtcrW/GPNNX
	 a4WByrGS5t9lcKRr9zuFwseMQ7e9DVbSPGwy8ibTjDBqzWG2NJegQC9NWRQsTLigUy
	 aapKw9yXk0+8Pikbp8/j2UHTyh7m3p3gzC3POCfxFIsmBfRfNaWbivv7pGS2fRqndf
	 Z+853/BbDQmQ9FIDDKC2GnD6yyY5efF+yjXSWly+2sgq9SFsomL4ga6jvTdPZI814Y
	 kEjGl2PZDAzdA==
Date: Sun, 10 May 2026 22:18:28 -1000
Message-ID: <8074401ce6fb258c2f27fe35b76f4c3f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Waiman Long <longman@redhat.com>,
 Tejun Heo <tj@kernel.org>,
 Michal =?UTF-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
 Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Chen Ridong <chenridong@huaweicloud.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Gabriele Monaco <gmonaco@redhat.com>,
 Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
Subject: Re: [PATCH v3 1/2] cgroup/cpuset: reset DL migration state on
 can_attach() failure
In-Reply-To: <20260509102031.97608-2-zhangguopeng@kylinos.cn>
References: <20260509102031.97608-1-zhangguopeng@kylinos.cn>
 <20260509102031.97608-2-zhangguopeng@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied 1/2 to cgroup/for-7.1-fixes with Cc: stable@vger.kernel.org # v6.10+.

Thanks.

--
tejun
