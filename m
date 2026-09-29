Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A7C3783C3;
	Tue, 29 Sep 2026 02:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790647640; cv=none; b=bZaqMH8U65um9LRoCGuvIlEgNTsz0TrhO2EIf9tZx6bsVS6He6/UUbb+8n3Pc0N75PaNhgD8wohZ/BmWeIj/3sMvAe5KrA9ue5J78e2V148Ch9y0B8/Z7+Wr/LnuG5p8Bsqqeq11hOoVOOxxVLKsZx0bQ6jWTBzavFEd8mPlUBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790647640; c=relaxed/simple;
	bh=aE96zJr67kH87ZzJpOUnfS7IQIJx8pXfv8T/Iq1xJcI=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ub6arHApYPORTZt5V0BYk9koIBcGNnOiYrcFDPxzEm6BFSKcHhyg7Hp4evNfpoMnnMepcMqBdKiKV9yJjfVFgODD5W8nP+EBT3LGX/qxfLswZGuPyxe8bsSQtbCXj0UODPQE/TLFfASauexG99mnY9ngqA2r1yBIycX1imoWg4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fOAnRJKg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fOAnRJKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B35E1F000FF;
	Tue, 29 Sep 2026 02:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790647638;
	bh=0oFuEd6wtq46KTeuSqyE3yQTRsrXC8YYPEexGHBfeJE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fOAnRJKg3WU49qaLOTHoQiboYV1kOch2/JcHCVX/IupmO10AfAU08bxE3//oXwS4/
	 tnWJb07aq8bQQhvN8tZcB3XqOdSOQTYIjmCznTtUBXlqUYEpz8gDQC2r9LjjzqFgcL
	 DO6EXz08yhbwfj/GWNgEMRW6aYLWubJHyB3vijyVSsD0GYUBjwzgIRaVBVszDUK84S
	 0ulWCjoVXG0w8zmtBQYANpGeJMA+4WvBcworv5q1y9QQlAbxfOshilrrPceQ3/0aN+
	 L+dvYZP4kxpRFxPq+Xcx++fplfzSu9a9IVWhva3tdwuJWhrpFFhmC7kzqg4bRXK0l9
	 fpMwM/qJkpniA==
Date: Mon, 28 Sep 2026 16:07:17 -1000
Message-ID: <941e5affde16b803741ddaf87b937f3d@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Hui Peng <benquike@gmail.com>,
 Guopeng Zhang <guopeng.zhang@linux.dev>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: Properly disable partition when
 partition state switching fails
In-Reply-To: <20260928235159.515654-1-longman@redhat.com>
References: <20260928235159.515654-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello, Waiman.

The following is a Claude-generated review.

On Mon, Sep 28, 2026 at 07:51:59PM -0400, Waiman Long wrote:
> Before commit 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full
> don't leave any housekeeping"), the partition state can be freely switched
> from "root" to "isolated" and vice versa. After that commit, the switch
> from "root" to "isolated" can fail if it exhausts all the housekeeping
> CPUs. Later on, the switch from "isolated" to "root" can also fail if
> some of the partition CPUs are boot-time isolated by "isolcpus".

The isolated -> root failure came from b1034a690129 ("cgroup/cpuset:
Ensure domain isolated CPUs stay in root or isolated partition"). Maybe
add a Fixes: tag for it too?

> The partition is made invalid when the switch fails. However, the
> remote_partition flag for a remote partition can remain set and the CPUs
> from the invalidated partition aren't cleared from subpartitions_cpus.
> Fix this by properly disable the partition in this case.

The reproducer below is a local partition and the fix covers that case
too. The CPUs weren't given back to the parent, which is what leaves them
in subpartitions_cpus and isolated_cpus in the example. Maybe describe
both? Also, "properly disable" -> "disabling".

> In the case of remote_partition flag, it should be cleared for a
> invalidated remote partition. To be safe, the reset_partition_data() is
> now enhanced to always clear the remote_partition flag. So there is no
> need to explicitly clear remote_partition in remote_partition_disable().

After the update_prstate() change, every path that invalidates a remote
partition goes through remote_partition_disable(), so the other
reset_partition_data() callers never see the flag set. If one did,
clearing only the flag would leave its CPUs in subpartitions_cpus and turn
the WARN_ON_ONCE() in partition_xcpus_del() into a silent leak. Maybe drop
this part?

> On a x86 test system with boot option "isolcpus=10 cgroup_debug" set
> and more than 16 cores, the following commands was executed after boot.

"a x86" -> "an x86", "commands was" -> "commands were".

> @@ -2946,27 +2947,32 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  		 */
>  		if (((new_prs == PRS_ISOLATED) &&
>  		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
> -		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
> +		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus)) {
>  			err = PERR_HKEEPING;
> -		else
> +			disable_partition = true;

If a root -> isolated switch fails isolated_cpus_can_update() under an
isolated parent, partcmd_disable hands the CPUs back to the parent and
partition_xcpus_del() adds them to isolated_cpus, which is the state the
check just rejected. Switching to member ends up in the same place, so
this may be fine as is.

> +	}
> +out:
> +	if (disable_partition) {

The early goto out paths never need the disable. Maybe put this block
before out: instead?

Also, update_cpumasks_hier() below gets force only when switching to
member, to update effective_xcpus. Now that the failure path disables the
partition too, should it pass disable_partition?

Separately, a partition invalidated with PERR_HKEEPING can become valid
again through partcmd_update without newmask (hotplug, or
update_cpumasks_hier() from an ancestor), which doesn't check
housekeeping. A failed member -> root enable has the same problem, so it
isn't from this patch.

Thanks.

--
tejun
