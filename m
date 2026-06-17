Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6C5413235
	for <cgroups@vger.kernel.org>; Wed, 17 Jun 2026 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781705033; cv=none; b=i6HGDsufQVyMdqS9Aj5RTem3XxjSuxTd7PT6uTEcIuV8suvAZPd3N3cdQKydFr3WPP9kgQcvMXw0JdI6QB+3JPWfXRVosJ7/52GDfI9xCvU8Y+7XMffmX1wdF8IzIldB6Do9BKvz8t0wNjyApukIpkAG4OGYb9H+nU7TUM0EVFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781705033; c=relaxed/simple;
	bh=95TSTVQlWc9XEmLQ5CRQKISimsK3+z9mzOJYVfT8u2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XiJRDw+wcAifpKCGK/r199tqZ/oCTQafPpugzSeE1gWPyX+KleCNBilglxo7pGnKCeLBVN+UuBMzftK2q6raVF7oU4dW16cxF6tD0tMaI9uUzbqVsLhRseHiuoDMcVegfhCtpRKCVCXNseJEbFGF8LgkV7fdAjK7+UEr5dG3mTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=VKY/uljc; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="VKY/uljc"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5177945a279so65719371cf.0
        for <cgroups@vger.kernel.org>; Wed, 17 Jun 2026 07:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781705031; x=1782309831; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=21pxQXdsUMGW+bGknxxPyRxRyaJDV62jMRhp5DnWHkk=;
        b=VKY/uljcfnKh99zo5ySSTpXVX7+PQXcN9dydeIP3wAjLilTe7GyGtIKsWKRXaqjfcj
         V60zh+FXk43C01MtPyaBVrkkdpfCl05MVgB8i39okjylUDiUNSlSKaXk2ht/jc3PilPZ
         HhjWrtpiTDxksxAS3zbmbcxNEToz6Ha9CTeE3/wQBXkraKZvoeYV3B9KQ5R6VSzel+xv
         AdZ6a5EFmVMuU9exqmP7Cb3moiTHWGs8es23xSFCEbinplwlXICueJo9ReoXUb2Ee4nR
         1tRIZrraIrLJCu/UJBEc9RMu9dylL1GP0EbKXIj5hprozLZDygg1KuOwmHEoAInY5eOX
         yThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781705031; x=1782309831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21pxQXdsUMGW+bGknxxPyRxRyaJDV62jMRhp5DnWHkk=;
        b=ZT9K0roqGBnIbklU1jQe/RuGzGXxgKrEG/IPGxzdMAEofLjkyI2PcHIvMcIDVG9TpO
         PmfBCau21xWRwDxWh3rwPS4bhXg2XNR53Xd48k9Ssd6QHGJWa81tBpDCe5raH87oYZO9
         +UDva2wd1XchMXB4545Pw8PS+cqrgv2Rg0Qvu4v0on6j1cRPKpUgBfdyLe0R73bsBM3f
         132dCe276AN+BRq1G25Qp1Vq3MrdloDQtSjMj2r0GaoBDHFH380FE1kFgCSs9liPJ+JF
         xcvKI5OoMgYEDUmpRsSMaGJ/T+xdqB6wQrD/cDTmwmnPKnBxrZfYBcXjE7gXEKNULP5W
         tv+g==
X-Forwarded-Encrypted: i=1; AFNElJ+uF7wEMv3gWm9NWSQyYC4BSMfIjnZUBGYYYz0C36s2+idOv16TX+TCL1yPklLCTukeFxaD5aTx@vger.kernel.org
X-Gm-Message-State: AOJu0YzJCTAwK5OKVktxcoVRltjimn5408PN9xhrHpdnd+oECbMYACre
	7QKN2S2CnIxa6KnE7d0TZoGvjW3zJtr+u5ICL3/8Qmz65QEAJairJvEnz039qXsqUIs=
X-Gm-Gg: Acq92OFgImHsDSPRYwdPUPnQFZbgmeYV8LOh4qanSG4+G45h4mmXN/cPHj5f1xfiRmx
	nqnfLf+zG9P2bEjm5nTg6AxmalIafjx7SHgKYpgP0qEzuXN7cL8mEJp42vYA6dBDp3us/CDm+0A
	L7mjvWy+8oDhPbfwsaIfnDyQMwNtVWZ7ykJydZK/IagrU9pybbcZjFXybdJUupg+Dziq8tEzfmS
	wKcQByOJTkyGVdHmgWnsLK+tSCDIYStCc3YMx0aXisvfz6eNA5NjculvU0S8VdZH130VklXFmOn
	qw6HGDiwU5iGWroTIUdPsC0x9ysNPSQHHjdI0iROSAtrCpemuvCyt1cc1RGPNujKtxoUHbQigQe
	BOnPd01JLCQprZ9pDkxkjvOy7jDwUJziIHq8Y0VJd885Vvm3ekR1Tmnd3TROydQCkY9R8w54p+l
	FaZOpfWWshow88chYFjEyU
X-Received: by 2002:a05:622a:4a89:b0:517:82a1:adf1 with SMTP id d75a77b69052e-519a8de2756mr65756641cf.15.1781705031230;
        Wed, 17 Jun 2026 07:03:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::3:ce0d])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51955b271fbsm134106091cf.22.2026.06.17.07.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 07:03:50 -0700 (PDT)
Date: Wed, 17 Jun 2026 10:03:46 -0400
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <ajKpQgfimm-ztnHv@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <ajIb4DJdLGPbMB4V@parvat>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajIb4DJdLGPbMB4V@parvat>

On Wed, Jun 17, 2026 at 02:02:47PM +1000, Balbir Singh wrote:
> On Wed, Jun 10, 2026 at 12:37:34PM -0400, Gregory Price wrote:
> > On Wed, Jun 10, 2026 at 05:00:33PM +0200, David Hildenbrand (Arm) wrote:
> > > On 6/10/26 12:41, Gregory Price wrote:
> > > > On Wed, Jun 03, 2026 at 03:00:01PM +1000, Balbir Singh wrote:
> > > > 
> > 
> > For mm/slub.c we can choose to do one of thwo things
> > 
> >   1) 100% refuse slab allocations on private nodes, i.e.:
> > 
> >      kmalloc_node(..., private_nid, __GFP_THISNODE)
> > 
> >      And will fail (return NULL).
> > 
> 
> Doesn't this iterate through N_MEMORY only? N_MEMORY_PRIVATE should not
> be in the regular for_each(...) loops
> 

If a node is in neither FALLBACK nor NOFALLBACK - it is *completely*
unreachable in the current page allocator.

Next RFC I've reduced this to create a ZONELIST_PRIVATE separate from
the ZONELIST_FALLBACK and ZONELIST_NOFALLBACK, and an explicit folio
allocation interface that selects which fallback list to use.

the feedback in the past week has been helpful in honing in on a
solution that I think is generalizable.  Have just been taking the time
to test various behaviors to make sure I haven't been regressing any
userland API/ABIs (mbind, mempolicy, etc).

~Gregory
