Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173859;
	b=47CUD/61xq8mQiAkrEf9dS/hOmNH0M/5Y7HflHkac6S9fVG8qneny9Cc9DNEGuraSQ7Q
	 Iz43cZ3VNlmGj19e3behs22zhP8wvPbbuuLrYN/2T69R4P0QxfZbntJJ3pWfOOYw+TpdS
	 tSLMW4fufI1B3N94AhVQsG12SV1otOScwvSpWqR2wm/Vq0tRg+6IvburBGGfVRnogJ6BJ
	 MqlSgYEOkeTLwqmXdU0op5hhJPApt/dStIQsSRcDX29yFWPOkg/Xr004/p5EmOA6DiXhy
	 jsCJ/m8MzWa9pGnSLlZNLDZH796GneGUVamua9js0jPoCDgf6pZ9zTBPig5ln99kzmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173859;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=tueNy5jtfjpCu3mVXyg5MVYuIQ7eQt/pI0gIOgQ2c5I=;
	b=0nHmQN9eyfKWVttyBRezSxcSquPBivuvg6VdqY4eTMIeY+pYIsAAM89Ab42eUVMrtNd/
	 +v+oWjChcHfLmkwGKcj+z1Xw5hJuizZfWbeC9pO3xNghh/Y17pQe27jRIA8yJTuyH8EQt
	 p21i+kOyGtw0CYpL1/KKyau3QJRDoN8brSkXsPLaS4/CfY3HELPhQyFJJtqO+D9L96UDb
	 jsHya4Dec+tPYDsdcbrw/2jheeS8aWjbildgj8AZQ3236IVxQP+H+lSunpmmzNGQ3iTkd
	 hxU+dmpnDjnua4j+ax015F2BYFt8eGgMl4YeZFm5r20jB+iLeqTO5ovDufaEhlKzfTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CZ7KvW1B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E72606A32A;
	Fri, 20 Nov 2026 11:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CZ7KvW1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088D51F000E1;
	Fri, 20 Nov 2026 11:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795173859;
	bh=tueNy5jtfjpCu3mVXyg5MVYuIQ7eQt/pI0gIOgQ2c5I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CZ7KvW1BG87WZmC5zsowuF6jgMpGqlxCtm6y7gTt+yMoM4R3KFzlxxZOI4UTEAaFZ
	 Qp1yXKmJ/rrSaFE9GVSbI9uOmYo3ibatrg5ttCMkS7JmGy03N3g86ryI2sBybCjIpC
	 5FUOmVnLI8m2AImW+U8YOjP86QlB70lE53JdW76BUIwRFnd7SiXrikxlofHnqjSSir
	 Jcewz4Y4FwxTOlJTFRjHiMml4SfPSv2yk8j7x7Jd8Qfl0JgLPM/Cmia2yWhKB4kdLN
	 tOP9B61FiZN6GW4hr6/ysZVL0T9YKAyjaidNzJ5TaIevZcbqXbz4tFrN43COFnJxVJ
	 VQPmxvwZb5Lzw==
Date: Fri, 20 Nov 2026 01:24:18 -1000
Message-ID: <b8b2c07c12f5a156e2d72ab4ee4444cc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jori Koolstra <jkoolstra@xs4all.nl>, Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: allocate the inode for cgroup_may_write() before cgroup_mutex
In-Reply-To: <20261118230346.3700213-1-shakeel.butt@linux.dev>
References: <20261118230346.3700213-1-shakeel.butt@linux.dev>
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

Hello, Shakeel.

On Wed, Nov 18, 2026 at 03:03:45PM -0800, Shakeel Butt wrote:
> +	dst_cgrp = cgroup_kn_break_active(of->kn);
>  	if (IS_ERR(dst_cgrp))
>  		return PTR_ERR(dst_cgrp);
> +	new = new_inode(of->file->f_path.dentry->d_sb);
> +	cgroup_lock();

I don't really like new_inode() being called on every write, and twice on
every clone3(CLONE_INTO_CGROUP). The inode is often not cached but not
mostly. It's not a lot of overhead, but doing it the right way isn't that
complicated either. How about peeking at the inode cache before taking the
locks, preallocating only when the peek misses, and then looking up again
under cgroup_mutex? If the peek turns out wrong, it can drop the locks,
allocate and retry, so that nothing is allocated under the lock. Can we
apply the same shape in other places too?

> 	scoped_with_creds(of->file->f_cred)
> -		ret = cgroup_attach_permissions(src_cgrp, dst_cgrp,
> -						of->file->f_path.dentry->d_sb,
> +		ret = cgroup_attach_permissions(src_cgrp, dst_cgrp, &new,
> 						threadgroup, ctx->ns);

AFAICS, this changes behavior under Smack. Smack labels a new inode from the
allocating task's creds, and the allocation used to be inside
scoped_with_creds(). Now the inode gets the writer's label and the
permission check runs with the opener's creds, which can fail when the two
differ. Maybe the allocation can use the opener's creds too?

Thanks.

--
tejun
