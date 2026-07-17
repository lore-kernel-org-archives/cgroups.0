Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FA52C15A0
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300826; cv=none; b=V2qHMgQwpYztIQ5B/RvmYrIRtVaUzBBzUcYnpKL8ejndjzrOfteya6GrQWf6N5GuRLY3Iy4xXzF/yD1zoN+2lSS+THJKGgRjh0hExv3wtf035PqEghm4gIG/dyjI4janRzx7yj2CXtbEc207Q5ML3zxqBHPi3NMPape8oLWiY78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300826; c=relaxed/simple;
	bh=UzXoQ54grOHBxJXqvSe20dnebBRBQrRVxlPMfN6zvdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sZ02siHpPWGylujqEoqiA2KaJ6d0zk5JJVx7n3O1xOid1kaOwldL0ifCCNF/t8C8V7vPV79hHsOZhfTXbL/F5uaH4/PlARqNzm2tGPSmt5F2CUu2Ieq6t2bil/JfQA+U8zTvAsvYSV/WW4vdJnsmIsKZzU+usY+Rcr7OeIw/aPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cetD3+RI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cetD3+RI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784300824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J51Fw8rU8N3jKV4+nr08wo0Mj4JR8dhWVcD01BFVxwA=;
	b=cetD3+RIQppQmDXElkUU3aBu+shqq5+k8weuHE/7+fwMKEByS+gxQvMtzAttmZStszlpRo
	JDisLxLlt+IVViCk40kglx0VVQpW61u3rvnxF+GPjtn/4IuIPLn/5zhmIHsAN+rbYxkWMA
	u0mHI3glg11TujIvs1xySsk0nP4WdmA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-L9jxO2hANjmfYFmmOGOa8w-1; Fri,
 17 Jul 2026 11:07:00 -0400
X-MC-Unique: L9jxO2hANjmfYFmmOGOa8w-1
X-Mimecast-MFC-AGG-ID: L9jxO2hANjmfYFmmOGOa8w_1784300817
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCBC7180074B;
	Fri, 17 Jul 2026 15:06:56 +0000 (UTC)
Received: from [10.22.81.98] (unknown [10.22.81.98])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF5911955D89;
	Fri, 17 Jul 2026 15:06:51 +0000 (UTC)
Message-ID: <d2bf022d-d30a-415e-8a96-4136258e347b@redhat.com>
Date: Fri, 17 Jul 2026 11:06:50 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the page
 allocator
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 7/15/26 7:03 AM, Brendan Jackman wrote:
> These comments describing the page allocator are out of date:
>
> - __alloc_pages() is no longer a public API and has no business being
>    described outside of mm/.
>
> - The `wait` variable is gone.
>
> It may be out of date for other reasons too but this patch is just
> fixing the issues that stood out.
>
> To fix it:
>
> - Instead of referring to a specific function, instead to "the page
>    allocator"
>
> - Completely drop out-of-date details of that function's internal
>    behaviour, since they were irrelevant anyway.
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Link: https://lore.kernel.org/all/DJP11T5V7BDW.2FZZZ8R6LOY4I@nvidia.com/
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>   kernel/cgroup/cpuset.c | 13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 24ea2d09cdbdb..dfd0f827e3b92 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4193,7 +4193,7 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
>    * nearest enclosing hardwalled ancestor cpuset.
>    *
>    * Scanning up parent cpusets requires callback_lock.  The
> - * __alloc_pages() routine only calls here with __GFP_HARDWALL bit
> + * page allocator only calls here with __GFP_HARDWALL bit
>    * _not_ set if it's a GFP_KERNEL allocation, and all nodes in the
>    * current tasks mems_allowed came up empty on the first pass over
>    * the zonelist.  So only GFP_KERNEL allocations, if all nodes in the
> @@ -4206,11 +4206,8 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
>    * come before the __GFP_HARDWALL check, otherwise a dying task
>    * would be blocked on the fast path.
>    *
> - * The second pass through get_page_from_freelist() doesn't even call
> - * here for GFP_ATOMIC calls.  For those calls, the __alloc_pages()
> - * variable 'wait' is not set, and the bit ALLOC_CPUSET is not set
> - * in alloc_flags.  That logic and the checks below have the combined
> - * affect that:
> + * The second pass through get_page_from_freelist() doesn't even call here for
> + * GFP_ATOMIC calls.  That, and the checks below have the combined affect that:
>    *	in_interrupt - any node ok (current task context irrelevant)
>    *	GFP_ATOMIC   - any node ok
>    *	tsk_is_oom_victim   - any node ok
> @@ -4327,8 +4324,8 @@ void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
>    * should not be possible for the following code to return an
>    * offline node.  But if it did, that would be ok, as this routine
>    * is not returning the node where the allocation must be, only
> - * the node where the search should start.  The zonelist passed to
> - * __alloc_pages() will include all nodes.  If the slab allocator
> + * the node where the search should start.  The zonelist used by
> + * the allocator will include all nodes.  If the slab allocator
>    * is passed an offline node, it will fall back to the local node.
>    * See kmem_cache_alloc_node().
>    */
Acked-by: Waiman Long <longman@redhat.com>

