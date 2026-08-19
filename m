Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E1A36C0CD;
	Wed, 19 Aug 2026 20:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787170251; cv=none; b=CEB91YnHN2PeuNjzR1M4kMqTTucmoKbaBXpQqKzhEwhNvnpwAFW0NaG46BDCxK6cIG22W8VRDS/uAsmtb0Be1T6KcR6xapabmM/HS259PStv3qTuw9o27MATpeu9pjFuB8nCbycYT9MFB0BeZljPo5r5FTs2fuzPj+RQxobSWFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787170251; c=relaxed/simple;
	bh=tQX6Rnd7T2iA9CsgwyQtA2aMtObcAgpG1UiCZ6ND2UY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=eh6MQ68048omb/l8oyoGeBLy0jq0yfEVdPWxa2QyAbZyUzNMNGUdyGJob3QQUu3hdXf+Elfi8xlezDR6IdWHss60ZS3UhJSkMBJv2pHl7dtvrbjFXPJIi09bf66A0aYSffIMWYtv0v3C3iWsL9fOFKGNHKQIbPloqhsGb/UYdqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROZMl7ND; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROZMl7ND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCFB1F000E9;
	Wed, 19 Aug 2026 20:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787170250;
	bh=k/cnIJhFcOgw8OwlBThrel8zcpRLZAbDDGHjoie65A4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ROZMl7NDZYXXkwBOLaGYhmKvoJ58W/CYqkZe4zWkEmEZ0ULoJW4fy4III5DeGHMm5
	 jZw5Ev4EigfSLFkGZgd7Qt4o+uODj0xZi3rbM/Qrn48G2a3y+ZMc46YrXHhLf+kfAx
	 0Z2nMTgwj0iK+lpG3JVtZmfMI7eahCFwcEq/AYgqF86dVU2pCxJgFtjNdaalm/ICgB
	 8Ki3++itybeL+DAJC8em8oA1aLKzP91dpDDDs6QkLnGrBjgq8F9A6Au5+QH2c/UeV0
	 0TQZFiJqvTK0G2rOIVMn7+oQ2AuYj8tAHMexNcatk52W5qBY0KIjeA4GVFNH/HLHuv
	 MOXNG1WOTQIiA==
Date: Wed, 19 Aug 2026 10:10:49 -1000
Message-ID: <dc2411ec4acb17b8cf947a9cd213e78c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Sebastian Chlad <sebastian.chlad@suse.com>,
	Waiman Long <longman@redhat.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] selftests/cgroup: set the test plan after the setup
 checks
In-Reply-To: <20260819083600.1351711-1-hemanth.selam@gmail.com>
References: <20260819083600.1351711-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Wed, Aug 19, 2026 at 02:06:00PM +0530, Hemanth Selam wrote:
> The cgroup tests announce their plan before checking whether cgroup v2 is
> available, so on a host without it they promise a number of results and
> then skip out after the first one:
>
> 	TAP version 13
> 	1..3
> 	ok 1 # SKIP cgroup v2 isn't mounted
> 	# Planned tests != run tests (3 != 1)
> 	# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

Applied to cgroup/for-7.3-fixes.

Thanks.

-- 
tejun
