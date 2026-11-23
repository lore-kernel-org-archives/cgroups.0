Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795434566;
	b=vKCt97MQ9H7AgHRcxSnph1brXNpMjUqr7WIY+lXuBtlVEXEzwswgV9ntEjKMdZ/FI8Bt
	 IshT5hJ2qEKa/2Yk/BxIH1k1/MUCbX6xr8yYQNrm7OC5N3HGJsoOAzKgy4HBl0p6bmKL7
	 HKnuqxnYfyLNSYkb46XZltGdbuSZww4M/2RRle5OpS8zIicdpI+WcnvAhFKJVpyjc4tZo
	 SdEnPpyqVm2QddmFxCNVstZOtmuyrANuFoFWzfUlHYfa3mvrCCksxhPWz+pVRRCMXGglb
	 YMGbytrJqg16cRNaIh+xYrZ0hSzI/N4X9sumcldDB1tmLgbLFWQ0K2zs3CjrDwwNnvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795434566;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=DLWiLwlOa1M+CGXscE3EqyDLFhF6yXj7XzInNLOita0=;
	b=Ep3tK3BIOATKszDI6gPm5gUGjaB4zKknkrP3aVm5vHftImlsnyhPEmb5toTObXCrkQ+T
	 OW6BP6CQkcPLMdxauDZ8UVEPo5jH0cHW0R3bKaTnRsorubkyfOWeQUlvwgfB7XtCGhdUH
	 bcL4ZjratyV2cl06MmSXaLvA7eqBYW8jJ0kz+ZG4MqSGgNZPKh7fUyk5/p7YbcO7HlRTt
	 xiVM9mGTWIcoI9eFrYewZ8/moegu9DhzSOBx0x207h/jpxAC/Gxw1N1ultdktB18prn0K
	 N/fGfg6rZvxSedQmjeB9TvON7bo/lVkXRvehN43s0aaozutMknYP8m0jxTgCzuwXnBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=COSYS+dN;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E58606A31A
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 11:49:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83E58606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=COSYS+dN
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so27598375e9.0
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 03:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795434565; x=1796039365; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DLWiLwlOa1M+CGXscE3EqyDLFhF6yXj7XzInNLOita0=;
        b=COSYS+dNefZdqkxEJffuyhbTfHZeKxak1CQ0RmWdfYG/c4CrsOyFDid0VbHd6UUsK6
         ihEatHsLxMtusANsLiY+BgbJWxgE0PZCPAKSrONc900gvT48RIc8Lt3k0SePhL0EuiLp
         iCqCg3WaH4eDCOQK8gwwQKfI6QaLrqVWzUSiGeq68HfJUxeW29GpVAZrM841aJlBK3J3
         VonNZrihmfRFBsNBIllmKxy2dmE0Ibd6NPiXIhAoAP8BLZwH0BERyiIkBynx2L7Is7U8
         aUrhCKZTr+OpE9Kc3GhxM8evfIqq7RvvojUPrFA6mQOInvzwjBi5bS6SuKvShmskXbMm
         v9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434565; x=1796039365;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DLWiLwlOa1M+CGXscE3EqyDLFhF6yXj7XzInNLOita0=;
        b=zktAaKbONuh4IgyGLBifLMc1QyxRCUprgH0/JvOw2MKTUEe8wgck0U4nAZoJZhVhjr
         3vYHV3Ugwj31BWDRQQRJbtySCZ9C5hrq48h426mYPzNJEK/f+wARZl11paBSbXld98m6
         WAqM/3PB+4ONIeoj1MBnfyS/JmkFeF1uTofLqmyC1NLpTbDT6iJ//fUVYFXkC4Fb5Eri
         KCMsmDEDs8zCI16bd5GLNLzHIOUR8V9581omskkPYGEFX28+pbVKaOcTs9q68UA6G98m
         Qk0gWSt8mQIADte8J9Nx41verRna8+oNRczzj6KWsNkZ7YKtiOOvH0a0px6mq7dZx3TF
         K8yg==
X-Forwarded-Encrypted: i=1; AL+hErGP40sNcz3lOxJROaEGbXQTHCW10gCKKhSWqrqRHehvxvijlTzmyI/s9LiE6522pJXLo4XWXnnm@vger.kernel.org
X-Gm-Message-State: APuU4Z8oIDDd3EWRk0ha9OOdwGu4foFemhfMMHnxkFm1BUvymY6O4W8X
	i4YeY7ahoAYntMexMhUzkqVQpCNutQ8s3mSJZiQ9kLH0qewxof82W3Qp4a4qRjoyYCQ=
