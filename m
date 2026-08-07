Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091953F4125
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117220; cv=none; b=QdERUhmxAfLeT3si4k+GTHLjKoiEUG8WjNHzNcXQN1UagNw2/xgPDs8TUsPOvWLMzNYOFS9elLBdboUzIjJDLwTccpTx5zkjYN5UY9w93oFdpwPZ9m+ZqMfW+jffvXxnfI91R1G5qfMD+uLuVO9i3yH0IR4eb7RTHHSrZck5nDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117220; c=relaxed/simple;
	bh=DJR59YwJ7Tt4ifeiZXi5mGPEdgDkauzx90EQHq5Vl0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cizrd/Qb/NlIS/1FOIm8SJ1wDMvdpwon4IysCmi+EA34rspmga5XgzJE2S06tC8Fp5+Zn3NpimDFU0MERrtkqiFfUE8EbT8oeGPtcYikKC22iRfX1aFewTuckIS19xt7z1I8p5NQQC28leSYZoHDb+WJK+oG8Kabdlr2kVYJdco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EEyLg4q8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EEyLg4q8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786117217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aAIv91ZG6RZhCUiLfO509k7HKcESuAJJr1DwOx37KRE=;
	b=EEyLg4q8C6Iuew6WWoYOJZle/849pFnbxuW7qkxd8kEn5fpVihQFImbrKyiZCyQHWCOrqP
	Rb2ODLvtwwYsRf2/JfAFvUQ4x3007h+KHNxJxOide20P76uVsOBLFg/oScKmDRREe7sWwE
	NCwE09n1rtiXrFrewvIQdZR9VAhDfzY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-aWJUy7s1PZ6g8wWe1wDoeg-1; Fri,
 07 Aug 2026 11:40:14 -0400
X-MC-Unique: aWJUy7s1PZ6g8wWe1wDoeg-1
X-Mimecast-MFC-AGG-ID: aWJUy7s1PZ6g8wWe1wDoeg_1786117213
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1F3C19560A6;
	Fri,  7 Aug 2026 15:40:11 +0000 (UTC)
Received: from fedora (unknown [10.22.64.85])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFA10195DF96;
	Fri,  7 Aug 2026 15:40:08 +0000 (UTC)
Date: Fri, 7 Aug 2026 11:40:06 -0400
From: Audra Mitchell <audra@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: david@kernel.org, jocolema@redhat.com, raquini@redhat.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anX8VgySSw5OR_Sb@fedora>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anWSHc04JJBJ1VbS@tiehlicka>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> > Originally nr_retries was actually nr_oom_retries and we used it to track (and
> > limit) the number of times we entered the mem_cgroup_oom path and then attempted
> > a retry. The purpose of nr_retries counter changed with the introduction of
> > 9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
> > charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
> > to retry within the desired nr_retries threshold. Later d977aa939fca
> > ("mm, memcg: unify reclaim retry limits with page allocator") changed the
> > nr_retries counter from 5 to 16.
> > 
> > As the function has evolved we now have multiple paths that have a goto retry
> > path and we have lost the original purpose of the nr_retries counter, allowing
> > us to take a goto retry path an unbounded number of times.
> > 
> > Fix the unbounded retries by nesting the code in a loop and decrementing the
> > nr_retries counter correctly.
> 
> Are you trying to fix a theoretical problem spotted by the code review
> or is there any actual problem that you are trying to fix?

We have had some customer complaints that performance has slowed to a crawl when
the cgroup memory limit has come close to the maximum limit. In those cases, we
have noticed that each process is spending a large amount of time in the direct
reclaim path acquiring just enough memory for their specific allocation, thus
by-passing the oom condition yet degrading the system's overall performance.
In the global case, direct reclaim is bounded by DEF_PRIORITY, however, a cgroup
will go through the try_charge_memcg path which will call
try_to_free_mem_cgroup_pages->do_try_to_free_pages each time it does a retry (16
times). If we bound the loop in try_charge_memcg, the worst case is 16*12 passes
attempting to reclaim. This patch is meant to address the unbound case, limiting
the loops to 16 attempts at following the direct reclaim path. An argument could
be made to reduce nr_retries as well, but given that the nr_retries has been set
to 16 for sometime, it seemed unlikely such a change would be considered.

