Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795677958;
	b=OmdhGa8skAdhRjYJ+ABFJ7hsk5ZglMWZ5rMJCN2KXR0CNv8aqyhy1vc7ztUYwAd91YVT
	 pxwk6uKuVA3L0Eh9CgcM6rjqu5dovq1eaXEKFXyltu8m3K4Vn4klTK/l9ofIEAsOB5shH
	 knIr2H9fqE4OPvLbqqvO8A5rOzf9WyDlVu5OfCpM+d+pPotTUO0h87PYagByTWxM8y8xz
	 8H45VEVjGGF4DVfiGl8WaHMc3ldULFuoJz2aaSTWUPtNPAfhzcRTEyVb7posKiKhzbKne
	 uLFk9pzDgRmbDmbkY0sgvtN2aIibNIJWCacSVr99X5pz7N7NLSdBKKIH8FWtgSqFAEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795677958;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yogRRHzWTPFUOBNE7lKWXJHFAt55tvJabEUVbwtLF2U=;
	b=4CC/ipzSBgLAXGgbBVDlgDLErm3LimM7tDWMGP/Uljs4ILMDAI/UWNq8JHUqDinjOWI/
	 pve4fo41BlU+29zO7v4MNmQ4Cud8gIvfh5F9y9fehBY0IHePqJx5ElR0SyLJCqNr/EURi
	 TAJ3ZwafZ5i46w/CSrjrmVnZK0PtDsB8gMsZeV+EUYCgFiQSAITyvEkIaExezDwGdy+T/
	 S/ZjwE8jm6ST3G56rPEfowvRGbeQPE/BeIMVz6wxAMW8l77L+eF/SrIKu0Lr0hOF7/P0u
	 yc9RClanrawHKKqxrMaTt6qeUXRJSpiRDbxbDOk35Hohe9qy0PJs8HSR9EfiV5XF8DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KwLvKqwy;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YmH7Tp0T;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F98606A326
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 07:25:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38F98606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KwLvKqwy;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YmH7Tp0T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795677957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yogRRHzWTPFUOBNE7lKWXJHFAt55tvJabEUVbwtLF2U=;
	b=KwLvKqwy6nWA19QSpk8W11j+9V9YlfB1T8LVMoXiPDmN64naHA9x4YXrpAmwTNky02ZhO2
	PyHRMCb4GGWadhpsJdcQ0SYslvBUCLUHggaiE/bvdF+0CZk4rOntDI103x8GzEZ7rmQpKE
	TMVCWNF68vgSOLow8870VW/Tm2cJ2ts=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-ipH_fZ0wMFGlvGdetaKIUQ-1; Thu, 26 Nov 2026 07:25:55 +0000
X-MC-Unique: ipH_fZ0wMFGlvGdetaKIUQ-1
X-Mimecast-MFC-AGG-ID: ipH_fZ0wMFGlvGdetaKIUQ_1795677954
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a4654add56so45414395e9.2
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 23:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795677954; x=1796282754; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yogRRHzWTPFUOBNE7lKWXJHFAt55tvJabEUVbwtLF2U=;
        b=YmH7Tp0TeZjujhER/ZC6ivUaJk2pipMoVVOrecGfbKUxGKLZ0MuyTDP+Hjil7sTBQk
         2fiNl7IgTlC7+jpDZshMFElu6iUrqlXcN7tJ96gsFLfJvJgDGrilAacfX5hAY6ygj5l7
         dhzXSJVZMMBGuYGKWdLg3L0Tt53Q9NJNdGnkb3qZZ2SghDSmgQ9IQb6rGXzDIupO/JKs
         xmfxMViYHiL6PErxPG4CTnhNyTT5+f/JXrrUQaO6FefeOd7dDb41X3Bep7qvsnroD26v
         HxXTvEiuj+Kba8s8wEYuoEtfNPOXEXlgUY/dfeF5dXc2idCBc9xq7Z5NHj1wMb7iLB5z
         MGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795677954; x=1796282754;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yogRRHzWTPFUOBNE7lKWXJHFAt55tvJabEUVbwtLF2U=;
        b=o1Lyi7ulv8FkwuVh9L8Ox0KGXRXGarOosvT/ny20JAJo4FSV10Cj+0IvzZ23l622YF
         wo3bLLhvHU7rIFF8YX1ZSwND8XVLq+ojEC6rGQD4faAczeGGrBpbP0l/gfiu0Ojvfc18
         WRyHtsSxC8DwRzkAHMDucgKp51wCUtWBcoSPMD9CLk1/YzxZFFZrld79pL50pUL78s8C
         kF/5VAlhvM5r+v+tZVX+UhAxAUy2Gs28qYBuzODFyVYGt1BUvDPssO7GEtiSQ4KNrO2p
         7FABhzOXdn/d1G8wYZZOpHoJ+pz9K5Kocykkffu83UfYH0KDCkwmARFv7MSUiwRMPj2p
         gaAQ==
