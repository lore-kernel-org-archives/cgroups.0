Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B77944237B
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 14:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787839405; cv=none; b=O50laL6wwt8RM38EZaZi+nE1lnrp3gAs5U2CyFlfWbGfT4at0H93GNEyI0tu/6Tr+agR4IYQTAGvuMykV+Cac/7sMY9I4Lz/7WxhrVRv8i6f6htlQZdYn4aOkmWEwP/FnDZQuSAMamvmLXribI8C41yxbyD5eY8RSlcMNCye3aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787839405; c=relaxed/simple;
	bh=GxgWL05/rarsl7qmMHY1BfRfDlahGl4tISwa4ALF/BI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WdfZlT8LPZ3tO9VnOCb5g6IBCDTbQAMjhForjY9iHJKTg2r1yjhV2aR294JoIz37uVfGZDYGjYxT65cz1jDcQQtWn/dXWI963ukxTWoShxpm7rU2QOp+oQQl+OE6B4Gq60onvSFL0qX6gV+3PEk9UbA6UwJ5S47oDojh51+ymDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fr8zB410; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fr8zB410"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-482e2fdf5abso993270f8f.2
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 07:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787839395; x=1788444195; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ALN+Th3VygsiiqX2bmJC+etz4YolkrPm7RtMfzNo3Zc=;
        b=fr8zB410KWJECu7jlCjEEPe3kLGxHn0v63QkGXDA3NcRKF0/Y9cA71CUoKKJ6QwqQJ
         wAPacttxGsWkRYubH4Xs0HuwuHR51/L5mmdgu0MT5gO110BsH/9DU+CG481RRkS9FgdO
         CjZU+F0poCi8weHK+JqqhcPjmRK3arqhFYt23zIkm9ZKTnyWC8SL9l7JvBWBn86cyxRR
         n4srMPGCEV9mpR9cf3TXIUNlBcSWH2xdyRyW09LCBGuZu2vmjA15OPBhIBVCFgMHPQhT
         xR5oVt+Hm3ddtHzPmGCPyp1DzP/Jbgw01q/N3M0jfHA8SDKnQ3K3rbJWF2eL+63UfZKK
         1fUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787839395; x=1788444195;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ALN+Th3VygsiiqX2bmJC+etz4YolkrPm7RtMfzNo3Zc=;
        b=lRBKLbrKoFwNDMz8szDrKwU5Qh2uonfY5pka2q3hjywVNNmgpbfMuuprcW724et2UZ
         pTiMsi9om0gZJMnOioU4OOkEzcrtRAie7FNLXeIEqnRYla85aTPYXhlxRSeGLMuyq0pV
         xopkolD+YS5+P7aU1Yry6vaJ/CsPfZde9FYfIDBnlZH4o27DNsYE4YAAe9YNkKMhcPvm
         l3JgBEev9G2P3X2q95rphxnxWhTEx1Xhu1WW+ZszNW2dXLmFeyqQe+UzpMS/skL+Z1aC
         8COfe5zPNPYU1r0Ftu3tvvJ2MhHT3F0LyPeQGYV4hYDbmjJeIyYmJ/ZMB7AU/5IH9Vkd
         MCNA==
X-Forwarded-Encrypted: i=1; AHgh+RpVP5YSfwSJR5DEyOBQF8WjOSoFURl+chgzJx4xHOmGMoQuVcotinkk+dzvIZnaMil5hFD7rkU3@vger.kernel.org
X-Gm-Message-State: AFuF++m6ctwSKVd8OlkDukyUFAG7H7QzHleMyPx39XsBH6nRJ5/RbPzo
	mY1vqFlUps77JyCd7lOoV9axSLxyt013QtXHKrdt3bR+hIFBpMHaOLZqsnr1AbIzv1M=
X-Gm-Gg: AR+sD12PLEm1LbpIERfeUD0Obkdx2zlbr7STIa74kbCWa5bfVFgCa09wP8YrrJzaU2E
	K7Ew0/ODJwta0sM2N/JktalKkyIq+/1LrcqbbewazceFnxhHppKEZKPucCX/1IWGZQMdkgTfQs4
	+EMVO13SOB7uaqpJSTSBi5p55DwKXqkA+S/hIo2JTm68ITN2VNgvS44Khi39GhAHsgMj9inTkVT
	t5xA5fCWOFUu5janLFenee3caJA//HA80GJo0hWF01uRMEQAGAWenLKxqQj3UWrR5UYcJmp4BPP
	CJn80sooZOKWW4Fs/uCQ9qFNwXtGDHB5eUUQlvinrWWlwRpNQ9rpv8vsqnTIfNawlKJq0+lSrQz
	FNamRWIif8xwivsMgDDa+UNvxc1bsV9TfSnQMXUM1/nmMa51xUQXiViVxwhH0EUHipmT+PQcM/o
	Js1Q5as+yQdGRH704229X4wP4RIh+/onUf0trzij3MZP92L0Jre8JciwCROgxJrcW77t0/d6Gtk
	Q==
