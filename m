Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ABE3672BF
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 14:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787582233; cv=none; b=pH/uTnxY7jEJoMNlfNL9ojNwE0XfFqB4NvtMqaRZNBOY7MYNdrbU+s11wrx5c3v7fBoY9RTYUDHtxcyprM9N8+iMMY2XJ+nhewRjVt95u0DHtk4VcqnQlK5O5QJAvHlvtehH+Fus0noycsM/FDsvEmqkPsBahOB91srSo6foHtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787582233; c=relaxed/simple;
	bh=E95yqgu+uc/18j/95ZEM/xLlM0SYg+YIYsKPiW9JzhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XMXKpw6k8+ca+uzn3sQqWVN8GuYN3Otj6HGRJwjSCCAsnRA7NEMCe7zROIN/0nzS99mNNtkcZYBn20vopbK32wi8vW2l7WCVCPHqaOGECIUcklUpph3vitArjXdg5pvyNxKFRY3ULw8Kc8ZpXSZL7HTF5BwNkRwDq9EIaeVugnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J4C9ctMD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J4C9ctMD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CLfKTflZCIezVxGilF5qGmiTx8Ok8bqVruJftZGAGYs=;
	b=J4C9ctMDmkd2FdrMUoIwzd/pMD/gHi7EjMPAoSUWcvfcH7IGcyM7u8xx6uycz+6KEZJZSy
	Zlu0EJAaXGVxFmfMiyXXgcgRQpHpRKCyUtijGmZkQ5vOQ4tEPrz1RxXz49juCY26NRHQGw
	CO4EZ8Q9rtVvoimg711qcIqgJj7YJKE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-LJsUzn1bPr6kjEKCGZUQ6g-1; Mon,
 24 Aug 2026 10:37:07 -0400
X-MC-Unique: LJsUzn1bPr6kjEKCGZUQ6g-1
X-Mimecast-MFC-AGG-ID: LJsUzn1bPr6kjEKCGZUQ6g_1787582225
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FB021955DD0;
	Mon, 24 Aug 2026 14:37:04 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D0C2F1955D6D;
	Mon, 24 Aug 2026 14:37:01 +0000 (UTC)
Message-ID: <0a9afea3-bd0c-42af-8c92-6f2d54348d1e@redhat.com>
Date: Mon, 24 Aug 2026 10:37:00 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/17] cgroup/cpuset: Release CPUs when a type change is
 rejected
To: Guopeng Zhang <guopeng.zhang@linux.dev>, cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
 <20260820124202.517160-9-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260820124202.517160-9-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 8/20/26 8:41 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> When a housekeeping check rejects a root-to-isolated or isolated-to-root
> change, update_prstate() marks the partition invalid but leaves its
> effective_xcpus allocated. Those CPUs remain missing from the partition
> which owns the invalidated subtree.
>
> Disable a rejected remote partition with remote_partition_disable().
> For a local partition, return effective_xcpus to its parent before
> recording the invalid state. Use the complete mask because descendants
> are invalidated along with the parent and their CPUs return at the same
> time.
>
> Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 853942c1afeb..a616012927be 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3020,10 +3020,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>   		compute_partition_owned_cpumask(cs, tmpmask.new_cpus);
>   		if (((new_prs == PRS_ISOLATED) &&
>   		     !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
> -		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus))
> +		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus)) {
>   			err = PERR_HKEEPING;
> -		else
> +			if (is_remote_partition(cs)) {
> +				WRITE_ONCE(cs->prs_err, err);
This WRITE_ONCE() is not necessary as it will be done later in the 
function.
> +				remote_partition_disable(cs, &tmpmask);
> +			} else {
> +				spin_lock_irq(&callback_lock);
> +				partition_xcpus_del(old_prs, parent, cs->effective_xcpus);
> +				spin_unlock_irq(&callback_lock);
> +				cpuset_update_tasks_cpumask(parent, tmpmask.new_cpus);
> +				update_sibling_cpumasks(parent, cs, &tmpmask);
> +			}

This code to disable the partition is duplicating what is being done in 
the last else clause of the outer if, but in a somewhat different way. 
That is not good programming practice. You can either jump to the 
partition disabling code below or separate out the partition disabling 
code controlled by a separate control flag and set the flag to do it.

Cheers,
Longman

> +		} else {
>   			isolcpus_updated = true;
> +		}
>   	} else {
>   		/*
>   		 * Switching back to member is always allowed even if it

