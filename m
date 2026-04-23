Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CE52D8399
	for <cgroups@vger.kernel.org>; Thu, 23 Apr 2026 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776972126; cv=none; b=qt14g1vtshoxrsHrBPhQEfkixQvaW6q2UPitLMmfO8NhvlN2c7sntM+Y76+6b73V37zrbtbKGITi4oeqOwl+XrSvz4r7MBwsTzrXNlvG7t0zx+y7oBtlh1bgU0oHb3QW0g0JriWbJXnPpxpRLkVDYf6erjQFCWbXw5azuRq8ZUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776972126; c=relaxed/simple;
	bh=QtHjuTzc89JDqAcIY+ZA/UADrZI+EpqQxEi7XlkCt9I=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=ne6CUxvUPOJ1LP0Z1xyt6dbER13pllZNUoaX6TtkBKRkrBo6ATQ9DiZ2+CrqyE+UEOvFDxFFvr2b35jhFxjB4Y8luBT1MDbLBe6ogomyCO5/vydUKBVsuBUo7laojrbggA6d3zF8I37lmoRPsGIBN7RVPP/lZepUAcMa2emPWEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hVGiY29P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hVGiY29P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8A7C2BCAF;
	Thu, 23 Apr 2026 19:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776972126;
	bh=QtHjuTzc89JDqAcIY+ZA/UADrZI+EpqQxEi7XlkCt9I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hVGiY29PbkUxLrJrEavCOJBSZQJKGAfoPa5MLrxIAX8kKUktyASspQSTtYFC2llkT
	 jwZJJ1peb96Mq6MNQNbZ2tQnNsyqVcV3RaT+h9TxlitMJnZEcFrWFheY9jMGxgXQ0D
	 1O2HnMog6l+KB3UpW91mrMLlrppv9a3f2b8PxkZUCUuwMcc+U7zIpvdyczxW7+8Ckv
	 xE7FRdWsYvlSSnrQbO863wmUkYxbVhsWeteq63Asyc4vzjJB7xHwkU3zA3RSkM0sZi
	 j48ZoPJxAA/bmDY0XmahSqPSZcz18uuWsfvhiFgufujS3q8tw+Qu/Q0f4Wd/aELtVv
	 J0mfG92M5SF3A==
Date: Thu, 23 Apr 2026 09:22:05 -1000
Message-ID: <e8c3b8d6dc941d3a74f2adf7464351fc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Petr Malat <oss@malat.biz>
Cc: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] cgroup: Increment nr_dying_subsys_* from rmdir context
In-Reply-To: <CANMuvJmf7On+qRnkkBpqzDe2HqX0axWKKPdtfAdjSdN4i1f0qA@mail.gmail.com>
References: <CANMuvJmf7On+qRnkkBpqzDe2HqX0axWKKPdtfAdjSdN4i1f0qA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.1-fixes with the following Fixes: tag added.

  Fixes: ab0312526867 ("cgroup: Show # of subsystem CSSes in cgroup.stat")

Thanks.

--
tejun
