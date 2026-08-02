Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9DA2D97B5;
	Sun,  2 Aug 2026 03:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785640314; cv=none; b=VECTyf/YQ53U/Oj+8wUPTHY+p3lNAZq8DCNJOIWAmTX05Gv9zR2xatlRHs/88TU4skYYqTkxZLZ36KyfnR/VFExBmaFg/OIipS5bkV6uD635Km0guJorh2Cc0P1yKD6t55A0JUYn7m+B4XtIJZ41LrplKmEwkqGIv/cTh7Rer6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785640314; c=relaxed/simple;
	bh=jQPgsyKOUoXKj2cf9F4rs5fOLCsc0WbDpS4VOwud8ZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sn1H1G0ELjuLvaPbUExI67i24IpJXQq2diraQj1SPML0cwBLtb6eW1EOAoDaWt4/5XHk9IqwJjQs7rt1G4HUOEL2jN5a8vTdipzjRziXniinEg5LtNvxKk1Sl7TSK4/eUKLvMtyYq62U75O82C79deGY5MIcrtk72nKLJ9/c+Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SzO5E/Sw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SzO5E/Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5921F00AC4;
	Sun,  2 Aug 2026 03:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785640313;
	bh=EH4+hfnWIRFHkBk1HGdin9nvII6g4mwD+D9CCxF0/Zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SzO5E/SwYXEqxfk13hH/cxzvvRniYKz59jzhD87/fdx52/0nnag1bFzn7KtzeCIPS
	 z4fTmIcD5UcsGDsDrVMGvblg9dCB3cbh1Iq0Kgh9mVXofnnXmVZPQmEdjMX5UkI47z
	 lXwB8fwwQLE7pj6I0rxK/E9JIoKWZEhfhYkSIunLFeosbBunYt5GGSlL8HCBNvFdcK
	 p8aIhzaqKB+bjlEQY03u5bcCl6z0rTQV0A+k/o05avLSDFiQIgEYxz6PscxWSkLZuV
	 V58aB0rPRypzQpb/GCUF6nySKk4lBREyOGNwb6UWpSWD9Ya0nQChp0OFES/+PZaHpv
	 mjfTLFVEEZNJw==
Date: Sat, 1 Aug 2026 17:11:52 -1000
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Julia Lawall <Julia.Lawall@inria.fr>, kernel-janitors@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: drop unneeded semicolon
Message-ID: <am61eHsfLMfPCSsE@slm.duckdns.org>
References: <20260801191002.1383835-9-Julia.Lawall@inria.fr>
 <8797e8b8-59ce-4934-ac0c-7f9731de454b@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8797e8b8-59ce-4934-ac0c-7f9731de454b@redhat.com>

Hello,

On Sat, Aug 01, 2026 at 07:37:13PM -0400, Waiman Long wrote:
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index 38f8d9df8..f87fc4550 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -104,7 +104,7 @@ DEFINE_PERCPU_RWSEM(cgroup_threadgroup_rwsem);
> >   #define cgroup_assert_mutex_or_rcu_locked()				\
> >   	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&			\
> >   			   !lockdep_is_held(&cgroup_mutex),		\
> > -			   "cgroup_mutex or RCU read lock required");
> > +			   "cgroup_mutex or RCU read lock required")
> >   /*
> >    * cgroup destruction makes heavy use of work items and there can be a lot
> > 
> The RCU_LOCKDEP_WARN() macro is basically a "do { ...} while (0...)"
> statement. It doesn't have a ';' at the end.  So your commit log isn't
> right.
> 
> An additional semicolon at the end doesn't harm. By removing the semicolon,
> even if not needed, may make people wonder if it is right when reading the
> code wasting their time to figure out if it is all right. So I don't see any
> advantage in removing it.

I think the extra semicolon can hurt. Imagine something like this:

        if (blah)
                cgroup_assert_mutex_or_rcu_locked();
        else
                something else;

This should work but with the extra semicolon, it doesn't. I don't see why
we wouldn't fix this. It's obviously wrong.

Thanks.

-- 
tejun
