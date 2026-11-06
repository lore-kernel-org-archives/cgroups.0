Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793985775;
	b=CzkGIKqnMltX4BC9KBk+HYkN0ZYmP6o7m0Jd/suiS3GB60l8pTkVV0V8pZaSCLsxLZtX
	 1tuWbGgI8cMCw7gXYxDu8G/I5AWmEi6QVMMoltD6+CZshjlA8JS77QyYbbhOfgIjKLoP6
	 S6+PFyHDlRYOh1HaeB9TbUEVGMpjta5MfOIKdUgHRjiDvR/cmsLiyPz5P7hIJ5+88uBlG
	 8mgeEHTtAE6YtPHBB/3KfSwIYV0ali8rcIKkkzzZbNe6pY37ntpXvRalwe2a45WtPmAPk
	 n9mOCd3KydCTARDjSgAGP8KKpy+9i/7bxfb3wayhoL9ll1eNAjf81TBQC9rV7w8Sq7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793985775;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=nphGN6OafuQK+POULyX/FaBPk98YaajW2Mt6MczH2qo=;
	b=pn2oVwC20DHKFy4TiKE+zXu3T51lAkHUk3l9Wtc3Ui/glLLyRTw3ypRMu67vyRxbaZG7
	 vuKvmhLC+/rMeTMyluzjRnHWokVOhUgB9FvDgv+gXBC7DDXqbKOG9dmNkwnqwlnb9NRNQ
	 SuQ2fNKZRteEstWIyjmfe2I/67uhU7JslSB2cUX2Jcaosde2ODGXYueV+BxkDYDmNWU/5
	 dXXiXerZzXL5IJgPCdcqFL2PdZCe/ufSU9C4DAV2ewj9Kv2lnjFqbdYTeHdXCSJrenTGv
	 dbzEeocKbiNomyVAoZmGU6ySk4huCpqtdDgPPtwc8vW8ItFL3gPShKey/nSCmgG1ISw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Jky+WQjd;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377DC606A32D
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 17:22:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 377DC606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Jky+WQjd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793985774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nphGN6OafuQK+POULyX/FaBPk98YaajW2Mt6MczH2qo=;
	b=Jky+WQjd0fVxjUywFPVLiwDMaiQCCEcT5s6tQ+7MrH6Lx3YzEjRMvRB7F8DKD87nv0Tuu7
	fo5vTY1c9HbPw/JU1/On/1etl8RgfWnzXU6gwoYfag+ngJk87Y1zcUUx03Vo/BiU01USwk
	qgwEpeqZBdwMJA3L11JFANgHOFg1J4U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-WZc44TjbPKWnGjewcGzfsw-1; Fri,
 06 Nov 2026 12:22:52 -0500
X-MC-Unique: WZc44TjbPKWnGjewcGzfsw-1
X-Mimecast-MFC-AGG-ID: WZc44TjbPKWnGjewcGzfsw_1793985771
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA6831800559;
	Fri,  6 Nov 2026 17:22:50 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 72A2B39209;
	Fri,  6 Nov 2026 17:22:48 +0000 (UTC)
Message-ID: <ccdab485-e1d1-4055-bb0b-f8f712fc0a9b@redhat.com>
Date: Fri, 6 Nov 2026 12:22:47 -0500
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
Subject: Re: [PATCH v2 1/3] cgroup/cpuset: Reject updates that empty the top
 sched domain
To: Guopeng Zhang <guopeng.zhang@linux.dev>, tj@kernel.org,
 ridong.chen@linux.dev
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261105130344.664336-1-guopeng.zhang@linux.dev>
 <20261105130344.664336-2-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261105130344.664336-2-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 11/5/26 8:03 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> Boot-isolated CPUs remain in top_cpuset.effective_cpus, but are excluded
