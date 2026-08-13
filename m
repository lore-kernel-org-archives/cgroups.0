Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEA03603D8;
	Thu, 13 Aug 2026 07:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607302; cv=none; b=QxFzum2tZpw1ufr5AlyWkXl1QA8dLRmyncgE3FcP2vVnFfSdEpdtcIg6MH76diEcnAWQwtIaVFlBA/wOaQVnEo30jXMUsftx73GomFTipnM++TCu43ZsbiOeVExaFESDSKe3rXxCJpFSAGbvdTqzaa6YlHPY1s+HWn3JA0Zf354=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607302; c=relaxed/simple;
	bh=J7FScm4XWDaWiT4A/czPwxYtxnpAHbZUik4LaF21kMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwKMSSpOOI364HCFYcfJhrur+OeA/CmTon2aSNnyI7hGoD49fepoHVNlouxhWEEWNZMAsiwlHDN4OgxQT38HIWmMgDxBPwdOcTqZIBV4S+PVRhC0VRmHQz4NzLounVcltOFw6C7/xJv7LBH1PBcjd4ZJ+k3LYSsSnu+ZULfcsg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=XGymMy4m; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=b0DJhaHd; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="XGymMy4m";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="b0DJhaHd"
Date: Thu, 13 Aug 2026 09:48:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1786607298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/OhVWZ9lHJlcGMriNZm/1SFzBhyo3pOksNPNh0Vfes=;
	b=XGymMy4m0FWohPtYSnGFkzKSrx2c0BSHxsMbDG8O19Eu+LcsTOKxhuXZlhxdqheBWisiZ0
	vdJ/JlXZ3nV7yQXlRKHFfBZJaCWYQnyHCbekP1shSF9C/8r12K/AhpPRz/jB4s0EI+xqUM
	2JB0bGaSqJlbE63aJ6eEUBhE+Td2ZPjmDu7maP7DMlwoALuNTu/tFqEgw0pC6z/OOqFoba
	fNqP4j5k7LBQIJVbhXl7g9AWKL2kX586SnC+G/7kOIdWiYAGScYDTgqLFCriPnu5WgnZcu
	Nkp6ZI9jLcTx6GGi0nJeO7qTzg3RZwejMh6byZ9KNzTvEt/oOahpx0+IJXWAXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1786607298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/OhVWZ9lHJlcGMriNZm/1SFzBhyo3pOksNPNh0Vfes=;
	b=b0DJhaHdhAWGb2UfMVTrXRKtPbotlmzqfwwb0PlJYrrvJoPS0Ll9z97twGRtXF1N6nh8XL
	260aBuY3DKbtjXDg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"chen.yu@linux.dev" <chen.yu@linux.dev>,
	"Chen, Yu C" <yu.c.chen@intel.com>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v2] sched/topology: Add a cpus_read_lock to
 rebuild_sched_domains()
Message-ID: <20260813074817.t8IQTgfx@linutronix.de>
References: <20260813073855.ji2UrtVh@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260813073855.ji2UrtVh@linutronix.de>

+ CPUSET maintainer which I missed because re-used the CCs from v1.

On 2026-08-13 09:38:56 [+0200], To linux-kernel@vger.kernel.org wrote:
> A read from /proc/sys/kernel/sched_rt_runtime_us leads to backtrace due
> to missing cpu_hotplug_lock with CONFIG_CPUSETS=3Dn. The callchain is
> sched_rt_handler() -> partition_sched_domains() -> sched_cache_set() ->
> static_key_enable_cpuslocked(&sched_cache_present).
>=20
> sched_cache_set() itself is also invoked from sched_init_domains() which
> is early during the boot, holding just the sched_domains_mutex_lock().
> Here is no warning because it happens before user space is running (and
> hotplug operations are not possible).
>=20
> There is also sched_cache_active_set() which acquires the hotplug lock
> before invoking any of the _cpuslocked() functions.
>=20
> This is only a problem with CONFIG_CPUSETS=3Dn because in the =3Dy case t=
he
> other implementation of rebuild_sched_domains acquires the CPU-hotplug
> lock.
>=20
> Acquire CPU hotplug lock before in rebuild_sched_domains(), before
> partition_sched_domains() is invoked for the CONFIG_CPUSETS=3Dn case.
>=20
> Fixes: a7660ce1590fc ("sched/cache: Fix has_multi_llcs iff at least one p=
artition has multiple LLCs")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v1=E2=80=A6v2: https://lore.kernel.org/all/20260812095800.gl06ANul@linutr=
onix.de/
>   - Move the lock from partition_sched_domains() to
>     rebuild_sched_domains() in the CONFIG_CPUSETS=3Dn since this is the
>     only affected case. Noticed by Yu C Chen and Tim Chen.
>=20
>  include/linux/cpuset.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 65d76a38974ba..bf3999daa080a 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -273,6 +273,7 @@ static inline void dl_rebuild_rd_accounting(void)
> =20
>  static inline void rebuild_sched_domains(void)
>  {
> +	guard(cpus_read_lock)();
>  	partition_sched_domains(1, NULL, NULL);
>  }
> =20
> --=20
> 2.55.0
>=20
