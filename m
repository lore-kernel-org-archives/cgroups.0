Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.164
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410862;
	b=fX9cTMoECa0+y32f2FoYUfl3z8+yg9R7Jkcr7Eg5nLYzWGuZ4EMMgMxgJodx1BtTmkz3
	 ZJsSbRRLoDuiXygNIa5JrB5byAh4l3048JMvEjbcIcjnIsjGjta6ik9Zfh1CyWqoSCFyw
	 K2hgIOfqQPKe3Cyak7nX+hzoqOSsojBNLjk50TOJ7m43pNPoZuW+SQ3ZIx10m7tmk41Yt
	 erxgAkToSAlCLSVgtUR9TarOl0N3EAkqZLsPYyG66SFmbBGYiGOTyXUEjjrXEndsUnO9G
	 B3qkoXKgLjdGy5A95LCuzKjCZJLm3jB5j35Y8HE197oWYdWdYCMpq3MdVUgykf6pNdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410862;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=YVGRySLWzLbr6G9DwywhuXVVUIc//KTjhc8CQKSeRe4=;
	b=DSP7h/7PuFjxO08kg6ngGLlTNte3v1LRoPxeOEk1QWXT/T44YOTSKfMoOccdxKkj5PLw
	 RfExp+ohUVM45i5qW+OK/7qqgAtu0HTZUJDnLaVnFaT/ygUijg+63XWto19hLk1DbsFWp
	 188QEi2MRqBAQZxe9hpvMMvduC47IkIWBHGvlg1oCH1UyKcoaaN4cz1S0cgm/0JmcKPDo
	 fixM073pHxmPhWErcurxvBx6M6SukZRuBVy+Qxamk7tciKA/7EXoXVoQ3ekq/zAjHxiVO
	 orjid6/TzwKXrHhcoj6dNBnfejEZ593ruSHKDWYXYjkb5Gus096ayu8NncYIN1Z91mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r8Xrdv7q;
	arc=none smtp.remote-ip=91.218.175.164
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B74606A324
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 15:27:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03B74606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r8Xrdv7q
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Z1VGtGrk7JFgea2wbfV8+qOC1F1Ifp0uYdGtantuafk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794410859; v=1; x=1795015659;
 b=r8Xrdv7q0Iz4YtaCrzLS4oQ+Jamd8J4K2QIJUa1TZw/OFBjbUmQU9xouPjerP/8qexNH/vpB
 b06fMG+aLCxVxdjKGg67BmXDRwsdNbA/Pyl/RAwqUJZOZH36I8KYZqw1YyvhdW8NCRh2rYre7D7
 1gnSVWmdcMfzib/2+Lj1eb30=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 53e768523cdcce5d;
	Wed, 11 Nov 2026 15:27:39 +0000
X-Mizu-Trace-ID: 53e768523cdcce5d
X-Migadu-Flow: FLOW_OUT
Message-ID: <fe7aa630-d323-4981-9f89-0958cb6204a2@linux.dev>
Date: Wed, 11 Nov 2026 23:27:34 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v3 3/3] cgroup/cpuset: Check remote partition
 underneath before making an invalid partition valid
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20261111020204.1660055-1-longman@redhat.com>
 <20261111020204.1660055-4-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261111020204.1660055-4-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/11 10:02, Waiman Long 写道:
