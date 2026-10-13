Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE927392806
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 08:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879758; cv=none; b=ewjEHxHmtlzntTKlchfrOUi8UROqt2JNqxrb5sFQ8kCjDi/dNGtx8+WT5dyt9r9u2srhAFfZM3p4TVw0RiuWla53TWKlh/E/jabQ67j5xlzHheEcENHbntK40r/MXJ0lSGnKHLpWLnCSK3GbDvNCfYk99wB9d1Ghp1TdDfZwdLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879758; c=relaxed/simple;
	bh=bAvuor41lLlVeDP8wdYZS7BlOwLbZAT1AumUAtJEv+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5Sm6xvsAKlfRhAHMcqJFeN6iyq6v99qVmZXaLZFLzIUMBROKcTrFVWeklKZLrS8TPyj+M8khTCs/txzAZiEzn873wuxlB0dT5luGkpITRzkmUoAvQ0fuImZeHus3snepJZjwERqbAzlnB9PFhH19rf4H+K6Y1Xjzno3Y8vrJds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=azfqxOvS; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="azfqxOvS"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48b060ec084so1644586f8f.0
        for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 01:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791879755; x=1792484555; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0o16lOHfFj6vVRWcNjQS9Yl6CwcGXYm//tE7X4074jE=;
        b=azfqxOvS/XsDHcKIaBlu0Y+fnz4WAmqghKzJvAQ454WRiUJo/sLKcxZdwc/OUkxjBa
         GCl4g0Xcthcb0NZI+9wPZTinnkYwvBrWDhQ6gRZ9/Es0n5SpiIq/Ymvc/fy0xvmJnGTe
         f4pAMuNf8p2E0Vr9jBFVIM3gZXt25+Io1WsuBiB2+Fgn2qdWIXDvBage3CTgjk1o/eh1
         B+WuLhu8I0Ga+VOA8q+QRxtIzKR9VkrRzVuOC4tRR7fGSy3BiB9XloN9R4O+BZxytRVH
         sGFotlr0a+nwglqlvrIYsA1M+0xgIzC1ZgPC14GSNVqdetaiJoxBYkWPAgcbF2ySB9q9
         fkuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791879755; x=1792484555;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0o16lOHfFj6vVRWcNjQS9Yl6CwcGXYm//tE7X4074jE=;
        b=RwtoXGEmieb7ezv77dYFEyBXAujMHefyvUTahbyW2c3Z4I5RoirQx/QwGpiloizQY1
         W677bWh4AHrtJZzlCtoE3RO14W8QDKqogzMT/Ww0dHuh+RCBwVVLK2hichdoIu9Sk/AX
         0vs0l16X+t43LzC4YkxfIYwNqYSPQbRDS5r/XC05dDZqO2sh9Oh9e0OoLd3xQr2N6oZz
         Tys7f9R2w8G0LM5H6NzNhnhGXQeCgABt7obUVeIqGas+WCfFR7z4eeLFQS1lVBnzSFfN
         Bsuelo2JFi8wGxfn1CkjWVM+z5/36CFRkQFmZyNkiUTkrQygeVinlYTbMZN1+g2+BEZz
         oiMQ==
X-Forwarded-Encrypted: i=1; AKwUvBx7dG+ukvbmQLNxwAnVnZWHmozU6WoPsmFEGoSZrDDGDnUFnmPn8F43thrc8e4OKsou9tqHg2VF@vger.kernel.org
X-Gm-Message-State: AFq9FYIuYjQscYujvLoVyZ+V3Awi0eE0XpOmBQpQpjGm1j4yxn7VxIwW
	JfbxJOTriAOEsVYxgXhhKuNjPyiR4S1YeDpeDd01ihJKYxNoZEWCIvOHmLou3TDkUgA=
X-Gm-Gg: AYBFou0k2Y2EzcuOODPrtPQWU6CnUJHsjDJVQqJqKNq99QL5Bmk6X+UcjEhxRuBfkQL
	BfKtpDPPg8vJtF2pi4FRpS2Mk+eXHS2HLgGT2C6A4h5KF++Rff3BfFt1DVpI4CrdiEr+yS45UlK
	cKJ2eyvj0Y3pkYAsPV1xolfKNluL0i7HuGiP9QiOZlFJTJrenwo1EXcqSIqx2XMC0eVAlN0Uuhd
	rZ8EhCIxUi4iwd/YZAMOVpsMfI0o13Llaz/BLyklP3GxhESb8Xhdt/WR23GXOa6nufb26PIH17v
	YqsNFm8G9LywEZTQUg8KSPyD89svxU8bHWMIYAeOLQ5YrAVrBbR+nuPm0lUKdwxtQOYVC8cDIut
	RvDqTOGX3b+W+1Pd6ORCSVFoQ+Hp0k6MMB0KuoAaiau8qAbuUoSZaSaTufc/7/EIkloY300k3w0
	/guuWoyLshdbkjK6to67hQM0o2CeX9MCWd71AT3f69JNAVh51KbY/o3kGCFFWpt1nmVKxfAdBD4
	pWgpPfZ470b
X-Received: by 2002:a05:6000:2388:b0:48b:26b:7f8b with SMTP id ffacd0b85a97d-48dbacfbd3amr21310103f8f.57.1791879754824;
        Tue, 13 Oct 2026 01:22:34 -0700 (PDT)
Received: from localhost (109-81-32-161.rct.o2.cz. [109.81.32.161])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0aaabc3sm3951815f8f.16.2026.10.13.01.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 01:22:34 -0700 (PDT)
Date: Tue, 13 Oct 2026 10:22:33 +0200
From: Michal Hocko <mhocko@suse.com>
To: Rohit Ner <rohitner@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: log userspace OOM wait entry and
 completion
Message-ID: <as3qSdvoU2dESCsR@tiehlicka>
References: <20261013040034.3919469-1-rohitner@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013040034.3919469-1-rohitner@google.com>

On Tue 13-10-26 04:00:34, Rohit Ner wrote:
> When a memory cgroup hits its limit with memory.oom_control
> oom_kill_disable configured, mem_cgroup_oom_synchronize() puts the
> faulting task to sleep on memcg_oom_waitq and notifies userspace OOM
> handlers to reclaim memory, enlarge limits, or terminate tasks. On
> platforms where userspace is severely stalled under memory pressure
> before a hardware or software watchdog reset, no kernel breadcrumb is
> currently emitted when a memcg enters or exits this userspace OOM wait.

Correct, this is an inherent limitation of the feature. You rely that
the userspace OOM killer implementation is correct and memory pressure
aware.

> Log rate-limited KERN_ERR messages (pr_err_ratelimited) upon entering
> and completing the userspace OOM wait in mem_cgroup_oom_synchronize(),
> including the memcg path, memory usage/limit/unevictable stats, elapsed
> waited_ms, and whether the task exited due to a fatal signal.

Isn't this something you can achieve by adding dynamic tracepoints, bpf
progs etc.? Why do we need that for all users?

-- 
Michal Hocko
SUSE Labs
