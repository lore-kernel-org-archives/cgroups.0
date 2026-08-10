Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126F542E8C0
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786384717; cv=none; b=pq4u/sE5QRObC0T63X5DQfKmzjF6WLvZ06MiifkNikBlwJRCNt+T23lw1UGjK7XA+vBJkhrjYSa498bctRpevE2GDkLjvms2Q8VaupnxSoHVTYrEigf9Jvj1ql5XXqKhcjH7qfPeWw7uulWKWNtiUwEzgLUXfGpE0LqHELr4TX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786384717; c=relaxed/simple;
	bh=RStTNRMDhI9a0H+Pknj0YAy4WihNQpyj21Xi9j9GJu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=otP0AMNJzVn1qy+Q9sXS8R0F7ON2RE4+V/vXKMu9oSqvQg5peAO0/z8J+qlYLPBiDCTvsd4tHJ8fRCREuGil9+P8fDWxzx+PZWVQtP0ATmc90zF+AkMwB1XEkcGVjWHTSERsFnvnIz4HGS8CEK7C1gShT30+DRV/bAiGpOraiys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FFBel2fJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FFBel2fJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786384715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wKwM2K02//G5Hg2aJElXsfQywi2yCkfei0ArlLracVQ=;
	b=FFBel2fJzraGNobmQ/ZwlpweBF8SJ7HfQyhCnD4N3QuG43YjfOjIKtlGU08Fh3PynHmfqA
	vRB24GxJoldr1cglPP3VRPC7mv4o7qBDyW8iHRR3xJ5GlbVRfBnqOBSTwF+YrBM1PMLoAW
	TlmP3IyWDUF0nJxSnS8yCgXRbDfddA0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-Hti5-ngiNTCf05GFzE4_hw-1; Mon,
 10 Aug 2026 13:58:31 -0400
X-MC-Unique: Hti5-ngiNTCf05GFzE4_hw-1
X-Mimecast-MFC-AGG-ID: Hti5-ngiNTCf05GFzE4_hw_1786384709
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 716DB1954B18;
	Mon, 10 Aug 2026 17:58:22 +0000 (UTC)
Received: from [10.22.80.220] (unknown [10.22.80.220])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BAD611800577;
	Mon, 10 Aug 2026 17:58:20 +0000 (UTC)
Message-ID: <4a8cec73-0b25-424d-9f0a-314e221211fa@redhat.com>
Date: Mon, 10 Aug 2026 13:58:19 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Add test for partition root invalidation
 returning wrong CPUs
To: Shaojie Sun <sunshaojie@kylinos.cn>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260807085950.10960-1-sunshaojie@kylinos.cn>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260807085950.10960-1-sunshaojie@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


On 8/7/26 4:59 AM, Shaojie Sun wrote:
> Add a test case covering the bug fixed by
> commit 345f40166694 ("cgroup/cpuset: Return only actually allocated
> CPUs during partition invalidation"). The test verifies that when a
> sibling partition root changes its cpuset.cpus to overlap with another
> partition root, only actually allocated CPUs (effective_xcpus) are
> returned to the parent, not all CPUs in cpus_allowed.
>
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
> ---
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 0d41aa0d343d..a44e92c94081 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -393,6 +393,12 @@ TEST_MATRIX=(
>   	"  C0-1:P1   .      .  P1:C2-3  C0-2     .      .      .     0 A1:0-1|XA1:0-1|B1:2-3 A1:P1|B1:P1"
>   	"   C0-1     .      .  P1:C2-3  C0-2     .      .      .     0 A1:0-1|B1:2-3 A1:P0|B1:P1"
>   
> +	# However, a partition root changing its own cpuset.cpus to overlap with
> +	# a sibling partition root will invalidate itself. Only actually allocated
> +	# CPUs (effective_xcpus) should be returned to the parent, not all CPUs
> +	# in cpus_allowed. The root cgroup effective CPUs must remain unchanged.
> +	"  C0-1:P1   .      .   C1-2:P1    .      .      .    C0-1    0 A1:0-1 A1:P1|B1:P-1"
> +

The cgroup hierarchy used by TEST_MATRIX may not suitable for doing this 
kind of test as you can't easily check the state of the parent cgroup. I 
would suggest you use the REMOTE_TEST_MATRIX hierarchy with p1, c11, 
c12. After making c12 conflicts with c11, you can check p1 to see if it 
has the right state.

Cheers,
Longman


>   	# cpuset.cpus can overlap with sibling cpuset.cpus.exclusive but not subsumed by it
>   	"   C0-3     .      .    C4-5     X5     .      .      .     0 A1:0-3|B1:4-5"
>   

