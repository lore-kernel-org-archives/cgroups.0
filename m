Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C04366061;
	Tue, 24 Mar 2026 08:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774340522; cv=none; b=eP2FSPF1634KHjKhixZyIErxCojIdWsnRlVvL6deweWZJm5EhVy7YFlpnXuN8PKE9hBtvDrUXaIomwCGxFucMK8P1ix+8l6xWX9v6GBIkMWrk5JwQsIrvjuwTt2XxDt0ZiL5hzK+6ieYs6XGGJoFDcO+hcPbDJubhd7CCENlnVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774340522; c=relaxed/simple;
	bh=JnGJ5biCq/QEW/LA87r0v58dhqrJm9NANFByZWvH7pU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H9p+x83k7piIXi0kUjDjhq5UoYqIXH/sae9touoxpAamA9cd/qokeblC329JtBMjBQbSoiEqgItygfi8ATOLcibA9DkHac5AS4hXYVh3060jBO962XtKWB7uTTbOK9yhsejJjmyo3VLI2HpFWtu9qhyRsem18mQyUVA9g1KCPD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=HJGLEOfa; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=531903oW; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="HJGLEOfa";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="531903oW"
Date: Tue, 24 Mar 2026 09:21:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1774340509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k4HQ7OepA4zahepNUycO6sBiDAAl4/bkLE1Pcm9/xYc=;
	b=HJGLEOfacDWwcz/0bQ7+Gs/zj6cQ714VedIjSTqlC0S73SXSvBh4A6gbw2yRmCEnjdVjMm
	z3hzS46rL48+boTW45m3uSNAzip8wfE4LgvR3fVrU1pHXD11uUHSkZSnkT6cUC5QXw8H2+
	c/Thef7Z0AhKHA1lX923oNZN1f0CR3hXHtaFcuuxwxgpkQiJGSfulAdR3Jj6D4dzpzaSs6
	4Kn/FHh0IItKRKUyoj2acYGBR7w/TuEnTCb+QcHHGf8pI6cAeJEaSGW73I+bACaC5wRyS9
	NOeMBopD4L7RQUcY6PhjxlJkGt4lx5O3nBqT0BkJNsI+Q0jZfd8Zzj0ypHZkzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1774340509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k4HQ7OepA4zahepNUycO6sBiDAAl4/bkLE1Pcm9/xYc=;
	b=531903oWPxcGu2Ij5B5aMdGLWW8tTQv9ntKuFo+Rz3flw+4EpwmMZ6R+HzOl7sZoZAZCQm
	2EV5H53bcY1S8CDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bert Karwatzki <spasswolf@web.de>, Michal Koutny <mkoutny@suse.com>,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] cgroup: Wait for dying tasks to leave on rmdir
Message-ID: <20260324082147.9ysLN_6x@linutronix.de>
References: <20260323035806.724798-1-tj@kernel.org>
 <20260323113252.xsuwQA3z@linutronix.de>
 <acGavAFVTfggKIKy@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <acGavAFVTfggKIKy@slm.duckdns.org>

On 2026-03-23 09:55:40 [-1000], Tejun Heo wrote:
> Hello,
Hi,

> > Then I added my RCU patch. This led to a problem already during boot up
> > (didn't manage to get to the test suite).
>=20
> Is that the patch to move cgroup_task_dead() to delayed_put_task_struct()=
? I
> don't think we can delay populated state update till usage count reaches
> zero. e.g. bpf_task_acquire() can be used by arbitrary bpf programs and w=
ill
> pin the usage count indefinitely delaying populated state update. Similar=
 to
> delaying the event to free path, you can construct a deadlock scenario to=
o.

Okay, then. I expected it to be limited window within a bpf program or
the sched_ext.

> > systemd-1 places modprobe-1044 in a cgroup, then destroys the cgroup.
> > It hangs in cgroup_drain_dying() because nr_populated_csets is still 1.
> > modprobe-1044 is still there in Z so the cgroup removal didn't get there
> > yet. That irq_work was quicker than RCU in this case. This can be
> > reproduced without RCU by
>=20
> Isn't this the exact scenario? systemd is the one who should reap and drop
> the usage count but it's waiting for rmdir() to finish which can't finish
> due to the usage count which hasn't been reapted by systemd? We can't
> interlock these two. They have to make progress independently.

But nobody is holding it back. For some reason systemd-1 did not reap
modprobe-1044 first but went first for the rmdir(). I noticed it with
RCU first but it was also there after delayed the cleanup by one second
without RCU.

> > -       irq_work_queue(this_cpu_ptr(&cgrp_dead_tasks_iwork));
> > +       schedule_delayed_work(this_cpu_ptr(&cgrp_delayed_tasks_iwork), =
HZ);
> >=20
> > So there is always a one second delay. If I give up waiting after 10secs
> > then it boots eventually and there are no zombies around. The test_core
> > seems to complete=E2=80=A6
> >=20
> > Having the irq_work as-is, then the "cgroup_dead()" happens on the HZ
> > tick. test_core then complains just with
> > | not ok 7 test_cgcore_populated
>=20
> The test is assuming that waitpid() success guarantees cgroup !populated
> event. While before all these changes, that held, it wasn't intentional a=
nd
> the test just picked up on arbitrary ordering. I'll just remove that
> particular test.

okay. Thanks.

> Thanks.

Sebastian
