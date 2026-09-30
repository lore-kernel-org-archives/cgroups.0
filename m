Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE863C0A0C
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795028; cv=none; b=j2RRP/OrUp+q9xl4e14te7xVZeEvQy4YGWuuGXCKv0TlLxibQWWiwdln+KxeDhntnPMkKr0F6j9qSBu3xncvz7cLb8VqNEQdGlAUHFyuTshDu9b/SpdwyRWTcvrBmOxWeTWPcOlq+xVmlCHPTp0DZ55uN/oYjLpd1DKkRPtYytY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795028; c=relaxed/simple;
	bh=4+oie+eTfH4jo2XaFBzr53mKqHLBWRYbAnYHwX1qjgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hVl7N3Atbqb7f+oMHtrMuefQskT/VAbpkTZSC4y/axZgyiLm+yF1UmGmY7hCEPF7nbY9pOFb/PCbiHRxJUpr/AcyGsqhCA748rWRDYzophkpvG3p0TXIXbg3Kmo25IXlJCBVmjk1dktU1u8jeMOTRAQ7m+GudtBB5cwgXK8Dy20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XxOZS0eR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XxOZS0eR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790795026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XXomPzkAX9lYEuybyM3DBpwDXJ1S/KAjTHXLk9lllvI=;
	b=XxOZS0eRqQi6I5ZJNzK75GXhf8gL/7H/g7Vh55Uck9/GvF7lhbY9OjV0PgOYqMbkMRfMsE
	AjfUxIyqBBgCtmhQIJy5hw3gVHMs8++jQJGoV2lqz7E+j/aEhkdG2whHWw+egpMMf+FBe8
	oailgcEV59AyPavmyWKcBE1UAWT6URY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-NUf9f8fROdK4G8xkWV_LWw-1; Wed,
 30 Sep 2026 15:03:39 -0400
X-MC-Unique: NUf9f8fROdK4G8xkWV_LWw-1
X-Mimecast-MFC-AGG-ID: NUf9f8fROdK4G8xkWV_LWw_1790795018
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B77931944ABF;
	Wed, 30 Sep 2026 19:03:37 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 49AD7433;
	Wed, 30 Sep 2026 19:03:36 +0000 (UTC)
Message-ID: <b3a241b4-b769-41d4-988b-95b14e7db1f0@redhat.com>
Date: Wed, 30 Sep 2026 15:03:35 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: Don't access cpuset_cgrp_subsys.root in
 is_in_v2_mode()
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrea Righi <arighi@nvidia.com>
References: <20260930031833.660267-1-longman@redhat.com>
 <20260930-marlin-roaming-0be876825765@there>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260930-marlin-roaming-0be876825765@there>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 9/30/26 1:57 PM, Michal Koutný wrote:
> On Tue, Sep 29, 2026 at 11:18:33PM -0400, Waiman Long <longman@redhat.com> wrote:
>> After seeing the patch [1] to guard is_in_v2_mode() with RCU, it makes
>> me realize that is_in_v2_mode() may be called in a context where a new
>> cgroup filesystem is being rebound with stale cpuset_cgrp_subsys.root
>> pointer.
> add: which is a privileged operation.
>
>> Avoid this potential UaF situation by adding a new cpuset_v2_mode
>> flag which is set when the cpuset_v2_mode mount option is used. This
>> flag is written into only when cpuset_bind() is being called with a
>> stable cpuset_cgrp_subsys.root value. The is_in_v2_mode() helper is
>> modified to read the new cpuset_v2_mode flag instead of accessing
>> cpuset_cgrp_subsys.root directly.
> You write about "potential" situation. But are there any such callers
> (after the cpuset_v2() conversion in cpuset_num_cpus())?

Other than the cpuset_num_cpus(), is_in_v2_mode() should only be used 
with either cpuset_mutex or callback_lock held. Rebinding a cgroup 
subsystem is protected by holding cgroup_mutex. I am not aware of any 
situation where rebinding is happening while cpuset code is being called 
into, but I can't rule out that possibility. Also it is possible that 
future cpuset code extension may make it possible that this race 
condition can happen. For safety, it is better to make the code safe. 
That is the reason why I said it is a potential situation.


>
>> Fixes: b8d1b8ee93df ("cpuset: Allow v2 behavior in v1 cgroup")
> I'd even consider (pruning to)
> Fixes: d23b5c5777158 ("cgroup: Make operations on the cgroup root_list RCU safe")
>
> (Admittedly, is_in_v2_mode() wasn't always called under cgroup_mutex, but
> I'd argue (without comprehensive analysis) that predicate's callers were
> synchronized via cpuset_mutex in cpuset_bind() (and cgroup_mutex)
> anyways.)
>
> The caching you proposed looks safe. (I'm mainly writing because of the
> commit message wrt UaF.)

I said UaF because it is what Andrea patch is implying. As I said 
before, I don't think that can happen, but I can't rule it out.

Cheers,
Longman

>
> Michal

