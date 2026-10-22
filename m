Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792674247;
	b=WL+y0EvDgC/cKkonR84MGda220PdZFPYXNZBp1sIQcCJV72cX44Dum6NkCOYqJvCbXJy
	 1JowCILqloKU+FUK16xuWYtA3b/UnIzlyRzrg5IUMPrBmogFgC9OFUslreZair5m8Cg9d
	 cN0WVeGWi6BOz/K3uA5AFIAPTsr72p7nvYdMJVxOfWt0B/0MNsKmDff78z/VQfpdf/594
	 kG7GGad4XRL5qh2Jhl9wGHMwXqBAX5TVS/Ox1Fljoke4+rtcMBEofsZbUEkXYZktf6ge0
	 1mKaUEA0/GiLuYWyOyiQvBB8qO6DDr8Rn7CO5jA+WEwRLDFh+1OZ1AwnEx1krqCY96A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792674247;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=7y93v34nNjGpeAmit7nOmT/wmjCisg/zzFDLGmDNwQs=;
	b=xhp0Ip34jbd95r9B0j8/XPsyLvwpLBZ1ARQxZVZ37MiLSBdddYyH/lDGa2i4Ge++R9z7
	 8DuM4c5xLoAdirdxIIJTOZKl/MTEIiv2sSGj2I2snWzma3ULAGtLsIpAOvhJ87o+EGxZu
	 tya1D6t6rUgLLXdENfuvfjbgF+QaxClQuN3f0c/kfgyEOEht/X9QUUuo2Vx148FNcw9sa
	 ONXXe0evIAVuQBsKhh+HlK8nSBQSPKz1i3tL6bu3r9YYM8zqiMxoXTy+QlOVMrIhUW9V0
	 f9oVBCxWNhk34T24hd5LzbLqJqOlxaE81kXIllXXk0AJSoezi5HGhCUTs0FlRGXateA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=B1TD9fsm;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742BA606A31D
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 13:04:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 742BA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=B1TD9fsm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792674245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7y93v34nNjGpeAmit7nOmT/wmjCisg/zzFDLGmDNwQs=;
	b=B1TD9fsmYQ5fDAL1HgaB0awmNjb703UB4YwXWc24ahefADDhwsMt5dqeLADrJzmT6kkvSl
	fuqcWHZEQrFfWanK8Q9KK090qd8BRWOBtOrcnvRYzcDijXbILlurtH0636qfq8cEkSUulQ
	/8DsEZ1o8b0v1jtdIo1hiGM6HsYP/P8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-Qlgwt_lIOQWWZ-US4fULtQ-1; Thu,
 22 Oct 2026 13:03:58 +0000
X-MC-Unique: Qlgwt_lIOQWWZ-US4fULtQ-1
X-Mimecast-MFC-AGG-ID: Qlgwt_lIOQWWZ-US4fULtQ_1792674233
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC0C41954235;
	Thu, 22 Oct 2026 13:03:52 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DD74F1956089;
	Thu, 22 Oct 2026 13:03:50 +0000 (UTC)
Message-ID: <b1c7acc8-1a6d-4395-9b5f-cd5635f05d7b@redhat.com>
Date: Thu, 22 Oct 2026 09:03:49 -0400
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: check effective mems for a movable-only
 configuration
To: "Gregory Price (Meta)" <gourry@gourry.net>, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 akpm@linux-foundation.org, feng.79.tang@gmail.com, mhocko@suse.com
References: <20261022043943.3125239-1-gourry@gourry.net>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261022043943.3125239-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 10/22/26 12:39 AM, Gregory Price (Meta) wrote:
> check_insane_mems_config() warns and enables cpusets_insane_config_key
> when a cpuset's tasks can allocate only from movable memory.
>
> In cgroup v2 the request may name a memoryless node, which has no zones
> and cpusets reports it as a movable-only nodemask.
>
> For example, with node 2 a CPU-only node:
>
>    # echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>    # mkdir /sys/fs/cgroup/test
>    # echo 2 > /sys/fs/cgroup/test/cpuset.mems
>    # cat /sys/fs/cgroup/test/cpuset.mems.effective
>      0-1
>    # dmesg
>      Unsupported (movable nodes only) cpuset configuration detected (nmask=2)!
>
> This is a bit confusing, especially consider mems.effective ends up with
> a valid nodemask by-design (cpuset.mems is treated as-if it were empty).
>
> Check each new effective mask in update_nodemasks_hier() instead, as the
> hotplug path already does. The allocator's bail-out tests the task's
> mems_allowed, which comes from the effective mask.
>
> A request naming a movable-only not present in the parent's nodemask
> no longer warns (since, again, the cpuset.mems gets overridden and
> treated as empty). However, it will warn if the parent's mems include
> the node later.
>
> For Example, with node 3 a movable-only node:
>
>    # echo 0 > /sys/fs/cgroup/test/cpuset.mems
>    # echo 3 > /sys/fs/cgroup/test/child/cpuset.mems
>    # cat /sys/fs/cgroup/test/child/cpuset.mems.effective
>      0
>    # dmesg
>      { empty }
>    # echo 0,3 > /sys/fs/cgroup/test/cpuset.mems
>    # cat /sys/fs/cgroup/test/child/cpuset.mems.effective
>      3
>    # dmesg
>      Unsupported (movable nodes only) cpuset configuration detected (nmask=3)!
>
> Fixes: 8ca1b5a49885 ("mm/page_alloc: detect allocation forbidden by cpuset and bail out early")
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>   kernel/cgroup/cpuset.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8ee239d5c6b48..70fbece1b9399 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2795,6 +2795,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
>   			continue;
>   		rcu_read_unlock();
>   
> +		check_insane_mems_config(new_mems);
> +
>   		spin_lock_irq(&callback_lock);
>   		cp->effective_mems = *new_mems;
>   		spin_unlock_irq(&callback_lock);
> @@ -2848,8 +2850,6 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
>   	if (retval < 0)
>   		return retval;
>   
> -	check_insane_mems_config(&trialcs->mems_allowed);
> -
>   	spin_lock_irq(&callback_lock);
>   	cs->mems_allowed = trialcs->mems_allowed;
>   	spin_unlock_irq(&callback_lock);
Reviewed-by: Waiman Long <longman@redhat.com>

