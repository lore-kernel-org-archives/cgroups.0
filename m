Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BEF37A85D
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 09:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788427767; cv=none; b=GnV/GkdDhHoa4vhw9HQKiWjVam9A8MWg1WHLqT11yDVXXSiMLghcDuMQIXv0zx9+kxuZuNV8ciZySz6Ba2/X8PRBaPzp952IwMSUjyYDRtjjyrGAIqPKBgNY50tO3TrkCc7U9fLBHif81mE6LAv8EDuPXHMKpfaBAOriejK1k3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788427767; c=relaxed/simple;
	bh=35eiEfOrRizRYoh1kXYmiQrZmmBDpud87PGHldNlF4I=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=akonZWMx1dbor2GG1OJOfPCXWOqM9K7Tw0IyF4jgN1riDoEjEco75gckc/P/3Rp0/uW9jp/YHimzEoev//OO2/ZAPCi+hLud2P+ZdtT9kES9mw1kHP+7ocbtZDK6jy5NOp/apCiChUqHHNGQLPxFYd3UuPkDEjjeEsosSVlpW/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AQU8U2n2; arc=none smtp.client-ip=95.215.58.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AQU8U2n2"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=35eiEfOrRizRYoh1kXYmiQrZmmBDpud87PGHldNlF4I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788427763; v=1; x=1789032563;
 b=AQU8U2n2od0tqwdwItKt/jYtpJXfQ2aTy0Wyu/ScwKACUBPIK9ndaJinEBgSXGcz9LPdPB/q
 esZplpwcCnXEK7EshhVr8r1CeM1xKtKJeuUcqrn7WtMuI+M98IUYxcyW/h7YrVuzSWxd2Da+nMX
 7i7w97pd0fmyJ5USDX7zkJww=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1762dd09795c5969;
	Thu, 03 Sep 2026 09:29:22 +0000
X-Mizu-Trace-ID: 1762dd09795c5969
X-Migadu-Flow: FLOW_OUT
Message-ID: <8ef29e46-4edd-43ce-a3cc-0bb4794e861e@linux.dev>
Date: Thu, 3 Sep 2026 17:29:15 +0800
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
Subject: Re: [PATCH v2 3/3] fs: namespace: drop BUG_ON() in copy_mnt_ns()
To: Shaojie Sun <sunshaojie@kylinos.cn>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
References: <aphwXq5bEQwKhqx2@localhost.localdomain>
 <20260903064828.126643-1-sunshaojie@kylinos.cn>
 <20260903064828.126643-4-sunshaojie@kylinos.cn>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260903064828.126643-4-sunshaojie@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/3 14:48, Shaojie Sun 写道:
> The sole caller, create_new_namespaces(), always passes a valid mount
> namespace pointer from the task's nsproxy. The other copy_*_ns()
> helpers, e.g. copy_time_ns() and copy_pid_ns(), don't perform such a
> check either. Drop the BUG_ON() for consistency with them.
> 
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
> ---
>  fs/namespace.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 1ecd96c918b3..0f35c8c14027 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -4247,8 +4247,6 @@ struct mnt_namespace *copy_mnt_ns(u64 flags, struct mnt_namespace *ns,
>  	struct mount *new;
>  	int copy_flags;
>  
> -	BUG_ON(!ns);
> -
>  	if (likely(!(flags & CLONE_NEWNS))) {
>  		get_mnt_ns(ns);
>  		return ns;
Reviewed-by: Tao Cui <cuitao@kylinos.cn>

