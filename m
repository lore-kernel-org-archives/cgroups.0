Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793388585;
	b=Btxj+w+OJQo5hYsm8XsTMV0QWw8Gy2MiaGGKOAooh3j+as6ySxwppGH8csWYF1ctz4oA
	 hpUBDH4a3WZceQJGfURunj8xdX0YBtAdeGf+9HHagY8Xg9XqU0uybc1261+wz73L3svSb
	 7GbrHKnkUwy7avqFS95TIrYtzY+d5QhfzoP9QjXmz0V5vbMYa6rP1agNJliiXhxAJ+VXm
	 jNjx/Jput9nuyqXOHTyuJbrGHgFnDG3XznONkaLAb2MMV6VlRH3AShsXpYr/kA5EhNEDD
	 PwaTvyGUOwnbgiDm4G1OFdNlHv8+44hdyCMOZnaa3Ubv7GhMxULd10CcuxsGOxSvCcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793388585;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=UvfT6hSAyzO93qIIEMJt3Vvo8yCu/1uMWsPhY4ae/gE=;
	b=v3PPGdaJgmW7zu8zD1zrjAAWnaGax9XccUyJZjy33krhXzO4hAILliaJ1OBqygoU3Sow
	 LpQoELPGUP93OJEvjcgzmmRNL45MjG5II2K1nmdfG78CkAXbT79b8KRjpqiO3wl55f1AS
	 tIzFV4wqBmLvqYeaMMxhFfJ2eKnPCiSqRWXALE520MncIVhj4v2bOjMFxnSvecO2Kjxm1
	 uMqh8iDh9liCfR9ZElYh0eOx9P6Du6ArUNICRd+/HEfW4gfVbilmXNy48ax1K370T8HII
	 JWE0WXJpxy/ApNiW3ikagdcqC3D4kPhDI+FoV80CMxW7nZPvyMzFMlbMwdMAjRDOHLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Pi0R+BkQ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D558606A31A
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 19:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D558606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Pi0R+BkQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793388584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UvfT6hSAyzO93qIIEMJt3Vvo8yCu/1uMWsPhY4ae/gE=;
	b=Pi0R+BkQUJ5eFyXnQdCM0eZNDJOL2i6byzuHgboYpIYoxDcTrtB9FBFuHg6l7O72jlvOKW
	ghXnUssRrPkJmZ9VsQTW4nV/eIZncDPSM2wkJ4DOEZFVSxGPJBTJNaV1sJD6JZirXZikPe
	nSvNbPTOuA6JI0G6NzrFcCKF32daigg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-152-VlHsgRidPJ2jzKQ_VNfY_A-1; Fri,
 30 Oct 2026 15:29:38 -0400
X-MC-Unique: VlHsgRidPJ2jzKQ_VNfY_A-1
X-Mimecast-MFC-AGG-ID: VlHsgRidPJ2jzKQ_VNfY_A_1793388577
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5C7E195422B;
	Fri, 30 Oct 2026 19:29:36 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A43093000B7A;
	Fri, 30 Oct 2026 19:29:35 +0000 (UTC)
Message-ID: <6904bcf6-6a6a-46fe-83f3-09880d45873f@redhat.com>
Date: Fri, 30 Oct 2026 15:29:34 -0400
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
Subject: Re: [PATCH] cgroup/cpuset: Drop redundant no-cpu check in
 partcmd_update with newmask
To: Shaojie Sun <sunshaojie@kylinos.cn>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261030131408.1054507-1-sunshaojie@kylinos.cn>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261030131408.1054507-1-sunshaojie@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 10/30/26 9:14 AM, Shaojie Sun wrote:
> update_parent_effective_cpumask() with a non-NULL newmask is only ever
> reached from partition_cpus_change(), and only after validate_partition()
> has checked the very same condition with the very same arguments:
>
>    tasks_nocpu_error(parent_cs(cs), cs, trialcs->effective_xcpus)
>
> since newmask is exactly trialcs->effective_xcpus and both functions use
> parent_cs(cs) as the parent. cs, parent and cpu_active_mask cannot change
> in between either, as cpuset_mutex and cpu_read_lock are held for the
> whole operation. Hence
>
>    nocpu = tasks_nocpu_error(parent, cs, newmask);
>
> is always false here and the block that turns a "nocpu" condition into
> PERR_NOCPUS is dead code. A new CPU list that would drain the parent is
> fully handled by validate_partition(), which routes the write to
> partcmd_invalidate and hands the partition's CPUs back to the parent.
>
> The "!adding || !cpumask_intersects(addmask, cpu_active_mask)" test that
> guards the block does not change this: the block can only be entered when
> nocpu is true, and that never happens here.
>
> Drop the redundant check and the dead PERR_NOCPUS block, and leave a
> comment pointing at where the "parent could be drained" case is handled.
> The empty-newmask check in the same branch is left alone: it validates
> the newmask argument of this function, while what is removed here is a
> decision that belongs to validate_partition().
>
> No functional change.
>
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 20 +++++---------------
>   1 file changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3219f927c35e..c7b3a734cda8 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2016,9 +2016,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   			goto write_error;
>   		}
>   
> -		/* Check newmask whether cpus are available for parent/cs */
> -		nocpu = tasks_nocpu_error(parent, cs, newmask);
> -
>   		/*
>   		 * partcmd_update with newmask:
>   		 *
> @@ -2033,6 +2030,11 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   		 * For invalid partition:
>   		 *   delmask = newmask & parent->effective_xcpus
>   		 *   The partition may become valid soon.
> +		 *
> +		 * Note that the no-cpu check is not repeated here:
> +		 * validate_partition() has already evaluated
> +		 * tasks_nocpu_error() with this very mask, and a failing
> +		 * write is routed to partcmd_invalidate instead.
>   		 */
>   		if (is_partition_invalid(cs)) {
>   			adding = false;
> @@ -2056,18 +2058,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   			cpumask_and(tmp->new_cpus, tmp->delmask, cpu_active_mask);
>   			WARN_ON_ONCE(!cpumask_subset(tmp->new_cpus, parent->effective_cpus));
>   		}
> -
> -		/*
> -		 * Make partition invalid if parent's effective_cpus could
> -		 * become empty and there are tasks in the parent.
> -		 */
> -		if (nocpu && (!adding ||
> -		    !cpumask_intersects(tmp->addmask, cpu_active_mask))) {
> -			part_error = PERR_NOCPUS;
> -			deleting = false;
> -			adding = cpumask_and(tmp->addmask,
> -					     cs->effective_xcpus, parent->effective_xcpus);
> -		}
>   	} else {
>   		/*
>   		 * partcmd_update w/o newmask

LKTM

Reviewed-by: Waiman Long <longman@redhat.com>