> from its scheduling domain by generate_sched_domains(). Checking only
> effective_cpus when distributing CPUs to partitions can therefore allow
> all boot domain housekeeping CPUs to be taken from the top cpuset.
>
> The resulting empty domain triggers a warning in build_sched_domains()
> and can cause an out-of-bounds CPU access in build_perf_domains(). Both
> root and isolated partitions can trigger this, whether local or remote.
> For example, on a 32-CPU system booted with isolcpus=domain,10-31:
>
>    echo 0-9 > A/cpuset.cpus
>    echo root > A/cpuset.cpus.partition
>    Oops: general protection fault
>    RIP: 0010:build_perf_domains+...
>
> Require local and remote partition creation and CPU mask updates to
> leave an active boot domain housekeeping CPU in the top cpuset,
> accounting for CPUs returned by the same update.
>
> Add test cases to test_cpuset_prs.sh to verify that every partition
> update leaves an active boot domain housekeeping CPU in the top cpuset.
>
> Fixes: 9b496a8bbed9 ("cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains")
> Co-developed-by: Ridong Chen <ridong.chen@linux.dev>
> Signed-off-by: Ridong Chen <ridong.chen@linux.dev>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c                        | 48 ++++++++++++++++++-
>   .../selftests/cgroup/test_cpuset_prs.sh       | 47 ++++++++++++++++++
>   2 files changed, 93 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3052413e41e7..c405719ccd12 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1180,12 +1180,56 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
>   		cpuset_force_rebuild();
>   }
>   
> +/*
> + * top_cpuset_sd_nocpu - Check if top_cpuset will have no sched domain CPU
> + * @add_cpus: CPUs to be taken away from top_cpuset
> + * @del_cpus: CPUs to be given back to top_cpuset, can be NULL
> + * Return: true if no active CPU will be left in the top_cpuset sched domain
> + *
> + * Note that @del_cpus may include CPUs that are also in @add_cpus and
> + * will stay in the partition. They are skipped by the @add_cpus check,
> + * so callers can pass the current effective_xcpus of a partition
> + * without masking it first.
> + *
> + * Boot time isolated CPUs stay in top_cpuset.effective_cpus, but they are
> + * excluded from the sched domain of top_cpuset in generate_sched_domains().
> + * So checking top_cpuset.effective_cpus alone is not enough to ensure that
> + * the top_cpuset sched domain won't become empty after @add_cpus are taken
> + * away from it. The sched domain of top_cpuset must keep at least one
> + * active boot domain housekeeping CPU.
> + */
> +static bool top_cpuset_sd_nocpu(const struct cpumask *add_cpus,
> +				const struct cpumask *del_cpus)
> +{
> +	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
> +	int cpu;
> +
> +	for_each_cpu_and(cpu, hk_mask, cpu_active_mask) {
> +		if (cpumask_test_cpu(cpu, add_cpus))
> +			continue;
> +		if (cpumask_test_cpu(cpu, top_cpuset.effective_cpus) ||
> +		    (del_cpus && cpumask_test_cpu(cpu, del_cpus)))
> +			return false;
> +	}
> +	return true;
> +}
> +
>   /*
>    * tasks_nocpu_error - Return true if tasks will have no effective_cpus
>    */
>   static bool tasks_nocpu_error(struct cpuset *parent, struct cpuset *cs,
>   			      struct cpumask *xcpus)
>   {
> +	/*
> +	 * The top_cpuset always has tasks (kthreads at least), so its sched
> +	 * domain can't be empty. The current effective_xcpus of a valid
> +	 * partition will be given back to top_cpuset if not in @xcpus.
> +	 */
> +	if (parent == &top_cpuset &&
> +	    top_cpuset_sd_nocpu(xcpus, is_partition_valid(cs)
> +				     ? cs->effective_xcpus : NULL))
> +		return true;
> +
>   	/*
>   	 * A populated partition (cs or parent) can't have empty effective_cpus
>   	 */
> @@ -1724,7 +1768,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>   	 */
>   	compute_excpus(cs, tmp->new_cpus);
>   	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
> -	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
> +	    top_cpuset_sd_nocpu(tmp->new_cpus, NULL))
>   		return PERR_INVCPUS;
>   	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
>   		return PERR_NOCPUS;
> @@ -1828,7 +1872,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>   		if (!capable(CAP_SYS_ADMIN))
>   			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
>   		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
> -			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
> +			 top_cpuset_sd_nocpu(tmp->addmask, tmp->delmask))
>   			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
>   		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
>   						       excpus, tmp->delmask))
The code change above looks good to me.
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index bdca6c471f87..e813ea9959f4 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -133,6 +133,15 @@ LAST_PRESENT_CPU=$(cat /sys/devices/system/cpu/present | sed -e "s/.*[,-]//")
>   [[ -n "$FIRST_NOHZ_FULL_CPU" && "$FIRST_NOHZ_FULL_CPU" = 8 &&
>      "$LAST_NOHZ_FULL_CPU" = $LAST_PRESENT_CPU ]] && RUN_NOHZ_FULL_TESTS=1
>   
> +# These tests require boot domain housekeeping CPUs to be exactly 0-9.
> +# Check the actual masks to cover isolcpus= with or without explicit flags.
> +DOMAIN_ISOLCPUS="10-$LAST_PRESENT_CPU"
> +[[ "$LAST_PRESENT_CPU" = 10 ]] && DOMAIN_ISOLCPUS=10
I think you should use "==", not "=".
> +RUN_ISOLCPUS_DOMAIN_TESTS=
> +[[ -z "$NOHZ_FULL_CPUS" &&
> +	"$(cat /sys/devices/system/cpu/isolated)" = "$DOMAIN_ISOLCPUS" ]] &&
> +	RUN_ISOLCPUS_DOMAIN_TESTS=1

