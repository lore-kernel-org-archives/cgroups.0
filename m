Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F020033DEFE;
	Mon,  4 May 2026 21:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777928745; cv=none; b=fJsUuR4n0RfleZxdVjOGZDguiDB5LSFQy7Giajr5iZ71u0vG5RXX0A3qZPhuqvzdSCjF9A1BGqfNbWkz4lonvW7zpvuIYcl/bZw8hPcc5iSOkR8kaL5nqX4yg9FitvZjZ65dUP5aUHJlxtDlofK6tLqEsIMcPkjRvYCCgI318G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777928745; c=relaxed/simple;
	bh=h+uhi/NqA0FdGMn82gWEgw/8zcywPLWzEWQvhat6/88=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=X/pnK/KAd2JHeZuBBhCPYxNomXHqbFEN2LdpGLn/RmaVce+Myax5xPtiQ9OBkm7ZYAPH55BWltrSI0zqcfSp18I1PJk9IdvCgwx+w70SJfQQeNG9o22pYFvaEMeyxPyFyHwbCOErrS9oRZWo2/ihYUysFM2CumbHolG/Ss0mGL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tCElDrI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tCElDrI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84D7C2BCB8;
	Mon,  4 May 2026 21:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777928744;
	bh=h+uhi/NqA0FdGMn82gWEgw/8zcywPLWzEWQvhat6/88=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tCElDrI/MdAu045nEHvrc+UDML/ckzykUrdkNaoejc9Qa4bjaRcZwRO15nC3ojXBr
	 K5lJVwHFKSJ6BuU5tj0mDodCFp1DCauBMPOx34sZLdnwuE91AEahMYwYgSxOmxrAhk
	 hUE/LdoeglmrAs9wMzst6g8FuIXiJIx7POmi+NAc/X146pu4uU6j3Frlw6cArR70Vb
	 ErWkzeIg/BaxI+B1gCUrlpdHoJWvjJF0MBFyP5D8vxx8qNofPFn3Fj0/FVCRKTRHJJ
	 sgQHkHFdLkHFCsC8ohTn1mC0TnHMQlPe7tBoMoLEwEroGIK66L/pEYxu/uNqDruodL
	 V4pjGDmJPVWaA==
Date: Mon, 04 May 2026 11:05:44 -1000
Message-ID: <27f00387eb2bcb4eb95d2c34f01aa1d3@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutný <mkoutny@suse.com>,
 cgroups@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: cgroup-v1: Update charge-commit section
In-Reply-To: <20260430201142.240387-1-tjmercier@google.com>
References: <20260430201142.240387-1-tjmercier@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.1-fixes.

Thanks.

--
tejun
