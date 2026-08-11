Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634BE38330B
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 18:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786473257; cv=none; b=FbYwxu7DV49l6UfwjfpnJ44Gbc14flABfnCkZWv511m+JUPTfadJQUi8hzb3B/s5HL9n7Qh/bSHSiekZ0YIdwt+IUadPX4Wm7b0ClS/qrUBsy852tWrWHpjOFnUjKZJe7yfBa0nz8rrW0KZgYa78HKA4UIjv0DCWca7C2uGv1D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786473257; c=relaxed/simple;
	bh=dvRoLetg55z8gdKVyUlSTPIl76+Yh2w/FgWJ3VAuuDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s7ImKNW2tO03Eslh/o1zz9LEuBTsKOds7JkbMQCbCs//uApLaHN5a3xUHuuuXzynHVcALpd3GMxka77LfQplmE1L2a4CuHuxgEs6v7yBguL3wM0EyH7cyCofj4EWhOfZMnj+bnLzpfd66TZrKaBerJdy+qWnrmUqxrlTGolNI10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJ9Xt50z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJ9Xt50z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786473254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0RVrHzwVzUXZyRLBgFRaa8g3siFTJyPwqFQjqZP67bo=;
	b=aJ9Xt50ztXkeoGgZuYfHl4JDIePI3dAvP3JsvP3QSsqGxpmSfcAPD80v3N4O5zX7lsXNUx
	Q45H8ZIW2NvoxHRFwNRsGinegdnJ4/RekdcW/RqS2l6efS+vEnUfVC6K8GsH5uatLGLQl6
	POEXqnWMtrnjP5HmeY6p5w5i6Eyb4II=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-10-H53hdvBiO86fJH7i9Q7wZA-1; Tue,
 11 Aug 2026 14:34:01 -0400
X-MC-Unique: H53hdvBiO86fJH7i9Q7wZA-1
X-Mimecast-MFC-AGG-ID: H53hdvBiO86fJH7i9Q7wZA_1786473240
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F6FE1800EFF;
	Tue, 11 Aug 2026 18:33:59 +0000 (UTC)
Received: from [10.22.65.157] (unknown [10.22.65.157])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ADBC8180034F;
	Tue, 11 Aug 2026 18:33:57 +0000 (UTC)
Message-ID: <19c86abc-feb7-409c-b2f6-6eafdcaa4c76@redhat.com>
Date: Tue, 11 Aug 2026 14:33:56 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: Add test for partition root
 invalidation returning wrong CPUs
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 mkoutny@suse.com, ridong.chen@linux.dev, shuah@kernel.org, tj@kernel.org
References: <4a8cec73-0b25-424d-9f0a-314e221211fa@redhat.com>
 <20260811095848.365138-1-sunshaojie@kylinos.cn>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260811095848.365138-1-sunshaojie@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 8/11/26 5:58 AM, Shaojie Sun wrote:
> Add a test case to REMOTE_TEST_MATRIX covering the bug fixed by
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
> index 0d41aa0d343d..236cb1b38178 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -502,6 +502,12 @@ REMOTE_TEST_MATRIX=(
>   	"  C1-4:P1   .   C1-2:P1  C1-3:P2  .       .  \
>   	      .      .      P0     C2-3    .       .     p1:1,4|c11:1|c12:2-3 \
>   							 p1:P1|c11:P0|c12:P2 2-3"
> +	# Changing a sibling partition's cpuset.cpus to overlap with another
> +	# sibling partition should invalidate itself and return only actually
> +	# allocated CPUs (effective_xcpus) to the parent.
> +	"  C1-4:P1   .   C1-2:P1  C2-4:P2  .       .  \
> +	      .      .     .         C1-2  .       .     p1:3-4|c11:1-2|c12:3-4 \
> +							 p1:P1|c11:P1|c12:P-2"
>   )
>   
>   #
Reviewed-by: Waiman Long <longman@redhat.com>

