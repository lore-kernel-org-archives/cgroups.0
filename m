Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.241
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795543757;
	b=5fI0bJtvRoAaviaxx321O/q9PLqt9kCTBCdcaI1rUN1NMhKdBexiBTyxvVo173ukc82R
	 rvODMAddOtb9SMEl6XoIsc0Hvkj4WRo5jrNmKns7EW7j5TpiHJbhMEgoNGtDhk6BHpIYp
	 Ym+FPkIYUZ9oNOx7zBAKgqGPk+td2cPv9zz+zNAamyYm8bxvCJM8bmDHaYxIqcJE/3CXS
	 8BwlRs1UIddITFEdQ7rCMBGbCP/S0ZnqATN7DqmPqAZKIt5dFuEu2z2Znqajl1ulEjmYc
	 rTUPALyMRnGfm2xHRVbn08K4DusGXX5eH8O2p1QP+ry9e6kDkiw7HhvbMT57b4/Puqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795543757;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rmGe/t/C0SL9g8ULw+bwhnr2ClafaU36qS6ic4NOFiA=;
	b=bKgoTkq9hap+QvnsZXusEn5dERXjh/2IkvtbYiLuUUGDgaqhtyT8kS1fnufIts8BuA4M
	 Nr2vMIyAT6Lg6fkbR/iMLfep1fXRNI+9earU6g2u/X42R2SO+vS4We/6ZeHccslfF+Mu4
	 AIoLtOJsCPZIY5SFEABai2JhKO824ZG5MJnoZzQSUnxPbD5s4+pT8Fh+uLmTja9Iq7UlW
	 TnVkbTwwtCQE+sXLuaUw2tPnV1XmUpqhQX4ihtSigTj7+hyOUOuzCFdexTUXDmJKLwKH+
	 RCr6T3EKhiaDfEWLAzjgXM/SkI7ocgudSeJ57M7wHc8Xz6UP4J4vGrcYkQJ/1Eb0deA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="I/HJu2pX";
	arc=none smtp.remote-ip=95.215.58.241
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD691606A333
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 18:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD691606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=I/HJu2pX
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4gdXdhSPnpdDcm1qThNOazm32H/ntbl45f/Fx2FZymA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795543754; v=1; x=1796148554;
 b=I/HJu2pXaxA/6D92tMNPKFdLiJ5r+MKziuqlC/PgID1/SHOBpu2BDjWISwD1IunHoLyYQrAX
 VEBr6VKwlWhBr/lrh5uACCpBBafsN7uqkmb2Zj88Xo6dmhmTCbhSpQG0ju6jk0JKrOsudu7xxfJ
 XCgbcvJwF/9NkoEodPo2lAT8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5399617d78ec6d7d;
	Tue, 24 Nov 2026 18:09:14 +0000
X-Mizu-Trace-ID: 5399617d78ec6d7d
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 10:09:12 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: warn when memory cgroup IDs run out
Message-ID: <awXPkCxVlQMAIUWx@linux.dev>
References: <20261124020800.2313930-1-shakeel.butt@linux.dev>
 <awVQShRRwF1IfEws@tiehlicka>
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
In-Reply-To: <awVQShRRwF1IfEws@tiehlicka>

On Tue, Nov 24, 2026 at 09:52:26AM +0100, Michal Hocko wrote:
> On Mon 23-11-26 18:08:00, Shakeel Butt wrote:
> > Every memory cgroup gets a 16-bit private ID, so a host can have at most
> > 65,535 of them at a time, counting dead ones. A dead memcg keeps its ID
> > as long as any swap slot still records it. On Meta hosts that create
> > many short-lived cgroups, dead cgroups held this way filled the whole ID
> > space. After that, every mkdir of a cgroup with the memory controller
> > failed with -EBUSY: systemd could not start units, and container setup
> > failed.
> > 
> > This was hard to see:
> > 
> > - Nothing is logged when the ID allocation fails. The only sign is
> >   -EBUSY from mkdir.
> > - Since commit 8290f45995f5 ("memcg: move memcg private ID refcount to
> >   objcg"), a dead memcg is freed even while swap still holds its ID. So
> >   nr_dying_subsys_memory in cgroup.stat can be 0 while the IDs run out.
> > 
> > Print a rate limited warning when the ID allocation fails because all
> > IDs are in use.
> 
> Not that I am against but isn't the issue clear by observing EBUSY from
> mkdir?

There are multiple software layers (binaries and libraries) between mkdir
operation and the folks debugging the failures. Not all software creating
cgroups log the returned errors. Also I am not sure EBUSY can only be when
we are out of memcg IDs. These errors can be transient as well. Initially I was
thinking of adding a vmstat but decided to go with a warning first.

