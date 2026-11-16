Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.192
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794800846;
	b=EjRwz1c0ot3F3V9tIrQNhDANNoKj1sRWZ1JnPyxTvh/jjPBJp9b913m2Gm94RfQkVoXL
	 sklDz7Bg8QUA7N/Rgp4+k/zRG0RfRJ74iBjy4JowJmv2oSdbnWh24fPRL9LlcPn+jWhas
	 P8QKb7pYatw/8hL5hrbRq/jUNl1H2/cMYTGe6T8xxCqvxMFJcg06CmAOHLQBHRxZEkysN
	 RMHtPUp5PgFMYl1okufSSN5sYDTM6IGA1/7/bsWNahll11ZLj1z+2R3wtGFmZh7Sogd6g
	 E3ydxIhI5ajRHA09BxAu2jcvPpEawDSsLs5oCzZ+I9RhS4hA48z9dl+MmxkpKn8Cafg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794800846;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=mxtGDW8k72v2ewlH5LJPbUbRhsFJxwv8c4Cyzl3vcdw=;
	b=wEjKO2D5i71EJPtQWsVG9g6c4fOqr+NOf8pqwIOCo2UUz9YE7hGtDqsqRzcCVRTtx3QI
	 /SG8+cRdPdFzmHG6TAAc6RiBn/kzLGWLj/JAkIcV6c9mHL1Fm6N0My+Jkq+sATtoaGd/L
	 HbcPAosn7J1mQK4IIfLkfC4/QA0t7xrrYi5BUXQBnWHr+UM97QjibhOsOKyM8Zk2ZcoOA
	 lIGw/ePiafjzXKvJpznNzlLAW7lLTAb17BojgADFyHheRd52bCLImP5nEDi102toDnvw3
	 JYvJdkbZ+U2andkqK+ywBdZzbjUFcORzMxEpNp/lz2k4ZloG4RCxW2h7co7z4ihxoEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EhjSukCR;
	arc=none smtp.remote-ip=91.218.175.192
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23781606A31F
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:47:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23781606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EhjSukCR
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VNKu1O3jLmEybfGZEBfN8zveOanUXXgeZB5opcIdxts=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794800842; v=1; x=1795405642;
 b=EhjSukCR3Y/ANIp+IXDEOyiSQbJGrnVmqAjyQtb4EZa/x08odp6+Zsiq4mMFRNbKyPCiJHgH
 KrOlfKsJ+SBRNQkurzrLU3RXpFdgQQ1AegB7O4PdI0HmhylxHLBtKWD3ZDOBN8yKzwK+UmDyhQk
 ePDbPW3YAktwGbQEJEMjqO8A=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3c46850778065e03;
	Mon, 16 Nov 2026 03:47:22 +0000
