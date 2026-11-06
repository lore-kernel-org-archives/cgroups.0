Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980130;
	b=WccDm4RfrfXNyXMG2tB+PPkFwZs8+0XNpzfzFHuakieEWiJeycHWmsXFNQ7YrMJGYwjs
	 bftG3jvOPulpRmQhAVEy9MT5rch899LkWfaE1ZiCRRTb9G1orYKIaKa9lkGcRJUCJyIY+
	 wEP8MKYxivrz9iqRO6BFkilW1N1wtCVjkn2UxVon7QArpcOsmSA8MvlrarjD2JYdJSYA+
	 q08vo+R8+UNTI7GeNGQvUkSkl7ou71vVKZ54cZT1JIpgem/LvXjeAyBPnhk3fwMBxjoPN
	 3z63hBEyQTFADsYf2ZDvni8kRBhtHwYQXC+7OXNe+qiahN5A6gTvI6Sec6nTnNfV3oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980130;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=tYP5TleIEch3VLAIP9Ft5HxHg1kcwlIJDfJyqYRyetQ=;
	b=rriQpzxsgdH3T8fLlFNrVYp0zxsmktSV7HH5Lp/4ziOKPqKICyJVyJVfdRgCS+dlQ5yc
	 reQ/+OTsQOCkMcWl1yQ5aDlQxzF3mOKOkbk8fc/VchFtaVym0Qmj6ayuyo+ReW1TpGZdA
	 rCPHJ8qpRbroXVTYHZJi6fgr5PXbtG0UZracdJosyUdx45BIHWjrPfKiJb3Mr6YVkCwoC
	 qodPSy3T6qyQW58eqskQ6P0hp6qDJyzvKbI0d1nIQNyA+91JBoJD1FeX1z4nv6g4JFlWf
	 +cIkn7omx9fixbUreCs/8GhHEg8FbcctkekhPh3JLp/eVIVGkjpljvkmDBUg1iaUn9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=kawekjpF;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F238606A326;
	Fri,  6 Nov 2026 15:48:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F238606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=kawekjpF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tYP5TleIEch3VLAIP9Ft5HxHg1kcwlIJDfJyqYRyetQ=; b=kawekjpFkeEGdTL/oDhrDnFvls
	K1D01E+FexEpQanMibxBalmMtyOvnUTJ+UVQ8QxUMrKmFHlioowyeYzLKNbVsfgIp7VObIcFExEpf
	vqYossnW/QB+XhOiQZEppddiMVHXWse+H6IqywSELZUSdLbBdVk4mDFaLTGnjY6c1zXFYdGRZviu1
	a1JRUdlohP6HrX1J+E2nkajmSx1GeiVHJV/RkCNrWDiGtvZFHB+MgKikLbDD8f/s+7y4Wh1Uqfyl8
	3xiLyWiCoerUT2LoIv1B8UEwXKqw9UuoY2k0ksG4hzsmmN4H47F7SWp6jznWjd8iBPUPCXWoA9lv+
	luXUpRbA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPMBA-009OCi-2T;
	Fri, 06 Nov 2026 15:48:37 +0000
Date: Fri, 6 Nov 2026 07:48:30 -0800
From: Breno Leitao <leitao@debian.org>
To: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Julian Sun <sunjunchao@bytedance.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/4] writeback: name the bdi in the slow writeback report
Message-ID: <au32skMUJvDOSsgb@gmail.com>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-2-bf0c3b9023a5@debian.org>
 <n7s5cijjaiso6mhaqolsmfkyyfk7wkb4l4o2cnxqadjfllik7b@hh6u4v5f6t2t>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n7s5cijjaiso6mhaqolsmfkyyfk7wkb4l4o2cnxqadjfllik7b@hh6u4v5f6t2t>
X-Debian-User: leitao

On Fri, Nov 06, 2026 at 03:27:49PM +0100, Jan Kara wrote:
> On Fri 06-11-26 04:26:32, Breno Leitao wrote:
> > The slow writeback report names the waiting task and how long it has
> > waited, but not what it is waiting on. On a machine with several
> > filesystems there is no way to tell which device is slow.
> > 
> > Pass the bdi to wb_wait_for_completion() and print its name on a second
> > line, together with the number of work items still outstanding. A sync
> > issues one work item per cgroup wb with dirty inodes, so the count also
> > shows whether a single cgroup is holding up the others.
> > 
> > wb_wait_for_completion() took the bdi until commit 5b9cce4c7eb0
> > ("writeback: Generalize and expose wb_completion") made it usable for
> > the memcg foreign flushes. memcg tracks those by bdi id only and passes
> > NULL, which bdi_dev_name() prints as "(unknown)".
> > 
> > The first line does not change, so anything matching on it keeps
> > working. A sync on a throttled null_blk device now reports:
> > 
> >   INFO: The task sync:180 has been waiting for writeback completion for more than 28 seconds.
> >         bdi 252:0, work items left: 1
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Dunno, I'd put everything on one line. Otherwise things can get interleaved
> by other messages. Kernel messages are not really an ABI, we can change
> them...

Ack!

I will get them in a single line and respin,

--breno
