Received: from mail.piware.de (mail.piware.de [37.120.164.117])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 475323A875A;
	Sun,  3 May 2026 13:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.164.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777816436; cv=none; b=oDYRKo7aSnivWkTH1ylM7fBinmgj5NIGlYfrShpGby8l87i9TfG7IN8sE7/sj9gVaNGcx8SNjGCm3bqi+qJlPSeOMXwRuMMcvdQy3ILM+ynwikYZ9rrXiLTBJ+aoiuGtbjfnTswNmX7mizZsyRJyMHdjnxE3R9kAAd31mjFvS3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777816436; c=relaxed/simple;
	bh=+/QBPDKuejX5RK9MIlRm6Y6hQS92z0N8GOAF3fBZaoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=psscM+ZPAtX12a2gqUW3mO2ZAy49Engp8dNqWjsY8/Z5jeCaEmQRX8vzDNh3R4DWNYomN1N+bt9oKUs5Uot6lXLF8zcmfpbHfu77Q8Vs+uBn83l+I4OSSDiRoN1BDpfokf7YX12nvMCkZTDjyUKZuxnUpRLEUs6VkpsM+inZSD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=piware.de; spf=pass smtp.mailfrom=piware.de; dkim=pass (2048-bit key) header.d=piware.de header.i=@piware.de header.b=WbGWTHzr; arc=none smtp.client-ip=37.120.164.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=piware.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=piware.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=piware.de header.i=@piware.de header.b="WbGWTHzr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=piware.de; s=2025;
	t=1777816426; bh=+/QBPDKuejX5RK9MIlRm6Y6hQS92z0N8GOAF3fBZaoM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WbGWTHzrPdPzmLCNmgDDQXwNuLINgouT2LkJze9DC8qU0QOKyeBE44UR2c7SqYv4p
	 H/NU/d2OS82GIGmrsGtk1xRdtOReK/NOYJCS4MSG+ipvgZ/DRGgAK1rTzv4RFiwZ5p
	 d94gfp0L3xKkFVknttVjE8DYEMDWmg1JwN8rhErxeDJyTHz4ggC8RwQ0BXL4WiBe49
	 2bqsIsnSYbN68MBnDflcrANzwgvR6RCGCVGsY5FwwRamUz2g5fdD0HTLr6Gy/B+SoU
	 MznmknzjoPL2v7JpoDYqEfVZ0Sv+JHw4Ro5sEZ469sTOu5Levmgej43vojEJse3Wxl
	 lZeFkxnA4kKNA==
Received: from piware.de (localhost [127.0.0.1])
	by mail.piware.de (Postfix) with SMTP id B0F4CFF854;
	Sun, 03 May 2026 15:53:45 +0200 (CEST)
Date: Sun, 3 May 2026 15:53:44 +0200
From: Martin Pitt <martin@piware.de>
To: Tejun Heo <tj@kernel.org>
Cc: regressions@lists.linux.dev, cgroups@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 cgroup/for-7.1-fixes sched_ext/for-7.1-fixes] cgroup:
 Defer css percpu_ref kill on rmdir until cgroup is depopulated
Message-ID: <afdTaEBPqzYGnO4n@piware.de>
References: <ad3b4597f3df81914b871618535370db@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad3b4597f3df81914b871618535370db@kernel.org>

Hello Tejun and all,

Tejun Heo [2026-05-01  8:31 -1000]:
> A chain of commits going back to v7.0 reworked rmdir to satisfy the
> controller invariant that a subsystem's ->css_offline() must not run while
> tasks are still doing kernel-side work in the cgroup.
> [..]
> v2: Pin cgrp across the deferred destroy work with explicit
>     cgroup_get()/cgroup_put() around queue_work() and the work_fn. v1
>     wasn't actually broken (ordered cgroup_offline_wq + queue_work order
>     in cgroup_task_dead() saved it) but the explicit ref removes the
>     dependency on those non-obvious invariants. Also note the
>     pre-existing cgroup_apply_control_disable() race in the description;
>     a follow-up will defer kill_css_finish() there.
> 
> Fixes: 1b164b876c36 ("cgroup: Wait for dying tasks to leave on rmdir")

Tested-by: Martin Pitt <martin@piware.de>

> Could you give v2 a try? Same defer-the-percpu_ref-kill mechanism as
> v1, with an explicit cgroup_get/put around the deferred work to make
> the lifetime invariant obvious (Sashiko bot review on v1; v1 wasn't
> broken but the explicit ref removes a dependency on non-obvious
> ordering). Fix should behave identically to v1 for your reproducer.

Sorry for the delay, I haven't built a kernel in a decade and not ever for
Fedora.

I applied the patch to the Rawhide 7.1.0-0.rc1 kernel, it applies cleanly
there. (I first tried on top of 6.9.14, but there are conflicts.)

  https://copr.fedorainfracloud.org/coprs/martinpitt/test-fixes/build/10419932/

Usage on Fedora 44:

  dnf copr enable martinpitt/test-fixes
  dnf update kernel-core kernel-modules-internal

(This assumes a cloud VM. If you use the full kernel, update the "kernel"
package as well).

I ran the cockpit-podman test that originally triggered the bug, as well as my
reduced variant, against that patched kernel for 50 rounds each, and it has
consistently succeeded.

So this works great, thanks a lot!

Martin
