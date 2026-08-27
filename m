Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE423D9540;
	Thu, 27 Aug 2026 22:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787871518; cv=none; b=omCm+E2SotpWojJFEmEB1OsQzG+GXkJpdIxhxEjL9z4KkhvggUXV6JYvDsNgZvs/3ltAj7CMLADoKgJJ1VMVeo1DxKvBZtkqoS3bYkHyqnPjQy1d2ClgreEVrcIVtP3ULYtW8FStwStj4B2uQNxRtua0gb+w3t4YbBzOXl26pFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787871518; c=relaxed/simple;
	bh=5q1K0Y4OgILhKpFqC6V0wh5KJHs9+MupmQvC1o1Trrw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=o6TAR6jY40lWrZioC77YfDVAREC3XrKfHj15rVvnk3r+Zgd8tOSMCBXAGt4QXCW8s8ldshnZC1foN0DsvYfAgO7c1hZuyaYtyowQ4vamgARF7o9wcNF9Yhl01p2PziDDuJo853gnjKN3pepualGB453NHV4t85M9PHmqZ3vXsuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uYjmXJ0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uYjmXJ0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191751F000E9;
	Thu, 27 Aug 2026 22:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787871508;
	bh=o+CbAiQiCIV+X/Q5GkUr3xptEh0VJF+8loj/KjFok3E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uYjmXJ0o0nclaaJYRmGvcWh+PMXoFy/4V5w+QgCWh8eiWJb/86f00TXFVBhbrLHhB
	 8lQosBwA0un/NICBloB17fuu/r+IR/E6r6IhUBF68l7qps2RaUPak5VGjmfyDXCX/Q
	 bRnygD5L99ynxU0xzCPn1/M1i0SWw9TtVfU7HRFk=
Date: Thu, 27 Aug 2026 15:58:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?ISO-8859-1?Q?"Michal_Koutn=FD"?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] selftests/cgroup: fixes for test_zswap on single
 core VM
Message-Id: <20260827155827.e40d5d88cee174437a16f432@linux-foundation.org>
In-Reply-To: <20260827034807.2822234-1-wfelipe@google.com>
References: <20260827034807.2822234-1-wfelipe@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Aug 2026 03:47:40 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:

> This series fixes two test failures in test_zswap observed when running on
> a single-core VM (-smp 1) with 4GB of RAM.
> 
> Patch 1 addresses a race condition in test_zswap_writeback() where
> waitpid() returns before the exiting child process is switched away by the
> kernel, causing an immediate write of "+memory" to cgroup.subtree_control
> to fail with -EBUSY. We fix this by waiting for cgroup.events to report
> "populated 0".
> 
> Patch 2 fixes an implicit unsigned conversion bug in test_no_kmem_bypass()
> where small negative timing differences between debugfs stored_pages and
> cgroup zswapped bytes caused the comparison to falsely fail due to
> unsigned promotion.

Thanks.  Sashiko thinks there remain some
signedness/truncation/overflow issues in there:

	https://sashiko.dev/#/patchset/20260827034807.2822234-1-wfelipe@google.com

