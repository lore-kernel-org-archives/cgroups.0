Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2684E2F31;
	Mon, 21 Sep 2026 17:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790010113; cv=none; b=tT3geCRGU+w7YYgpI9z7ChJqnnTPQwv+GR7RYs/wmXsSWc8ww16z0VVvn4QKrUr414QP7kbdfiyQlJMdegpR9dSlH7H5MoGHgxWq/xLs4TMko/dBJ+zs8FxhzQwDXsZfi6/YFqw4atJg5hMDwmTGoA14M+LRQou6tp2mMJiSOhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790010113; c=relaxed/simple;
	bh=ShV3X2YXppnmN/a717TSQONRJW1gjfiDhJAudCtwcME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNfpb7MAiOdgTi/FFFYZko1PuVsEB0Jrsu0Wf0yDjUM58DIXOQuSy1specw0D6o6XgC51dGb5HMz2uD51ps9zP6gcxzOmuoAAqsYzwTARm+jfo0zrf7hfZXObTwUFzDuN6A7JPCDGrh2eVh6uAAJQnMUo7K8zKF3Lw+kmCdc5XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256:X25519MLKEM768)
	 (Exim 4.100)
	(envelope-from <daniel@makrotopia.org>)
	id 1x8hOg-000000000JY-1ffP;
	Mon, 21 Sep 2026 17:01:42 +0000
Date: Mon, 21 Sep 2026 18:01:39 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Etienne Perot <eperot@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Christian Brauner <brauner@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP
 children
Message-ID: <arFi84zuQ015Tip1@makrotopia.org>
References: <20260828215252.4126811-1-eperot@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828215252.4126811-1-eperot@google.com>

On Fri, Aug 28, 2026 at 09:52:51PM +0000, Etienne Perot wrote:
> For CLONE_INTO_CGROUP, however, the snapshot in cgroup_css_set_fork()
> is taken before the target cgroup has been resolved: kargs->cgrp is
> always NULL at this point (it is only set at the end of the function).

We hit this in OpenWrt and reached the same conclusion independently
before finding your patch, so here is a second data point from a real
workload.

The symptom is that re-creating an OCI container fails. procd's service
supervisor writes cgroup.kill to /sys/fs/cgroup/services/<service>/<name>
when a jailed instance exits, and leaves the directory in place. The next
generation of the same instance is started into that same leaf and execs
ujail, which clone3()s the container init with CLONE_INTO_CGROUP into a
freshly created cgroup under /sys/fs/cgroup/containers/. The container
init is SIGKILLed before it executes a single instruction, and every
subsequent attempt fails identically for as long as the services leaf
lives.

Instrumenting the child confirmed it never reaches its first statement
after clone3(). What isolated it was that rmdir() of the services leaf
followed immediately by mkdir() of the same path at the same mode makes
the failure disappear, while an unrelated cgroup operation in the same
window does not, and while the leaf's attributes are byte for byte
identical to a freshly created one. That pointed at per-cgroup state
exposed in no file, and the snapshot site then explained it: on 6.18.52
the capture is at cgroup.c:6740 while kargs->cgrp is only assigned at
:6803, so the else branch is always taken and cgroup_post_fork() ends up
comparing two independent counters.

Backporting this patch to 6.18.52 fixes it. With no userspace change at
all, and with the killed cgroup still deliberately left in place, three
consecutive create attempts that previously failed now succeed:

  before: create rc=251, container spuriously left running  (3/3)
  after:  create rc=0,   container correctly left created   (3/3)

Your selftest in 2/2 reproduces it on the same machine, and behaves
exactly as your commit message says:

  6.18.52 without 1/2:   ok 1 test_cgkill_simple
                         ok 2 test_cgkill_tree
                         ok 3 test_cgkill_forkbomb
                         not ok 4 test_cgkill_clone_into_killed

  6.18.52 with 1/2:      ok 1 test_cgkill_simple
                         ok 2 test_cgkill_tree
                         ok 3 test_cgkill_forkbomb
                         ok 4 test_cgkill_clone_into_killed

Tested on x86_64, kernel 6.18.52, with procd/ujail as the OCI runtime;
the two kernels differ only by 1/2.

Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Daniel Golle <daniel@makrotopia.org>

One request about stable, and apologies if this is simply a matter of
timing. The patch is in mainline from v7.3-rc2 and carries Cc: stable,
but as of 6.18.53 it is not in linux-6.18.y yet. Given that the failure
is silent from userspace, the child dies with no diagnostic and kill_seq
is visible nowhere, it would be worth queueing for 6.18.y and the other
branches carrying b69bb476dee9 ahead of the usual post-release sweep.
We are carrying it as a local backport in the meantime.

Thanks for tracking this down.
