Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55D01C862F
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 03:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121462; cv=none; b=q5F0zJWLHY0uRulFdOnRItzxxWERZo8Ba/YjJoFR3Bf3XNnWuEoclnrV7+CWbN5+23KIKglgSRjVxyP/EYIbVsLDNoro97Z0d+2OhYCXfqtFH6fmPg5eT1R+iJB2rcfj8dgLC0izHbT+u+vhOTzkMNExAUTQg9bjTDbl+flvQvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121462; c=relaxed/simple;
	bh=UuPBc3LRsWbAd4egcVpTfpxrv4fiEWFXnS5VgV5rga8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GJS0YIepi6GTt4tBtjV2xGAYkG1c5LCMO3iSopr5MbIsDRElt9D7ADs9Kx3n2duMmUkweJBRaTDLWomnFJHfVoB5xYwfn9/doZdXL2vDCRVW/rjKJ/3n5m4njyodDYS5WtZeQQu/81XlzNMrti9cAEzL+ghEh5YgjQ6kBExthZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tUsYPxz1; arc=none smtp.client-ip=95.215.58.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tUsYPxz1"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=UuPBc3LRsWbAd4egcVpTfpxrv4fiEWFXnS5VgV5rga8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792121457; v=1; x=1792726257;
 b=tUsYPxz1taAWGICGaHkh76UH6SsAIJC+Jbb/cGOr0LfnC7pQ62P2k48Ngu5N+Ueq4hgxmWFT
 bTzi2E+/23dOy/wTI7yx4IhJPv5fuRGduU+2iiP4lEtvq4E/RZjjvzkra+G8ZqdbQKGvKGf6iNF
 b5ipZ8iturK3zdJe9GrXOIns=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 665f0c2d48d1a662;
	Fri, 16 Oct 2026 03:30:57 +0000
X-Mizu-Trace-ID: 665f0c2d48d1a662
X-Migadu-Flow: FLOW_OUT
Message-ID: <497db854-17ba-47ae-a9e0-8f1dacb0b205@linux.dev>
Date: Fri, 16 Oct 2026 11:30:47 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v3 6/9] cgroup/cpuset: Don't allow a child root
 partition under an isolated parent
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
References: <20261014140548.575122-1-longman@redhat.com>
 <20261014140548.575122-7-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261014140548.575122-7-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/14 22:05, Waiman Long 写道:
> Although it is not typical for real users to create a complicated nested
> partition hierarchy, it is currently allowed to create nested root and
> isolated partitions. In addition, disabling or invalidating a partition
> should always be allowed especially when the cpuset is being deleted.
> 
> With a nested root and isolated partition hierarchy, it is possible
> that all active housekeeping CPUs can be exhausted when disabling or
> invalidating a root partition and returning its CPUs to the isolated
> parent.
> 
> One way to avoid this problem is to disallow the creation of a root
> partition under an isolated parent. It is indeed a new limitation imposed
> on the existing cpuset partition functionality. However an isolated
> partition is usually a left node where scheduling and some other kernel
> noises are disabled. It doesn't make much sense to create a child root
> partition under an isolated parent and remove some CPUs from the set
> of isolated CPUs again. Creation of a child isolated partition under a
> root or isolated parent is still allowed.
> 
> The cgroup-v2 documentation is also updated to reflect this new
> limitation. New test cases are added to test_cpuset_prs.sh to verify
> this new behavior. Some existing test cases are also updated accordingly.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst           |  4 +++-
>  kernel/cgroup/cpuset-internal.h                   |  1 +
>  kernel/cgroup/cpuset.c                            | 13 +++++++++++++
>  tools/testing/selftests/cgroup/test_cpuset_prs.sh | 14 ++++++++------
>  4 files changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index bd8c80f3bbc9..2c445829e24d 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2767,7 +2767,9 @@ Cpuset Interface Files
>  	be retained, but behaves more like a "member".
>  
>  	All possible state transitions among "member", "root" and
> -	"isolated" are allowed.
> +	"isolated" are allowed with the exception that a local child
> +	"root" partition is not allowed to be created under an "isolated"
> +	parent partition.
>  
>  	On read, the "cpuset.cpus.partition" file can show the following
>  	values.
> diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
> index 5da9c91295b0..2e44dc8634dc 100644
> --- a/kernel/cgroup/cpuset-internal.h
> +++ b/kernel/cgroup/cpuset-internal.h
> @@ -35,6 +35,7 @@ enum prs_errcode {
>  	PERR_HKEEPING,
>  	PERR_ACCESS,
>  	PERR_REMOTE,
> +	PERR_ISOPARENT,
>  };
>  
>  /* bits in struct cpuset flags field */
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 40c004386af0..681701ba46e1 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -60,6 +60,7 @@ static const char * const perr_strings[] = {
>  	[PERR_HKEEPING]  = "partition config conflicts with housekeeping setup",
>  	[PERR_ACCESS]    = "Enable partition not permitted",
>  	[PERR_REMOTE]    = "Have remote partition underneath",
> +	[PERR_ISOPARENT] = "Root partition is not allowed with isolated parent",
>  };
>  
>  /*
> @@ -2865,6 +2866,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  	int err = PERR_NONE, old_prs = cs->partition_root_state;
>  	struct cpuset *parent = parent_cs(cs);
>  	struct tmpmasks tmpmask;
> +	int parent_prs = parent->partition_root_state;
>  	bool isolcpus_updated = false;
>  	bool disable_partition = false;
>  
> @@ -2910,6 +2912,14 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  			enum partition_cmd cmd = (new_prs == PRS_ROOT)
>  					       ? partcmd_enable : partcmd_enablei;
>  
> +			/*
> +			 * It is not allowed to create a root partition under
> +			 * an isolated parent partition.
> +			 */
> +			if ((new_prs == PRS_ROOT) && (parent_prs == PRS_ISOLATED)) {
> +				err = PERR_ISOPARENT;
> +				goto out;
> +			}

