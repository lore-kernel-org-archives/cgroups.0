Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7C11B532F;
	Sun,  1 Feb 2026 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769964705; cv=none; b=K4zpU1Dd6DnlQZR4RbGVgvJhXEzy2Xg/IMxVdw5RVQ6FOVp2pwnQ4WQsSnn9CTFl/67BL8ZoIlh2q0/y9wXal2pPXxxq2DZ5F26syAX7pqiaBDm54C1xRjuHLc2H9OztHZwZcZNCiThJ7rQgOh6mrSJlhOIEl7ZoZbnnQKsEHcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769964705; c=relaxed/simple;
	bh=AvgjU4pq3tQBOXYv2Cm4Oz/DnPNOIpwzLhpGB43kziI=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=GBoxoKRgzx+ffK5UkDo4X2zqePQgpanFyiuaJLZWSRHbdzf56ZXu8NfVF0RnXvj2xdRCuU8rwL2HHNYambvJClw/f8NDMJ9d0knRR5tKQZTgjHn5aVrORApPy3YAps2oWbMPooskpJjNM1O9fOxGi3uyHpY4ePtckACVv1zwQ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XMAJJQC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XMAJJQC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49552C4CEF7;
	Sun,  1 Feb 2026 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769964705;
	bh=AvgjU4pq3tQBOXYv2Cm4Oz/DnPNOIpwzLhpGB43kziI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XMAJJQC2+X6ri3NaXv8SjeQyf6YNMLSeModHRRA+Vri8PJvX5ReQvBXDt1pP2jnoc
	 HH7vA5/ZW6PoiLWcFQDfDYIog1YUzPHd3vxag88LnCF12gwtY9iV3YjZiyNvCqrY85
	 jUyfRg4dDbVutiootcM40Zged27EClZqYKGyQ93b+9H04PO2nIlrv41BRueUW1oR85
	 j4tKcC1rUjekZY5epBIUjnNcGjZGlevK0SbMxoIx852hDNNFXiBm5vC6gY3POQ2mNy
	 pGXuxVT3oBz5ClTIcBfNQGzGacE0RzgoeLXUmsGZvB3NmyJ+e55EaNMM06OcsK5C3w
	 VECxQY7NsUMbQ==
Date: Sun, 01 Feb 2026 06:51:44 -1000
Message-ID: <ac04dfbecb4d9f0d4b2ddbbaab0a014d@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 inwardvessel@gmail.com, longman@redhat.com, shakeel.butt@linux.dev,
 chenridong@huawei.com, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 lujialin4@huawei.com
Subject: Re: [PATCH -next v2] cgroup: increase maximum subsystem count from
 16 to 32
In-Reply-To: <20260131030509.317315-1-chenridong@huaweicloud.com>
References: <20260131030509.317315-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-6.20.

Thanks.

-- 
tejun
