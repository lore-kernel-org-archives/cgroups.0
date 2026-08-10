Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CF44189AD
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373405; cv=none; b=Oa1GlcxmhAmHEpHo/GNNY+NgHMoRLENEo5GdOMx4+Cjbo0gzYlcPzsNgf2ljeGgdyxYR9jc1ge//yyE8RiiEtTZn3WOywD34NStzBb8/2A59ChtmSUv+cs9p08AUPhMKr/F7HHHINVWikaOtmaByovOhWPBVkTJwsG4GT///cJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373405; c=relaxed/simple;
	bh=BUKRM5UNVrjcwfigAkAdTCB4TpOi9su7mFoaox95Fsg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e70TDYiKiX+RX3agltQEBFUNkz/omb02S7yKwGbk+Bt+B+yOR+Lvp6CyZhTeMlPgwGZIzYbYLAoOb/5ZJp330ruy5SFG9iMK7YmMIc0VlO7alXtF6l2ixmKhNWcX7BpNvyZXktSOPVfwfgRIyeSsnkV0dMWks3FQkr+urTw5kzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wd2pcaFL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wd2pcaFL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q6+029G7RX00+t8jXWjA93xlFFwy4mUEXvvA9ZvLWg=;
	b=Wd2pcaFLJ+kvyJxEjSsA/hiqHBeLP976/eG1n3/C0HiATGEL02RR0yPUbnH7EPVISQa5DK
	wOe4EvF+7p7fKaYk/TBRtKXfQ83WO+/TswB8wRfA7qA7mZpMrQTD+GiH+9RLS6IUmNYxZK
	VlxEgjJMVp7IabczrZ1Q5FdzfWehlOE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-yDBOBY94NviefHAlFhblyw-1; Mon,
 10 Aug 2026 10:49:57 -0400
X-MC-Unique: yDBOBY94NviefHAlFhblyw-1
X-Mimecast-MFC-AGG-ID: yDBOBY94NviefHAlFhblyw_1786373396
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0BDC1800611;
	Mon, 10 Aug 2026 14:49:55 +0000 (UTC)
Received: from [10.22.80.220] (unknown [10.22.80.220])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2AFA9195DF95;
	Mon, 10 Aug 2026 14:49:53 +0000 (UTC)
Message-ID: <afd8ff90-4c70-40b2-ac98-ecd2552e981d@redhat.com>
Date: Mon, 10 Aug 2026 10:49:53 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] selftests/cgroup: Avoid awk -e in cpuset tests
To: Rui Qi <qirui.001@bytedance.com>, Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260809082111.3827531-1-qirui.001@bytedance.com>
 <20260809082111.3827531-2-qirui.001@bytedance.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260809082111.3827531-2-qirui.001@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 8/9/26 4:21 AM, Rui Qi wrote:
> The cpuset selftests use awk -e to parse cgroup mount points. This
> works with gawk, but mawk rejects the option. In test_cpuset_prs.sh,
> this leaves CGROUP2 empty and causes the test to skip as if cgroup v2
> were not mounted. The same non-portable invocation exists in the cpuset
> v1 hotplug test.
>
> The scripts only need to pass a single awk program. Use the standard awk
> invocation without -e so mount point detection works with awk
> implementations that do not support the gawk extension.
>
> Fixes: a8c52eba880a ("kselftest/cgroup: Add cpuset v2 partition root state test")
> Fixes: 812c5945bdb8 ("cgroup/cpuset: Add test_cpuset_v1_hp.sh")
> Signed-off-by: Rui Qi <qirui.001@bytedance.com>
> ---
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh   | 2 +-
>   tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 400a696a0d21..16c38eb11e63 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -20,7 +20,7 @@ skip_test() {
>   WAIT_INOTIFY=$(cd $(dirname $0); pwd)/wait_inotify
>   
>   # Find cgroup v2 mount point
> -CGROUP2=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
> +CGROUP2=$(mount -t cgroup2 | head -1 | awk '{print $3}')
>   [[ -n "$CGROUP2" ]] || skip_test "Cgroup v2 mount point not found!"
>   SUBPARTS_CPUS=$CGROUP2/.__DEBUG__.cpuset.cpus.subpartitions
>   CPULIST=$(cat $CGROUP2/cpuset.cpus.effective)
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh b/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
> index 7406c24be1ac..da97f1643f9a 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
> @@ -14,7 +14,7 @@ skip_test() {
>   [[ $(id -u) -eq 0 ]] || skip_test "Test must be run as root!"
>   
>   # Find cpuset v1 mount point
> -CPUSET=$(mount -t cgroup | grep cpuset | head -1 | awk -e '{print $3}')
> +CPUSET=$(mount -t cgroup | grep cpuset | head -1 | awk '{print $3}')
>   [[ -n "$CPUSET" ]] || skip_test "cpuset v1 mount point not found!"
>   
>   #

The test systems that I used have gawk. That is why I don't have this 
problem. Anyway, I support to make it more usable with other systems 
that use mawk.

Acked-by: Waiman Long <longman@redhat.com>

