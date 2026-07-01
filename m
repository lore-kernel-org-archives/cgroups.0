Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA8C39E9AD
	for <cgroups@vger.kernel.org>; Wed,  1 Jul 2026 22:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782944595; cv=none; b=lsPwZ/ZwOyg3TfvQIrYLNwrqnAym7gEj8xUhYiJghKo3/pJQ0sdXrLTHrnTAw+BTWPMQia09fOweCGh6cA8kLNgP/XLiG81/lXjeNknWO1TbgSLYWtqX33yRpO/erXC4gj0o0Zs1pU98RGiDSF5Dua7+YX63jSrlMxDpebEHky8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782944595; c=relaxed/simple;
	bh=KU8JRczlJGcjFzAodJdzcbwxr9RfuKid2NQv/U9XCsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WeZfY8CXBONGqxLF4BDRglEPX839az94zNUGAEEeJYgl4SrmZR+A1ZWHKMUZ1wDtTUoFSrT/4BLf2/yR1cSfAqfffnw9A6+ukFzv0/4FcLgkZSQuXOYaqPepMBUjLZ+GHMbnTJP7NPHGyQ0cL7+xxirZA2YKhwKM09snqyMaw3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=M1etvRLq; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="M1etvRLq"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c22c61795so7635751cf.0
        for <cgroups@vger.kernel.org>; Wed, 01 Jul 2026 15:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782944593; x=1783549393; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mzGi3q7f//J+/0nbK8M7S8SOi/us89kIFm9tzA7hwts=;
        b=M1etvRLqYf/ndYzuUN/Ok7deUvxMhbfMG7x2BMXR5v7odKN1jvx9o4oAXe26Xb9AeS
         W/wqrVPVPX4yrpsQHFLkQHxf+nAEDcPEpH/7tuRuopKHAk2wgRTs3dsQvUHFBlZ1+AJO
         sMMblxQtdTz1lQFg4r67luf+ffNSXEwq3yz/tgGV57ae3z/bj0wRTC2QSjEvAQ5sMwzR
         IR9zoemFu76z+5iuPp6dUFb+Eam7Rho51RGQNou4PHHe1xXYanBEe8UUiaxBvWDydduh
         ufzOQxO+A9zTMii+pvhKk7og/SZqtjc5tH5PaCAxcxo1InDm1IiB0fu4raSFXzHomM6x
         4CvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782944593; x=1783549393;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mzGi3q7f//J+/0nbK8M7S8SOi/us89kIFm9tzA7hwts=;
        b=OzfFz5FtsEJzFrRR9aARei62sJdAk2dsXJM1COsNA9DYF4SwwILgX6y5GDq7lkOUgE
         jei0uITOYihdy23Jx9oRIvCMSO+nnoergCIRHsD/kYk/yx2jl5AV9Bht8NbNdR7shsr8
         uuwWakhsk2QvWK4stmSKUaD8cehkDDvgWXhySHKGLpH4qiSxHd5JjRlU+aGg9W7ecvJb
         k6yi2WLuXpe2YEM/P6hsk5+sjYscIIhndmEkSAv1x3Gk7xRIly75FVhpxZ9s2a1yyn8B
         wtQ7ZhF75ChBTpf93L+U+gPo9BhtWWO/sa9a+U0NE+HcrCbrfakEEt+i+3TL40Q6WfXi
         H2RQ==
X-Forwarded-Encrypted: i=1; AFNElJ+htzYpmSlqF6OsCdKV8j6KzDk1J8Fww3cltQ0hEx9/RfcOLYLtevXcHHsBEcS06dpPA9AB8XIa@vger.kernel.org
X-Gm-Message-State: AOJu0YwhG3ap1G8/bfpaOzgbftnh6OI4XXgtEpVfpx5Q8HEzr0Z6FSBc
	T7ruoCB+NAgsAsMx6r0QD6qlvB1fKli8drvN0fINMoT2Oi2uZbttWdIQTinVBKtlyYY=
X-Gm-Gg: AfdE7cnBSD28EgRxvbmvY42a62ACtnkhaBIyzAO72FoA95prXuG2p0t8QHJTvuynujj
	+ma91FNW/FJOqtEihH/Qk3RQbVEPbkTWWTnEAIASJKcPSMp23X9CkRnOVcn2GYvP1wYVXlb2JHm
	3cu+dbQF7dI/HoMIg/TJltgWG02waiIH88VZ9wev9UMBI/F6seOV8J/27Sdbx6/VtqRDPE6NNTT
	rS1uqn697+Sjh9iklD+iP9o6feEgttA9n3egxszonX2v4NvWpon2E5T62xE65ZyUcfsUgeQBe8X
	jwPSDwK9tNOEXWnpo9S061/liWvjmYLeFa7CcDVCqwObn7gacizKn/GFtyAEJXxvuRFSM7ZNapA
	yzB3CCg3iX51XMtg64shLnFfn2wpj0kA+cKUXJhdg34zXNrOFBCbHyFD6AisNao2xGQmEAa5nzM
	o2HzRv8Xr4cPBQKIUxpjyg4sdWPYaf940+ceBNC1x7x9/YQ6qSkh1OtjmGnHnIPO36RLdK
X-Received: by 2002:a05:622a:1:b0:51c:1e6f:5c5e with SMTP id d75a77b69052e-51c2af1dc26mr37747081cf.55.1782944593541;
        Wed, 01 Jul 2026 15:23:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c30c15822sm2061921cf.15.2026.07.01.15.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 15:23:13 -0700 (PDT)
Date: Wed, 1 Jul 2026 18:23:08 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: gfp_types: fix __GFP_ACCOUNT, GFP_KERNEL_ACCOUNT
 documentation
Message-ID: <akWTTJe8l_nRQWt7@gourry-fedora-PF4VCD3F>
References: <20260701182102.1586784-1-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701182102.1586784-1-hannes@cmpxchg.org>

On Wed, Jul 01, 2026 at 02:21:02PM -0400, Johannes Weiner wrote:
> Gregory points out that these descriptions are cursed and confusing,
> considering what these flags actually do. This is mostly due to
> historic implementation choices and cgroup1 baggage. Improve the
> description of their actual effects.
> 
> Reported-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Much less cursed, thank you!

Reviewed-by: Gregory Price <gourry@gourry.net>

