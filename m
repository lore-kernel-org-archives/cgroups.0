Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7FF2F87B
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 02:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789958795; cv=none; b=mfw6IMwYcP99YoLFdXpQq10J2poF+WeTqzEJqi5LZVe1ajZC42uv4x3aQ5i4fy8MtEO9bMygQsgRDhuGAB2Muea0IrmtIQrS97t4uG32zGoZz2aNBWeHRtf19bPyz2mFSjQzHHgr/ryCAVOkmGPtE7oE3ZKlJRn3LtfTIPlcqvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789958795; c=relaxed/simple;
	bh=zrNzY+eAXsNHITbizGrQwVQ8pjNQ61cL9S+ZPXEvtNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lOQK11LmZccR1+Ta+oEGfDHUuY6GezfDXwqurikcmttUe/6c7XxWXAEhcGjT8lL3xSWgGa2N3FmhbzI609LMUIzi2OUnWBy+4D8UJ6+GHL0XdZzZ5pH2AQKzLu/QQbB7rnG6L+jOchwFKJm7R/zKLBJAr6SVPa9u1fuBfkIACJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WsSMkVcN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WsSMkVcN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789958792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ybEXVD+RVkifaQltAIcZER0Zvs5L7kxdbiy0I9qQQeU=;
	b=WsSMkVcNBFDM1veDiNIM/b25sHn634f+mFEFGDMxX/P2cHfMJ7RCFunpyR45quT6phRGHq
	Yhc4Ij8d4hBlnv2/2w8dR6fpzSWdgvUfcfzKUppPbHKb03jdA4e4HaCZ4Hg8K2PcQdJemg
	KHbkE/mjLUwL4nufzfdxROruGtzek0U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-oQvblMsgPBuqZZY0a50iUw-1; Sun,
 20 Sep 2026 22:46:27 -0400
X-MC-Unique: oQvblMsgPBuqZZY0a50iUw-1
X-Mimecast-MFC-AGG-ID: oQvblMsgPBuqZZY0a50iUw_1789958785
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2DE49195422D;
	Mon, 21 Sep 2026 02:46:25 +0000 (UTC)
Received: from [100.91.18.181] (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 542A31800352;
	Mon, 21 Sep 2026 02:46:23 +0000 (UTC)
Message-ID: <95b36b23-91bd-4546-8090-2cd735efbc1e@redhat.com>
Date: Sun, 20 Sep 2026 22:46:22 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: Remove redundant sched domain rebuild
 from update_prstate()
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260920025256.24991-1-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260920025256.24991-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 9/19/26 10:52 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> Both callers of update_prstate(), cpuset_partition_write() and
> cpuset_css_killed(), call cpuset_update_sd_hk_unlock() immediately
> afterwards. That helper rebuilds sched domains when force_sd_rebuild is
> set before releasing the cpuset locks, so the check in update_prstate()
> is redundant.
>
> Commit 3bfe47967191 ("cgroup/cpuset: Move
> housekeeping_update()/rebuild_sched_domains() together") removed the
> same check from cpuset_write_resmask(). Remove the remaining one from
> update_prstate().
>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
> Changes in v2:
> - Rename the patch to avoid the misleading "defer" wording.
>
>   kernel/cgroup/cpuset.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8f24171b6055..d58ecf56f384 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3039,8 +3039,6 @@ out:
>   	update_partition_sd_lb(cs, old_prs);
>   
>   	notify_partition_change(cs, old_prs);
> -	if (force_sd_rebuild)
> -		rebuild_sched_domains_locked();
>   	free_tmpmasks(&tmpmask);
>   	return 0;
>   }

LKTM

Reviewed-by: Waiman Long <longman@redhat.com>

