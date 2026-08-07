Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8FA41F376
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786133256; cv=none; b=UlSzr3kW2YQhgmsFxegSRFqhMeXypDHcCQMSUVz8bkqRO4BhhggIu1FnoUOFsgG9d9NpDmBknGIYOj13AXmyitd3tE/cNuxzSwYULrDTnWaoGyYLXSr82jKFQ+E6LFAREfhBvQZM2iKl4fF36b1Ws+h7YTrr5y7G5QGc1nPZxHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786133256; c=relaxed/simple;
	bh=h+x6kpisysewhLc9kX8A2S5kwjryOVqBoH0OmWTWEFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlBE7Up7mv3p4/J0FN9458jv0jg1SJ9Dk4TuyN2UWUc5ywkGYHIl1kGyxgdw+/i8rqeCaYnESyZrK+Q4NvdyrQinafpdIm2AXV7C+ebksBE2KatMkDX8IPW6xWL9NQWKE6uPNGXSaBbRI+K/BzHq+oGE+pPaIUNcwTsyj5Ct6po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eNO6GHWm; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eNO6GHWm"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4955de8797cso26800345e9.3
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786133253; x=1786738053; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d/MJr6Oe7Mwi0NIRhRgjfbHGJr7/OP8f2gsXk/Z1AZs=;
        b=eNO6GHWmXCg/rfx/iGUK3ncE1Oi3XhNPMzlonDEFEK/5uVPe90/92vkprAQj///2Qc
         Rwe+LAuUlWmXf212EuFot5YDxybaN1gSwrd739Sp8z3Se9aYYs87hiB3x7OUUkO6gCDg
         XV/FenGEnrecvx/jFFOqZcjhkZ1pTbw8Blzp76q1JLmBON2f5chI8azTXxKYJindaVpA
         zm0c/3+boPjz/+a+EnKbZyFBI2Pq4f0dziDIvKgvrYPEQCTsEli3bNDBnP3ZWLpuEhDi
         47ow6m5gvuUg7/FXROkrorAT0i30vurlThteVD5oYHh6bsb2YeQ39RoihACwYFSfEYDO
         pXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786133253; x=1786738053;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d/MJr6Oe7Mwi0NIRhRgjfbHGJr7/OP8f2gsXk/Z1AZs=;
        b=LkQG1dhiDuc/hXJVw0mC/L8wWt9k1UPSAeEa5w/tSCVJ138YGzctf9qd0KH07uyW2b
         OMPa4taS7s3RQ3fDNzjS/Qsb3MaKugiXKfBe20DRxxiLsDYKTHMz+oTXTNHbPOl1Tw4B
         oyvr1vNWFFGWRsYA4aRNlUZm1lLVz1NJfsxFJQzNBmoSzus9yheyC7/LRyaWic6f1cBb
         AcQbg2b4+gddBCrhiPgifuTgHkb5VDQblvX9jdBtiwhGjVTaWRWNsw5IjzWQQejMDP1N
         AO54KJws02fXp50TW3Sdktzdp4pq08y+CCbw/Uil3wFVlbRbWy98Jcn/clRX9C6XxQ5u
         9MXg==
X-Forwarded-Encrypted: i=1; AHgh+Ro+6VwgAQsI/CQ3Xu8hUUR/gsv3bhwLCwbcTes0RIjQAMo0hTHcVcGieSsJBN7FNOpDspWDLgGt@vger.kernel.org
X-Gm-Message-State: AOJu0YzJkFej8VJfFgVl2gSlmgJVdvH+WPds9AZrO28DiJmKr40J2/Pr
	ArfisDEPPQEihf6boSo/MShpLyxCE9pf9bTG2PCFpa17mrrUf4ohx8u1kcgzPwufB7I=
