Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755863;
	b=j0YbIeb1UmFspMGTvKqrg9HcYAf/rqqXw6uoRTv+peCavWSq8xvUDWlwgXNvWrf+Zm8c
	 9pYJlcrKsKs3ITNBhtgN4LwUgjJyfMYPNzAALwnYugeytgWmOScyF0CvVxhr++GZYoSrF
	 YfsFHLKeQCxk7wh7Jmorj7BiEv979GVDcHeqg1ert4PoXXVqPzHHtIBatO0rqoL49b277
	 aCOH4X4dU9xAfXNZB5ULGLwogyZ1KaRw+n7zbdqR4wuvK+t2AhYmiR3g5d67n6Kc/hOWr
	 IGg0A+6mp43TYz3CkOM6ZV5J30frzb5v4iaRoWP62vTYrne5tUZqGDiDzqEFlXFNYDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755863;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=O4i36jX6RyYdIwpo8ZrzTqJ+lhrYGLfk2Tf+zg6vut4=;
	b=Za0+YSsCPF9SJp5j2yujz/85u0WfdRewpVFIh0TX23YHcONH7ZS+/UTfI1chBQXfUuW0
	 JbmrKpLC2QFLkj9nv+hUNyxuKKhsZCBrmnNSq2vyOpelKqOXHQHiB0c+ccdPi6TsM9N8V
	 S9eMs2gIQHeqOOUr4Lv5XvcKuy8lPe2YUGi8HWJU7FN4hW0abytK7l4bpnj1//v7KdI+S
	 MVB0Ti2bE3olWrEeRSpy3HuVGzHeNxshUJE41WshFz8b3iRIgW4NxWkxSDHz0cGJT49eH
	 XL357xP/AD/M6kLE40ejeFumrvIez0U7t0dJDBsxd7G82U8g90L+4CzhschidkPJBjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PDe9Do8h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0198606A32C;
	Sun, 15 Nov 2026 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PDe9Do8h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C251F000C4;
	Sun, 15 Nov 2026 15:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755863;
	bh=O4i36jX6RyYdIwpo8ZrzTqJ+lhrYGLfk2Tf+zg6vut4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PDe9Do8hdPQygAIiib84ATkD85AgyCm5RV6VOK6mqOGSdjYPVyXm3YRHsST8G55Hh
	 jiqIyoCdKpLoOpi/MeB17rnFhd3c/Ph2qIKY2/6HvPA58S1zAUyKLD/V4xIeqb+QOK
	 v9infeSR8jbhQ/GuxAtQ5UzO1FsatlO0bMu8x3/v9P22BgoLAuVLTlJHg6dZE9rtpS
	 33a8bVdWBfcQVN8BL4RY16BR2vtv4MPsssW/vreZbF7vOeHOfPFCK7/wqmWzKutERB
	 sXJ5v7Q4rUYTBh1WEZsA4DZ0UsjRmVT/wOIl0pqGeduwaeiGh2PLLZQzTcGP8//0Gq
	 U66Za3LmAojsg==
Date: Sun, 15 Nov 2026 05:17:42 -1000
Message-ID: <e4f172e286a51e9969b8a5cbf1a7da72@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Johannes Weiner <hannes@cmpxchg.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, driver-core@lists.linux.dev, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kernfs: Build paths in linear time with respect to depth
In-Reply-To: <20261114142137.ecf5e6af6608b218@chrisdown.name>
References: <au_pnu4s141ylqHD@chrisdown.name> <91fa9a5de005245ed3c1bde305fc6778@kernel.org> <20261114142137.ecf5e6af6608b218@chrisdown.name>
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

Hello, Chris.

On Sat, Nov 14, 2026 at 02:21:37PM -0800, Chris Down wrote:
> What bothers me more is that whoever picks the depth isn't the one who is
> affected by it. cgroup.max.depth defaults to max, so anyone with a
> delegated subtree can make a deep chain. Every read of /proc/<pid>/cgroup
> for a task at the bottom of it then takes that long with css_set_lock held
> and IRQs off. It doesn't take five digits for that to become problematic,
> either.
...

I'd say three digits is already pretty extreme, and I think it's on the
parent to set cgroup.max.depth when delegating a subtree. It's similar to
e.g. memory.high. If the parent doesn't set it, a child can affect others
that are unrelated to it.

That said, I don't see any reason not to improve it.

Thanks.

--
tejun
