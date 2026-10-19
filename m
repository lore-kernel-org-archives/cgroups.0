Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792421655;
	b=q/M23Gj8qslGp2z5wUrtE46aaV6ZSMi4DuMNRcIeBx71oUQHrsymuxEUli7Qd7kayDYk
	 tkCpzQvre3CI3YIaMMIntBG7Oc4d57qlIQjEyEVcI96jIrr1ZGz4MavUSw1st/LJdEkiW
	 3deWeRaxGH8y+MqS0PivW+68KCplHd/2mIFEU0x0VmsbUHlj8rFIggndFCSvJ7ZHj/Ua1
	 NPexw+33WPmgG9xMEeWLOJfN0SUrjHz9zyss7u0mMbDc/x6xQD1Sh+YHGCDNNpPHwQIfj
	 1L9VZqNStQpsMV9dIG/VlgskXYwrwVFbP0Du+Q+g0fvk3bFPkmjjV9PiRq1NAWKdV2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792421655;
	h=Received:DKIM-Signature:Received:X-MC-Unique:X-Mimecast-MFC-AGG-ID:
	 Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=LA9yLlWDsUw4mAlFrb8iNJ8Iy8siUyde3QGxANbXUgc=;
	b=n3362GSj2gNXOojL4haUoulSgMmwyWRKvQNWRIHzi4CxREu0RjomAaw6P4gkHj720QTd
	 PIsIVkICX9+R2hrNQBAGdSvDABQDfS4jh7rf6tNLlUclHxma3sJJRsea8OHfkyyNH4uQr
	 E9MK/k6PWhJTewJsVYRha9XwHgPEI3Cm6rKiT3b+Qz6+xi0voVh8a/X91SxRxh8W6qo/f
	 G8Zug0HD+d4pIgXtJ/8zqhRYdzuQ+wU6514itcqwh7VkgVQRqZYRxd4OrE5S9K7tJ9r1p
	 lKWbsQBz6jKaeS7QqmEr5Bjtrek5eRsJ1lmqI/yD3Sl5Z+kLCame5VxKy3FKWoLQorA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LbEJ8Mi3;
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
Received: from aws-us-west-2-korg-listserv-1.web.codeaurora.org (ip-10-30-226-211.us-west-2.compute.internal [10.30.226.211])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D4A5606DA4F
	for <cgroups.vger.kernel.org@localhost.mlmmj>; Mon, 19 Oct 2026 14:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LbEJ8Mi3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6621D2741A0
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 14:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421655; cv=none; b=Smr1m7agenApCFQveSnz6KyHJLWoo8FkNpnbHzqI5M+SXBBM9oO5m8dDbXKksiI8D//ORAgUdub9jCN3CKadeOKyx4DVM4MkWO7LYCjLHWlxUhLg7JJUdLBRnhfcMJxP3ErYKFboPA4FPJ+lO/am8svrAAi9SYZwSb+oYl8mAPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421655; c=relaxed/simple;
	bh=f/SGXW3zS8s9qfLrgBkvDJ+xdVjRbBYrPEPmubUH4Ko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KXijFKnFxPN0d37ix6DysO8ToZBBQ+YxO9VbRJPF/0cVynoLRwAJQo5k/g2Yak5mRMpVmg6KrRRO/tBUizMLQZ5q9SPQMicp4AoQswGGsoZ/lvh9V8DCJLlP7bG1SkuI6fLZRxkmsBx+3N5bejHT17AsQEiChfM7zIKyQfGbyq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LbEJ8Mi3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792421652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LA9yLlWDsUw4mAlFrb8iNJ8Iy8siUyde3QGxANbXUgc=;
	b=LbEJ8Mi37Vcqra9+Ww2qQBv2dh5uy8kUl9HHp/OJzEIgxGAXMs8IBkyweVxt66xQTEWSs/
	E6PA2ubZL7zCdAuaO81d0pEiPqW6ry8xbGQqEy25aEbdGElkEt4ZiARDjKrQiKhKs8CYyC
	b6eM1l5IlMvy0TLRzPOP4bq9p5oGQEE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-BFeS7YMuPXOJqu7Wckh88g-1; Mon,
 19 Oct 2026 14:54:00 +0000
X-MC-Unique: BFeS7YMuPXOJqu7Wckh88g-1
X-Mimecast-MFC-AGG-ID: BFeS7YMuPXOJqu7Wckh88g_1792421637
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9A5A195399B;
	Mon, 19 Oct 2026 14:53:46 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07778410;
	Mon, 19 Oct 2026 14:53:42 +0000 (UTC)
Message-ID: <1bae2a1a-e4fd-4f11-94e3-c9ff9b37a399@redhat.com>
Date: Mon, 19 Oct 2026 10:53:41 -0400
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
Subject: Re: [PATCH 2/2] cgroup/cpuset: use mems_allowed_seq when checking a
 policy nodemask
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, ziy@nvidia.com,
 david@kernel.org, mgorman@techsingularity.net
References: <20261014222456.2318284-1-gourry@gourry.net>
 <20261014222456.2318284-3-gourry@gourry.net>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261014222456.2318284-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 10/14/26 6:24 PM, Gregory Price (Meta) wrote:
> A cpuset update changes the task's mems_allowed and rebinds its
> mempolicy in separate steps under mems_allowed_seq, but the check
> reads both without it.  This can cause a spurious numa placement
> miss under some cpuset/mempolicy combinations.
>
> A reader that loads one mask before the update and the other after
> it can see a spurious empty intersection and drop the nodemask.
>
> For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the
> cpuset moves to mems={1,2}, the policy is rebound to {1}.
>
> The allocator can race and compare the old mems_allowed {0} against
> the new policy {1} - which will result in a dropped nodemask and a
> misplaced allocation on node 2.
>
> Simply retry the intersection until mems_allowed_seq is stable.
>
> This covers the task policy, which is rebound under mems_allowed_seq.
> VMA policies are rebound afterwards by mpol_rebind_mm(), outside
> mems_allowed_seq, and are not covered by this change.
>
> Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>   kernel/cgroup/cpuset.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3f52717c19654..8ee239d5c6b48 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4354,10 +4354,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
>    * @nodemask: the nodemask to be checked
>    *
>    * Are any of the nodes in the nodemask allowed in current->mems_allowed?
> + *
> + * A cpuset update rebinds the task's mempolicy and changes mems_allowed in
> + * separate steps, so retry if an update raced with the check.
>    */
>   int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
>   {
> -	return nodes_intersects(*nodemask, current->mems_allowed);
> +	unsigned int seq;
> +	int ret;
> +
> +	do {
> +		seq = read_mems_allowed_begin();
> +		ret = nodes_intersects(*nodemask, current->mems_allowed);
> +	} while (read_mems_allowed_retry(seq));
> +
> +	return ret;
>   }
>   
>   /*
Reviewed-by: Waiman Long <longman@redhat.com>

