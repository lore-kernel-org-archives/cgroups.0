Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793296885;
	b=cwIRXxL9gwcfmb0zZTgQ/+K/pI3KjhBQqYGsIzUTw1p9oTiXj8XsEWlLaPFwBqbNwdKk
	 QvYDpn1VWBvGjmZUTRJZj/9roKfF0udBbUSf0O+dpGhlb6mAjugkPdWRTk2HhZGVR++Gx
	 J7SS9X6HwgBFytjdy8lUPQCz8A2GLaCUYeO+dFo2ADb9NXox5a8qj+1dW+9+rVulepers
	 zKCYN0GcshbB67UY5FXAJ29Q6CVgDHJhF5gxhPmckf/WkCxL2LG+p2r9InOscWOgh1wpn
	 mgHmkuMJEHhcGQtbhSfWIyHJ6bPS+A6itWuDlLDDai50D30wN/WuGR1vypDb07Ztodw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793296885;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=vDJylRa+BEz9FX1boW3lxDX7Nctsiexo7u0jpFX8B3Q=;
	b=KJzm0E5dQXsnrJsyPBpV2PtyE4Yj8Zw0+w1aLlRDVaCwVrn4TwDugLfPvoNIz8TnpZaP
	 TeYJNI+P46dcUDBVzOyauXMleV+wIK/F/2Wwx/C8Qh1KuAfDgBDy8kR1sFFzG4uelUOhe
	 uwFgKF+xWIN/yD7whBMK5pmfgJQheV3E4+wKlZKvAGiGX/E/ulo2Qi7xHvcjfNZB/qUgD
	 /i/xkHhMjlQiqJgD1zxSeqTaD5HR9NgKjPy9AYBZCANt/pXTNoNoNVKbvVlLEJtg8AtYE
	 2OVJRrUrTMtb0vQH1rc7JdDYY4FX99F8liLfw3M6J11Q/voYoO1LkuF506VsK93vH1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HoEdUSKt;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F09F606A31C
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 18:01:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F09F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HoEdUSKt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793296884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vDJylRa+BEz9FX1boW3lxDX7Nctsiexo7u0jpFX8B3Q=;
	b=HoEdUSKtxZUllxFMblTf8EqB2tyVH6zPelBNj1VaZWeh5+ubCWekbMrV70ztCMIg1aXGQ3
	uozheHPn7Tyh0a61v+9FIQIEUS3oPX6QYOECP6z4mh8JvVoWhpzNH9R46GHFzNPKamvdaw
	v4/QA4Mzs4qvBi72ggqPO8BOdLSD6l4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-hJ2iShZ8ODyePXj78tYXHg-1; Thu,
 29 Oct 2026 14:01:20 -0400
X-MC-Unique: hJ2iShZ8ODyePXj78tYXHg-1
X-Mimecast-MFC-AGG-ID: hJ2iShZ8ODyePXj78tYXHg_1793296878
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A51E1805A17;
	Thu, 29 Oct 2026 18:01:18 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A86B318001CA;
	Thu, 29 Oct 2026 18:01:15 +0000 (UTC)
Message-ID: <4d9a1530-6212-4952-addb-fbd6299f0c4b@redhat.com>
Date: Thu, 29 Oct 2026 14:01:14 -0400
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
Subject: Re: [PATCH] cgroup/cpuset: Fix missing effective_xcpus accounting of
 child partitions
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261027123837.100909-1-guopeng.zhang@linux.dev>
 <c00f13e5-d048-4d5d-98ea-984ea7ebc13b@redhat.com>
 <ed6fecb4-38e9-4a73-8c1a-7bdd80175a69@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <ed6fecb4-38e9-4a73-8c1a-7bdd80175a69@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 10/28/26 9:52 PM, Guopeng Zhang wrote:
>
> 在 2026/10/28 23:30, Waiman Long 写道:
>> On 10/27/26 8:38 AM, Guopeng Zhang wrote:
>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>
>>> When a partition root expands its exclusive CPUs, a valid child
>>> partition will be able to claim more CPUs from its parent. As
>>> update_cpumasks_hier() always updates a cpuset before its descendants,
>>> the parent has already been committed when the child partition is
>>> reached. Its effective_cpus is computed with the child's old
>>> effective_xcpus subtracted and no further adjustment is made
>>> after the child commits its new effective_xcpus.
>>>
>>> The additional CPUs are thus granted to both the parent and the child
>>> partitions. generate_sched_domains() then emits the warning below
>>> about the overlapping sched domains:
>>>
>>>     WARNING: kernel/cgroup/cpuset.c:919 at rebuild_sched_domains_locked+0x1ec/0x2e0, CPU#21: bash/1225
>>>
>>> Fix that by taking the CPUs newly added to a valid child partition
>>> away from its parent at the commit point of update_cpumasks_hier()
>>> right before the new effective_xcpus is committed. The tasks in the
>>> parent cpuset as well as its other children will be updated if its
>>> effective_cpus is changed.
>>>
>>> A new test case is added to test_cpuset_prs.sh to test this patch.
>>>
>>> Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> Thanks for reporting this bug. Yes, the current code doesn't handle expansion of parent effective_xcpus correctly. I would prefer to handle it inside update_parent_effective_cpumask() and try to minimize partition related changes in update_cpumasks_hier(). I have posted an alternative patch for your review. Let me know how you think about it.
>>
> Thanks for the alternative patch.
>
> Well, I am still learning how you approach this whole series of
> problems.
>
> One more thing I found yesterday: neither the current code nor my
> patch runs the housekeeping check when a valid child partition gains
> CPUs from its parent, e.g. when its parent expands the exclusive
> CPUs. With nohz_full, an isolated child partition can take over the
> last housekeeping CPU. I verified this on a nohz_full=1-7 boot.

This is a problem reported by sashiko as well. I am going to send 
additional patch to address this as well.

Cheers,
Longman

>
> I handled it roughly like the diff below. Please take a look and see
> if it is worth handling together in this series.
>
> @@ -2142,12 +2142,28 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   				deleting = !cpumask_empty(tmp->delmask);
>   			else
>   				part_error = PERR_NOTEXCL;
> +		} else if (cpumask_andnot(tmp->addmask, tmp->delmask,
> +					  cs->effective_xcpus) &&
> +			   prstate_housekeeping_conflict(cs->partition_root_state,
> +							parent_prs,
> +							tmp->delmask, NULL)) {
> +			/*
> +			 * A valid partition may be able to claim more CPUs
> +			 * from its parent, e.g. when its parent expands the
> +			 * exclusive CPUs. The newly computed effective xcpus
> +			 * may not have been housekeeping checked before.
> +			 */
> +			part_error = PERR_HKEEPING;
> +			adding = cpumask_and(tmp->addmask,
> +				       cs->effective_xcpus,
> +				       parent->effective_xcpus);
>   		}
>
> I have something urgent at hand today, so I will get to your patch a
> bit later and run it through the test cases I have, including the
> isolated_cpus accounting case I mentioned in my previous reply.
>

