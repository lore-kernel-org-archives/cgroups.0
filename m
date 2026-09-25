Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A35819D074
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 19:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790364166; cv=none; b=pBhPdLuX3i2GiMyqe9zHEBgdz9oLmKFjDB3Ubp+/dgYVTpEucoiEOGHG1NhvortxzxeK9k9LG0xE/AREKa+gVV6EAGvhtPxoJd16C9gL9IL2wZFx7l41ghYqFbxMNaVHWe5Pyj1CQlqstKUJjfb/NniAq+ZZl7013uvi12beGr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790364166; c=relaxed/simple;
	bh=bQdHUqZ89Dat9b4twM81FEqBHQkZuZ38nbP+8euFmpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJK46x+buiEz5bdz+ODo1ZFHO9HsjTdKSlvlITww7JsPe04jihlicpeVFxgjjf6c1tQYMPjb/UCcY1JP35NGACnnm+66PSlYmGBDFnYIsyPB9GECfK5xmnomGMCR+OYey2kT55sq6z2tnfhwxqj33XPyDdJ0bjNKxGWGAGI/RaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RpLIZCgg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RpLIZCgg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790364159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aWk4K3bjs72mNw+sBMqiIvaUwaOVCuWNNLV5F6PcuRc=;
	b=RpLIZCggpE+nhsrFbpffE8ojHctVl5d5m03rV06jsXrvrIbuJDrFqgBi9gjeqy7szJxbbU
	oVampqdDXJpTxkIuRwbJioMgcT1WDhp0NJ4dH7klS3VWg+YqsRmQrQDVGOqITbYanivAOr
	4R5JTVr9ac8ul8mmpTe0FWDSlTdZgoY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-163-Ke7tYFS9MfOCqCl9BWIvpQ-1; Fri,
 25 Sep 2026 15:22:35 -0400
X-MC-Unique: Ke7tYFS9MfOCqCl9BWIvpQ-1
X-Mimecast-MFC-AGG-ID: Ke7tYFS9MfOCqCl9BWIvpQ_1790364153
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76EE61911B23;
	Fri, 25 Sep 2026 19:22:32 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 38DF141D;
	Fri, 25 Sep 2026 19:22:30 +0000 (UTC)
Message-ID: <547bea01-880a-4a87-8cbc-a632f087f896@redhat.com>
Date: Fri, 25 Sep 2026 15:22:29 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] cgroup/cpuset: return PERR_NOCPUS in
 remote_partition_enable() on subpartitions_cpus conflict
To: Hui Peng <benquike@gmail.com>, Ridong Chen <ridong.chen@linux.dev>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Shuah Khan <shuah@kernel.org>, Chen Ridong <chenridong@huawei.com>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260924042729.1908863-1-benquike@gmail.com>
 <20260924042729.1908863-2-benquike@gmail.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260924042729.1908863-2-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 9/24/26 12:27 AM, Hui Peng wrote:
> When a remote partition is created underneath an existing local partition
> via a non-partition (PRS_MEMBER) intermediate cgroup, update_prstate() sees
> parent->partition_root_state == PRS_MEMBER and calls
> remote_partition_enable().
>
> Commit 86888c7bd117 ("cgroup/cpuset: Add warnings to catch inconsistency
> in exclusive CPUs") replaced the cpumask_intersects(tmp->new_cpus,
> subpartitions_cpus) error check in remote_partition_enable() with
> WARN_ON_ONCE(). As a result, remote_partition_enable() emits a warning
> and proceeds to enable the remote partition on CPUs that are already
> owned by the ancestor local partition in subpartitions_cpus.
>
> This can be reproduced on Linux 7.3.0-rc3 with:
>
>    mkdir -p /tmp/cg1
>    mount -t cgroup2 none /tmp/cg1
>    echo "+cpuset" > /tmp/cg1/cgroup.subtree_control
>
>    mkdir /tmp/cg1/A
>    echo 1 > /tmp/cg1/A/cpuset.cpus
>    echo 1 > /tmp/cg1/A/cpuset.cpus.exclusive
>    echo root > /tmp/cg1/A/cpuset.cpus.partition
>    echo "+cpuset" > /tmp/cg1/A/cgroup.subtree_control
>
>    mkdir /tmp/cg1/A/B
>    echo 1 > /tmp/cg1/A/B/cpuset.cpus
>    echo 1 > /tmp/cg1/A/B/cpuset.cpus.exclusive
>    echo "+cpuset" > /tmp/cg1/A/B/cgroup.subtree_control
>
>    mkdir /tmp/cg1/A/B/D
>    echo 1 > /tmp/cg1/A/B/D/cpuset.cpus
>    echo 1 > /tmp/cg1/A/B/D/cpuset.cpus.exclusive
>    echo root > /tmp/cg1/A/B/D/cpuset.cpus.partition
>
> which triggers:
>
>    WARNING: kernel/cgroup/cpuset.c:1594 at remote_partition_enable+0x1c1/0x300
>
> and leaves both /tmp/cg1/A and /tmp/cg1/A/B/D as active root partitions
> claiming exclusive CPU 1.
>
> Fix this by returning PERR_NOCPUS when tmp->new_cpus intersects
> subpartitions_cpus in remote_partition_enable(), matching the error code
> used by remote_cpus_update() for the same subpartitions_cpus conflict, and
> add a regression test case to
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
>
> Tested in QEMU on Linux 7.3.0-rc3 using the reproducer above and
> tools/testing/selftests/cgroup/test_cpuset_prs.sh.
>
> Fixes: 86888c7bd117 ("cgroup/cpuset: Add warnings to catch inconsistency in exclusive CPUs"

Technically, this commit isn't  wrong as it does not expect that a 
remote partition can be created under a local partition. I will put the 
commit to be fixed as 181c8e091aae ("cgroup/cpuset: Introduce remote 
partition").

Other than that, it looks good to me.

Reviewed-by: Waiman Long <longman@redhat.com>

> Suggested-by: Guopeng Zhang <guopeng.zhang@linux.dev>
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
>   kernel/cgroup/cpuset.c                            | 3 ++-
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2538faac9aba..7381fa8502e7 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1591,10 +1591,11 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>   	 * above it or remote partition root underneath it is not allowed.
>   	 */
>   	compute_excpus(cs, tmp->new_cpus);
> -	WARN_ON_ONCE(cpumask_intersects(tmp->new_cpus, subpartitions_cpus));
>   	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
>   	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
>   		return PERR_INVCPUS;
> +	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
> +		return PERR_NOCPUS;
>   	if (((new_prs == PRS_ISOLATED) &&
>   	     !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
>   	    prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 3f7e81709365..b732078bf319 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -298,6 +298,8 @@ TEST_MATRIX=(
>   	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
>   				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
>   								       A1:P0|A2:P2|A3:P-1 2-4"
> +	" CX1-3:P1 CX1-3  CX1-3    .      .      .      P1      .    0 A1:1-3|A2:1-3|A3:1-3 \
> +								       A1:P1|A2:P0|A3:P-1"
>   
>   	# Remote partition offline tests
>   	"   C0-3    C1-3  C2-3     .    X2-3   X2-3 X2-3:P2:O2=0 .   0 A1:0-1|A2:1|A3:3 A1:P0|A3:P2 2-3"