X-Gm-Gg: AZFdTZfiWE8xAlpnc4N8bCwFwWzauReUyEP2oiyZ8t0mfvfBx3soLnRuq0hGlQAW5t8
	f8Hj4hlcbOh0bgb20i1IfE/MLh91DLh/mxqQquWiL1uChiHyaP/0bTLTq/JFFiI23jRtOyoTbsh
	UhUo7Xqq0WPAcn0QUZDj//iAboevgyRK2c/SCwhukUtpH6bYCjduSLDWSZTWXR5wdfaIdDufhaY
	tgkwHiTvCsGRBN1v/hMOf4zzGkLgGhQXV8Kc5eHBrUn6IUAWqt3MoEn8EBHTLw2t3n2IWO4Jo0V
	kOzcc57xmh+k+GFcel52ly8mXh5HMeffPgLhDt3gqbuH/54OSU8ZF90m9Jzw9LTIMItMe8c/jfX
	yc2PXPL4h5ewiwMAg0Z3qX9KeX2QSsr2P68DPv710Uwk6go6h8uNX+/eSpd2HVasGc2wroX85N8
	1/mSR7jjzuWcq/UixSUdLpiwyCWN/ATlwNYPrARd3+gnv+dyWu7WfdgPeU+NiM0AuE9/5jFRv62
	v6SSlUXcDL3ED+QIAZ/tK0Y+hJBtFyZY0c2o/bwpkxzXzi3KAuaokA9x5XN1WTSM/WjGak3gPDl
	OTjxY5PpJvMUhrUbbPod+8P9mwC7dVnDC7KU49FAVEE=
X-Received: by 2002:a05:600c:1911:b0:4ba:38a9:85e3 with SMTP id 5b1f17b1804b1-4bb8880eecbmr256789465e9.12.1795434564856;
        Mon, 23 Nov 2026 03:49:24 -0800 (PST)
Received: from localhost (109-81-82-199.rct.o2.cz. [109.81.82.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884865b1sm337727695e9.5.2026.11.23.03.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 03:49:24 -0800 (PST)
Date: Mon, 23 Nov 2026 12:49:23 +0100
From: Michal Hocko <mhocko@suse.com>
To: Tejun Heo <tj@kernel.org>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, akpm@linux-foundation.org,
	hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp, mkoutny@suse.com,
	chris@chrisdown.name, cui.tao@linux.dev, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Message-ID: <awQoQ4Ib9nCcK9Z8@tiehlicka>
References: <20261121073222.834282-1-zhanxusheng1024@gmail.com>
 <awQRT7InNqEF-K8-@tiehlicka>
 <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <305c5803b904a57c188b505d6ed9e1e4@kernel.org>

On Mon 23-11-26 01:13:25, Tejun Heo wrote:
> Hello, Michal.
> 
> On Mon, Nov 23, 2026 at 11:11:27AM +0100, Michal Hocko wrote:
> > Tejun, is there any strong reason to keep the exiting thread group
> > leader in the original cgroup? This makes CSS_TASK_ITER_PROCS iteration
> > really tricky and error prone as above examples show.
> 
> No, and I agree that the leader should follow the rest of the process on
> cgroup.procs migrations. It's this way because controllers primarily care
> about resources and exiting and zombie tasks don't matter much in that
> regard, so migration skips them and controllers don't have to deal with
> them. I don't want to change that. It doesn't make much sense to teach
> all controllers about them.

Agreed!

> That rules out the full migration path for the leader, and moving it
> without one looks fragile. If cgroup core switches its css_set without
> involving the controllers, ->release() sees a different css from the one
> the task exited in, which breaks e.g. pids uncharging, and that still
> doesn't work for a leader which is exiting but not dead yet as it's still
> running.

I see

> Maybe the leader can pretend to be in the new cgroup instead. On
> cgroup.procs migrations, record the destination css_set in an exiting or
> dead leader without touching the css_set it's actually on. When a
> CSS_TASK_ITER_PROCS iteration finds the first live thread of a process
> whose leader is exiting or dead, it looks at the leader and visits it
> there if the recorded css_set agrees.
> 
> That leaves the leader's actual css_set and everything that the
> controllers see as they are now. Only the iteration changes, and exiting
> and dead leaders are handled the same way.

Makes sense. Thanks a lot Tejun! This would allow to use
CSS_TASK_ITER_PROCS for the oom path.

Thanks!

-- 
Michal Hocko
SUSE Labs
