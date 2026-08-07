Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1213C1D44
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 19:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786130026; cv=none; b=iawNH2IU0QXwqwR3VI/T+yz4l6RpNl3RWnfL6ymxBamPtJn+5VBZbpzql8AMUdVhQ0UmO0zIHIC2kRFOoi1GTK5pCmnSxbLoUAPOvmwh7Od576Q+IjNNIKDkdjgszhZSHYc+OzVNLkJUPSie8iNZVGM7WYnZ2exJQMvAhNduVHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786130026; c=relaxed/simple;
	bh=L/1HrdLPh7MtbveaAL6o+48cTzbGRCOAsDN5Ubn4UV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nKJgF1CRIfItapiZSRBOBrMuL7u5WEHEzIWbSH02IiN5/F5mubojVWILda/PSpvTbqWLaWonzKn8//Y6fvc0hW3qMCPB2IxcIVotZKxpHpFeS79JYjTiI7rhwKWkjIW2XFey8qUY6Z/JH0wwI/3E+N41GLpVGsVGKBvwbQw3ocM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S167rtf4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S167rtf4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786130024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sJYGVFI+AMYRJ/HMDjzVs+LLOKd26PLu0JdeojtQXvw=;
	b=S167rtf4n/IC2g9tU17DHzJvwl+M8D/B/xCUQkUkBztx0O+12s8jzzpe5QIABZTQLimCMQ
	UhAZ9mITmM+7iFA23kPVLuc9JzrjVnkgbSB5nStffcP3cL2xcTWHkRkDXMX8lKFDh0JMTU
	DLwl/A9ua3KWBoI/jgtLdbSNRneh8cE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-FONeiBgkO7i1sT07L_P4-Q-1; Fri,
 07 Aug 2026 15:13:29 -0400
X-MC-Unique: FONeiBgkO7i1sT07L_P4-Q-1
X-Mimecast-MFC-AGG-ID: FONeiBgkO7i1sT07L_P4-Q_1786130007
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F11E195608E;
	Fri,  7 Aug 2026 19:13:27 +0000 (UTC)
Received: from fedora (unknown [10.22.64.85])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58D84422;
	Fri,  7 Aug 2026 19:13:24 +0000 (UTC)
Date: Fri, 7 Aug 2026 15:13:22 -0400
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
Message-ID: <anYuUpgvsUGZcGMQ@fedora>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
 <anX8VgySSw5OR_Sb@fedora>
 <anYoLs1B0MwUNR2n@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anYoLs1B0MwUNR2n@tiehlicka>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On Fri, Aug 07, 2026 at 08:47:10PM +0200, Michal Hocko wrote:
> On Fri 07-08-26 11:40:06, Audra Mitchell wrote:
> > On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> > > On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> 
> Well, both global and memcg reclaim share the reclaim logic. Both of
> them try to exercise all reclaim priorities (i.e. check whole eligible
> LRU lists) and they fall back to OOM killer only if there is no other
> option left. For the global case should_reclaim_retry is the gate keeper
> around direct reclaim retries while for the memcg we have more or less
> fixed number of retries.

> From what you are describing above those users might be hitting reclaim trashing.
> I.e. last small portion of a reclaimable memory is bounced back and
> forth for the workload to make tiny but steady forward progress. While
> OOM killer might help to stop the suffering and restart the workload
> sooner I would generally recommend revisiting limits set for the
> particular workload. Especially if restarting it might lead to the same
> state sooner or later. Watching PSI metric would be a good start to see
> how the workload behaves wrt memory stalling. User space oom handlers
> might be a proper measure as well but that will always be safeguard
> rather than a solution.

Both of these recommendations were made to the end customer, with a
significant emphasis on reviewing the workload and the limits in place.

However, while reviewing the code, I was truly surprised to find retry
pathways in try_charge_memcg that do not decrement the counter, such as this:

        nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
                                                    gfp_mask, reclaim_options, NULL);
        psi_memstall_leave(&pflags);

        if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
                goto retry;

If the intent is to have a counter of nr_retries, I am genuinely surprised
we are comfortable not adhering to said counter. The patch is not meant to
change any heuristic, but only enforce a counter that is already in place.

I have no real dog in the fight of pushing this change to upstream, so if the
patch is not desired I will let this lie. Thank you for taking a look and
the dialouge. Happy Weekend!

