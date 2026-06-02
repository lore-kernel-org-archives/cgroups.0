Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368FD38737A
	for <cgroups@vger.kernel.org>; Tue,  2 Jun 2026 08:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780388389; cv=none; b=dcFrHQ7smHdunxQ4fZ15z4ZrsrZIM/oQrwRDXv1V0Scnl4wYiOw/2V29OStB3P4YTUhKNy1vPSOKGraBgyVZ8/v1+WwKqkpWKneAUqFQcw9IHumBjUikNPwpGhOZayDtgTWG5r1zQBmIiohesyfQRrC0uC++KZJXnGTty0Nac2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780388389; c=relaxed/simple;
	bh=d4uyziz9BCE8n1/QwSyz4DMAfmTUBkyZhaAzDsbbxhg=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rE8tM/4icWTKemx8mqprqn/Cudvyhd3M4LR5zIRNXq0c5PpVSDAo+WFriGecBV8lSCesKgG4um5lX1SFhCbs0muekhqt7lZxmfeHS1v1EIeSrUTewOa4I8PiPS+8Sg7HpegnkJLQ85+jTXYMVc+Secq7s+UPmFDkCXoFz8YYVzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hpz+v1DU; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hpz+v1DU"
Message-ID: <4ce16a92-9b23-400d-bb32-b79a10807412@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780388376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NjDmMYOSfD3R0tgoLgQADu8SWNpyCv43yiDku36kijg=;
	b=hpz+v1DUS7cGfQV6UbWNPeAH/+RFW/D95prOy74xTkTHVNc1MPUEy0B2VbZ4JZ56Xq2/Md
	LjxthbGhs7myjVsXGU1F/hKA8kVhjaa7/7uP2Fm71J0plLL8cD282MxiaKHSPwBi9nMj3B
	Dnny0zBNQGx0hMpca+gtjvS1FHH5gfo=
Date: Tue, 2 Jun 2026 16:19:21 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, longman@redhat.com, chenridong@huaweicloud.com,
 tj@kernel.org, hannes@cmpxchg.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] cgroup/cpuset: Fix update_prstate() always returning 0
 on partition errors
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
References: <20260602045521.2381230-1-cui.tao@linux.dev>
 <ah6JpNvdO7vaBmjS@localhost.localdomain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <ah6JpNvdO7vaBmjS@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Michal,

You are absolutely right. Looking at this again, this patch is total
suckage.

Returning 0 here is the correct declarative UAPI behavior. The invalid
state records intent and can recover later when resources become
available. Returning -EINVAL would only make things worse since the
state has already been mutated.

Sorry for the noise. I'll drop this patch.

--
Tao

在 2026/6/2 15:46, Michal Koutný 写道:
> Hi.
> 
> On Tue, Jun 02, 2026 at 12:55:21PM +0800, Tao Cui <cui.tao@linux.dev> wrote:
>> update_prstate() stores the error code in cs->prs_err and transitions
>> the partition to an invalid state, but always returns 0. The caller
>> cpuset_partition_write() uses "return retval ?: nbytes", so the write
>> syscall always appears to succeed from userspace even when the partition
>> became invalid.
>> Return -EINVAL when err is set so userspace can detect
>> the failure immediately.
> 
> This is quite a visible UAPI change (a write can succeed to invalidate a
> partition) and users are meant to watch for cpuset.cpus.partition state
> anyway for asynchronous changes.
> 
> I'd not change this gratuitously.
> 
> Michal
> 