I tested the following case. Writing root initially leaves C invalid, but
updating its cpuset.cpus makes it valid again.

CPUs 0-15 are online, with nohz_full=2-15 and no isolcpus:

    # cd /sys/fs/cgroup
    # echo +cpuset > cgroup.subtree_control
    # mkdir A
    # echo 1-2 > A/cpuset.cpus
    # echo isolated > A/cpuset.cpus.partition
    # echo +cpuset > A/cgroup.subtree_control
    # mkdir A/C
    # echo 1 > A/C/cpuset.cpus
    # echo root > A/C/cpuset.cpus.partition
    # cat A/C/cpuset.cpus.partition
    root invalid (Root partition is not allowed with isolated parent)
    # echo 1-2 > A/C/cpuset.cpus
    # cat A/C/cpuset.cpus.partition
    root

C becomes a valid root partition.

Thanks,
Guopeng

>  			err = update_parent_effective_cpumask(cs, cmd, NULL, &tmpmask);
>  		} else {
>  			err = remote_partition_enable(cs, new_prs, &tmpmask);
> @@ -2922,6 +2932,9 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  		if (prstate_housekeeping_conflict(new_prs, cs->effective_xcpus)) {
>  			disable_partition = true;
>  			err = PERR_HKEEPING;
> +		} else if (parent_prs == PRS_ISOLATED) {
> +			disable_partition = true;
> +			err = PERR_ISOPARENT;
>  		} else {
>  			isolcpus_updated = true;
>  		}
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 874a8a161236..85a4f87840b4 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -288,16 +288,12 @@ TEST_MATRIX=(
>  								       A1:P0|A2:P1|A3:P0|B1:P1"
>  	"   C0-3    C1-3   C3     C4    X2-3  X2-3:P1   P2     P1    0 A1:0-1|A2:2|A3:3|B1:4 \
>  								       A1:P0|A2:P1|A3:P2|B1:P1 2-4|3"
> -	"   C0-4    C1-4  C2-4     .    X2-4  X2-4:P2  X4:P1    .    0 A1:0-1|A2:2-3|A3:4 \
> -								       A1:P0|A2:P2|A3:P1 2-4|2-3"
> -	"   C0-4    C1-4  C2-4     .    X2-4  X2-4:P2 X3-4:P1   .    0 A1:0-1|A2:2|A3:3-4 \
> -								       A1:P0|A2:P2|A3:P1 2"
>  	" C0-4:X2-4 C1-4:X2-4:P1 C2-4:X4:P2 \
>  				   .      .      X5      .      .    0 A1:0-4|A2:1-4|A3:2-4 \
>  								       A1:P0|A2:P-1|A3:P-2 ."
> -	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
> +	" C0-4:X2-4 C1-4:X2-4:P1 C2-4:X4:P2 \
>  				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
> -								       A1:P0|A2:P2|A3:P-1 2-4"
> +								       A1:P0|A2:P1|A3:P-2 ."
>  	" CX1-3:P1 CX1-3  CX1-3    .      .      .      P1      .    0 A1:1-3|A2:1-3|A3:1-3 \
>  								       A1:P1|A2:P0|A3:P-1"
>  
> @@ -430,6 +426,12 @@ TEST_MATRIX=(
>  	# cpuset.cpus can become empty with task in it as it inherits parent's effective CPUs
>  	"   C1-3    C2      .      .       .    T:C     .      .     0 A1:1-3|A2:1-3"
>  
> +	# Creation of root partition under an isolated partition is not allowed
> +	"  C1-3:P2  C2      .      .       .     P1     .      .     0 A1:1-3|A2:2 A1:P2|A2:P-1 1-3"
> +	"  C1-3:P2  C2      .      .       .     P2     .      .     0 A1:1,3|A2:2 A1:P2|A2:P2  1-3"
> +	"  C1-3:P2 C2:P2    .      .       .     P1     .      .     0 A1:1-3|A2:2 A1:P2|A2:P-1 1-3"
> +
> +	#
>  	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
>  	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
>  	# Failure cases:

