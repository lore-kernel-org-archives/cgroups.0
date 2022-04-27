From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup
 in cpuset_init_smp()
Date: Wed, 27 Apr 2022 15:53:24 +0200
Message-ID: <20220427135324.GB9823@blackbody.suse.cz>
References: <20220425155505.1292896-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651067606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z0VSn2vEXwWXMGAfap1HPPywpjqAc/nB4nW5xPcHwuA=;
        b=f/xNu/kDIRTMogOu0Uw02XT1TextwCqsKVU5GEime6fEx0GQmAShKNghzduSIpnAvkWvIl
        4XLpd3AXnkkx71Us1FiykJTL38kwzzkcISvSZKWwnE24AiQJotbu2LNxhs2RA6jAzmKmeI
        YWMQC29ImtGt9spIXjuzKoHdmIYLXW0=
Content-Disposition: inline
In-Reply-To: <20220425155505.1292896-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com, stable@vger.kernel.org

Hello.

On Mon, Apr 25, 2022 at 11:55:05AM -0400, Waiman Long <longman@redhat.com> =
wrote:
> smp_init() is called after the first two init functions.  So we don't
> have a complete list of active cpus and memory nodes until later in
> cpuset_init_smp() which is the right time to set up effective_cpus
> and effective_mems.

Yes.

	setup_arch
	  prefill_possible_map
	cpuset_init (1)
	cgroup_init
	  cpuset_bind (2a)
	...
	kernel_init
	  kernel_init_freeable
	    ...
	      cpuset_init_smp (3)
	...
	...
	cpuset_bind (2b)


>=20
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 9390bfd9f1cd..6bd8f5ef40fe 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3390,8 +3390,9 @@ static struct notifier_block cpuset_track_online_no=
des_nb =3D {
>   */
>  void __init cpuset_init_smp(void)
>  {
> -	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
> -	top_cpuset.mems_allowed =3D node_states[N_MEMORY];
> +	/*
> +	 * cpus_allowd/mems_allowed will be properly set up in cpuset_bind().
> +	 */

IIUC, the comment should say

> +	 * cpus_allowed/mems_allowed were (v2) or will be (v1) properly set up =
in cpuset_bind().

(nit)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>