X-Gm-Gg: AR+sD10O3g852DqMJ3PMUqNcCjQZTxrJZoAxbtkQqTlmQePKJC9uzjCloQiDiRm6qww
	6WxDQRX9jD6VmbfrhMW2hVQf+hNs/cFe7Bpw7lZ2VUvvEJ0ADW1zGXb1Blh/CraiyCVQbB9uDzb
	A4z4NocUxLySLHRY+fVyVCIhPSvJKSz4UbWK/AuWxKku+E1QfUUHPsP410soVanPPpK2udaTd6p
	4ncIQ39+1WJ2YhMjoLKlnXmwKj+glkStU5a53urVHYNyA2/l+LtdNf5JKrycKl0RoXWY3VnPYaF
	fhslLcz08fUaFB2dRVUAlmq1cDEJ0Fbi+fQa26DaBLFp8KBMQj8uTg1ZtHlnCn+cFoySJaiYshj
	iebr97PziZ65aovk109zyEjVO3f406MLV2Brvwbh6n2KVlR9PDViByrw2feZosKjY7k6n6JrFp1
	A7+cSrjUbnI52eJkRd57XztbnUuk/997vWBT1OfWG9Z92lATwkKtKqQD5u8480fxVnb1Ax22AVe
	UYLWA0KPtEE
X-Received: by 2002:a05:600c:b85:b0:496:c93d:e2f with SMTP id 5b1f17b1804b1-4995e0dff0amr84684845e9.15.1786133252699;
        Fri, 07 Aug 2026 13:07:32 -0700 (PDT)
Received: from localhost (109-81-83-166.rct.o2.cz. [109.81.83.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021fd392sm8251138f8f.31.2026.08.07.13.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:07:32 -0700 (PDT)
Date: Fri, 7 Aug 2026 22:07:30 +0200
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
Message-ID: <anY7AnkL1WktYbVW@tiehlicka>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
 <anX8VgySSw5OR_Sb@fedora>
 <anYoLs1B0MwUNR2n@tiehlicka>
 <anYuUpgvsUGZcGMQ@fedora>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anYuUpgvsUGZcGMQ@fedora>

On Fri 07-08-26 15:13:22, Audra Mitchell wrote:
> On Fri, Aug 07, 2026 at 08:47:10PM +0200, Michal Hocko wrote:
> > On Fri 07-08-26 11:40:06, Audra Mitchell wrote:
> > > On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> > > > On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> > 
> > Well, both global and memcg reclaim share the reclaim logic. Both of
> > them try to exercise all reclaim priorities (i.e. check whole eligible
> > LRU lists) and they fall back to OOM killer only if there is no other
> > option left. For the global case should_reclaim_retry is the gate keeper
> > around direct reclaim retries while for the memcg we have more or less
> > fixed number of retries.
> 
> > From what you are describing above those users might be hitting reclaim trashing.
> > I.e. last small portion of a reclaimable memory is bounced back and
> > forth for the workload to make tiny but steady forward progress. While
> > OOM killer might help to stop the suffering and restart the workload
> > sooner I would generally recommend revisiting limits set for the
> > particular workload. Especially if restarting it might lead to the same
> > state sooner or later. Watching PSI metric would be a good start to see
> > how the workload behaves wrt memory stalling. User space oom handlers
> > might be a proper measure as well but that will always be safeguard
> > rather than a solution.
> 
> Both of these recommendations were made to the end customer, with a
> significant emphasis on reviewing the workload and the limits in place.
> 
> However, while reviewing the code, I was truly surprised to find retry
> pathways in try_charge_memcg that do not decrement the counter, such as this:
> 
>         nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
>                                                     gfp_mask, reclaim_options, NULL);
>         psi_memstall_leave(&pflags);
> 
>         if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
>                 goto retry;
> 
> If the intent is to have a counter of nr_retries, I am genuinely surprised
> we are comfortable not adhering to said counter.

The said counter is conuting retries without any real progress.
Similarly to the global reclaim. If we get some margin here we are
making progress so we are not really OOM yet.

> The patch is not meant to
> change any heuristic, but only enforce a counter that is already in place.

It is very much chaning the heuristic ;) With your proposed change we
would be hitting OOM much more eaiser and often. Not something a lot of
user would appreciate.
-- 
Michal Hocko
SUSE Labs
