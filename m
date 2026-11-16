Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833060;
	b=2IBh/FjYqeiiCqEWS08c1ZCgoaGN1BQh3upgnjfzn1ihhrg72KDe147KSX1qQ321niHc
	 pOkLjjn1JA3kVygi7z2juueHtzA0t8U/EIloD3/KUWTQ72WYsj6Vj4bv9nYibQFT56nsP
	 Yq3+pI6dyh3NIHugJMzqdOOSrJHVeCls/LL9/fAseb2m+HMTNJIk4kq6xU2e2IMehVeTc
	 h51yjV8KCvFU69mXBfAGtmHYeiOiPW5gsg5pwv61/SYJbleuunxRVTR0GcGI++JKQt95y
	 jYTssCRRhc0ZzWgyoAyGFtkJs1L9BWWbNh98FhJmHkiglJe1KPu1vDi+ISO3hql+4eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833060;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=HdBYWB42Ov1f7t5UzOhOjOd4BKScNXzBpb3W6636xpA=;
	b=MjU+AykLvA6KqMUwAtEEBxLp6N4+ikVcxPUp6+qf0ValTBn18eqNAtDo5nH4Tai4pi+6
	 NovYRtFzpZq6u2w3zKIQguWrqceNWezftaUwY4KJhhbqnWt72EcopeT7zD3eCUrorsin9
	 q8LHE54OMA+5PudGM2+UGJ7OJ2TDedvSteDfiki5B0jZgbmx/DjeGxORqOrNv82TBg7nF
	 gOyqWc8XQPUhCn2YMIlLuewy6ugLN8RYmq8kXmCSXeqzBzGlcpPRT21dBuPiAH7yhm4Ab
	 Sx3SB/zWAuLPf0Fqem0irL9Lm9TOwBbd0sCbtD6t2A7p6UToWNjAt8qowlXeJw3qrlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SBi8nsIQ;
	arc=none smtp.remote-ip=91.218.175.147
Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5063F606A32A
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 12:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5063F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SBi8nsIQ
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=t5dJVaGKrDmbOPD5DFRf/whdm1YuXTQu5zTjuKwHh4A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794833057; v=1; x=1795437857;
 b=SBi8nsIQOJA45gIFRMHH2Ml12AHpKafEV6fzehZjssQob1eD04E8DSiHGJNRwbZzHOnxpAdU
 38ehjlTif7N09vwGwPXrZ3vrKTQL7/E+cIEJHT/WOuGeARKOwPLiiXPs7PAeqezV40PLL8SV0qX
 zvBsGB2ZdjU4OWBfA1Gn94eQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 10d7ca4d1171aa70;
	Mon, 16 Nov 2026 12:44:17 +0000
X-Mizu-Trace-ID: 10d7ca4d1171aa70
X-Migadu-Flow: FLOW_OUT
Message-ID: <01f0b173-dbd2-484e-8e53-f4a001af9acb@linux.dev>
Date: Mon, 16 Nov 2026 20:44:06 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2] blk-throttle: Avoid unsequenced accesses to jiffies in
 throtl_schedule_pending_timer()
To: Nathan Chancellor <nathan@kernel.org>, Tejun Heo <tj@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>
References: <20261115-blk-throttle-wunsequenced-v2-1-1d297c891b82@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261115-blk-throttle-wunsequenced-v2-1-1d297c891b82@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/16 11:37, Nathan Chancellor 写道:
> After a recent improvement in clang to warn on unsequenced accesses to
> volatile variables [1], two instances appear in
> throtl_schedule_pending_timer(), which can break the build with
> CONFIG_WERROR=y / W=e:
> 
>   block/blk-throttle.c:469:25: error: unsequenced accesses to volatile qualified 'jiffies' [-Werror,-Wunsequenced]
>     469 |                    expires - jiffies, jiffies);
>         |                              ~~~~~~~  ^
>   block/blk-throttle.c:469:25: error: unsequenced accesses to volatile qualified 'jiffies' [-Werror,-Wunsequenced]
>     469 |                    expires - jiffies, jiffies);
>         |                              ~~~~~~~  ^
> 
> Per C11 5.1.2.3.2, accessing a volatile object is a side effect. Per C11
> 6.5.2, unsequenced side effects on the same scalar object are undefined
> behavior. Per C11 6.5.2.2.10/12, the evaluation of arguments in a
> function call is indeterminately sequenced, meaning any side effects in
> the arguments are unsequenced.
> 
> Add a local variable to hold the value of jiffies before the function
> call so that there are no unsequenced side effects, clearing up the
> warning.
> 
> Cc: stable@vger.kernel.org
> Fixes: 69df0ab030c9 ("blk-throttle: separate out throtl_service_queue->pending_timer from throtl_data->dispatch_work")
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2191
> Link: https://github.com/llvm/llvm-project/commit/955715460eaf9188c241c74750637fc82dfcc423 [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Tao Cui <cuitao@kylinos.cn>
> ---
> Changes in v2:
> - Reuse value of jiffies in max_expire to avoid
>   -Wunused-but-set-variable for j when CONFIG_BLK_DEV_IO_TRACE is
>   disabled (Sashiko)
> - Link to v1: https://patch.msgid.link/20261114-blk-throttle-wunsequenced-v1-1-d28ed5553ff3@kernel.org
> ---
>  block/blk-throttle.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index c5e26551956a..8e58e50bce4d 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -453,7 +453,8 @@ static void throtl_dequeue_tg(struct throtl_grp *tg)
>  static void throtl_schedule_pending_timer(struct throtl_service_queue *sq,
>  					  unsigned long expires)
>  {
> -	unsigned long max_expire = jiffies + 8 * DFL_THROTL_SLICE;
> +	unsigned long j = jiffies;
> +	unsigned long max_expire = j + 8 * DFL_THROTL_SLICE;
>  
>  	/*
>  	 * Since we are adjusting the throttle limit dynamically, the sleep
> @@ -466,7 +467,7 @@ static void throtl_schedule_pending_timer(struct throtl_service_queue *sq,
>  		expires = max_expire;
>  	mod_timer(&sq->pending_timer, expires);
>  	throtl_log(sq, "schedule timer. delay=%lu jiffies=%lu",
> -		   expires - jiffies, jiffies);
> +		   expires - j, j);
>  }
>  
>  /**
> 
> ---
> base-commit: ab43ec385580b8f8abf72d70fa3acbf4e4f098a5
> change-id: 20261114-blk-throttle-wunsequenced-ccf308a23c1b
> 
> Best regards,
> --  
> Cheers,
> Nathan

