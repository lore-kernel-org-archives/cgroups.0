Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C916B17555;
	Mon, 11 May 2026 01:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778464756; cv=none; b=gxUIad7f9/UmFyf9wqfw6PYEkVFMD1UFgI5B7iVqzcrB9+ShH2tbJWJt9k8qcGfiHJQndwlQbx15OGYb5FNPVEYstFtJVg2kVkXBS5nIL1BAfDfoiCYTz0M5kdB+5kKJtVTwXpJt81ynetmgkD0YXKy7X8UYR2mPuAn9S8xhp+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778464756; c=relaxed/simple;
	bh=/bnuSi6Jyx6Ck/Xl8v6v+2RU46QHYn5Jj0iPaddHTv8=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=GQZcpTxSra9Ehxv4FiVwsGmafDOgIkykiEhUsPxQu/wNu3vn1Qzvz6cYp65PNbmUBOeUDsy17Ll4ka1ROCDRblraTMyg2oaah4FJrFxO6x21Rx4qpJ1PwNx95UzIwMbqfy1TlfjQ6BgiQ6qOt7+yHO0mK1nl716nFtLl7As1SvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlGz0HfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlGz0HfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE59C2BCB8;
	Mon, 11 May 2026 01:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778464756;
	bh=/bnuSi6Jyx6Ck/Xl8v6v+2RU46QHYn5Jj0iPaddHTv8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PlGz0HfEd+KnfvDQO1xiakQ4Ephkc3idA45CVkYFpy1puVO4HKc/m+Hpy7yOqMYae
	 b1iYs4UkdYr5HkzyjVFuTD6sKY2J6xHFsyTAv5W4tykHt/z0dGyOLKBhdrnR4dUfum
	 zHktdXGGE6qnDk75U7bK6ZAVpg3hXGgj6jPK1uE08hIQ/ft9/Dr1ZC8lVnGAi8UhwB
	 HZ3nK+5HvWrpb+EIko4/LH2djeAOK0wjT/UXxBtJoiz73d/FFRFQEWNfsK91PhVXSg
	 ONy1dvffGPVbr2EqNste2kR0kPCTTCILdymmBmufTwadpyvmRKIUXtRvB9Q7uHdWbS
	 p+zc/EAikTX3A==
Date: Sun, 10 May 2026 15:59:15 -1000
Message-ID: <ac005a30532c0c8660bd9f57c22e3e7e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: Waiman Long <longman@redhat.com>,
 Chen Ridong <chenridong@huaweicloud.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutný <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: fix string comparison in write_test
In-Reply-To: <20260511013957.1749665-1-lihongfu@kylinos.cn>
References: <20260511013957.1749665-1-lihongfu@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.1-fixes with the subject capitalized to "Fix
string comparison in write_test".

Thanks.

--
tejun
