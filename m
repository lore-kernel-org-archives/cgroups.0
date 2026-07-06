Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D083C3789;
	Mon,  6 Jul 2026 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783367157; cv=none; b=D7VJthrDdrr1L90d5DYw9E5sEhIjxQl3cSxlnRiv33D4OPrbpdhCuH5fp4zXFG62+41h7QVqK3oZejI/Ykw0K/F7gZBF7JNQbYAh7XpiIsTxp3XhXS7qfkzL1YR8omNxCUhwHQ7pkNul9FUihctQR1tHLS8DvJsf0uoTcl1bMD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783367157; c=relaxed/simple;
	bh=AovqIHQqwVYs0zTuniHpmPmij/s519jnqC8QcN6eRkg=;
	h=Date:Message-ID:To:Cc:From:Subject:In-Reply-To:References; b=jV1Z0X7JAci8LX4EBcaiEF8gsIE9dKh1MkgS8/WMsCTAYamgJYubfiCnQT3J+USopViAuhijBvHuc6YeshPRUrLz6Kpr6d33imN2u0EVqee3pw/YWLJQwE6P18SnfPQtNyMrDZK9NRaRAFkidCFXlMqeMB47ZPzgBBclvYZITbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOfQfD6B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOfQfD6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9411F000E9;
	Mon,  6 Jul 2026 19:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783367156;
	bh=AovqIHQqwVYs0zTuniHpmPmij/s519jnqC8QcN6eRkg=;
	h=Date:To:Cc:From:Subject:In-Reply-To:References;
	b=XOfQfD6BV5xPh/dM2/TdgTOCFYbwCcwQ9mf6FopUDp6IG1cB3+quIfh+HUzbr19i1
	 lZ+vyu3KCohQ2wEqRjvaoMyzAJKGjm7H6X1QH7c0IL2OdQL7CC6EEXVKzUBwR+m/Sa
	 QhyyMQkNYYaFJIoy21I9oLbG6A9JrZXti4DJRV+w4SuRKdfmNZLjucKEhWKsBMukE9
	 iyWM+wUvzn+JM6/jvHwRViM+a7GZP+Sp/XaP4tUyk6SCT+lWAEXS8vIw/LNXRyUc22
	 8Fc2Dq7H7kKA2CuoxJz2VT028L4G1PpEdo/7bJADZbijFJUcryIcjVCYO53lbZAK9p
	 7qJkWa+B8Iaww==
Date: Mon, 06 Jul 2026 09:45:55 -1000
Message-ID: <6414bf279afba506259bda347299fee9@kernel.org>
To: Manuel Ebner <manuelebner@mailbox.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] docs: cgroup: Fix bracket
In-Reply-To: <20260703063805.219517-2-manuelebner@mailbox.org>
References: <20260703063805.219517-2-manuelebner@mailbox.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.3.

Thanks.

--
tejun
