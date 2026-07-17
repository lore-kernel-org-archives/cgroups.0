Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB56225413;
	Fri, 17 Jul 2026 22:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784327556; cv=none; b=RIlG/eUPPrBamPpxl27Ag1OqDkiqj5KsY+un5wqM63T1rOWFs/FkWYKTHxmUtPAe2aVzxSMv9mC3lOHe+vaJoaThcdq48CXyWVRY7SFSHdveKZSHgpiLKi2lqYnHt06n5f3as82ACYfSeI//wmaL+53lyMFZ/G9eEGLkOeg5cIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784327556; c=relaxed/simple;
	bh=i8FQ/sM+rJEaeK5A4kEUPxamVPy0FH7uPk29F8VMbLY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=fvEnVzqcNEiq6DbXg3k4cCBFCWUgAIHHPhUQzHQiq8inDlAf6TdjJYhRF5fXB1rzq9ZY1IPco80EEshl6zo180sBNpQsXWnyAsj1H7TmqaW1svAc6/SjmBWFZhnkSwsYqgvN/iDYTrTtSk29H8KyI5mRh567eC1nzuZTrYVHE7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I99MRwE6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I99MRwE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FC61F000E9;
	Fri, 17 Jul 2026 22:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784327554;
	bh=FL7ZhG7Ht+zYG5Bu6srAkLtEtO2al1lZEK5yJDBMWto=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=I99MRwE6UGB8P+kl39PWAudS0PNjdoTiS8ez0kKiC5ZIYo1RBWLKmGtEt+biJzg8w
	 dwtHG4cGJqzOtthVbJR1wMPLqkFl5cmmZuD1eim5Rp/fZSVV/pwyoj1sLdVPjrHRHS
	 pcGVXrBE7n74mMHioTYyPExqqni2lixh+MCoH5EtycCbCQkenDCRn0VAhYIAWagP+N
	 jEeZtI7dYyCWCZ56Y5KXJtp3noXfFqeophCMiV8yNsEchqkvCV3EAUTjEs2vjk6D8X
	 MzvTA07CzJNziQTcebkHkWsoBp/O8NBDjdjsqjO73sSQzKsv/hWRz/JtjGM9zTRrxk
	 1yKVukd1ukEug==
Date: Fri, 17 Jul 2026 12:32:33 -1000
Message-ID: <b4f0318df0a206a12d4a59cf1c52808c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: ridong.chen@linux.dev, hannes@cmpxchg.org, mkoutny@suse.com,
 shuah@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH-cgroup/for-7.3] selftests/cgroup: Fix minor defects in
 test_cpuset
In-Reply-To: <20260717191814.989215-1-longman@redhat.com>
References: <20260717191814.989215-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.3 with a couple of typos in the description fixed.

Thanks.

-- 
tejun
