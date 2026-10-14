Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1913FFABF;
	Wed, 14 Oct 2026 18:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792004060; cv=none; b=TG/IHHxz9BdEUs0giMJDp/BLl2nE5ipF8K1e6KkAyxRPjFo3TkEBsiIcNLVP6WDdPSYNRgEQI0ntqrEzUSdPF0zfzmZhaCtToEBKqlKVv8nvv/B2HTbqL+bZWfvWDXG+hBCfVTJ3b1YsABh8eg+hw8QYCP4wkMN36lORqsju4EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792004060; c=relaxed/simple;
	bh=Shp1V24z7twJ2gmzVTdpyt3bw71+ZJyAoCLTQZz5Ntc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=grfo5s6UzvVb4/R3HUHhfN/+omNVEdbgIxQuDA+BqcXNCi/BUqSpfSC2OQt2AZVt6FGt5cyu5ingOkb83EJIzfmYJ7F9a9Q3nTjO12zdv8mOHOrBhNKgWTZYoHyrwn2o5ANSSMZY1AECYvJAJp0TKId3mFF+/iRjytMBCfjs0RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QzdOHYUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzdOHYUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324E21F000C4;
	Wed, 14 Oct 2026 18:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792004059;
	bh=Sn0TUje/xLNp9okf+baAS0Cznr3CBb1Va+Y4WHDu8rg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QzdOHYUNssCudHcHWErpVxpNeG1l1YNTpc6/KyfI/mjurZH7fnrXGh/oBkyuKQbVD
	 68Uu/kn2UyV4WorjsEIgnjt+D1r8B6NgQYsfo6qO9wUBHgi78zqTTBjqCVFIB0Ymgc
	 bEdHL2sTNNikPZ9b7uhYyPIa1p7ELP1gukWdueFQbO2aqjB7ptjRtTbmG3nWCcRBSS
	 ftn8lrH2MNX01PCz6Nly78IypC8KJTxwLRtBnnYqFZQ31EB9PQUowSgKIO/fiyuNlN
	 5pTPdwqysFTTJywroVhhrTZxYYsoNXrZwx87vs+MQkmxf3RLWdTZdYMlbuTS4I3i+J
	 6zLykRgXzGvnA==
Date: Wed, 14 Oct 2026 08:54:18 -1000
Message-ID: <81a8a0d64d269851ce4b48a240aa673c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/cgroup: test pids.events notification
In-Reply-To: <20261013064812.875787-1-sahaj123.sc@gmail.com>
References: <20261013064812.875787-1-sahaj123.sc@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Sahaj.

The following is a Claude-generated review.

On Tue, Oct 13, 2026 at 12:18:12PM +0530, Sahaj Chaudhari wrote:
> Add a selftest for pids.events notifications. When pids_localevents is
> enabled, a fork rejected by pids.max must increment pids.events and
> generate an IN_MODIFY inotify event on that file.

Can you mention 1765a153d985 ("cgroup/pids: Restore pids.events
notifications in local mode") here as the fix this test covers?

> Check for a failed read() of the inotify event before comparing its
> signed ssize_t result with sizeof(struct inotify_event). Otherwise -1 is
> converted to a large unsigned length and the uninitialized event buffer
> is inspected.

This describes the v1 to v2 change. As v1 never landed, it belongs only in
the changelog below the --- line.

> +TEST_GEN_PROGS += test_pids_local_events

Can this be a test in test_pids.c instead? Its main() already does the
same setup, so the new test fits as another T() entry next to
test_pids_events() without the Makefile and .gitignore changes. It can
then use cg_run_nowait() with run_success() for the fork and cg_control()
for the pids.events path.

> +	if ((size_t)n < sizeof(struct inotify_event) ||
> +	    !(event_buf.align.mask & IN_MODIFY)) {
> +		reason = "received no pids.events modify notification";
> +		goto cleanup;
> +	}
> +	if (cg_read_key_long(cgroup, "pids.events", "max ") != 1) {
> +		reason = "pids.events did not count the rejected fork";
> +		goto cleanup;
> +	}

This repeats the counter check before poll(). Nothing can change the
counter in between, so maybe drop it?

> +	if (proc_mount_contains("pids_localevents") <= 0)
> +		ksft_exit_skip("mount cgroup2 with pids_localevents to run this test\n");

Is this skip necessary? In the default mode, the rejected fork also
increments the test cgroup's pids.events and notifies it, as the test
cgroup is the one over the limit. The same checks hold, so without the
skip the test covers the notification in both modes and still catches
the regression on a pids_localevents mount.

Thanks.

-- 
tejun