> When re-evaluating an invalid local partition via partcmd_update,
> update_parent_effective_cpumask() does not check whether a descendant
> remote partition is using its exclusive CPUs, promoting the cpuset to a
> valid partition root over the remote partition. This condition should only
> be possible if parent is the top_cpuset and exclusive_cpus isn't empty.
> 
> This leaves an active remote partition underneath a valid
> local partition root with overlapping exclusive CPUs, breaking
> scheduler domain partitioning and triggering warnings in
> compute_partition_effective_cpumask() and generate_sched_domains().
> 
> Fix that by checking the effective_xcpus against subpartitions_cpus
> when an underneath remote partition is possible to make sure that all
> the exclusive CPUs are available before allowing the invalid partition
> to be switched back to valid.
> 
> Also make sure that effective_xcpus is non-empty before swtiching an
> invalid partition back to valid.
> 
> Add a test case in test_cpuset_prs.sh to verify that an invalid partition
> with a remote partition underneath cannot be switched back to valid
> with a hotplug event.
> 
> Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-47715b89-d5fb-4731-b7c9-070773c6ff75
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c                        | 42 ++++++++++++-------
>  .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++
>  2 files changed, 30 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8b684361c94e..af5fd543fe88 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2034,11 +2034,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		 * tasks_nocpu_error() with this very mask, and a failing
>  		 * write is routed to partcmd_invalidate instead.
>  		 */
> -		if (is_partition_invalid(cs)) {
> -			adding = false;
> -			deleting = cpumask_and(tmp->delmask,
> -					newmask, parent->effective_xcpus);
> -		} else {
> +		if (is_partition_valid(cs)) {
>  			cpumask_andnot(tmp->addmask, cs->effective_xcpus, newmask);
>  			adding = cpumask_and(tmp->addmask, tmp->addmask,
>  					     parent->effective_xcpus);
> @@ -2046,6 +2042,17 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  			cpumask_andnot(tmp->delmask, newmask, cs->effective_xcpus);
>  			deleting = cpumask_and(tmp->delmask, tmp->delmask,
>  					       parent->effective_xcpus);
> +		} else {
> +			deleting = cpumask_and(tmp->delmask,
> +					newmask, parent->effective_xcpus);
> +
> +			/* Check if a remote partition may be underneath */
> +			if ((parent == &top_cpuset) &&
> +			    !cpumask_empty(cs->exclusive_cpus) &&
> +			    cpumask_intersects(tmp->delmask, subpartitions_cpus)) {
> +				part_error = PERR_REMOTE;
> +				deleting = false;
> +			}
>  		}
>  
>  		/*
> @@ -2126,34 +2133,37 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		} else if (is_partition_invalid(cs)) {
>  			struct cgroup_subsys_state *css;
>  			struct cpuset *child;
> -			bool exclusive = true;
>  
>  			/*
>  			 * Convert invalid partition to valid has to pass the
> -			 * cpu exclusivity test when cpuset.cpus.exclusive is
> -			 * empty as well as the housekeeping check.
> +			 * following tests:
> +			 * 1) housekeeping CPU conflict check
> +			 * 2) cpu exclusivity test when cpuset.cpus.exclusive is
> +			 *    empty.
> +			 * 3) if parent is top_cpuset, none of the effective_xcpus
> +			 *    (tmp->delmask) are in subpartitions_cpus, if not a
> +			 *    remote partition may be underneath.
>  			 */
>  			if (prstate_housekeeping_conflict(cs->partition_root_state,
>  							  parent_prs, tmp->delmask, NULL)) {
>  				part_error = PERR_HKEEPING;
> -				goto write_error;
> -			}
> -			if (cpumask_empty(cs->exclusive_cpus)) {
> +			} else if (cpumask_empty(cs->exclusive_cpus)) {
>  				rcu_read_lock();
>  				cpuset_for_each_child(child, css, parent) {
>  					if (child == cs)
>  						continue;
>  					if (!cpusets_are_exclusive(cs, child)) {
> -						exclusive = false;
> +						part_error = PERR_NOTEXCL;
>  						break;
>  					}
>  				}
>  				rcu_read_unlock();
> +			} else if ((parent == &top_cpuset) &&
> +				   cpumask_intersects(tmp->delmask, subpartitions_cpus)) {
> +				part_error = PERR_REMOTE;
>  			}

Hi,Longman

I think this check can still miss a remote partition during hotplug.
When CPU hotplug leaves no active CPU available to the top partition,
cpuset_handle_hotplug() clears subpartitions_cpus before walking the
descendants. The remote partitions are still valid at that point.

An invalid parent is visited before its remote descendant. Since the
mask is empty, this check allows the parent to become valid and add
its exclusive CPUs back to subpartitions_cpus. When the remote
descendant is visited later, those CPUs are already back in the mask,
so it passes the subset check and stays remote. We are then left with
a valid remote partition below a valid local partition, and
compute_partition_effective_cpumask() warns about the remote child.

Could we check whether there is still a valid remote partition below cs
before allowing cs to become valid? subpartitions_cpus may have been
cleared by hotplug, so the lack of overlap does not tell us that the
remote partition has actually been disabled.

Thanks,
Guopeng

> -			if (exclusive)
> +			if (!part_error)
>  				deleting = !cpumask_empty(tmp->delmask);
> -			else
> -				part_error = PERR_NOTEXCL;
>  		}
>  	}
>  
> @@ -2174,7 +2184,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  			break;
>  		case PRS_INVALID_ROOT:
>  		case PRS_INVALID_ISOLATED:
> -			if (!part_error)
> +			if (!part_error && deleting)
>  				new_prs = -old_prs;
>  			break;
>  		}
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 1e9e6b4c6f7b..3d873804abc2 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -563,6 +563,10 @@ TEST_MATRIX=(
>  	" C1-6:P1 C3-6:P2 C5-6:P2  .       .    P1      .      .     0 A1:1-2|A2:3-4|A3:5-6 \
>  								       A1:P1|A2:P1|A3:P2 5-6"
>  
> +	# A hotplug event will not incorrectly activate an invalid partition with
> +	# a remote partition underneath.
> +	"  CX1-4  C3-4:P1   .      .      P1   O1=0     .      .     0 A1:2|A2:3-4 A1:P-1|A2:P1"
> +
>  	#
>  	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>  	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------

