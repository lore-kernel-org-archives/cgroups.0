Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D593A46F4A6
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 11:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791978388; cv=none; b=gRniOs2a4p9NLA31SV659jrubHCNqd8IuGZkaLy8uB+nTL2v3Nvv6T+w4HnVOcd4HqKvLTgzTHZBirxTvsO8O1OHV2daU1VzRmwSJvggF+AGZG4Pl25BYLljScpEK4ybUhNj13jq+OGYvh+MbmohunooEGw2jlREzWAk9XwG864=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791978388; c=relaxed/simple;
	bh=ibYxIqvBTuSPh+angcJ5uVYJ5s35O/vRDqWxuZSVtoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/+d4InvNMf586WgHrmLN6p9G7CtwPMuj8NEDkkt1bn2VegsBkDcKAchZI2ne8N4N/BzytIwF3FDlhD0vH1Ow28dXwdGwMX6VzESZAiqDqh6MBADVxskyuK/MhW7YxUc2BBslWiE4SlmMI/AIlgvm6cyq6DqRIibY0PA7cgYkyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fV4V53cR; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fV4V53cR"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48b0ef9c76eso309120f8f.0
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 04:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791978385; x=1792583185; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p8g+klyOjuE/CyZCMVGouc8UFY+Sf8KQ74E9e+yshUQ=;
        b=fV4V53cR2iMSTfvfXr8kgi84A25RQ89iDtfcYJ5Iw1IA3HStsQvNt5Kgg4j6A+Aco6
         2+oYcoUt/H+z6RFLv1P+nOaWxOmt2D8gYzglBJx0oQgL0ZnF2oBOGb03YNKcpjv7Ym6h
         UruC121q1rdCINshRVADehDJhqKe8FL+kZ4aw0ycbzTqfqU0OgV0JtmeSwZTD7yj6GER
         RYfpBxawMV5fEXAC66IQNoPJ/GHUVpBFrekX/EHWb+Ojo0zQublso+D3S6pIa1Nx0H44
         HJcy28WhKrOFQ/9CcLN8dHIry1BPNfkR/ncwui5u6GVEkok4GcJ6HNb5I8WDmbOpk853
         ef+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791978385; x=1792583185;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p8g+klyOjuE/CyZCMVGouc8UFY+Sf8KQ74E9e+yshUQ=;
        b=QjbNEqfBClT/SWiscqGLegAtdXvImwy5Fm1O7mKRIVOidpeFY4TGW8NS8XNidkyMwh
         k0RMLMgMTdGx7xlPdTQUcAhug46tqrpz9pJpqlbRjqiGHDrGUW2lGg7KYeBaVDyfG75U
         Uyc3BNIBsgDhb0L6SJIQ0hgyCPYjYvHHwIdsgVAUcjXMm/8IgJF5Hn9ceVdPAP3qw0rO
         Zwb3jcoqlTONQe3kb4o1QPNdnrSThAoOgXUkYOVMsitQ37wS/RmnoqTIDv3f0O8lXZfr
         9FQg2uqD0WXarIwQbVUNhmzUKz3B3i7cZ1MJGWRCCpJiHyk2st2n7Q+ISp6XXmw4Wk+P
         mAHA==
X-Forwarded-Encrypted: i=1; AKwUvBxFBas5jXjdzGODxd6/LUiIBGmLLl+Rjr6owlbcKz1aaLbA2lazf3sALdlOq+VEZhWYdAOH3k8R@vger.kernel.org
X-Gm-Message-State: AFq9FYKzwVl+32HBtMaBbUeYhQ2yM3vAavH7W8Y9ncmyzKktujyfxGKx
	dPPQrEqWZDUM1VwB+fS7wXTgBBgGsHIImzoIHqvJ8uBZcGCPedvEQkJBCIzyq6PN3qQ=
X-Gm-Gg: AYBFou1m1hyGwUXDkUx+V397eSMZ45nC+8EJrAqSM+hHTl72K6YKQy2pw2Stbv1NjnY
	Fcj39ffbhEr3N/sp3kjOOVgV1dxtkcV+8ABniUVKEZLfHJymw8v4sjlwLcYdZx4MGNPYTKFl4hi
	GufJCGIizKoQc9unB7DjCTW4C3ZGLA82F4u0CwXawLJMAnhtwLEk548KyoROvdrpzAEIEvbhtVc
	ic1pBH87HA4BkC8wr4mXULxvQKYDf14SmdNirrNrMkkNp6SFVFHUxgnzh5oUDMygUGAOSL03H7E
	QgtFPwpEiQrrOSIotojGwoZ7wkw8KkRlJDAfd2ZYEiBwWsCKW0/W83ouW0dD3c4tIXex9G9KWs6
	fdkzSaX1clvZu59fjuCc+IRwhdj5K2cNqDwopJdaRXjV9eIKzA/t3/fLsUNLTRGJtbtFlhkjacG
	4F35b2JkbQVnsood3QKq2L4vj+jpTdoVpfKoGKptl/gnVFXSNFZu7KGTfnsPaAl9VgryDa4GJCx
	wRYA5i9N49hBprfkkYhFiw=
X-Received: by 2002:a5d:43cb:0:b0:48a:f59f:8b70 with SMTP id ffacd0b85a97d-48dbaae4c6cmr24736574f8f.46.1791978385033;
        Wed, 14 Oct 2026 04:46:25 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0967affsm10286573f8f.1.2026.10.14.04.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:46:24 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:46:23 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 5/5] memcg: simplify high limit handling after a
 charge
Message-ID: <as9rj8KoF1oKO8rE@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-6-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-6-shakeel.butt@linux.dev>

On Sat 10-10-26 14:09:57, Shakeel Butt wrote:
[...]
> -	/* Interrupts, kernel threads, and remote chargers stop here. */
> -	if (use_worker)
> +	/*
> +	 * Use a worker for interrupts, kernel threads, and tasks whose mm
> +	 * does not match the charged hierarchy.
> +	 */
> +	if (use_high_work) {
> +		if (!iter)
> +			return;
> +		if (allow_spinning)
> +			schedule_work(&iter->high_work);
> +		else
> +			irq_work_queue(&iter->high_irq_work);
>  		return;
> +	}
> +
> +	if (iter) {

Would it be much simpler to bail out on iter==NULL (i.e. nothing over
high limit) right after the loop?

> +		/*
> +		 * Count the full batch so reclaim work and delay penalties scale
> +		 * with the pages charged by this task.
> +		 */
> +		current->memcg_nr_pages_over_high += nr_pages;
> +		set_notify_resume(current);
> +	}
>  
>  	/*
> -	 * Reclaim is set up above to be called from the userland
> -	 * return path. But also attempt synchronous reclaim to avoid
> -	 * excessive overrun while the task is still inside the
> -	 * kernel. If this is successful, the return path will see it
> -	 * when it rechecks the overage and simply bail out.
> +	 * Earlier charges may have left high overage pending even if this charge
> +	 * found no new overage. Handle it now if this charge can block, to limit
> +	 * overrun while the task remains in the kernel.
>  	 */
>  	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
>  	    !(current->flags & PF_MEMALLOC) &&
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
