Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD67B29993D
	for <cgroups@vger.kernel.org>; Thu, 11 Jun 2026 02:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781146251; cv=none; b=LH7z/QOAkFpsuR64QSGlq2ANgF8ZOlLgEproB7GjRaTXQq4k7UPIBEoBfyqxNS9BRICktYHf8eB3hBPk0+BoxkAFhFtwFD+wfnoYf8a6VzJq4XBot+svgcCdA8pBMChQ+bdQHAGjgdpe0ltDw7qKrBmIy0RL0SXmLbPzX1B9o8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781146251; c=relaxed/simple;
	bh=5xCwTikiya66h9P56QgbjupR8T8Zpq6Mr2nqwVAVxkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mx16icearcwX++79u4PU/XB637+ZsLEH5rOva2cBglx6XCbe3PntaTJauyt+I06rSZI/j4a8DOrPSq/pDlcXNkbmGNJzLDn0duyKSIof2jQ6+bBgpO/GMD27o5nfSQpysY2mX+RN8Awa9+J79l5yo2Z6yRGaP33Ay6b5ddKfieA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PSFbKFrl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PSFbKFrl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781146249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zeTt+ma90++oB/pmg/novekOFyYf+u+Cy444ynH4ojc=;
	b=PSFbKFrl/rO23Ry29nmZxVR9x1UlI2tCf9j86gWzipJVyOhExPHaTXCyL53CBZvyaCEP3R
	nPdShKcqySh3xwWZuvpKkhoxJZdHUwRhBZwOoKkb/5zdVq0hM1UpS2dddu57iIXXVwn9qh
	0i6lmz/puRe8b2jkWvCTbMgPo45YRJ4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-4GuzfYPJNDWLqOuDDRCa9Q-1; Wed,
 10 Jun 2026 22:50:45 -0400
X-MC-Unique: 4GuzfYPJNDWLqOuDDRCa9Q-1
X-Mimecast-MFC-AGG-ID: 4GuzfYPJNDWLqOuDDRCa9Q_1781146243
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41C861964CF2;
	Thu, 11 Jun 2026 02:50:42 +0000 (UTC)
Received: from [10.22.81.61] (unknown [10.22.81.61])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4CE7E2ED4;
	Thu, 11 Jun 2026 02:50:39 +0000 (UTC)
Message-ID: <c1cb5025-d089-4e73-8bb4-d7b8cc0badf7@redhat.com>
Date: Wed, 10 Jun 2026 22:50:38 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: rebind mm mempolicy to effective_mems, not
 mems_allowed
To: Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>
Cc: Farhad Alemi <falemi@asu.edu>, Yury Norov <ynorov@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
References: <25c4bc47-b65d-4c04-8a8f-18eef2b5566a@kernel.org>
 <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 6/9/26 7:57 PM, Farhad Alemi wrote:
> cpuset_update_tasks_nodemask() rebinds a task's own mempolicy to the
> cpuset's effective, online mems (newmems, from guarantee_online_mems()),
> but rebinds that task's VMA mempolicies to the *configured* mask instead:
>
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
>    Oops: divide error: 0000 [#1] SMP KASAN NOPTI
>    RIP: 0010:bitmap_fold+0x5e/0xb0
>     mpol_rebind_nodemask
>     mpol_rebind_mm
>     cpuset_update_tasks_nodemask
>     cpuset_handle_hotplug
>     sched_cpu_deactivate
>     cpuhp_thread_fun
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
>
> Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Cc: stable@vger.kernel.org
> ---
>   kernel/cgroup/cpuset.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2649,7 +2649,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
>
>   		migrate = is_memory_migrate(cs);
>
> -		mpol_rebind_mm(mm, &cs->mems_allowed);
> +		mpol_rebind_mm(mm, &newmems);
>   		if (migrate)
>   			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
>   		else

Could you change it to &cs->effecitve_mems instead? For v2, 
effective_mems will never be empty.

In fact, this is part of the following patch

https://lore.kernel.org/lkml/20260604150229.414135-2-longman@redhat.com/

Given that this bug can crash the kernel, it should be separated out as 
a separate patch.

Cheers,
Longman


