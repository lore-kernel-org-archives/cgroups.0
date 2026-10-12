Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B3437A851;
	Mon, 12 Oct 2026 18:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791830989; cv=none; b=kgh81Su5/zjuY4R+0JnJhNjNzZCdeKmRBajcCYNR3qfQJqj/8gNtnPiN7dRnJxSzU/TmftLB7A4diEomXmwS1smD3PXwldvekJlMGcTO7SeudEG85mWgRTFl4HD9q/5x8OmOKQ5DWIGfb8ekQeOHfkOp51w1sYnquvO7ZaeGTb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791830989; c=relaxed/simple;
	bh=J6xen1WxnC6vz63CBsE5t0vuneP+XxYBXC1IehUbei8=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=I/4cZ2wj5al+GIaNL+nirLo8of3Q2YeaA0gLXqXqiz/Wj4H0Z5BqUxSd7qZ2ZBQ8EkfHI/nZ/8fcWzQEMAalnUPB/Zj03YBcxiYhhb2SGR6CDc+pW9VMD4hjcUXktruFqnuDpZF1fYOOzOTfAesziXaDotcwuv3NlbgaUX88TsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5fIvYge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5fIvYge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521FD1F008A1;
	Mon, 12 Oct 2026 18:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830988;
	bh=j2fSXvse3Dj1dfRfkYZQh+js8N8w3GYsh4iwiLdyEEM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Z5fIvYgea/H6qs8NHI3yfPKP1MXVWDrlu75CADVhlDxl+OUX5Wex9i3drnU9494Or
	 tlGZuNUMRvACn5BJpT5//m+dOgBjDSg1WcDpyhs6WUw4kc8buiOwqA7dVQlHQwch4I
	 U7LMFlK7mN3aZ9ulbcJnHowEvNW4i0c6iS6BHKPD+A+42FgnRPlPS46PVNSQkSHrEE
	 9fFsBD/b3RHZT/GDUu9LHMMr9SL5pg8wunhMIKtxgWvjX59br5g+4qSa/IkyB7un6P
	 hyI4AoK2ohM8eMESJskBnGnaBpiT8BvDF78cTm9zZ/1R9Mx6cgXbxrW13HhMUGhgeB
	 /nMbaY7uiicTw==
Date: Mon, 12 Oct 2026 08:49:47 -1000
Message-ID: <2e0b71cb1f9bf47ae32c2a969883c62b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: test pids.events notification
In-Reply-To: <20261012095011.3188830-1-sahaj123.sc@gmail.com>
References: <20261012095011.3188830-1-sahaj123.sc@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Sahaj.

On Mon, Oct 12, 2026 at 03:20:11PM +0530, Sahaj Chaudhari wrote:
> Handle a failed read of the inotify event before comparing its signed ssize_t result with sizeof(struct inotify_event). This avoids treating -1 as a large unsigned length and inspecting the uninitialized event buffer.

This is a delta on top of v1 rather than a full patch. Can you fold it into
v1 and resend?

Thanks.

-- 
tejun
