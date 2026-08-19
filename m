Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F43E34FF41;
	Wed, 19 Aug 2026 20:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787170259; cv=none; b=ktIvQe5xw39QbVNZrEOu59lScIXC6zfz16tYu6ZL/bubLBxz2sR5Hq5KMRDzbEoHWvybR6mIdXscG2nWAnse4tGimbRoT7dUDhGnfeXq5A+OUIDBuNr8zhUFHVy4Oinb+PftgX2AsFWmmhMdPTE/uN7HxbTrPOHZcavS2IDh2+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787170259; c=relaxed/simple;
	bh=04r/jRyy45hTtR5es6u/tOSuo1S+Cr9MMePmQzd8UXc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=dSwTJmFjCh5/Pl16XxZDfcM+G3UNpkj4LRXlvuKn5NqvVubkEGhXFBmB9KYQXmEN9lBpWo6eENOpbfnMFa7j+w2a5JL+2jAyFLcDSj9fxZRnu55gTcn/npr49oLch90Ps9bgfRs6+u5CcGRpT2TbumS44rBAaClCGUTQfVhLWS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NMsQrJU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMsQrJU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7846D1F000E9;
	Wed, 19 Aug 2026 20:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787170255;
	bh=vC8PG1THg+ljzCGvx1mElmWUwTd0qzTF1Cgjf9y7qWE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NMsQrJU9J7Fyn7PdmqQOt2e978sTyHAoN2NnzEoy18m2vM1C5ABn+AoOkpMgqcaVA
	 OpP/toianNlfgKpZUFaJZDX4f4bprgsp5cufIn2qmH3NuDyg3f2YDi5gzn945dfxMg
	 FRe1DeziYvO1jb1rrfN7DAfNmAfKm0sWU2yBn1DSgQYE4ZtJVrrSGaFVEUR/BKVzcj
	 7zKrSpneQ5wT9tdmNjJGK3IN8CFCdwRF8Rs4LJLKnjRvXz2xjhWbgja7gbhH277/Zk
	 AG3C1xRlXcuhSORrhpGQvzkGScyaEyLem3PrqIeQqSmNUqoS5zIaFf6T+ZgfBjTaC7
	 u+4BtWdVhieMw==
Date: Wed, 19 Aug 2026 10:10:54 -1000
Message-ID: <36946be63a1b4593d18887b4aec61be8@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: cgroup: simplify cpuset subtree permissions
 test
In-Reply-To: <20260819103152.767771-1-sunshaojie@kylinos.cn>
References: <20260819103152.767771-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Wed, Aug 19, 2026 at 06:31:52PM +0800, Shaojie Sun wrote:
> Simplify test_cpuset_perms_subtree by removing unnecessary chown of
> cgroup.procs files. The test verifies implicit migration triggered by
> enabling/disabling the cpuset controller via cgroup.subtree_control.
>
> Implicit migration is handled internally by the kernel through
> cgroup_update_dfl_csses() when subtree_control is modified, and does
> not require cgroup.procs write permission. Only cgroup.subtree_control
> permission is needed to trigger the controller state change.

That's true but making the migration work isn't why the chowns are there.
cd3c6f682df4 ("selftests: cgroup: Add cpuset migrations testcase") added the
test to verify that migration permissions follow delegation boundaries, with
the setup emulating a delegated subtree, and delegating a subtree includes
granting write access to the "cgroup.procs" files (see the Delegation
section of Documentation/admin-guide/cgroup-v2.rst).

With the chowns removed, the test instead asserts that write access to
"cgroup.subtree_control" alone lets an unprivileged user trigger implicit
migration of a privileged task. That matches the current behavior but isn't
a documented property, and if implicit migration ever becomes stricter about
delegation, the modified test would fail without anything regressing. I'd
rather keep the setup matching the documented delegation model.

Thanks.

-- 
tejun
