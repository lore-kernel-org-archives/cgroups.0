Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792426245;
	b=1Po6fT6YGlQJ4Hc/bweVgTspusYj2tdSXKIDCddkLHYWkpNW/l5GkYAz8vfNPWjvMqy/
	 GhTE8KTOsP1FPdC15xImUECsVugqCZRpNfKRhQKNHDkaQ98c+Gy6EsM9X9nIIlm6AJKtW
	 y+t11rKs0+fA3q20r1vBWXfJF+5Hq1FGPNxTcHuXjbiw/CAk9v9XwtJNHQEZharSUrrl1
	 /pQqKX2uLI34hxjFVNI5/zngqibDbnzFSAjL3bNW4zx0FGCK2CyjbTFTAvaGq274PPhJF
	 vXhDurExCh+ukpVMQEsDoLwG+NzR7O+77t9KTzm5XnZTn+ATj67awkLXHjGSgeiFI1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792426245;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=524VuOfFgYNOliyeGIEdLFsd0yqaT8bQWUr86gODCAI=;
	b=gzeMP4UVotWw2PPSPAv+f8fWIVKtLxD6rF3+XRl98mBFMA7qDDxjjZmzysQGZddBC3+N
	 c4kJXW6TPAN8rvBf7/XvDI/KN1tfNa/F+z7FFNCP6hbd0vm0Pr8jjlIS49YWvFF4wImvG
	 EFIngkJCPWGJ88LhavlXOHeKHrmGZA/+wfxKa3jywjuFIRN76Ptk810hIvIAFMbaE+WdW
	 TAknW51pcTEYhl+xRcbql1TZVCZ41jATN3hTAiomSLFYdSZZEdEjR+t2UcAw4JAautk7X
	 LKqnP0IXNnXbGn9ucq5lyTEEg/kElfwKNm3vIRYp3F9i1jtNivB5jFa3M48BmK9juLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	arc=none smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DFF606A33D
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 16:10:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65DFF606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-53512cd2f85so26085911cf.1
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 09:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792426243; x=1793031043; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=524VuOfFgYNOliyeGIEdLFsd0yqaT8bQWUr86gODCAI=;
        b=TAJh4Er47ofnVCoUNWaumAYwysFjlSVRNjlHTmpTj1ZVtJ8fNPL1utvGKmXgV/4eBn
         WKml7mwNMk1f4tolbgazAnDGzkiSTKi9S8sXbDLJ3mZ6RBuEISEJCFx34RfbbToZYejN
         GZebR7UyU1PJt5HKc8XJur2s0Ojoh9U+eB+PjNvpRdBhPztdPt7yw5yjOZKUqVcf41Mn
         RZ4zmBu7vhessj9FGFWqp3joEv9m+RJWapnFHDaFxtO/DoPP+9H0PcsSGKdsdK9xVNIg
         JhR5TvhtMwla4ZgbDGqUQtnivSkJ958HLCYzNQxMzV2lswOONH30M2fjJylmos/D2s/+
         K9fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792426243; x=1793031043;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=524VuOfFgYNOliyeGIEdLFsd0yqaT8bQWUr86gODCAI=;
        b=TyfPCGyTR/nUXyP3WM6ae/23ZcCL9updrToHBfEqEwudtfqgEf6K/ktz9lAbcCzsJ/
         zzuthZ4VvaBl0N9Hwwjo13iyR583/A39+3q3GsemY/zSMbqCBuckbTI8DV8EPo+cGUno
         kSmGG3O1+OmVvN3zuNj/tLtvk+hQtg1hhHcRxlUCRXf48J2VGeO0QMI/RqpbTmmzlY/u
         e5FX8tqPiospJQ5fx4Sn5EeHCJi8+N1grOfV8c2p6/Al28kjtZyehn94sAmY3U6aerP2
         TevhTmPpDexoqNaIA+uYIAQKMCKAYxFFzY8vmUPMLFCuevRw2JjrFwb/eDIQX5djCrWa
         BF2g==