X-Forwarded-Encrypted: i=1; AL+hErGVHjurPbygk1MJWWWa7p2GIB8lVPmMfc9S5mCWPlxqbck4/3CIxFMocJAdl82BEHtRwvUTtG9t@vger.kernel.org
X-Gm-Message-State: APuU4Z/iGPGMV6qE1KtkrszBsAm1czh0ia/BMLDH3VZG76qx5mwBmC+7
	O2fhyNDv6qhVmQrAr1T3oU7ktT4f7O3AtLfgQ7R9qTf0z6/8qwu5Hykxd/awMPOvBhKNlSEwQK9
	pwbw5ddISyzsJM2vVUh3DHbaJeri82Syte4h5Tyyyxar+Fy74JSKt80PEHsQ=
X-Gm-Gg: AZFdTZcZiERT2tuC+CWN48k4tEkJmHHGuKKUM9fDy6+sH0JkgWJIGqurdw1gdLcageM
	uEN/VEyE8f/LyA67bGaU50w2Z99ugZeESZmeOYctfVmwsQ9g3Z66/t+3gPpzyuNHdsIfLY2E0LW
	Pd+Ss1TXZICjwHimC0dR5xZe/FeUy0fFr959+b3KVWhsgI0+mxxqIS7jb3fWEAABY1b8GKO1XVI
	pDozHQky9PVqHXS7tXfQuhmy7rNvpo077IGnk32dvKJmDUq16BcoIHs64VU0TOyaDm1voXdQACn
	/MM1G/6BGK6som8werHdzcJmo/mVHAV6XVgJKeGBtKl98gQU4Lgbqwl52JUG9/X85kte/lKJgDf
	NowBZR+3dynLtJxhwngQD/XPYf/MVwfraqnd8yt0VHJJPqwVnWc6KOF63RWEGZk5qisB4kn+D9X
	mn47eR
X-Received: by 2002:a05:600c:1389:b0:4bb:6519:477e with SMTP id 5b1f17b1804b1-4bb88813b35mr414453875e9.17.1795677953722;
        Wed, 25 Nov 2026 23:25:53 -0800 (PST)
X-Received: by 2002:a05:600c:1389:b0:4bb:6519:477e with SMTP id 5b1f17b1804b1-4bb88813b35mr414453455e9.17.1795677953356;
        Wed, 25 Nov 2026 23:25:53 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.146.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab9cf005f2sm32087795f8f.45.2026.11.25.23.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 23:25:52 -0800 (PST)
Date: Thu, 26 Nov 2026 08:25:50 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: luca abeni <luca.abeni@santannapisa.it>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
	bsegall@google.com, cgroups@vger.kernel.org,
	dietmar.eggemann@arm.com, hannes@cmpxchg.org,
	kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
	mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com,
	peterz@infradead.org, rostedt@goodmis.org,
	vincent.guittot@linaro.org, vschneid@redhat.com,
	yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
References: <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
 <20261119151416.33f90a64@linux.fritz.box>
 <471bf8d446becabfca00041fb2a78067@kernel.org>
 <20261120120659.2e902463@linux.fritz.box>
 <6fef47e08a37079c08806b3c57994778@kernel.org>
 <20261120212418.10221f2e@linux.fritz.box>
 <06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
 <20261123084345.4e24e3ca@luca64>
 <awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
 <20261123151846.3fdcbf4e@linux.fritz.box>
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
In-Reply-To: <20261123151846.3fdcbf4e@linux.fritz.box>