X-Mizu-Trace-ID: 3c46850778065e03
X-Migadu-Flow: FLOW_OUT
Message-ID: <8c126892-8e4d-4bfe-9f3f-bc1e1a72338d@linux.dev>
Date: Mon, 16 Nov 2026 11:47:14 +0800
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
Subject: Re: [PATCH-next v4 3/6] cgroup/cpuset: Check remote partition
 underneath before making an invalid partition valid
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261116012330.2271010-1-longman@redhat.com>
 <20261116012330.2271010-4-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261116012330.2271010-4-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/16/2026 9:23 AM, Waiman Long wrote:
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
> In the special case when the last active CPU in the top_cpuset partition
> is offlined, the hotplug code will empty subpartitions_cpus and let the
> existing local partition to compete for the exclusive CPUs again. If
> there is an invalid local partition above a remote partition and that
> invalid local partition is able to switch to a valid partition, the remote
> partition below will now share some the of exclusive CPUs violating the
> CPU exclusivity rule. This special case will be handled in a later patch.
> 
> Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-47715b89-d5fb-4731-b7c9-070773c6ff75
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c                        | 42 ++++++++++++-------
>   .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++
>   2 files changed, 30 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 195d4e3a283c..81481fa62cfe 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2029,11 +2029,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   		 * tasks_nocpu_error() with this very mask, and a failing
>   		 * write is routed to partcmd_invalidate instead.
>   		 */
> -		if (is_partition_invalid(cs)) {
> -			adding = false;
> -			deleting = cpumask_and(tmp->delmask,
> -					newmask, parent->effective_xcpus);
> -		} else {
> +		if (is_partition_valid(cs)) {
>   			cpumask_andnot(tmp->addmask, cs->effective_xcpus, newmask);
>   			adding = cpumask_and(tmp->addmask, tmp->addmask,
>   					     parent->effective_xcpus);
> @@ -2041,6 +2037,17 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   			cpumask_andnot(tmp->delmask, newmask, cs->effective_xcpus);
>   			deleting = cpumask_and(tmp->delmask, tmp->delmask,
>   					       parent->effective_xcpus);
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
>   		}
>   
>   		/*
> @@ -2107,34 +2114,37 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   		} else if (is_partition_invalid(cs)) {
>   			struct cgroup_subsys_state *css;
>   			struct cpuset *child;
> -			bool exclusive = true;
>   
>   			/*
>   			 * Convert invalid partition to valid has to pass the
> -			 * cpu exclusivity test when cpuset.cpus.exclusive is
> -			 * empty as well as the housekeeping check.
> +			 * following tests:
> +			 * 1) housekeeping CPU conflict check
> +			 * 2) cpu exclusivity test when cpuset.cpus.exclusive is
> +			 *    empty.
> +			 * 3) if parent is top_cpuset, none of the effective_xcpus
> +			 *    (tmp->delmask) are in subpartitions_cpus, if not a
> +			 *    remote partition may be underneath.
>   			 */
>   			if (prstate_housekeeping_conflict(cs->partition_root_state,
>   							  parent_prs, tmp->delmask, NULL)) {
>   				part_error = PERR_HKEEPING;
> -				goto write_error;
> -			}
> -			if (cpumask_empty(cs->exclusive_cpus)) {
> +			} else if (cpumask_empty(cs->exclusive_cpus)) {
>   				rcu_read_lock();
>   				cpuset_for_each_child(child, css, parent) {
>   					if (child == cs)
>   						continue;
>   					if (!cpusets_are_exclusive(cs, child)) {
> -						exclusive = false;
> +						part_error = PERR_NOTEXCL;
>   						break;
>   					}
>   				}
>   				rcu_read_unlock();
> +			} else if ((parent == &top_cpuset) &&
> +				   cpumask_intersects(tmp->delmask, subpartitions_cpus)) {
> +				part_error = PERR_REMOTE;
>   			}
> -			if (exclusive)
> +			if (!part_error)
>   				deleting = !cpumask_empty(tmp->delmask);
> -			else
> -				part_error = PERR_NOTEXCL;
>   		}
>   	}
>   
> @@ -2155,7 +2165,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>   			break;
>   		case PRS_INVALID_ROOT:
>   		case PRS_INVALID_ISOLATED:
> -			if (!part_error)
> +			if (!part_error && deleting)
>   				new_prs = -old_prs;
>   			break;
>   		}

Nit: deleting is always true when part_error is 0, so this check
doesn't change anything. It's fine to keep it as a safeguard, but
then the changelog shouldn't describe it as a fix.

Typos in the changelog: "swtiching", "share some the of".

Otherwise,

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>


> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 1397ec428c46..81f0eecaca80 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -563,6 +563,10 @@ TEST_MATRIX=(
>   	" C1-6:P1 C3-6:P2 C5-6:P2  .       .    P1      .      .     0 A1:1-2|A2:3-4|A3:5-6 \
>   								       A1:P1|A2:P1|A3:P2 5-6"
>   
> +	# A hotplug event will not incorrectly activate an invalid partition with
> +	# a remote partition underneath.
> +	"  CX1-4  C3-4:P1   .      .      P1   O1=0     .      .     0 A1:2|A2:3-4 A1:P-1|A2:P1"
> +
>   	#
>   	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>   	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------

-- 
Best regards
Ridong

