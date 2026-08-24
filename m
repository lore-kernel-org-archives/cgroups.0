Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6633624BBEE
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581908; cv=none; b=JIE0vhm/ZYEyiLCprILJ0XzviHHlmwSEu8EjCgJNliiDTT4kj03HOiqy624I8OgD3KgTuOwlCD5Je7RcQ9GIUdssqW+nNJpdW/LV9EGI/ywZdAeLtoZD4J6hNSNqKkdRCsT+J26mIVLzhy5Roembm7HA+owyGgXJmQzJ3m67j3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581908; c=relaxed/simple;
	bh=OAeem06yqaYjF5wBbX8KKB7PwlSwcuP8vHxxHwzgo6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cIb+NtiT17Xvk9rWKTkFRPsVeircZpV6FLnNZmhKjeNy0GelPLAiCGeM8sWp2Uz4yWB/byGn+mZDfU6jHfW4ZENYDUp7kaolz5LvbO1gnOSJGZPCyfLZDiAVrk29lP2FnYGsdzSiL/hmzjgAhiyuFtMlA65uoXeasYIU+zqIYgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fkoY+v8G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkoY+v8G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787581906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i8l4EPwNiuTO+kp3TLHVZbVV3KHRoPD2tT7Gl4iwnWY=;
	b=fkoY+v8Ga4nFmmOTMphzy8A/Yhcuw4E4zCqkkAuHWjlVVWQ5x2HDmlotm5Kwq/u5wB4p31
	lk7L4/9Om1+AwzocgIftXiC7hiY66A1s2gcViGxxXqp0+yWHrzbVts3O8kGJThV80eOHZV
	OPrJdyTwYVtFdMae6QYkwT82qiuwQC0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-qGMLb6K1N3eNd5-wohTAvQ-1; Mon,
 24 Aug 2026 10:31:42 -0400
X-MC-Unique: qGMLb6K1N3eNd5-wohTAvQ-1
X-Mimecast-MFC-AGG-ID: qGMLb6K1N3eNd5-wohTAvQ_1787581901
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9963E1834503;
	Mon, 24 Aug 2026 14:31:40 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 871241955F09;
	Mon, 24 Aug 2026 14:31:38 +0000 (UTC)
Message-ID: <54caabf7-45eb-4113-9838-61d12e131c91@redhat.com>
Date: Mon, 24 Aug 2026 10:31:37 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/17] selftests/cgroup: Test type-change validation with
 child-owned CPUs
To: Guopeng Zhang <guopeng.zhang@linux.dev>, cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
 <20260820124202.517160-8-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260820124202.517160-8-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 8/20/26 8:41 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> Create an isolated child which owns a CPU isolated at boot, then change
> its parent from isolated to root. Check that the change succeeds without
> altering the child or its isolated CPU.
>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   .../selftests/cgroup/test_cpuset_prs.sh       | 47 +++++++++++++++++++
>   1 file changed, 47 insertions(+)
>
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 9a1cce4807b4..bc8dbb724d5c 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -1214,6 +1214,52 @@ test_boot_isolated()
>   	echo "$TEST_NAME test PASSED."
>   }
>   
> +#
> +# A parent's type change must validate only CPUs owned directly by the parent,
> +# not a boot-isolated CPU owned by a valid isolated child partition.
> +#
> +test_owned_cpus_housekeeping()
> +{
> +	TEST_NAME="Child-owned CPU type change"
> +	get_boot_isolated_cpu "$TEST_NAME" || return 0
> +	echo "Running $TEST_NAME test ..."
> +
> +	cd $CGROUP2/test
> +	echo member > cpuset.cpus.partition
> +	echo +cpuset > cgroup.subtree_control
> +	echo 2,$BOOT_CPU > cpuset.cpus
> +	[[ $(cat cpuset.cpus.effective) = "2,$BOOT_CPU" ]] || {

You are using the same BOOT_CPU set up in get_boot_isolated_cpu() in 
patch 3. That creates an hidden dependency on the order of the tests. I 
will suggest that you set up BOOT_CPU and  BOOT_CPUS as part of the 
initialization so the data is available to all the tests that want to 
use it.

Cheers,
Longman

