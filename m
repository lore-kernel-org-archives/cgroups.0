Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3881FA859;
	Wed, 10 Jun 2026 00:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052829; cv=none; b=gO4OgDhyoP2DuOOggJCIIn69HQ8vBBaKDL7NgKT42wMwpV+v1an3BntDRLWQsqQqXCzvOMUjlkFCpdFybZ1BSUpJhOPrnFR2X2llgvKQULV8VYDMZSec9s5kZNTHx4lEDq5SHke3ik//Hgjru0vdYmZQcutwr+b3KfCLKdXju9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052829; c=relaxed/simple;
	bh=KB1rQPbtWmaqaVgJwVHfcqLWERwD+WGRldQxAg4xbhE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=p8tn9NG+nOVVz19+8yS1w19O2rJ3C+6aNqNykQXRaOmgk95mW5nYw0Vb8GNwaS040mipaVPQ14QxC2UvZ6I180XpxnBUxUa6/EV12AHO/thmKZ1U/Xv3lhIEBm1YZVLmYeA0E9UnNOA6RLbsgQQ4x+Y1Vfn5+K8CuFA+KBV+XN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=acgc7xgk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="acgc7xgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE071F00893;
	Wed, 10 Jun 2026 00:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781052828;
	bh=9sO0gIm4z95R8a+HuLm1r79PfCgTK1qEypIW9uF7ZLY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=acgc7xgkEu753ugPGGUjJS42dHPmgrdSxWxEl3bEd/o06wO8hf6DWmidvkiwJLPFQ
	 hH3311AyJa+Z/NfGYRTP9TDVz6X/iSlQSoFPBQmczKZpHJ1s8+ftom0oW9mcuE7YyE
	 gC2Lk9CMpaW6K6cnd1jRSb7PF67cSUFrf66896tE=
Date: Tue, 9 Jun 2026 17:53:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>,
 Farhad Alemi <falemi@asu.edu>, Yury Norov <ynorov@nvidia.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Waiman Long <longman@redhat.com>, Rasmus
 Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
Message-Id: <20260609175347.9688ac8060bc072ebd58cbe1@linux-foundation.org>
In-Reply-To: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
References: <25c4bc47-b65d-4c04-8a8f-18eef2b5566a@kernel.org>
	<CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 9 Jun 2026 19:57:41 -0400 Farhad Alemi <farhad.alemi@berkeley.edu> wrote:

> cpuset_update_tasks_nodemask() rebinds a task's own mempolicy to the
> cpuset's effective, online mems (newmems, from guarantee_online_mems()),
> but rebinds that task's VMA mempolicies to the *configured* mask instead:

Hard to understand.  Was "rebinds" supposed to be "is supposed to
rebind"?

> 	cpuset_change_task_nodemask(task, &newmems);
> 	...
> 	mpol_rebind_mm(mm, &cs->mems_allowed);
> 
> On the default (v2) hierarchy a cpuset that has never had cpuset.mems
> written keeps mems_allowed empty while effective_mems is inherited
> non-empty from the parent, and tasks may be attached to it (the
> empty-mems attach check is v1-only).  A subsequent rebind -- e.g. from a
> CPU hotplug event walking the cpuset -- then calls mpol_rebind_mm() with
> an empty mask.  For a VMA policy created with MPOL_F_RELATIVE_NODES this
> reaches mpol_relative_nodemask() ->
> nodes_fold(..., nodes_weight(cs->mems_allowed) == 0) -> bitmap_fold(),
> whose set_bit(oldbit % sz, dst) divides by zero:
> 
>   Oops: divide error: 0000 [#1] SMP KASAN NOPTI
>   RIP: 0010:bitmap_fold+0x5e/0xb0
>    mpol_rebind_nodemask
>    mpol_rebind_mm
>    cpuset_update_tasks_nodemask
>    cpuset_handle_hotplug
>    sched_cpu_deactivate
>    cpuhp_thread_fun
> 
> cs->mems_allowed is the only nodemask in this function that is not the
> effective set: the task-policy rebind, the page-migration target and
> cs->old_mems_allowed all use newmems.  The sibling cpuset_attach() path
> already rebinds VMA policies against the effective mems
> (cpuset_attach_nodemask_to = cs->effective_mems) and explicitly notes
> that mems_allowed can be empty under hotplug.  Rebind the VMA policies to
> newmems too: it is guaranteed non-empty by guarantee_online_mems(), which
> fixes the divide-by-zero, and it makes the VMA policies consistent with
> the task policy and with the nodes the task is actually allowed to use.

How is this bug triggered?


