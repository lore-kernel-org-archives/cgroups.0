Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F3E35C197
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 07:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038940; cv=none; b=lQcQrBqNe/MZhk8MPom6bU6mrNuaoUWRSt8ZWXmUJvKYmOwOUGxfjLj3HAU6F9XRQjZ+GJJQg/VYCg+kWaTMxEGPnHvv8rrCkbjl+xbcWPVL7BhCBeTD4wyJH0ISAANICy0Wdbk95OaHADAu7WF2M0+hLaYfQ0cnLY7SXCPsY64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038940; c=relaxed/simple;
	bh=yTVDlGVmJyUm2z/XuDzwC26W0QaVpiXhZa4hwBnuj8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jy6ETT6I0AC8DVQp0LgkcVjRePMN0WPX5PxdeNy+yF5LXdHlb32LkZgaAc/Mq7aiSONSkPHgT3H6a+GrzjQFY1YUKoSDVbhDbMgXNzQ/Tl0BiwKCIaVFo8tAIrcMlBCCXkg33hGnQx1xcuk8y/URAy7h519nVTu4kAveLKxRAOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KLGN32TE; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KLGN32TE"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-481412f1828so1418380f8f.1
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 00:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787038936; x=1787643736; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8kxhoXQ3JMlTJinzz2e3MZXls2upTKaBok9FISR0LnA=;
        b=KLGN32TEKdXcpwaGj5LMTSdfHZ2JHqNvqj4G9Rxkg5ayNYgIxHVDqLHsADba00nOyp
         KSdZHhTRVqH5fthH9Yt8HxsB3t4XRaeVw8CF5iHZZll4HPnbBOceX6+NJ/7njia8+WPf
         NThqlhphPiuP6AslQL/cDyCXSyYUfO2hLQ+Y4mMOwsgZ5R4X0a5jvhHsYakKqQWifeAl
         TZJd4Bnpq5E1Goe3fg5h9WSDRTeYy+GLdSKkwjbMSEUphGefivWFH7v8zy3tV2w9FlEU
         W68H/+U87hlXnNRhXjLegA+Wp1iUGx2OELv/RBkXiN689GaeXXgZFIPKkOONk3vnyD6r
         At1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787038936; x=1787643736;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8kxhoXQ3JMlTJinzz2e3MZXls2upTKaBok9FISR0LnA=;
        b=E3Q4Cksf7K3j2EmsvpWPldA4f2xmyJ12kfvq3hKQHv8EgF1c2RqkAKcMTh5BhQij0B
         hYBjcRhciJVLCb/HrSf7peOLmI0CMPykitXoR6zlnIy4OB4MNLKvmW7VjWJxZdD2bmow
         IVrBR0VxR5yf4Txtu/k4hoT8wRnrWIry8WIGDBnG2hEpQ9CXR2mUihwZvGJ82FlogsZi
         TW88W2FPjPbB+eIzR870ItkMTIuudIKOSJFdpBixpYhBP7V78gGB5C5kBGKHsRdIBkmP
         w8yCa0Rg0y4IA1zci8WPxtGq9nIP0RfKkYwYjN9eipo2lFy1AAolmd7u641VobgEzMtk
         U5GQ==
X-Forwarded-Encrypted: i=1; AHgh+RoLbz8vcURnkhLyAPQPiNC9dnqsX/tRufGe4fYRGkERXXr8mOMduqlv/Y8n336pnIBapTJ41vw1@vger.kernel.org
X-Gm-Message-State: AOJu0YyCsv4eGvDbRe+pWYnRKTuhyUsystENrM+/Wf5d0A40rT/19l/u
	UlXLp+BeFd0yIRkbfxXO3r5P9lfQXI9eGi/fEh2Z8DB4MvT8cY8mLC4nlnOoq/KCkYU=
X-Gm-Gg: AR+sD11FHY9xVeBWT8bU3g3/uSCGtyGJjIzp3mmIGugodDc23CoiHNCBAJkyUJfWMeN
	3caCAG4DdOs9EAOtLdnddfGmjam6tSCPoQpm3Pp1NnqCh7NfrbPAEN+BqHNpgIEiu3Hse2Ja9Yy
	K7YWLUCYPK4WSZkjTHB5KG4fYB/UD57FVu9MbcszEyllCS4+njuUMLnoeu+/N5z5t7Z+FVMueOC
	dgati7+HFBaEZNshYavKRACRSA4FP6/tXEehGNwgwh5TqIOnbecphFHyUrlR5+0lVjM6BDpwtXS
	pmq00Q7pFxcdaPbrwNCSN/ddplV9eJiaeennd/tVS3uHq9xzIDfUEEg8dgsDlofDXSWzzj4OHuZ
	OWl/1caalckAfiHw8q53w5vSUZaELdHRPc2mlL9Z7xoln/EnwHuEt5SHabfVBSbSHDqp8ri7gin
	lIbUsqYteRAU30dkMvR/te7/T8ZbJ2xSpURul6WeN4gBreqx3J08LsSuD50AEKYK4pZY+qTWk=
X-Received: by 2002:a05:6000:40de:b0:47f:83ee:e56f with SMTP id ffacd0b85a97d-48160748fb9mr49670647f8f.18.1787038935656;
        Tue, 18 Aug 2026 00:42:15 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5b81748sm9986909f8f.37.2026.08.18.00.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:42:15 -0700 (PDT)
Date: Tue, 18 Aug 2026 09:42:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: shakeel.butt@linux.dev, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	muchun.song@linux.dev, roman.gushchin@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	kernel-team@meta.com, kernel test robot <yi1.lai@intel.com>
Subject: Re: [PATCH] mm/memcontrol: avoid false sharing between vmstats and
 events
Message-ID: <aoQM1i39pGKh_0Fk@tiehlicka>
References: <20260817103835.2937733-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817103835.2937733-1-usama.arif@linux.dev>

On Mon 17-08-26 03:38:35, Usama Arif wrote:
> Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
> struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
> This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
> vmstats_percpu pointer onto the same cacheline.
> 
> The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
> disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
> 60-second run on a 176-CPU test system.  Those writes bounce the line
> while memcg statistics paths load vmstats_percpu.
> 
> Move cgwb_list into the existing alignment gap and cacheline-align
> vmstats_percpu.  This separates the pointer from the event counters
> without increasing the size of struct mem_cgroup in the tested
> configuration.
> 
> The blamed commit reduced median mremap throughput by 4.38% on the
> test system with one socket. The patched kernel brings the performance
> to within 0.5% of the parent which is within the observed boot-to-boot
> spread (up to 1.2%).
> 
> Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
> Reported-by: kernel test robot <yi1.lai@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/memcontrol.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e78bc98ab229b..215e2e87f42b2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -268,10 +268,15 @@ struct mem_cgroup {
>  #endif
>  	int kmemcg_id;
>  
> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> -
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct list_head cgwb_list;
> +#endif
> +
> +	/* Keep the hot per-CPU stats pointer away from memory event counters. */
> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu
> +		____cacheline_aligned_in_smp;
> +
> +#ifdef CONFIG_CGROUP_WRITEBACK
>  	struct wb_domain cgwb_domain;
>  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
>  #endif
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
