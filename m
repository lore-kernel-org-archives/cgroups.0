Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4842740D59E;
	Mon, 10 Aug 2026 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390581; cv=none; b=JdgBUY1Y/jDKZQ1PS69KbDwvGymh+YH9ANQbjZrYpEee++8Vb3bab3iRU4PcaQI6Q3n5DWZYQYpMNqCP2Snfpj8HtMjnZlhxDrQsJCyZQjfwL4plp588Bo7GjjtsURT56gkDnvwFcOzZsAXI9GfWFmfr4v0GndTKRwIXy+JQU1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390581; c=relaxed/simple;
	bh=QaI3f+JgF1cl1I0tD7pA+f7nPitkkzyAZMje2nFqsLk=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=qVgICKIDVAtoOztf6GLYJ7mkyrqn9u9t16kSdUDxYNJb3NPScBDaOLEjMvI3H1XFmqrFqUM2U4VmmcwVB6TwXrqfRWGzvcCciSV9ihst6ThfihyfrdGRH1GQ0R+MX/Dsblwbnqx1AgGA8vwgBltIZ5y92kHTU7otK+cDZW4oo4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQVEehY7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQVEehY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70AE1F000E9;
	Mon, 10 Aug 2026 19:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786390579;
	bh=QaI3f+JgF1cl1I0tD7pA+f7nPitkkzyAZMje2nFqsLk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UQVEehY7HSlr66TOhq+af3CBjJ5wRNmXYupmVUQYkncrpoywumEZ3DQ2oPyZBfqDD
	 Vp9PEcUAUXhkmvxuu+8o9+depA/pOgRRXzg+ciQjyDoHDF55mH/AbEvvKgzvkHKdh9
	 0s7erUfjRJejA5lUZgYnAtCgbwlZmAgycPOBzm+Y5CbXtI41EbujKTKpq6/grdIhPV
	 FieCtlEKNViHqDUW7YSxn5ew0CZIZ5IhKT5kDBXnW6ogL8mQLwZrGTnIAJGB2/Cd5d
	 XOZzBTQ55/vzFpAAIXmk5KsF56T7obVEYlmIXxnteCDkQFgeL8uS6Tar6ThrIEbHFi
	 kWAzgLETl8/XA==
Date: Mon, 10 Aug 2026 09:36:19 -1000
Message-ID: <ae7f84d5a5b8da71f57a9102b30b8491@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Rui Qi <qirui.001@bytedance.com>
Cc: longman@redhat.com, ridong.chen@linux.dev, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] selftests/cgroup: Avoid awk -e in cpuset tests
In-Reply-To: <20260809082111.3827531-2-qirui.001@bytedance.com>
References: <20260809082111.3827531-2-qirui.001@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Sun, Aug 09, 2026 at 04:21:10PM +0800, Rui Qi wrote:
> The cpuset selftests use awk -e to parse cgroup mount points. This
> works with gawk, but mawk rejects the option. In test_cpuset_prs.sh,
> this leaves CGROUP2 empty and causes the test to skip as if cgroup v2
> were not mounted. The same non-portable invocation exists in the cpuset
> v1 hotplug test.
>
> The scripts only need to pass a single awk program. Use the standard awk
> invocation without -e so mount point detection works with awk
> implementations that do not support the gawk extension.

Applied to cgroup/for-7.3.

Thanks.

--
tejun