On 23/11/26 15:18, luca abeni wrote:
> On Mon, 23 Nov 2026 11:22:03 +0100
> Juri Lelli <juri.lelli@redhat.com> wrote:
> 
> > Hello!
> > 
> > Me again interjecting, please bear with me, but I think we want to get
> > this as right as we can. :)
> > 
> > On 23/11/26 08:43, luca abeni wrote:
> > > Hi Tejun,
> > > 
> > > On Sat, 21 Nov 2026 07:24:36 -1000
> > > Tejun Heo <tj@kernel.org> wrote:
> > >   
> > > > Hello, Luca.
> > > > 
> > > > On Fri, Nov 20, 2026 at 09:24:18PM +0100, luca abeni wrote:  
> > > > > But the deadline entities serving the real-time tasks in a
> > > > > cgroup are pinned to cores (one dl entity serves the cgroup's
> > > > > RT rq for a core). So, they cannot just be added to the sum
> > > > > mentioned above (which works for dl entities which are free to
> > > > > migrate). This issue was solved by reserving a fraction of the
> > > > > CPU time (and the root cgroup parameters indicated this
> > > > > fraction) to RT cgropus, so that the SCHED_DEADLINE admission
> > > > > control is still the same (we just decrease "limit" by the
> > > > > fraction reserved to RT cgroups).    
> > > > 
> > > > I see. Can the fraction be the maximum across the CPUs then? With
> > > > the root at "max", the kernel knows how much the cgroup servers
> > > > have reserved on each CPU. If "limit" is decreased by the largest
> > > > of those on all CPUs, every CPU has at least what its servers
> > > > need set aside and the admission control for tasks stays the same.
> > > > 
> > > > I'm not familiar with the admission test, so I may be missing
> > > > something.  
> > > 
> > > Uhm... I think this can increase the code complexity, but yes, I
> > > guess it can work.  
> > 
> > What about a slightly different approach? Instead of reserving a
> > fraction up front (or the max across CPUs), cgroup servers could be
> > accounted like fair/ext servers already are: each server adds its
> > bandwidth to total_bw of its root domain, and on top of the global
> > test we check, per CPU, that pinned bandwidth (cgroup servers plus
> > fair/ext servers) stays within the limit.
> 
> I am not sure about the SP theory, but if this solution is fine with
> kernel maintainers, I think this will work, too (it is even better, as
> it reduces work for Yuri :)

Just for my own (hopefully) better understanding, I tried to come up
with a setup that uses a cgroup with entries on some CPUs and "max" on
others, to reason about it more concretely. This is an illustration, not
a deployment I actually know of:

A container runs a single RT process. A few threads (control loops) need
a guaranteed budget. The other threads are FIFO as well (e.g. comms or
watchdog threads that must preempt normal tasks promptly but use little
CPU, or threads that simply inherited the policy), but need no
guarantee, and shouldn't run on the reserved budget, as they would eat
it while the loops sleep.

  P/          cpuset.cpus=0-10
              cpu.rt.max: 4-10 runtime=400 period=1000
  P/noncrit   cpuset.cpus=0-3   (threaded, no cpu.rt.max entries)
  P/crit      cpuset.cpus=4-10  (threaded, no cpu.rt.max entries)

Threads in P/crit are served by P's servers on CPUs 4-10. Threads in
P/noncrit find no entry up to the root on CPUs 0-3 and run as plain
FIFO, as they do today. cpuset keeps the two sets apart, so no task ever
moves between a server and the root runqueue, which I think addresses
Luca's concern about tasks changing reservation on migration, at least
for setups that care about the analysis.

The mixed config ends up on P because of _delegation_. P's cpu.rt.max
belongs to whoever delegated P, and it's what bounds how much the
container can reserve. The application only arranges its threads below
it. If a cgroup had to be "all or nothing", the admin would have to give
P either zero on CPUs 0-3 (no RT threads there at all, not very
flexible) or a budget there (reserving DL bandwidth for threads that
don't need it).

Tejun, is this the kind of usage you had in mind?

Everybody, is something like this anywhere near what you think people
might be asking for? Do you have any other examples in mind?

