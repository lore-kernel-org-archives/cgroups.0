Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3548829ACC5
	for <cgroups@vger.kernel.org>; Tue,  2 Jun 2026 04:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780375769; cv=none; b=VtZXfny9l/tJbxo4UUu6YVsqUAINVBU/cxCe01Nx2Jyr9G/39nksVfoyTmza5mVz0v59m5eRO4p0jANysEJkrs5fHDcQYZqWImGy8zVRqDKwuhUY9Nb8hV/ULnqhUVRHwXh2Kmx9OSPaJkcLEFzME/GR9/Lu6wpoQk016p/N7s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780375769; c=relaxed/simple;
	bh=1Qrk5ZXccS97TyXCQxR52Bh8rhkslTxwBKocetfsx7s=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hxuHqLukP2D5RapvGNhG35ma6pxYU9+qG43ueRQ4BguLwEc2/vE6kPOkGE5nuPk4uW9QILywyQezNwZwq14DIm51/zLSvSDl46HQW3XuL6zCrZP7cd/n1pmJ/r0clWDWlcudv+N7RtuTbR/+LYkZKixGPVyU1i+/w5X2NmJ7N10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LIKnJB0J; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LIKnJB0J"
Message-ID: <39c542a0-bf0f-408c-a9ff-17b4c629bd36@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780375764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SwTLelEfiTVz4jxk36vlB7KdEqDbVGRLNUw55IfMwNs=;
	b=LIKnJB0JYtwzfYiGNcT58DCvfqVcH8SmyLcKRYecmSyVG6oaHRCJT1odfahrDm7WBwOKjb
	eq5gR/tYclOq1CyrqvTVG43qLHTUDO2O44DE7Bxx5bmg23DMbOTjdCR3SvZ0l2oX9f2Qsi
	HB+rvV786I2HWEyhYWEJKGgZFSVmf0o=
Date: Tue, 2 Jun 2026 12:49:15 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, "Claude Opus 4 . 7" <noreply@anthropic.com>
Subject: Re: [PATCH] cgroup/cpuset: Fix update_prstate() always returning 0 on
 partition errors
To: longman@redhat.com, chenridong@huaweicloud.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org
References: <20260602043652.2380163-1-cui.tao@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260602043652.2380163-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Kindly disregard this patch. 
The issue is fixed by AI auto-testing without Signed-off-by; the tag will be included in v2.

在 2026/6/2 12:36, Tao Cui 写道:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> update_prstate() stores the error code in cs->prs_err and transitions
> the partition to an invalid state, but always returns 0. The caller
> cpuset_partition_write() uses "return retval ?: nbytes", so the write
> syscall always appears to succeed from userspace even when the partition
> became invalid. Return -EINVAL when err is set so userspace can detect
> the failure immediately.
> 
> Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
> ---
>  kernel/cgroup/cpuset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 591e3aa487fc..8605b4da610e 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2965,7 +2965,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  	if (force_sd_rebuild)
>  		rebuild_sched_domains_locked();
>  	free_tmpmasks(&tmpmask);
> -	return 0;
> +	return err ? -EINVAL : 0;
>  }
>  
>  static struct cpuset *cpuset_attach_old_cs;

