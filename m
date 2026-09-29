Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5330B544897
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 18:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790705457; cv=none; b=hfVGJhyg6lr1jarUiki1k2EQTr9osvXNrBdKkXdxOiBi21crpu6Upr4xqALLQRv98ULbgjg203KSZ88Vp0NDI3jTm082ubm5daE7eKcjXG2363Y31DdNW3oDhzVY0LKqoDkuhmUR9etxUPnX3u3BVkgaEa7pSoLwYSC8bhZ8t9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790705457; c=relaxed/simple;
	bh=BdOWcAOOxnoZAaelqkv5+pHXFW+fXg7mSMHCiHIPqDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozFXxi3qQiRcXD4vN832l8riUR5MD97UdL4j+1OcjYgvRkT+gYHMkKfAV6SL7scqdep7JZ0+Xd6BozGwokErSPalxuN+EjrPc4aiNGAOtw1uSVtrkCX2Pzj3QTrBy/m45/VALj4OdU7pilSD4Z52+/JFKJ4mNZJFfwl1qYBda64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IF/6ZUq0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IF/6ZUq0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790705455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bOUYSKhcjhx0eLJz4L3uR/Jcsau7l05zABkw7uWvQuw=;
	b=IF/6ZUq0XrA/YBcMcFWa4NXwJOd2JAEjotTM+/4nsU7pPUDsRN4zBWuZFR+867IBqjVKU9
	9ppqu/QaI2DTnSxx8oSTsUh6BKMRKwSRITlWkQ/Mk4dNvaZ62t6sM4pZvRG5Is1h8P793U
	z8fuLOAW8Z8oBeYAOrytKJcPKPowpak=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-TZsAgQ6jOZmXFqN0l4Gbug-1; Tue,
 29 Sep 2026 14:10:47 -0400
X-MC-Unique: TZsAgQ6jOZmXFqN0l4Gbug-1
X-Mimecast-MFC-AGG-ID: TZsAgQ6jOZmXFqN0l4Gbug_1790705446
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF593196C409;
	Tue, 29 Sep 2026 18:10:44 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 06C421956089;
	Tue, 29 Sep 2026 18:10:40 +0000 (UTC)
Message-ID: <b8f66cbe-bb1e-4148-b2e2-55bd95f1c8d1@redhat.com>
Date: Tue, 29 Sep 2026 14:10:40 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] cgroup/cpuset: Protect is_in_v2_mode() in
 cpuset_num_cpus()
To: Andrea Righi <arighi@nvidia.com>, Peter Zijlstra <peterz@infradead.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
 Changwoo Min <changwoo@igalia.com>, Ridong Chen <ridong.chen@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, sched-ext@lists.linux.dev,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260929084124.626693-1-arighi@nvidia.com>
 <20260929084124.626693-2-arighi@nvidia.com>
 <20260929-making-language-254d9c6a6605@there>
 <af938567-01d2-4518-8f7e-974828e25d3e@redhat.com> <arv2-3-6-Ewv0gpb@gpd4>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <arv2-3-6-Ewv0gpb@gpd4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 9/29/26 1:35 PM, Andrea Righi wrote:
