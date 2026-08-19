Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B39E3A0E8A
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 14:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787150066; cv=none; b=MFZgpkK6Jj57JUw+DjWUZR0WpU3w8G+l0Nb9pVjwcc452MthYWf//6mK/qcLFiXMXqjoAhKIRTo/rXsMUfwRDGo7qtAmjmoiAHwTf40kCCgAMgXxq66OYDMuFPUpZpXdZ9S71AWi8cwKLglX3e4Wo9pxPXQSC5OCGZIiTGhRyms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787150066; c=relaxed/simple;
	bh=HU+qPdUQS0BEZD7n5Bfk9KiA3akMlx3J74BeJkMhjxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AI/9UloR+Vt5eX1HItBk60Ql3KtT1HoE4sepCUCgK5xEd6nkdvicdjQ/+R6QeEKXG0UVlLbJ15x7+mAHuBxMisn7nBTKO23vRMPNNWh9N+tRJmZ7Wqa9E4JHiRGjAlfdJWoM9/EzaK2Nfl0N40Sl8+g9YRSgzX7fO7zulkJjpYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SUabsjI3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SUabsjI3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787150063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nL5TdQYFTc+LhqgfFIL8+rQklS1IicuWMxunD/2jpt8=;
	b=SUabsjI3huxqJLvXY95F3DDTgFs3YhW7o5ikGJHKA0dnA6ZU7PG5HVND6yp2J/ePP8tFmE
	40WGQB4OwZBkuUQaWTa6bZsFkI8qpO+qqtFDh7sYL73HZk+akNPZWUFyv1PrH9gFrhx+Gw
	z26wjE/oreLi4MqedK2cIWfgAkTk89U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-oY19yZ_SNtymbl_oIIFBfg-1; Wed,
 19 Aug 2026 10:34:21 -0400
X-MC-Unique: oY19yZ_SNtymbl_oIIFBfg-1
X-Mimecast-MFC-AGG-ID: oY19yZ_SNtymbl_oIIFBfg_1787150060
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 832251800D8D;
	Wed, 19 Aug 2026 14:34:19 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7506180034F;
	Wed, 19 Aug 2026 14:34:17 +0000 (UTC)
Message-ID: <e5433074-5d95-4991-96be-eb03e7173900@redhat.com>
Date: Wed, 19 Aug 2026 10:34:16 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: cgroup: simplify cpuset subtree permissions
 test
To: Shaojie Sun <sunshaojie@kylinos.cn>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260819103152.767771-1-sunshaojie@kylinos.cn>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260819103152.767771-1-sunshaojie@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 8/19/26 6:31 AM, Shaojie Sun wrote:
> Simplify test_cpuset_perms_subtree by removing unnecessary chown of
> cgroup.procs files. The test verifies implicit migration triggered by
> enabling/disabling the cpuset controller via cgroup.subtree_control.
>
> Implicit migration is handled internally by the kernel through
> cgroup_update_dfl_csses() when subtree_control is modified, and does
> not require cgroup.procs write permission. Only cgroup.subtree_control
> permission is needed to trigger the controller state change.
>
> Remove the allocation and cleanup of parent_procs and child_procs
> variables that are no longer needed.
>
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
> ---
>   tools/testing/selftests/cgroup/test_cpuset.c | 16 +++-------------
>   1 file changed, 3 insertions(+), 13 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_cpuset.c b/tools/testing/selftests/cgroup/test_cpuset.c
> index c5cf8b56ceb8..b323addcc519 100644
> --- a/tools/testing/selftests/cgroup/test_cpuset.c
> +++ b/tools/testing/selftests/cgroup/test_cpuset.c
> @@ -167,7 +167,7 @@ static int test_cpuset_perms_object_deny(const char *root)
>   static int test_cpuset_perms_subtree(const char *root)
>   {
>   	char *parent = NULL, *child = NULL;
> -	char *parent_procs = NULL, *parent_subctl = NULL, *child_procs = NULL;
> +	char *parent_subctl = NULL;
>   	const uid_t test_euid = TEST_UID;
>   	int object_pid = 0;
>   	int ret = KSFT_FAIL;
> @@ -175,9 +175,6 @@ static int test_cpuset_perms_subtree(const char *root)
>   	parent = cg_name(root, "cpuset_test_0");
>   	if (!parent)
>   		goto cleanup;
> -	parent_procs = cg_name(parent, "cgroup.procs");
> -	if (!parent_procs)
> -		goto cleanup;
>   	parent_subctl = cg_name(parent, "cgroup.subtree_control");
>   	if (!parent_subctl)
>   		goto cleanup;
> @@ -187,16 +184,11 @@ static int test_cpuset_perms_subtree(const char *root)
>   	child = cg_name(parent, "cpuset_test_1");
>   	if (!child)
>   		goto cleanup;
> -	child_procs = cg_name(child, "cgroup.procs");
> -	if (!child_procs)
> -		goto cleanup;
>   	if (cg_create(child))
>   		goto cleanup;
>   
> -	/* Enable permissions as in a delegated subtree */
> -	if (chown(parent_procs, test_euid, -1) ||
> -	    chown(parent_subctl, test_euid, -1) ||
> -	    chown(child_procs, test_euid, -1))
> +	/* Grant minimal subtree_control permission to trigger implicit migration */
> +	if (chown(parent_subctl, test_euid, -1))
>   		goto cleanup;
>   
>   	/* Put a privileged child in the subtree and modify controller state
> @@ -221,12 +213,10 @@ static int test_cpuset_perms_subtree(const char *root)
>   	}
>   
>   	cg_destroy(child);
> -	free(child_procs);
>   	free(child);
>   
>   	cg_destroy(parent);
>   	free(parent_subctl);
> -	free(parent_procs);
>   	free(parent);
>   
>   	return ret;
Reviewed-by: Waiman Long <longman@redhat.com>

