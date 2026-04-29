Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E46640F8E9;
	Wed, 29 Apr 2026 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777479714; cv=none; b=PKGoSeYpjEYfnnLjjfhx9EyRjGLctIhHJ04v8U76EcF7k1XMqufT4FBIFhRC3Espr3xCxJHjkNKZK8z4ZnA5Rmzv6ksgyJFRZh1xjx2k76ktcmlYDdhwAHVY6O9UyUIPdhNzCXoMkaEhG9UXi7keSrkouc5I/kgUN14AFiuqN54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777479714; c=relaxed/simple;
	bh=HhOc0548G9kfNYjkAtqOMROBce9JOmnelyqUUYgADxA=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Efg6ks0SNL3bo7eQh+gdkkDuYuRXIAyYpA/oc/Tb6UhhFbDtaUgUYo6vaStko5j97SqLkffZ1ZSF/xu5jg0N5UQPhAqi7AGpDCcVOw57ANWQQvYBb++W3/WIDKQw4yMv8pMUBNA/59owBQ3CKLg+kZS8mg0DwWI42I2AboNvtXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncjJDjms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncjJDjms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AB6C19425;
	Wed, 29 Apr 2026 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777479713;
	bh=HhOc0548G9kfNYjkAtqOMROBce9JOmnelyqUUYgADxA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ncjJDjmsKo9FHZ5Eg7sqZvXvkcxwteBzdLsgHilIwmzFFXfebJC1KQLChivIPNPOY
	 F6nHcxBEL4prAYMapymK+4Zx2kCF9kFdwuGTPvD7FH4VIHU6+RUJPcOunfLMiMXmez
	 2nk1IkpWcEv15CZZuhexl/ieqbls+cHPm+5q0X60wTBlUvYeZdM2q2ZUgG7MShV50N
	 uk2BTVInoSmHd1UH1wJ92F1nxxktMiPYA/Ne5ZHTyDQkX75RYoZeFOnotEh1aFVukl
	 1vlQ8hC4pDnvkhLSonpnMwoyGzduurZofQ8mbZYKKO+fImAK9FMdH0fchiD/xNhSdP
	 rLy7XtIIf6G8g==
Date: Wed, 29 Apr 2026 06:21:51 -1000
Message-ID: <f19d08689301f9cc0211e6273f833246@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Martin Pitt <martin@piware.de>
Cc: regressions@lists.linux.dev, cgroups@vger.kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Subject: Re: [REGRESSION] 6.9.11: systemd hangs in cgroup_drain_dying during cleanup after podman operations
In-Reply-To: <afHNg2VX2jy9bW7y@piware.de>
References: <afHNg2VX2jy9bW7y@piware.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Thanks for the report. The dmesg you attached has only a partial sysrq-t
- the dying-task stacks I need were pushed out of the ring buffer. Could
you increase log_buf_len, reproduce, trigger sysrq-t, and send the
resulting dmesg?

Thanks.
--
tejun
