Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB773EF0C8
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 09:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788427739; cv=none; b=MatJOBXohQZxqNuSdyGgGEJ3/zZ8W4R6EiqLMCZRa+po2pMFDvD1dW/oV7QxboWl1XI/HVga94ZIX8l49hK+Os6bH9jgp4ICzdMdTu++PESdQF1TvwmPO+SXwV16CvpCdYOYeHVUe++murURDOwa9I/3WHEMpsvd7SV5+pOhWbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788427739; c=relaxed/simple;
	bh=U5pi9NpNkggEpIXhIWqLp0A74V6qUf5yXoAM5xhOX0Q=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Oh5gPI0ZJVI8AZTYdnoPiE3KhfXXnoEWsgM3QQQBiIFp7MOvGvodFxL3WTVFd1TjSlzHLNlHV48GfAHbTOHMY5G/fvohCwDtJDMvCo2amdsvWttrzYHUUFVbS6Q7bOC0SIKKeXBqgnlIu3i5xSDFYssGapCinuJ8MQaoTuOxdfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fE/xtliZ; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fE/xtliZ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=U5pi9NpNkggEpIXhIWqLp0A74V6qUf5yXoAM5xhOX0Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788427735; v=1; x=1789032535;
 b=fE/xtliZyUR7sSEanHE6W6zVSFJ7M268Lo+drXADDWbmQN4mZr8Dpbe2bm3RrxyXKeJGtDwD
 oF4xtqmfEQ025u9ATgpzOYfb2yn6hm/a+LNJVz/BHkUH+8A7NpPjIu61YSgYC5yNUxYNAuNY2vp
 2fNGEfKqC5fTbA9EUUx4GNmo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6635a15b9f1bc633;
	Thu, 03 Sep 2026 09:28:55 +0000
X-Mizu-Trace-ID: 6635a15b9f1bc633
X-Migadu-Flow: FLOW_OUT
Message-ID: <7fb0d5df-6d16-477a-a140-377158b0fa05@linux.dev>
Date: Thu, 3 Sep 2026 17:28:48 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Jan Kara <jack@suse.cz>,
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, cgroups@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] cgroup: namespace: drop BUG_ON() in
 copy_cgroup_ns()
To: Shaojie Sun <sunshaojie@kylinos.cn>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
References: <aphwXq5bEQwKhqx2@localhost.localdomain>
 <20260903064828.126643-1-sunshaojie@kylinos.cn>
 <20260903064828.126643-2-sunshaojie@kylinos.cn>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260903064828.126643-2-sunshaojie@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/3 14:48, Shaojie Sun 写道:
> The sole caller, create_new_namespaces(), always passes a valid cgroup
> namespace pointer from the task's nsproxy. The other copy_*_ns()
> helpers, e.g. copy_time_ns() and copy_pid_ns(), don't perform such a
> check either. Drop the BUG_ON() for consistency with them.
> 
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
> ---
>  kernel/cgroup/namespace.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
> index ea4ee13936be..76660332ec64 100644
> --- a/kernel/cgroup/namespace.c
> +++ b/kernel/cgroup/namespace.c
> @@ -53,8 +53,6 @@ struct cgroup_namespace *copy_cgroup_ns(u64 flags,
>  	struct ucounts *ucounts;
>  	struct css_set *cset;
>  
> -	BUG_ON(!old_ns);
> -
>  	if (!(flags & CLONE_NEWCGROUP)) {
>  		get_cgroup_ns(old_ns);
>  		return old_ns;

Reviewed-by: Tao Cui <cuitao@kylinos.cn>
