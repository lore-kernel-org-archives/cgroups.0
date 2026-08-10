Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB9E42FCB6;
	Mon, 10 Aug 2026 19:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390738; cv=none; b=pxjccYB2Hm7gSipoaadNkU6dk1IFV6tiiMqFHNGvtMU44fWZav8o1jrGblQut9xFpF+HmGvDw6BGvxYvNkmCkJ/NQhUBUJN0RuGxhaW1y5ay158cYw/TlF5QRDV8167w4Fwk63OMUZfnqExpqM/P/ybV4fp0Si38juvf/+ZGk6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390738; c=relaxed/simple;
	bh=dG/8AAFigWvibDY1XI8k38r2ccVlQbAw4ceSjKMXsOI=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=tsDzOWs9XFN/T13aAO9e30163c+jPJ6wOUxcR50Gc+D6tCTIWDp9RKOfm9FaoCxY6TArq1cEcyRCFylTYrTU9F3mtfoP1JABncP679z+fGk0jtaqokHJpMR9GWKXUC33sqEovmP5Y050BwqZsk8KhTyFLIMZ9+HV56hY1rXTorc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jB31N14f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jB31N14f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AEB1F000E9;
	Mon, 10 Aug 2026 19:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786390736;
	bh=dG/8AAFigWvibDY1XI8k38r2ccVlQbAw4ceSjKMXsOI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jB31N14fxkXljp4/UGo7qvkw4DtsFrqBGHjJ1afcSpwJ5IeHNFY3h9Fb2mZbQOdpW
	 m8Wb0Otn7iYvA5OGO4jfY9gubOWQ4BSQNsD2UDfyb1pVO+U8754c9kVWbHtB4Cp6pa
	 aeQugnbPQpQYQ8+IERnIpk8wZcK6LGOZOr2W7K3OlrNjCU3ANN9PSqFjWwQ7ZE4g1K
	 PemhBdXStUDPD60zslhQ5VuDiABVXX7WcyvUqX3AOrvr8ukJbsiaFxuwSkU2W9gTfb
	 ocMw7uImvdr49uSszX9+rxm+RLTUN6q+v567xnQozebhHFdbfaP0mHfl3prmcTa2E+
	 HKZfXBqrL55zg==
Date: Mon, 10 Aug 2026 09:38:55 -1000
Message-ID: <4e428a3ff9132483383e46341828bc6a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Zhe Liu <liuzhe1@kylinos.cn>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tao Cui <cui.tao@linux.dev>
Subject: Re: [PATCH] docs: cgroup-v2: fix stale "io" controller introduction
In-Reply-To: <20260810063535.327765-1-liuzhe1@kylinos.cn>
References: <20260810063535.327765-1-liuzhe1@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.3 with the cfq removal version in the
description corrected to v5.0 as pointed out by Tao and his Reviewed-by
added.

Thanks.

--
tejun
