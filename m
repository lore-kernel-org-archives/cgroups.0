Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6B53A0E99;
	Sun, 19 Jul 2026 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473264; cv=none; b=okzPLKcTlrxsWOkVpbvuyC4Rlf9McWJ9kVD9qkFxL9ODXzPEbDEV1G7a/jsOtStb9R/D9slXI5aIt1HQn4g/rYOOLCMoUdh6uaQYim6xzAQMiX4PZ8SRUwd54aAxpFaPxg1iWIoarrjqMSFCyp7qciaStp/6Eixdb7pKjCqWT+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473264; c=relaxed/simple;
	bh=l8YHxl2GP5YDQVXzNy+qHX/q1HmVOPiu7snktXuZAPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slKsKK1IhMjxFt+TOyMWSz9I7toWVEZFbvja3BXqFj4xM7jwbfdgV2voVvW1KYhPXHf8DazyMrUclwehgamVCGgu8cxAjong5pPzj9tOQAtwBOM6YVWVJVaS9EzeYGhO6nwdgeGTuBhpcVdS1YGD6zlnqy+cn1WMLZdnTSabdVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpD+I4xA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpD+I4xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF781F00A3A;
	Sun, 19 Jul 2026 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473261;
	bh=he4QShXo/hm/vEiGnRhLGzz6JHIPgvhYG9sEjtQzwcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dpD+I4xA8hlRcoWkfNcFJmu1s2GGoomMuCJbEgbwvr4UeuVUZSmGyDDEbaZ+rjme1
	 oky5jSTCIFpaGLMRfFN5FwLjLrfYB7QNhMhyYp5G28DRIvbSgju/05n+nAvJUSOmge
	 4YLHYAxs9k3olHLelnlfhShPIrDi1Umpio3PpjzW55qAoa61RWpGaAM/5wKHH8mQDO
	 Ov/lzbuLxn7RnqqFM7trIY/ARsKvdRVqa4E1RhO/MyRPYnz6kAgSxUy6IWr5wutfRc
	 Q1+5siNc6Df9kuqsxFE8iGT71cBInbNbZEE0ok7p7VUm5PHm+J+vL6puZinzPAGlgo
	 T3mOjfbv5PtuA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	chenridong@huawei.com,
	tj@kernel.org,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	eadavis@qq.com,
	chenridong@huaweicloud.com,
	akpm@linux-foundation.org,
	surenb@google.com,
	dust.li@linux.alibaba.com,
	Philo Lu <lulie@linux.alibaba.com>
Subject: Re: [PATCH 6.12.y 0/2] sched/psi: fix race in pressure_write (CVE-2026-52991)
Date: Sun, 19 Jul 2026 11:00:32 -0400
Message-ID: <20260718192718.0018-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9805cccf-91d8-4766-a79a-035e5de39857@linux.alibaba.com>
References: <9805cccf-91d8-4766-a79a-035e5de39857@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> BTW, I have an unrelated question. I'd like to backport some stable
> patches to earlier LTS trees (e.g. from 6.18 down to 6.6). For patchsets
> like this one that apply cleanly to multiple versions (6.1, 6.6, and
> 6.12), which of the following is preferred?
>
> (1) A single patchset covering all three trees, with subjects like
> "[PATCH 6.1.y/6.6.y/6.12.y] ..."
>
> (2) Three separate patchsets, one per stable tree.

A single combined patchset is fine when the same patches apply cleanly
to all the target trees - just list the versions in the subject like
you described. Separate per-tree submissions are only needed when the
backports diverge.

On this series: still holding for now - Tejun's fix for the psimon
creation under cgroup_mutex hasn't landed in mainline yet. Once it
does, I'll queue the series for 6.12, 6.6, and 6.1.

-- 
Thanks,
Sasha
