Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488BB3C3C16
	for <cgroups@vger.kernel.org>; Mon, 11 May 2026 08:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778488562; cv=none; b=E2NM/CPhQ/MKI9T9I2SwVkEo/JAdYGI853rVavLHbYLn5CYWR12ssct7ZgOHllF30fJEm/4PbidhS7br3GhnxOB2vD7CGw9EvYG2DtcKg3UQObVniM7RDYAHJyrMmjnDn9yxOr2t/Z5Q1XdQ1MpUUQvwOlv2r3ZKq3fzquk7vKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778488562; c=relaxed/simple;
	bh=/EBK9Za3dzKeST6xzL+uhXsqga85E68iUDnkuLoGL9Q=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=UKQ75UxkRbFXY9V05InkDh5LvEQcT8Yy9xjeOj3v2iuHDn0nuwMCm7I6sKy7vqzkWXA1fscBEBtgw2oyO4PI02p/kU2tT2DGjOqTPU48WWtSAkqpMESN0t+RO+M3FxF7fBjsxfNiQfZ+h4lEoipVLeUQQESUu+Yar6oIFJzazo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G8xk+Rc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G8xk+Rc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1A7C2BCF5;
	Mon, 11 May 2026 08:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778488561;
	bh=/EBK9Za3dzKeST6xzL+uhXsqga85E68iUDnkuLoGL9Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=G8xk+Rc3eIqRQt0vI+6veshK7W/MVAEz7JeIhLc4M4dcGm7SoWeBNHQv2jZSqlEXu
	 QnR+almD3L3H33Edqx4yqbXSqQwBOZN8++75J/9PIdvNRplbZiTI2hNxWFc4nlVXLI
	 1FKMIgO46h771tsFMwWkwcApyP1CBQpW5q7cxOah+XzgW6iCrGdQS1AH5ORNTf3BVz
	 ZXp2E8qvKzK1BS2slUF9PwttI453s4tMEVB9bC65H728nPvgwaeRL2ERzNL/UQF0gi
	 TG0uE1GeiAyJaTwhp766f07YQNGbGJFwoX4nl9COYQWG/9WNBXD+3jD+D0I/lkows0
	 KOYse6KMExc+g==
Date: Sun, 10 May 2026 22:36:00 -1000
Message-ID: <1217c9bba758367164b27f508b27a84c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cuitao@kylinos.cn>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: fix child process escaping to parent
 cleanup in test_cpucg_nice
In-Reply-To: <20260511061508.255649-1-cuitao@kylinos.cn>
References: <20260511061508.255649-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.2.

Thanks.

--
tejun
