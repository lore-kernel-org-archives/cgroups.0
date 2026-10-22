Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640098;
	b=WMqYMrTAhTm7Y81VOnH2OfnoaMhBapViXoo1wPMyCprUboWe+p3MMIc8llgzUTV51lU+
	 a+WEK0c5s9WkIzA+nSI4e58WLrPJHq88aSomLEY0/nxT2GnrhroYIfM5jUEa0UCv8KpMj
	 Yy/WxZVXzXZoOVshyw5I+YDhk5p1hUlJxJLS9pk5e2yfgr5uLkv9gUtojlN7/nTU8d2LV
	 rFDWflLmbtw14gypgkLveFZzw3YUMHutBWU+KBj4z597oVmcSUA8UfNyISoLjk62GcIda
	 G+M9wpTGtkj7lP8uIPVmv0l36tsXioOzW0G5RIve7F0ruc7B/j7c+qnliTsSFHKKpNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640098;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=RowDvTGb4ELInwDHcAfgOokyo9acekEdzcJ9i+SgpJo=;
	b=0ho+VLrPU6DJQUAd0+SZREXrCA/Aq3LlbXIzQ519TfXDl5CXdHSMoQv5Z+deuZThzavJ
	 xbPJ06L9C76qMIluw2vi+CjvwmSl5RLwuaEWAeNqoWKKruNZgKIUxGADYHfYwOpSSDMm2
	 S2vAvGL9XQq3UAT+0lvujMmo1tEsuwcMPTrayUEjpWCbYFFpcpJq3f/46VhVkM5WXJ66j
	 CdxQ/LdywiCJp5tSOT+3TC4aGGCxqEUaesFJsZRJ1bjsys3QG/kbgt2WCHSTFA9BkM2FE
	 FdHCuGA0xPAZI6KdbOHZSFfDqg/Q96TRI/uisAu7tZKYFGShqNPNugR3do2SELhRnVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dXiuUNG8;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B81606A31B
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 03:34:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9B81606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dXiuUNG8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792640096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RowDvTGb4ELInwDHcAfgOokyo9acekEdzcJ9i+SgpJo=;
	b=dXiuUNG8XGzwW65WYYRTKCeEqlz7fwYXtnvECN8We4Wh89Y2z10AQfbq6ks1hyV0itp9M7
	UqKuqBOO9KGq9CSDPP3+YrnPrIGn3KWmNT2ve9JRN+FnpzRbIVD28/sQenoJMgupL+lA8y
	qnpQO+Bmbee+jVMmhKeRD+kQG+yKXGo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-241-dbi6avkgMBKkYmVRBiayhA-1; Wed,
 21 Oct 2026 23:34:53 -0400
X-MC-Unique: dbi6avkgMBKkYmVRBiayhA-1
X-Mimecast-MFC-AGG-ID: dbi6avkgMBKkYmVRBiayhA_1792640091
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DECA19560B8;
	Thu, 22 Oct 2026 03:34:51 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 37A057DE;
	Thu, 22 Oct 2026 03:34:49 +0000 (UTC)
Message-ID: <d8786672-a864-4029-8b15-ecfc7f0d734a@redhat.com>
Date: Wed, 21 Oct 2026 23:34:48 -0400
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
Subject: Re: [PATCH] cgroup/cpuset: Fix task checking when enabling a
 partition
To: Guopeng Zhang <guopeng.zhang@linux.dev>, tj@kernel.org
Cc: ridong.chen@linux.dev, hannes@cmpxchg.org, mkoutny@suse.com,
 shuah@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261020133615.124373-1-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261020133615.124373-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 10/20/26 9:36 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> Creating a child partition can fail when tasks are present in its
> descendants, even though the parent has no tasks of its own.
>
> On a cgroup v2 system with CPUs 0-7 online:
>
>      cd /sys/fs/cgroup
>      echo +cpuset > cgroup.subtree_control
>      mkdir A
>      echo 1-2 > A/cpuset.cpus
>      echo root > A/cpuset.cpus.partition
>      echo +cpuset > A/cgroup.subtree_control
>      mkdir A/B
>      echo 1-2 > A/B/cpuset.cpus
>      echo +cpuset > A/B/cgroup.subtree_control
>      mkdir A/B/C
>      echo 1-2 > A/B/C/cpuset.cpus
>      echo $$ > A/B/C/cgroup.procs
>      echo root > A/B/cpuset.cpus.partition
>      cat A/B/cpuset.cpus.partition
>      root invalid (Parent unable to distribute cpu downstream)
>      cat A/cpuset.cpus.effective
>      1-2
>
> B should be a valid root, leaving A with an empty effective CPU list.
> The task in C belongs to B's partition and does not need CPUs in A.
>
> partition_is_populated() is called with B as excluded_child, but
> continue only skips B in the pre-order walk. The walk still visits C
> and finds the task there, so A is considered populated.
>
> Fix this by skipping the whole excluded subtree with
> css_rightmost_descendant(), as is already done for valid child
> partitions. Also add a test case to test_cpuset_prs.sh with a task in
> a grandchild cpuset.
>
> Fixes: b1bcaed1e39a ("cpuset: Treat cpusets in attaching as populated")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c                            | 4 ++--
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 3 +++
>   2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 585a982249ad..71644482faa7 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -478,10 +478,10 @@ static inline bool partition_is_populated(struct cpuset *cs,
>   
>   	rcu_read_lock();
>   	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
> -		if (cp == cs || cp == excluded_child)
> +		if (cp == cs)
>   			continue;
>   
> -		if (is_partition_valid(cp)) {
> +		if (cp == excluded_child || is_partition_valid(cp)) {
>   			pos_css = css_rightmost_descendant(pos_css);
>   			continue;
>   		}
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index d04aad697b96..9978c560b398 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -452,6 +452,9 @@ TEST_MATRIX=(
>   	# Enabling partition with child cpusets is allowed
>   	"   C0-1    C1      .    C2-3    P1      .      .      .     0 A1:0-1|A2:1 A1:P1"
>   
> +	# Tasks below a new partition belong to it, not to its parent.
> +	" C1-2:P1 C1-2 C1-2:T    .      .      P1     .      .     0 A1:|A2:1-2|A3:1-2 A1:P1|A2:P1"
> +
>   	# A partition root with non-partition root parent is invalid| but it
>   	# can be made valid if its parent becomes a partition root too.
>   	"   C0-1    C1      .    C2-3     .      P2     .      .     0 A1:0-1|A2:1 A1:P0|A2:P-2"
Reviewed-by: Waiman Long <longman@redhat.com>