Why there shouldn't be any nohz_full CPUs? Domain isolated CPUs and 
nohz_full CPUs don't need to be exclusive.

Maybe you can move the new testing code below the ISOLCPUS section as 
the value of /sys/devices/system/cpu/isolated would have been read into 
the BOOT_ISOLCPUS variable which you can use instead of reading the 
sysfs file again.

> +
>   #
>   # If isolated CPUs have been reserved at boot time (as shown in
>   # /sys/devices/system/cpu/isolated), these isolated CPUs should be outside of
> @@ -602,6 +611,43 @@ ISOLCPUS_TEST_MATRIX=(
>   	" CX1-2,I:X1,I:P1 . .      .     X1,2,I  .      .      .     0 A1:1-2,I|XA1:1-2,I A1:P-1 ."
>   )
>   
> +# Test matrix for isolcpus=domain,10-<last> or isolcpus=10-<last> boots.
> +# The top cpuset must retain an active boot domain housekeeping CPU.
> +ISOLCPUS_DOMAIN_TEST_MATRIX=(
> +	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
> +	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
> +	# Neither a root nor an isolated partition may take all boot HK CPUs.
> +	" C0-9      .      .      .     P1      .      .      .     0 A1:0-9 A1:P-1 ."
> +	" C0-9      .      .      .     P2      .      .      .     0 A1:0-9 A1:P-2 ."
> +
> +	# Growing cpuset.cpus must not take the last top-level HK CPU.
> +	" C0-8:P1   .      .      .    C0-9     .      .      .     0 A1:0-9 A1:P-1 ."
> +
> +	# CPUs returned by the same update can keep the top sched domain alive.
> +	" C2-9:P2   .      .      .    C0-4     .      .      .     0 A1:0-4 A1:P2 0-4"
> +
> +	# Root and isolated partitions together must leave a top-level HK CPU.
> +	" C0-4:P1   .      .     C5-9    .      .      .     P2    0 A1:0-4|B1:5-9 A1:P1|B1:P-2 ."
> +
> +	# Remote partition creation must enforce the same constraint.
> +	" X0-9    CX0-9    .      .      .     P1      .      .     0 A2:0-9 A2:P-1 ."
> +
> +	# Growing a remote partition through cpuset.cpus.exclusive is rejected.
> +	" X0-9 C0-9:X0-8:P1 .     .      .    X0-9     .      .     0 A2:0-9 A2:P-1 ."
> +
> +	# Remote CPU replacements must account for the CPUs being returned.
> +	" X0-9 C0-9:X2-9:P2 .     .      .    X0-4     .      .     0 A2:0-4 A2:P2 0-4"
> +
> +	# Local exclusive CPU updates must not consume the last top-level HK CPU.
> +	" C0-9:X0-8:P2 .   .      .    X0-9     .      .      .     0 A1:0-9 A1:P-2 ."
> +
> +	# Ancestor updates must not grow a remote partition over the last HK CPU.
> +	" X0-8 CX0-9:P1    .      .    X0-9     .      .      .     0 A2:0-9 A2:P-1 ."
> +
> +	# An invalid partition can recover once it leaves a top-level HK CPU.
> +	" C0-9:P1   .      .      .    C0-8     .      .      .     0 A1:0-8 A1:P1 ."
> +)
> +

Could you also put this new test matrix together with the other test 
matrices?

Thanks,
Longman

>   # Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 0-7
>   # This also means that CPU 8 is available and is a nohz_full CPU.
>   NOHZ_FULL_TEST_MATRIX=(
> @@ -1472,6 +1518,7 @@ test_inotify()
>   run_state_test TEST_MATRIX
>   run_remote_state_test REMOTE_TEST_MATRIX
>   TEST_ISOLCPUS=1 run_state_test ISOLCPUS_TEST_MATRIX
> +[[ -n "$RUN_ISOLCPUS_DOMAIN_TESTS" ]] && run_state_test ISOLCPUS_DOMAIN_TEST_MATRIX
>   [[ -n "$RUN_NOHZ_FULL_TESTS" ]] && run_state_test NOHZ_FULL_TEST_MATRIX
>   test_isolated
>   test_boot_isolated

