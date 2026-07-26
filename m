Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0D52DB7AE;
	Sun, 26 Jul 2026 19:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785095280; cv=none; b=Rwjc2swOLHhis0Wa0y/XvldrPW1uD+hSw1Xn/P0bedjaPRp9nMCYRJbsmUupzmY4+eBb6ppIervET8OTP7xqCHkI099zfpZXph0p9kNx7BosNfiaCCV+u1jdJfiBcBpuedNGfyMoLcZaf93C3LsTRyAEoA4IxN8/uGAngpfWKjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785095280; c=relaxed/simple;
	bh=rcecFNGcJXDww8IZO/Blslo0dYnHfaFIR3xJxo5cJ88=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=piELtHZ89k6eltPUHi3tZglyM9+0pnx8YLEYiFpmJ69yScroSXMhoMyYWjU4PqH2frWFvWKEVu35Ux6t6zchTCY2nwwC9a4VcsLA/nxeLWAonAnPX2ogo+ioUxIdPbgemCDDTGwBVtYKIKXG8NDo/jzbu8VhwhuKuOGFg9Hiuv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFhjDdob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFhjDdob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53001F000E9;
	Sun, 26 Jul 2026 19:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785095279;
	bh=rcecFNGcJXDww8IZO/Blslo0dYnHfaFIR3xJxo5cJ88=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BFhjDdobGoprb+nyrN4jbguWgFw9TVt+sftNsgfMFNIbb7BxEgjmZaV8EJCv77oTg
	 v/1rDo3p1Hld9tWvQuDYKkm6R4/oP5TX6UzvdzjpPj8sPmi6AJo1olDHP4jOgYBCx3
	 gA7jiq64VYKKjftbG2BVjA/Po9Btl4X8+OyPNEM7vu3IuBGjQpSk5BMrOV+s0DwLdz
	 DjHNCKJI11kQd4QFbHGKQzS+y3+R6vSXA0WwuLJ7aLJbjU1b41uA2oFCwYrht1RiqZ
	 y0jNTfUqYZz3l64I4GFg8aRHoXghgGkt+TkLZn/lK7Fbnd9J8FWgFv7eJeShgM8kzx
	 YCstTY140jneg==
Date: Sun, 26 Jul 2026 09:47:57 -1000
Message-ID: <47297f950ca6dde636f9c821c74c5792@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutný <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] docs: cgroup-v2: mark memory.pressure and io.pressure
 as read-write
In-Reply-To: <20260724020508.500893-1-cui.tao@linux.dev>
References: <20260724020508.500893-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Fri, Jul 24, 2026 at 10:05:08AM +0800, Tao Cui wrote:
> The cgroup-v2 documentation describes memory.pressure and io.pressure as
> "read-only nested-keyed file", but both files accept trigger writes
> (cgroup_memory_pressure_write / cgroup_io_pressure_write) and are therefore
> read-write. cpu.pressure and irq.pressure are already documented as
> read-write, so this also resolves an internal inconsistency.
>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Applied to cgroup/for-7.3.

Thanks.

--
tejun