X-Forwarded-Encrypted: i=1; AKwUvBwzFZk9LcTEXXCPeFFUttL4DKfo29ngbF2RIenghxZWkldiqXNuf4AOS4fq7KTa2wFMWqWOfGCx@vger.kernel.org
X-Gm-Message-State: AFq9FYI3YirkI9IgeevIne9SakBFeVwfeTOvjQTrp+1cw/Jouur1qsFB
	BmPLIBtXZ2GXbAL30/jLG+6oYHj0JFAvIx5oIoH4sr7TC5B5znXBGvonUj/HPQ29l5U=
X-Gm-Gg: AYBFou1pOk9VYLAz3ZLNCyFEm6MCM7qcweACBohpbz/+CaN1CtDDq+Jtdbv1xzLxyKQ
	LnDyjp2vrWA/6JQx2T6jipeZrKMbKlyHZtMxyWOa/MsnQaPUXJPJnPMLXtjNqR7ZFiC8HzmU601
	hQvADvMVmsYqF5OpFryJ3547DMWDvShRZd31vmTnvnI38Poms4ULJ+nM5xTXZYqFFnjgxJ3vaKh
	Sd1siNZV0lp2NTm4BMSHTeSRq578qV+Vs+hFflY8bDtpvdKnk9ZNbBRgbF8t8+ryx2k9oKoZc/8
	sfe2NoliUYRzWjYlVQXn6cm5CPL7O9UuoavuuGHuri7XQL7UqzGlEgT5WWHKDyOC8RMbUT8WR0K
	HXvGFFTpLKe8+B02uxG0y/vJ8Sl49aZtv0eALxwWOibJa1aTXgKPfyyWykxMlOgnElwIp59Sta7
	giXY/RC0TRTcBViMAuFU1LF1hChgN8ycK1ylROdmRB+bcMnVROEMdyB5aNeaNtEKJnvVVedZsLK
	L8Jem6QdUt3xT947i9laiN1ly1y1/fUkL1KrSwckcWSDUI1eeer0xU=
X-Received: by 2002:a05:622a:90b:b0:536:48df:345a with SMTP id d75a77b69052e-53648df3cb9mr103473081cf.32.1792426243229;
        Mon, 19 Oct 2026 09:10:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5367b3d1ccbsm12827051cf.0.2026.10.19.09.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:10:42 -0700 (PDT)
Date: Mon, 19 Oct 2026 12:10:40 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, ljs@kernel.org, 
	mhocko@suse.com, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, weixugc@google.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Message-ID: <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F>
References: <20261019141401.11927-1-lizhe.67@bytedance.com>
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
In-Reply-To: <20261019141401.11927-1-lizhe.67@bytedance.com>

On Mon, Oct 19, 2026 at 10:13:59PM +0800, Li Zhe wrote:
> memory.reclaim is a useful proactive reclaim interface for memcgs, but
> tiered memory makes "reclaim N bytes from this memcg" underspecified for
> userspace controllers that manage memory placement across tiers. The
> kernel's reclaim policy is aging-based, and on tiered systems aging may
> demote folios before they are eventually evicted. Without a way to
> declare where reclaim pressure should start, userspace can only reclaim
> from the memcg as a whole and observe one aggregate progress value.

This is not a good argument for pushing the complexity of managing tiers
into userspace - it is an argument for fixing the reclaim interface to
handle demotion and eviction sanely - which presently we do not do.

My best examples:
  1) the watermarks don't make sense for lower tiers that need to absorb
     large amounts of demotions from upper tiers.  It's likely lower
     tiers need larger WMARK_PROMO to let low-tier kswapd run longer.

  2) proactive and async reclaim current reclaim top-down, which results
     in swapping directly from top-tiers because lower tiers don't have
     space to absorb demotions.  We should experiment with async /
     proactive reclaim applying bottom-up (lowest tier first) so aging
     the top-tiers demotes into lower tiers more successfully.

     direct reclaim should stay top-down because we want the best page
     with the least work to minimize stalls.

I have a strong suspicion if we made these change, then memcg.reclaim
would work more or less the way you'd want - and anything else can be
managed more directly with madvise/process_madvise.

I also have concerns with extending memory.reclaim this way permanently
locking in reclaim implementation details that prevent us from making
changes like this in the future.

~Gregory
