Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944C83C13E5;
	Wed, 19 Aug 2026 17:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787159682; cv=none; b=QY5ML0MlSl2V+M/nqawQCEx8VgMUqdulso2EIN2g44kRf1lqQ3Ozn6U1gJ3aBTrp64mQF/CCYoPx/2Xc2CXoagTypwYDnKOwpLhovj4DUrCkOMcwbXPQxebBWbsVDQGj94lKrjB54GQgQitPbgodWAJwF+1ZLv1RGmCy+xlTWrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787159682; c=relaxed/simple;
	bh=G2az3kMaKEVhL2SBJG2o50oNa+isI1FJN0rhDo3+L8M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q1K4d6e0/jwigHJUkuPUxqfdAQ7g+nk5nWTAL5rnNJkLnwyYSBVcs65fF1Ve7RbFKHU0vsivufTthUxVdSm39i/BR+tdvyFknnwF1ikezArnJzKGlu3iSl6KvJVN373Rq5oh4OZ5BcdiSEAPXf93+tb6LpVn1qlxV8TBWdC2Iac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zp1n/BVI; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zp1n/BVI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787159681; x=1818695681;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=G2az3kMaKEVhL2SBJG2o50oNa+isI1FJN0rhDo3+L8M=;
  b=Zp1n/BVIUYNjJWNuLXPN9hd20Vi3nj3Yn+nLXQM7P4GL+054XoY5Aaia
   Fo6q2HfbIrRjZ7jaif83j7+TSttp0F+ysGqfuAOy6L7bCK4Aj2L6O6RH/
   bq901Hh+GNBAk2q6uK3LeqdOgDD4em2ilwELEjjEwiR4XOeKDfeRiIX7H
   WWLX5Jc67ntFYlu53s9lmGYhPdHlcIn+bgXEav8TEvLJwZhb+1mCH6wLJ
   gTsApYjPyoUIUxWTZnm+03dkir70JGR5765Fh4NZP+h3UnLgaChDRnEYT
   iR75JV7sCF01CZapzQ4Q4DHmJPLaUK28HxUO8UPR1Y8a2CgFu80KgdfKB
   w==;
X-CSE-ConnectionGUID: HBvsTbq1QPCN/WPJBvIDGg==
X-CSE-MsgGUID: fidyHryrTXCVUPQvutgr8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="91561107"
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="91561107"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 10:14:40 -0700
X-CSE-ConnectionGUID: DqhfA6knSzKbQizUUgDOFA==
X-CSE-MsgGUID: kiuO5Lh5QfS5kLcaViSxPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="290404560"
Received: from unknown (HELO [10.241.243.185]) ([10.241.243.185])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 10:14:39 -0700
Message-ID: <ac36ff70f74b5e071e80a5df89d9979afa7b9956.camel@linux.intel.com>
Subject: Re: [PATCH v2] sched/topology: Add a cpus_read_lock to
 rebuild_sched_domains()
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ridong Chen <ridong.chen@linux.dev>, Sebastian Andrzej Siewior	
 <bigeasy@linutronix.de>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
Cc: Ben Segall <bsegall@google.com>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>,  Ingo Molnar <mingo@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>,  Mel
 Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>, Steven
 Rostedt <rostedt@goodmis.org>,  Valentin Schneider	 <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,  "chen.yu@linux.dev"	
 <chen.yu@linux.dev>, "Chen, Yu C" <yu.c.chen@intel.com>, Waiman Long	
 <longman@redhat.com>
Date: Wed, 19 Aug 2026 10:14:38 -0700
In-Reply-To: <d7129d5a-c9ec-421c-84e9-d227cd10ec32@linux.dev>
References: <20260813073855.ji2UrtVh@linutronix.de>
	 <20260813074817.t8IQTgfx@linutronix.de>
	 <d7129d5a-c9ec-421c-84e9-d227cd10ec32@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-08-13 at 17:43 +0800, Ridong Chen wrote:
>=20
> On 8/13/2026 3:48 PM, Sebastian Andrzej Siewior wrote:
> > + CPUSET maintainer which I missed because re-used the CCs from v1.
> >=20
> > On 2026-08-13 09:38:56 [+0200], To linux-kernel@vger.kernel.org wrote:
> > > A read from /proc/sys/kernel/sched_rt_runtime_us leads to backtrace d=
ue
> > > to missing cpu_hotplug_lock with CONFIG_CPUSETS=3Dn. The callchain is
> > > sched_rt_handler() -> partition_sched_domains() -> sched_cache_set() =
->
> > > static_key_enable_cpuslocked(&sched_cache_present).
> > >=20
> > > sched_cache_set() itself is also invoked from sched_init_domains() wh=
ich
> > > is early during the boot, holding just the sched_domains_mutex_lock()=
.
> > > Here is no warning because it happens before user space is running (a=
nd
> > > hotplug operations are not possible).
> > >=20
> > > There is also sched_cache_active_set() which acquires the hotplug loc=
k
> > > before invoking any of the _cpuslocked() functions.
> > >=20
> > > This is only a problem with CONFIG_CPUSETS=3Dn because in the =3Dy ca=
se the
> > > other implementation of rebuild_sched_domains acquires the CPU-hotplu=
g
> > > lock.
> > >=20
> > > Acquire CPU hotplug lock before in rebuild_sched_domains(), before
> > > partition_sched_domains() is invoked for the CONFIG_CPUSETS=3Dn case.
> > >=20
> > > Fixes: a7660ce1590fc ("sched/cache: Fix has_multi_llcs iff at least o=
ne partition has multiple LLCs")
> > > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > > ---
> > > v1=E2=80=A6v2: https://lore.kernel.org/all/20260812095800.gl06ANul@li=
nutronix.de/
> > >    - Move the lock from partition_sched_domains() to
> > >      rebuild_sched_domains() in the CONFIG_CPUSETS=3Dn since this is =
the
> > >      only affected case. Noticed by Yu C Chen and Tim Chen.
> > >=20
> > >   include/linux/cpuset.h | 1 +
> > >   1 file changed, 1 insertion(+)
> > >=20
> > > diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> > > index 65d76a38974ba..bf3999daa080a 100644
> > > --- a/include/linux/cpuset.h
> > > +++ b/include/linux/cpuset.h
> > > @@ -273,6 +273,7 @@ static inline void dl_rebuild_rd_accounting(void)
> > >  =20
> > >   static inline void rebuild_sched_domains(void)
> > >   {
> > > +	guard(cpus_read_lock)();
> > >   	partition_sched_domains(1, NULL, NULL);
> > >   }
> > >  =20
> > > --=20
> > > 2.55.0
> > >=20
>=20
> LGTM. Thanks.
>=20
> Reivewed-by: Ridong Chen <ridong.chen@linux.dev>

Thanks for the  patch.

Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
