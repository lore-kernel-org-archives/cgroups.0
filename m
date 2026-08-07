Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086DC19AD90
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 18:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786128435; cv=none; b=RO0WpkQRC8x1GtityqAhO26DJOxyOIRLdSehqYckLvonJOcw5rLJImtWMAsZt4Qaz/9ir6XMopMOqQvEtIJKGkzYNUXqNFgNy2xVKXUf4Upg+FI054elG/cd9gQH5GFUPgA0260BzrNRMrUdp1qWHG4kn+vVrCJmtP8G3VT2UKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786128435; c=relaxed/simple;
	bh=Q3zMfs0oIZooCkzovlm+2MhqgPkDKvI82bjRYdher3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tO+FRsvwLT80tGzb84mBdFZl/CQ+B8hFUL9jCA3CjzySC48foGZ1FPN+IaQQHMTwfiMhJAStkYSe1OqW8FsMWZ4fhHf36C/dJJVk86wevWadsRffqDYekBKkARGyQwNm5g9CJdqCd1DFTbVjpAs5gIUoRGvJIbkrkAB6c7HDhjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QpEvBbFA; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QpEvBbFA"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47f96c5b722so2346906f8f.0
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 11:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786128432; x=1786733232; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hHkc9rDqUe2P8JaMcDwcL4akwJKzjI4/vsUwMy8sChA=;
        b=QpEvBbFAOSPzBoKn3NBAMUWZhwRCYtzvIRhRGUyJr56UhKzLwsX17ob8qJl0dYh3nE
         6CajnKRMUF9Ol8aFSKbWWYV6GUp0XJsd/aSrJlmRYPCdzgPjzqXn//S/2duTYKDKZv7E
         6P6MSK/aIKJWbmzhIktJzkrhGzLtNNljF2XuEgeZ5RtWxdtu6QUlpZkq+RSxB49d5oiJ
         Dzo9rJD9FzoodyFAeFdIluNwhK3whwrXZ+VgfV6d0cSNDdKbHGBaQ/cxF7gQpuoNNWaG
         o2vdDEVOcF6imKbW1eAu+Yg+s+e8TryqjpxROpOyhqcdXfSXfgEwGZ/ipE3g9ZSWqpbc
         3BVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786128432; x=1786733232;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hHkc9rDqUe2P8JaMcDwcL4akwJKzjI4/vsUwMy8sChA=;
        b=On+LAGRffsjDTTCWEtANT5ePMmBIPo1hz/YSOx9H93gyvioTYng3jF+U/S9Wiqx0d8
         CQptL1nn+kd6431Prk7GKlR8300+XM+dJGhe42ARSQocjyewBWhkmM3Kck5K5nzLu4eu
         6RAgLgknFKOAGjk1kdArqoboeIUPdoPoqbX+wFoY5eseGgZHtL0nBRTKUOFzS/qrp1n2
         ehWrWHBEcTIU4kktrt9T7JINpBRtU9ZVVLVzk1Ysv5VftHyMcIwVAiK8oXGuLxuybusH
         l3jQG5oub/Yk0fpk4PYvtoryqfH0K4Ir2JAMbi7ZU1Pawpq5BqfqY/A0EvfHXYGbpqJo
         SIUQ==
X-Forwarded-Encrypted: i=1; AHgh+RrbZOD6ABRfn++msBl7nIrgGRQFallBXDpHnn0SDAN1iwGG91zDcbyEhytovUNk+9aLozWFCmhZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2rvQzlZXnV+XgxAZGvapPTBr9kRqqanEYIsqFUGPJAeAmxs5p
	7Pgm62hvUvxl0eSyLO2guknIfhqAvwbQGgDqbVbvL/dXn91qW3ls+h6Kg+LQE4Sbk1Q=
X-Gm-Gg: AR+sD11f68JRZtYPYismG1220Gw/RIObYUC/o3CH3P5x3+SziHzE4tccMStnwH92x22
	EWgdN9CbRJ8FAE7EnU7sRUZm5WgTAFGHIHUkD4NusmWRzP6fHUA3yyHoCB8tmQXAHV6Ek1tkxYC
	rt9WUM+QSz2aqAxb0yjVbrzDEUONYCBfs6ujRb5C6YO47JlNzTYrpPSkCIN/rs+46wxOdgbdwhP
	9zYQJafocRlSYcYYjZXLcTl9ysFVqt6NNg2rkVqXNfnqPkNBGy5P8QmMEj5D9HOtJV4O5Nkcom5
	SzP2QYG3MExhnGa45/0TxFRr9MOMm0+1UuAClwlmBMCyDoLludytzIdQTIM7M+MPGSoP0oGTLmZ
	x/+nr35HoyLqpRCO4b4HnmNBz18gBVljB3JWBFhOA8xV25DD7Gsxbkd7Vppql8V+68mbu39t14Y
	ldyh8gCi8GupaLeA5v/YtMqOFUdj3ae48LYUusJPgqACq67G3rR1zYFgqOsGc8mnxsZmsF0gP87
	g==