X-Received: by 2002:a05:600c:4e55:b0:499:484a:81d0 with SMTP id 5b1f17b1804b1-499dc723fadmr189406965e9.9.1787839394561;
        Thu, 27 Aug 2026 07:03:14 -0700 (PDT)
Received: from localhost (109-81-32-216.rct.o2.cz. [109.81.32.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e28dbe1dsm9947082f8f.22.2026.08.27.07.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 07:03:13 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:03:12 +0200
From: Michal Hocko <mhocko@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <apBDoJEq_4UuJAaP@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
 <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao3quaSze8YjPjxZ@tiehlicka>
 <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao6eC2SUIGVz3Qct@tiehlicka>
 <ao8uZ0cNyqaAJuPB@echanude-thinkpadx1carbongen13.rmtusma.csb>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao8uZ0cNyqaAJuPB@echanude-thinkpadx1carbongen13.rmtusma.csb>

On Wed 26-08-26 16:31:56, Eric Chanudet wrote:
> On Wed, Aug 26, 2026 at 10:04:27AM +0200, Michal Hocko wrote:
> > On Tue 25-08-26 16:58:51, Eric Chanudet wrote:
> > > On Tue, Aug 25, 2026 at 09:19:21PM +0200, Michal Hocko wrote:
> > > > On Tue 25-08-26 14:33:48, Eric Chanudet wrote:
> > > > > On Tue, Aug 25, 2026 at 04:59:52PM +0200, Michal Hocko wrote:
> > > > > [...]
> > > > > The administrator opts in by mounting cgroupfs with
> > > > > memory_cma_accounting. At which point the cma allocator will charge CMA
> > > > > allocations against memcg and manages a per area counter depending on
> > > > > what area the allocation was made into.
> > > > 
> > > > So each CMA area will have its own counter and limits?
> > > 
> > > Yes, in order to enforce a limit per CMA area this series add a page
> > > counter for each area. Areas are fixed and discovered early so the
> > > counters are added to struct mem_cgroup and initialized when the cgroup
> > > is created.
> > > 
> > > An admin would then use the cgroupfs entries to assign an area limit to
> > > a given cgroup, something like the following, using the reserved area
> > > for example:
> > >   mount -o remount,memory_cma_accounting /sys/fs/cgroup
> > >   echo +memory > /sys/fs/cgroup/cgroup.subtree_control
> > >   mkdir /sys/fs/cgroup/mycg
> > >   echo 16M > /sys/fs/cgroup/mycg/memory.cma.reserved.max
> > >   echo 64M > /sys/fs/cgroup/mycg/memory.max
> > 
> > OK, thanks for the clarification. This confirms my initial suspicion but
> > it is better to have it clearly articulated. I can see several problems
> > with this approach. First and formost I do not think dealing with all
> > cmas this way is manageable. This can become a mess very quickly if we
> > have one limit per cma and too coarse if there is a single one. I also
> > have my doubts about space allocation control through a simple limit for
> > something that is effectively a reserved physical space.
> > 
> > I might be proven wrong but unless cma serves objects of a uniform
> > size then this will simply not work in practice. Hitting ENOSPC without
> > hitting limits and thus impractical for shared space management.
> 
> Isn't that an inherent limit with CMA as it is? If the area gets
> fragmented, some buffers may no longer be allocated since there is no
> remaining hole big enough to accommodate them? I do hear that putting
> arbitrary limits would make this worse, which might breach the threshold
> at which it becomes a problem.

I wanted to say that a limit for something that is basically a
reservation problem for shared pool is an ineffective solution.
Exactly for reasons you are mentioning. You might set limits for parties
sharing the same pool but that will not ensure they will be able to use
their promised portion - that makes low,min limits effectively
impossible. And hard/high limits are only to stop runaways.

[...]

> > Thanks. Yes this is more clear now. And it resembles hugetlb situation
> > more than memcg. You simply need a memory pool specific access and usage
> > control. Dispersing that to a global memcg limit seems rather coarse and 
> > I would say impractical. So it really calls for a per pool control with
> > an understanding of how the specific pool really works.
> 
> Thank you for the feedback. It looks like this won't work. It also
> excludes the attempt through double charging dmem[1] as it would have
> similar issues trying to use memcg.
> 
> >From your last sentence, would this rather call for a different
> controller entirely that would handle CMA semantics?

I would recommend focusing on specific CMA users rather than trying to
define a sane semantic for all potential CMA users because that might be
a lot of different things.
Then I would suggest focusing on the ultimate goal. Do you really want
to provide any sort of guarantees (a reservation system) for a shared
pool or merely cap maximum usage.
Last but not least think about whether the whole sharing of a
constrained memory area between uncooperative parties really makes sense
in the first place. Especially when the pool serves objects of different
sizes and fragmentation becomes a real problem.

> [1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/
> [2] https://lore.kernel.org/all/7e4e9662-d876-4493-a0b3-e31640937dd1@kernel.org/
> 
> > -- 
> > Michal Hocko
> > SUSE Labs
> > 
> 
> -- 
> Eric Chanudet

-- 
Michal Hocko
SUSE Labs
