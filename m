Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3F037880B;
	Wed, 12 Aug 2026 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546002; cv=none; b=ImoScV96O960/kdrzWUnmCaTRI0rsbHmDt66xct4BBMi3jNFFRz5fuqDsHUjpcASSwEnbf4ooSQ77KMeYBeYsn9GH2npgOZAaQMwq1so+DMFJMFOdJR4hqaZ1D6SP3j646ekh+qsEKCgwDLMQN3tqa/02CIW5sB2oxbiIa8Gh58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546002; c=relaxed/simple;
	bh=N4H/nJwHNuBHjUBnBHV42PpdwFwk+iDNDfBpK8ku+ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtBXsZX+1m6j0v70G9rXYgcH8WxtoG0iVxx27uTZdfmk0HkWS9wnpyWQz6Eaj7YzJfF27OmxsPSOL3u5BojC3UjknmmBsMdFgjDYa0XtmBCzG5xMXpMfTjHVLm/I02enQayUIgrHQcvuhjORz3qAhRfCIWmKgzzAUx1w0RJX3EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gaSj1BT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaSj1BT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E081F000E9;
	Wed, 12 Aug 2026 14:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786546001;
	bh=kmSRdXbDxC5n1fJ3eK/gMJjVKqziFhOwGBO5vuQoRgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaSj1BT7QxKuMtbp1QTQ29Z2m70mOEdqmCvsBkiMou7WyYKucciI8E4D0HzMQq6Uj
	 p8s2uInxnHPfr+wLZFoDeuOkbY1rs7+dy1+KmYFVsRpVZYAbY25SLz1mz5ZPonyFCv
	 lX/S8U1mTU9e6cc4NJCdoE3gwtiXduOMuOMDOb7yXUSarlWrWcw68OKYd8QI67q53z
	 Zm+1LTQopJPSjltBg0jG1UWJ51gwAVpx/HyEvtN+3OeaqL/zlm7kNhedgQerrRX4m9
	 aLIHK0LJzRbosqtGIyYDtlf3pO8fjOuo71f+OE1MQiIrhGLVfsm2hm2574BHbqFdrz
	 OSRVzqTJipJIA==
From: SJ Park <sj@kernel.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?=20Michal=20Koutn=C3=BD=20?= <mkoutny@suse.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3] selftests/cgroup: test_zswap: skip test_no_kmem_bypass if debugfs is unavailable
Date: Wed, 12 Aug 2026 07:46:32 -0700
Message-ID: <20260812144633.125604-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260812050848.848882-1-wfelipe@google.com>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 12 Aug 2026 05:07:55 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:

> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
> 
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
> 
> Selftests should not fail if debugfs is unavailable, and it should print
> a message when it is skipped.
> 
> While I'm here, also add a warning message if the test is being skipped
> due to totalram size and make the check for totalram more readable.

Looks good to me!

> 
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
