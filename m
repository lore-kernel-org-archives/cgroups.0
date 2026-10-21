Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792615203;
	b=qBd5cm8M+hc3ZkszlZv8ynVRQV36K9TZPoPE3kjeKRGyVVzONb924RRsC4xSuEMMzq85
	 ujRcXuWgfXMe85gsht2GglCmpDaLvwj5cAkbHosjVg9NvmAJMKWD8RPfkDfzR8g0ADB4+
	 ue+6dwNMFnhTsSvgoNxa/9ea0PqT3C7XuPeLD34R1B4Y3o1lTObdoGulicktnJp2R8RB2
	 J+7jlqzt8Jcvq/RxwKwb6yVHdiTilNOWHCKARZLftEaspKWPtrRW8SlWbYqXx8UYh3Igm
	 IQJoU0HStgn0P/rcn9YBJM3Aph3U3TNAx60lXHB/LFF/5BTcued3LH7+D1IQu4nqQZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792615203;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Subject:
	 From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=juErZhvjoSkm5e8GzLZMCvXuam8Gd7RIkFvc7uAIv/w=;
	b=UcYv+vx9ZqqA9UhAdIz1qfg2kmZt/7Vf5XjzljVtyf2MKTwX+1nb6BIRuEMMZ7FTLFJ1
	 tqA6dITvq2PhezWkbqhELhEJpX6VskvneqzWF2D17rK5KhEEqZRVW5SwTrUas0G6oh40o
	 T/gGluOUdmf/dT8QGoihOJZpVniIB6eCPZcpSc8sEybqecXYX3NQLdaYrJdSwagsLoeWs
	 a4bjiDzsQomiffB8n550rFWvS1B1SydZsbz2aEfgPZu9+yiD2xUx4Mr5Iz/57gSrN0DAW
	 MptGu/Bir86CO6fBNNE33w14kuEj1t07rr4wu7Ak+3VaOpfcs41WoCU3DeGVI83rsOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GhlogCuR;
	arc=none smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC93B606A32C;
	Wed, 21 Oct 2026 20:40:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC93B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GhlogCuR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792615203; x=1824151203;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=J5q7gxHb9njBGGMG4RpHoR7VIzzwmBGZbkkvnhJBKA0=;
  b=GhlogCuRzdBGj7MCL90UYCwuatoGstdFI+z8Mkh9vAOZ7kmSsPT8GFQP
   PEEwTcmrA7jED8800DRTE0vyO4Eys1zAYqWJhPjxkoZwxCavsGkQepII9
   ejY0v9vkZeQM+YZGESE+03KMofZ9cfzR/OF+aD9z98VCfgsN7oBqRIcwc
   dhrFDOpMg0w6Fre2aTCpHjGQEDGaPeCEIQDda71C36MqrXpgf7cIIRfM1
   avB5fsNWGJAHUSX/TL0qMmFq+p9xbm1wfF/16X4sSeB9xCWw7uqBmfa7p
   WrhtSinP5rjPtUpwODW1dpl1UOpAEa/OOdLvnvdSkJWndetAFOg95heD8
   A==;
X-CSE-ConnectionGUID: aPs//FJdTpab+oEjulmjTw==
X-CSE-MsgGUID: 8nKBQ0jYSImbr5w7OyAcyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1257293"
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="1257293"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 13:40:02 -0700
X-CSE-ConnectionGUID: x2Z9GKP8TG6vbIsZ4Fic/A==
X-CSE-MsgGUID: 3/BEZK9pTXOVpTGnUawn+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="4982516"
Received: from unknown (HELO [10.241.242.209]) ([10.241.242.209])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 13:40:02 -0700
Message-ID: <cbf93381e02861620b012ace93c816f2c0822fea.camel@linux.intel.com>
Subject: Re: [RFC PATCH v3 bpf-next 1/5] sched: fix stale get_pref_llc()
 stub for !CONFIG_SCHED_CACHE
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
 daniel@iogearbox.net, 	andrii@kernel.org, eddyz87@gmail.com,
 memxor@gmail.com, mingo@redhat.com, 	peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net,
 tj@kernel.org, 	hannes@cmpxchg.org, mkoutny@suse.com,
 shakeel.butt@linux.dev, 	roman.gushchin@linux.dev, yu.c.chen@intel.com,
 zhao1.liu@intel.com, 	lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 21 Oct 2026 13:40:01 -0700
In-Reply-To: <20261019064157.29885-2-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
	 <20261019064157.29885-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-10-19 at 14:41 +0800, Yafang Shao wrote:
> Commit b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp
> to fix UAF") switched get_pref_llc() from taking a struct mm_struct * to
> taking the task's struct sched_cache_group *, but only updated the
> CONFIG_SCHED_CACHE definition and its caller: the stub in the
> !CONFIG_SCHED_CACHE branch kept the old mm_struct parameter.
>=20
> Fixes: b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp=
 to fix UAF")

Cc: <stable@vger.kernel.org> #v7.2.x

> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Chen Yu <yu.c.chen@intel.com>
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 57360f5cdde4..973647ad6c2d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2194,7 +2194,7 @@ void init_sched_mm(struct task_struct *p) { }
>  static void task_tick_cache(struct rq *rq, struct task_struct *p) { }
> =20
>  static inline int get_pref_llc(struct task_struct *p,
> -			       struct mm_struct *mm)
> +			       struct sched_cache_group *grp)
>  {
>  	return -1;
>  }

Thanks for catching it.

Should be backported to 7.2.x kernel as commit b636fef85bda
that this patch fixes has been backported to stable.

Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>

Tim
