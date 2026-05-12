Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0153DC85B;
	Tue, 12 May 2026 17:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607422; cv=none; b=l2BamXSRfXrh8EdmEV/gh7KUQwbW/1r2TL0Vs6mcqT7T+H/KBlZHGN6gWeghrItyp2cqvUnEJIPspjXRqxhnK91cPKsOd/rkMNkHtSoMTqJdeodbRH4KD7CW2esevPZXbQUXSDPZ7BNYJrSO0gZsowVEnYAWYjKNrvJxrK5LCKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607422; c=relaxed/simple;
	bh=1YWLm6P5dl6Nqn/xSQpMmjICfYZmlh32zBqzh9A+p8A=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=FCQMc2KNHtJzcQ335oqs5st01osly8N5xxEGH6VyvkkJN7pAPXh7r+k5wVj03CGMirebhnF7zWSnanTy0Za4NDkf1wr9Gk/zkN3mwKaVOcEwTOky6U1POiQZDBsAj9Vl65oQ98SJdBHz5V5uVWwE8CsgO/z8KivaQj8cUfZTSi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UJ566vjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJ566vjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D284C2BCB0;
	Tue, 12 May 2026 17:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778607422;
	bh=1YWLm6P5dl6Nqn/xSQpMmjICfYZmlh32zBqzh9A+p8A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UJ566vjSXgweHDlHu8LJSIbOY1CkCckjo6GvLQnAACBt5LOXs8Csa98m7zLt//ePU
	 1klnV/b3K5XQLftE0R87bAjMZMWFv6cQ7QZgl97gWK0lts0vfTXRkWdcWbioR3Ksj4
	 E7GPKogEEbPRizsN7xSJLLHKqnUzM8Nmq98fn9Tn2VqhOAJzjyPvBc/3AskWvO4+Qj
	 vGsO1XvRCICUqEdB5j854egpqlzvWd7rC0u+I6ZYlvu5aV8xs9twLdGeRAiRVepNpr
	 oYQBJwgqrn5oBsNeNTZHVb/hR5YnQXGhoztu0lNmVr7wfugkoxgxVq3TSavAMAULe/
	 ezsKx6s7/HMSQ==
Date: Tue, 12 May 2026 07:37:01 -1000
Message-ID: <efa2a7a0fd633cd8fc6a9f5d40eff1c4@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org,
	vishal.moola@gmail.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: check malloc return value in alloc_anon functions
In-Reply-To: <20260512071424.59449-1-lihongfu@kylinos.cn>
References: <20260512071424.59449-1-lihongfu@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

> Hongfu Li (1):
>   selftests/cgroup: check malloc return value in alloc_anon functions

Applied to cgroup/for-7.2.

Thanks.

--
tejun
