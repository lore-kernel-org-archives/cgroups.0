Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E8235A38C
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 20:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787775360; cv=none; b=ZWDHCsVvcWvMyXA039BzOpBZZeyJyFEePZ1SeeOuMSkybS+dznAUHzNqq+NdYPwxQHnLFKFGWA31AsEZYlO7RMxytT00jCJt4P+nyvmd+h96P18mV6XQhWLgDXi5AtTIDKCj35uGxJOvOMwLwA5ofOMbeVG0c8+lTnXqaYJVdC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787775360; c=relaxed/simple;
	bh=PW8N1IgTlrulZyKeLd423puC2qwQejHBLTHJOwUtobI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvMFDu84vDGPQlxR8T0C4FFTKACStFq9AYRpkW99nHgsxPV23gL8fKwcBTWmN042X4zy2VSnpH5EA9qT0G5SBWOSnO2iO6S98J5d1Gi0G5yfYEPI9E4YuTEQWImtbf9lt4PBr55B1SmSldgIFPI7x2lg8hnJ6uNp0gOwqeOJuHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JBCsWFhL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jGKLdrvd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JBCsWFhL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jGKLdrvd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787775357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5XOoAhfyz9xtKGJKuczZNY14PVIcWN7EMcbfAjCg3O0=;
	b=JBCsWFhL6FmBdPcALxH0wohjcZnNNLlqRdNBKvOgUAl6XqPonr7eUgiMcBr+HLf68wVw4V
	f7vOqNxPHZJO6NNqQqaYX97rpahkVDncWGxkPSUfTT0N8yvRO/3ql0EEPK1jMD/hiqnvCn
	wXgGcusjnetvN1jaVR7pwE6f6yBx6GQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-YambST9XMWmKIE8EtV2yLQ-1; Wed, 26 Aug 2026 16:15:56 -0400
X-MC-Unique: YambST9XMWmKIE8EtV2yLQ-1
X-Mimecast-MFC-AGG-ID: YambST9XMWmKIE8EtV2yLQ_1787775356
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-9368f2b7b2bso133909485a.0
        for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 13:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787775356; x=1788380156; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5XOoAhfyz9xtKGJKuczZNY14PVIcWN7EMcbfAjCg3O0=;
        b=jGKLdrvdS84sl5YO5wfp/iGYQua5fev9zMbo0s6pYSpp1q0ey8+aTe/gD6SASgTjG/
         M3WN8Jx3NxAoJJ+1392ipM/zyWcDNV0F66B6WFOVcpjtpPIgloFncqb2eZ0ot6My/VpC
         6zQAt45sus0ap3D9d+IyZbxRzavaRqODrMFjkDSvR4tyZUv6JjvW3JjkAZ39ssNrYD7W
         r7flFOb77UoLxolD1jrTJuroKuu5dSE8sCtq60rDKZSZoiDSJZzTJr5L+/AeSI/HleQY
         3Q/KZaeBu5w1OcTQRoguIbKa6dGm37NG+nnmiRsgPvKZAKl3CspIgbRAjJpUO2q9TrbT
         ouaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787775356; x=1788380156;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5XOoAhfyz9xtKGJKuczZNY14PVIcWN7EMcbfAjCg3O0=;
        b=A3ZCSWgN2C1bcpv1ljZmVN2E6QdFX2IUbnE8OPv81kptyzE6ZSg5CDYzzMZaDTHVvd
         ws8cKyMMFJtq3/snT0hU0j4Kxh9lllX2ruYvH417UxzqcKqdPbVX29fsscZ+u61vAmrF
         RcusYifZPrna6DM1ANv5TmTPzikY70Ul2IATYOM1/3Neu+ppQC8J/ZoEZ0ZjC/TS1iY+
         GhHIHLYfsGqr8EPJAhQqe095bj+GD7rqWmT7RzdNqpnrfFVK+deWfpJuGPApFQFSDrWq
         bpI2Hk0u5K8vlEx4tdoh2IuMKwzRoIEbE72s01+hbVpc7r9cl97vwuuidwDobVMID7j0
         hmQw==
X-Forwarded-Encrypted: i=1; AHgh+RpH9k/XEyv2fAKOYVir77yBnlght7hTxAmnilQ0E14OuKfkc5rO4Yats1/nRaE2EsB99l9H6b8w@vger.kernel.org
X-Gm-Message-State: AFuF++lvwUZTv/kHXGU+DmSbi5KXGlDQ8UU6+xbgdtcspyyFPzfyWmKt
	uBP7T5AcHRb9w1ELEJBDrPQUei1Z3MvEBTy4Sp6ARJpnxbmp1IbVrkv/D/85uLrgmzoP5E9fzxC
	dxR6gi7ljbGpIkurHO5ifLtYxr9fvPKX8/yjlIe//M//iDQ1A8TUPLE6yp7c=