X-Received: by 2002:a05:6000:2997:10b0:47f:7b75:9dfe with SMTP id ffacd0b85a97d-47fec4f5f96mr31634247f8f.8.1786128432412;
        Fri, 07 Aug 2026 11:47:12 -0700 (PDT)
Received: from localhost (109-81-83-166.rct.o2.cz. [109.81.83.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021e8cd0sm8254153f8f.17.2026.08.07.11.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 11:47:12 -0700 (PDT)
Date: Fri, 7 Aug 2026 20:47:10 +0200
From: Michal Hocko <mhocko@suse.com>
To: Audra Mitchell <audra@redhat.com>
Cc: david@kernel.org, jocolema@redhat.com, raquini@redhat.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anYoLs1B0MwUNR2n@tiehlicka>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
 <anX8VgySSw5OR_Sb@fedora>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anX8VgySSw5OR_Sb@fedora>

On Fri 07-08-26 11:40:06, Audra Mitchell wrote:
> On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> > On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> > > Originally nr_retries was actually nr_oom_retries and we used it to track (and
> > > limit) the number of times we entered the mem_cgroup_oom path and then attempted
> > > a retry. The purpose of nr_retries counter changed with the introduction of
> > > 9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
> > > charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
> > > to retry within the desired nr_retries threshold. Later d977aa939fca
> > > ("mm, memcg: unify reclaim retry limits with page allocator") changed the
> > > nr_retries counter from 5 to 16.
> > > 
> > > As the function has evolved we now have multiple paths that have a goto retry
> > > path and we have lost the original purpose of the nr_retries counter, allowing
> > > us to take a goto retry path an unbounded number of times.
> > > 
> > > Fix the unbounded retries by nesting the code in a loop and decrementing the
> > > nr_retries counter correctly.
> > 
> > Are you trying to fix a theoretical problem spotted by the code review
> > or is there any actual problem that you are trying to fix?
> 
> We have had some customer complaints that performance has slowed to a crawl when
> the cgroup memory limit has come close to the maximum limit. In those cases, we
> have noticed that each process is spending a large amount of time in the direct
> reclaim path acquiring just enough memory for their specific allocation, thus
> by-passing the oom condition yet degrading the system's overall performance.

Yes, this is entirely possible scenario.

> In the global case, direct reclaim is bounded by DEF_PRIORITY,

Well, both global and memcg reclaim share the reclaim logic. Both of
them try to exercise all reclaim priorities (i.e. check whole eligible
LRU lists) and they fall back to OOM killer only if there is no other
option left. For the global case should_reclaim_retry is the gate keeper
around direct reclaim retries while for the memcg we have more or less
fixed number of retries.

> however, a cgroup
> will go through the try_charge_memcg path which will call
> try_to_free_mem_cgroup_pages->do_try_to_free_pages each time it does a retry (16
> times).

> If we bound the loop in try_charge_memcg, the worst case is 16*12 passes
> attempting to reclaim. This patch is meant to address the unbound case, limiting
> the loops to 16 attempts at following the direct reclaim path. An argument could
> be made to reduce nr_retries as well, but given that the nr_retries has been set
> to 16 for sometime, it seemed unlikely such a change would be considered.

As Shakeel said in other reply, this is a deliberate implementation
decision. The OOM killer is the very last resort and we are giving
chance to userspace to handle close to OOM situation much more
gracefully and also workload aware. Keep in mind that what might be seen
as a slow progress for one workload might be acceptable for others where
OOM killer could mean a lot of work being lost.

From what you are describing above those users might be hitting reclaim trashing.
I.e. last small portion of a reclaimable memory is bounced back and
forth for the workload to make tiny but steady forward progress. While
OOM killer might help to stop the suffering and restart the workload
sooner I would generally recommend revisiting limits set for the
particular workload. Especially if restarting it might lead to the same
state sooner or later. Watching PSI metric would be a good start to see
how the workload behaves wrt memory stalling. User space oom handlers
might be a proper measure as well but that will always be safeguard
rather than a solution.
-- 
Michal Hocko
SUSE Labs