> Hi Michal and Waiman,
>
> On Tue, Sep 29, 2026 at 11:32:33AM -0400, Waiman Long wrote:
>> On 9/29/26 9:47 AM, Michal Koutný wrote:
>>> Hi.
>>>
>>> On Tue, Sep 29, 2026 at 10:37:38AM +0200, Andrea Righi <arighi@nvidia.com> wrote:
>>>> cpuset_num_cpus() enters its RCU read-side section only after checking
>>>> is_in_v2_mode(). When cpuset is bound to a v1 hierarchy, is_in_v2_mode()
>>>> dereferences cpuset_cgrp_subsys.root, which is freed via kfree_rcu()
>>>> once that hierarchy is destroyed and cpuset is rebound to the default
>>>> hierarchy. A preemptible caller outside RCU can therefore read the flags
>>>> of a freed root.
>>>>
>>>> The only current caller, fair's group share calculation, runs under the
>>>> rq lock with preemption disabled, so it can't hit this. However, the
>>>> helper already means to protect itself with RCU, and upcoming sched_ext
>>>> support exposes it to sleepable BPF programs.
>>>>
>>>> Take the RCU read lock before is_in_v2_mode() so that the whole lookup
>>>> is protected regardless of the caller's context.
>>> This feels like mere querying of the mode shouldn't require such
>>> constraints (despite it's needed anyway later down). But it could truly
>>> happen with the novel usage (CONFIG_CPUSET_V1 && unmounting cpuset
>>> hierarchy for some reason, I wonder how you noticed :)).
>>>
>>> Then I'd welcome more structured approach with at least:
>>>
>>> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
>>> index 3754d697854b3..7f4d346cfb119 100644
>>> --- a/include/linux/cgroup-defs.h
>>> +++ b/include/linux/cgroup-defs.h
>>> @@ -841,7 +841,7 @@ struct cgroup_subsys {
>>>           const char *legacy_name;
>>>
>>>           /* link to parent, protected by cgroup_lock() */
>>> -       struct cgroup_root *root;
>>> +       struct cgroup_root __rcu *root;
>>>
>>>           /* idr for css->id */
>>>           struct idr css_idr;
>>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>>> index 227d09704ca59..a718b5f521fb2 100644
>>> --- a/kernel/cgroup/cgroup.c
>>> +++ b/kernel/cgroup/cgroup.c
>>> @@ -1909,7 +1909,7 @@ int rebind_subsystems(struct cgroup_root *dst_root, u32 ss_mask)
>>>                   /* rebind */
>>>                   RCU_INIT_POINTER(scgrp->subsys[ssid], NULL);
>>>                   rcu_assign_pointer(dcgrp->subsys[ssid], css);
>>> -               ss->root = dst_root;
>>> +               rcu_assign_pointer(ss->root, dst_root);
>>>
>>>                   spin_lock_irq(&css_set_lock);
>>>                   css->cgroup = dcgrp;
>>>
>>>
>>> However, if I zoom out, I see that the intention of reading cpuset's
>>> nr_cpus from the scheduler is meant for setups where cpuset tree ~ cpu
>>> tree:
>>>
>>> | * This only really works for cgroup-v2 where all the controllers are mounted
>>> | * in the same hierarchy. If not cgroup-v2 or no cpuset controller is
>>> | * configured it reverts to num_online_cpus().
>>>
>>> Hence it may be just OK to do:
>>>
>>>           int nr = num_online_cpus();
>>>           struct cpuset *cs;
>>>
>>> -       if (is_in_v2_mode()) {
>>> +       if (cpuset_v2()) {
>>>                   guard(rcu)();
>>>                   cs = css_cs(cgroup_e_css(cgrp, &cpuset_cgrp_subsys));
>>>                   if (cs)
>>>
>>> I hope Waiman seconds this -- if a feature depends on shared tree,
>>> there's only so much that 'cpuset_v2_mode' can guarantee.
>> I think it is simpler to just change is_in_v2_mode() to cpuset_v2(). Almost
>> all the cpuset functions should either take the callback_lock with interrupt
>> disabled (which is a RCU read-side critical section) or with rcu_read_lock()
>> and cpuset_mutex() acquired. This cpuset_num_cpus() function is an
>> exception. Given what is said in the comment, this function is not supposed
>> to be used with v1 mounted. We should change it to cpuset_v2().
> The comment says that, outside cgroup v2, cpuset_num_cpus() falls back to
> num_online_cpus(). However, on v1 with cpu and cpuset mounted together using
> cpuset_v2_mode, it returns the group's effective cpuset count and fair.c uses
> that count in the default "concur" group share calculation and in "max" mode.
>
> So replacing is_in_v2_mode() with cpuset_v2() would change scheduler behavior
> for that setup. I guess we could either preserve the current behavior, fix the
> comment and protect the root lookup with RCU; or make the code follow the
> documented v2-only behavior. Which one would you prefer?

I will let Peter decide if he wants to support the cpuset_v2_mode mount 
option of cgroup v1 since he is the original author of 
cpuset_num_cpus(). If this is supported, we have to update the function 
comment as well.

Cheers,
Longman

>
> Thanks,
> -Andrea