X-Gm-Gg: AR+sD11MIRC2GEEmjVGj8YFtFhpjMQ4vGLEIx6HqDhvQu8WEy05mUJDjMv0JReTsCM1
	GdbCu99XEjtsbU2TsGGtzsJgeqAEbs1ud2O3Ym8Ht/V6qFLneUgsww1mFNkFm2hwt6gX6wXZcfM
	LaLWzMBmzWw5plqW6oSrh0WFMnJuu7GHFJwrumRIMjQ6u0hmGudc33NM5wZJ+rD1YzIT9pNszet
	BlLVuemNrVMQJd+MpNyR8ENYo1tljUVX2xcIKO/Klno8E+/zDssMH7NWfNcAFkcduHfk/992DN/
	y3Er4YZBCe54zmo+e2FE1gM+T1NVrEtxB2IiOE2l+myNPCd8CvZnQGkvvyDoCj9ksiFu2RqpXEY
	mwISsX13F4URq+FziFSP2316+XJBGq1TTxJljKNmezKG/
X-Received: by 2002:a05:620a:3bd0:b0:936:a407:98bb with SMTP id af79cd13be357-937800f72b0mr763365685a.9.1787775355588;
        Wed, 26 Aug 2026 13:15:55 -0700 (PDT)
X-Received: by 2002:a05:620a:3bd0:b0:936:a407:98bb with SMTP id af79cd13be357-937800f72b0mr763358185a.9.1787775355027;
        Wed, 26 Aug 2026 13:15:55 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e30ed19sm292126185a.8.2026.08.26.13.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 13:15:53 -0700 (PDT)
Date: Wed, 26 Aug 2026 16:15:52 -0400
From: Eric Chanudet <echanude@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao89rgCB4VhNt7n0@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <5970a8d4-fe7c-4dde-bdc8-1c66bfb57f12@kernel.org>
 <ao3CQicH0t-k95NA@tiehlicka>
 <ao3gLqsF4WSeKBIa@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <7e4e9662-d876-4493-a0b3-e31640937dd1@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e4e9662-d876-4493-a0b3-e31640937dd1@kernel.org>

On Wed, Aug 26, 2026 at 10:02:08AM +0200, David Hildenbrand (Arm) wrote:
> On 8/25/26 20:50, Eric Chanudet wrote:
> > On Tue, Aug 25, 2026 at 06:26:42PM +0200, Michal Hocko wrote:
> >> On Tue 25-08-26 17:45:56, David Hildenbrand wrote:
> >>>
> >>> How does this e.g., relate to hugetlb allocating from CMA, to then charge to a
> >>> hugetlb cgroup?
> >>>
> > 
> > AFAIU the system defines CMA areas to allocate hugepages from. For this
> > initial series, I failed to handle it. The intend was to consider it as
> > any other CMA area. It entirely missed that hugepages are already
> > accounted for by their controller (cgroupfs opt
> > memory_hugetlb_accounting) and they are charged when faulted in from
> > their available pool.
> > 
> >>> I always thought of CMA being a low-level allocation mechanism with various
> >>> different use cases, and actually the higher-level users should decide how
> >>> to/what to charge instead.
> >>
> >> Exactly. There are many different users of CMA all with different
> >> requirements. Then there is CMA reservations if an area is shared and
> >> the overall memory consumption. That is why I am really not able to
> >> wrap my head around this proposal.
> > 
> > It is nonetheless available almost directly to userspace via dmabuf
> > heap, or as a result of drivers ioctl providing a contiguous buffer, and
> > unaccounted for by existing controllers, with the exception of CMA
> > hugepages with memory_hugetlb_accounting.
> 
> No. The charging really only makes sense for selected mechanisms that built onto
> CMA.
> 
> It does not make any sense for subsystems that declare CMA for their own use only.
> 
> Like hugetlb. Or s390x's VMCP region. Or PPC KVM stuff. Or the crash kernel area.

I see. The crash-kernel does not use the CMA allocator it would not be
affected, VMCP or PPC KVM HPT use specific areas and do not have
userspace use AFAIU. They would default to the root cgroup that does not
get charged. Maybe it should instead be more like GFP_ACCOUNT, making
charging opt-in when the allocation happens on behalf of userspace?

From the other thread it doesn't seem like memcg is a good fit either.

> 
> -- 
> Cheers,
> 
> David
> 

-- 
Eric Chanudet

