Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE6443801B
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421822; cv=none; b=lGU+wksF1lzejBS+e3Ro76Io2ZkrXcSeP+O5lx1rZ4f3wOZLoyKxnm/d52E78FXr+0U/AehzEC0klB0pikCm3kkEWl9Dg2IBoX95ITP1HOIESEfQcaD490+Oi9TbgowMAk4LtR35nUwxErm0snuPB3DuoAdbeMYiefmSRqtTkHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421822; c=relaxed/simple;
	bh=6zxsMNNBcnPilLYN0lpOH6oC8qH8IQaVIGoWa8512x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzB4efwQv5aV5jcbVGqQVPG+Dp1GuQmSDvXqF0YA/1jOrWeHo2UuzgOQf+983Z9MRAURrQtCWLAFtdEEFdQam3MUCbwyLuz30m8rF64Tp1eNMAzbDHdQT7JlVQAyIcoIX4aNn2HF2Q8s5GiAkr5AtVuNzfVAaPRP3P8W5SbMzzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbUfHsAb; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbUfHsAb"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-4583b1703d3so805764fac.3
        for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 07:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785421820; x=1786026620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PziV63Nbks27UfV1soZbzQSjz5qZMrsSwS8b4MFid6w=;
        b=jbUfHsAbVQouSfaVk1kNLikd+kdeEEeJcUrNu4bmOyo1T6vua7q4f2tm+JY4ROCSZp
         VNwgLwUw0H74b2wFK+hTStGiWIiqvr6aRi8Q2oTXkPtYD5pUEyOVDPdaDt3s12CPgZJp
         wr5zaIiOWygG24kFLUA7XwHnsD0k72plmdSfqeNU+toH7ctiQE8OXwUPHELN5wnMpyXM
         7ePJHe+m1DiCv3BBBk3qrtuOBbmUY498CqGzhFEwAIQxfgB0PVjGw3CNO8peHuLyRSdN
         cqIFeq+1DAtlvFwqKDCu5XpdIXSZ8GnKV83rkLfVO/+Vuq4NOoqrVkTz9yDbM+UyslFe
         38MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785421820; x=1786026620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PziV63Nbks27UfV1soZbzQSjz5qZMrsSwS8b4MFid6w=;
        b=Ysgg7LHte4p/hBt5Y+yAtP+/kZZWqWG6TqkxFY7mcaVMR3TMYNmh6iy1o5lt4GEhgS
         Ys7sd9tL251CcHAL3L5ONPStoAIRvqXcS9YKZ9+KVvh0GajXOh88OvCNrkp8CYWwfiJQ
         p8diakc+FtAscvXg/eXdSf2WFXPpS/Fd64KHEnFFQwxNGXqRnlq/LUhQRK6+WQ/IvOn2
         gSQvmu/ZV0rywS1cm0IdwgspmIICMKQxJ0P0m1TsCzW57riL4hzZ3dkwDWpfiWiS/3Xn
         jmzKPDBvV3bCe+0D94EWMPH2boJi+VNkEtoLpmPWQqZtKhvrdi9r3AlahBajVzBR0dVw
         NWfA==
X-Forwarded-Encrypted: i=1; AHgh+Rq30cP1rsLovz1WVPYiQdiiBn88wan6JejlrUWKtASDjrjhBGqbr+F/4feMP5N+zfZ09Mug/lPf@vger.kernel.org
X-Gm-Message-State: AOJu0YwJetxpukQ7+8isTb15Qe3Bb7glIlXv5j68ZDMfSgELjtfhoy+L
	0vPQdkdPT3snXsdQIic2SjVCID275WkMJd2pd/U8ubq7qmYYtyTGnT05
X-Gm-Gg: AR+sD13G9daJeWq3SCmnJj/Wy55/xDMui5WOINpJdaRGZcgKL8hR8/QtrTeuoAPwe5u
	X9XJOZ3PI5edcQz7NxC5qccYVntmyTH8YAs+7oUS5prbhBhGEwzLOVJcJ77jfhj6qTtuoPKjuHy
	d0t/N57I2one7Atws1dQnep2sa7dX5PxaCNkOajWEdFJlzw407ar8y6DY8xq9+DyjzQniLnajd/
	ik+wya9H4skaaVhBrJB26kDkdese7C6y7AGYRI4rkDxTQnMal/Ds+YcTDDlhYZtwF2f0LqqE7sn
	dxMomm+7kYeZ+JqLF11eNz30VEWvdF4E6StXScwtR76HMzKsYVk0Bx5GJHM9fZnSIlVkWjLZC5M
	VlSceVXGqo+0HjwobAH5W/sQBzmqYh5LvOWdoWY2UN6lSYPUX8gw0j9uRz5P/nGyCJYD0R3IxBJ
	I0z/WGTA/I+KIbJsNgg/9eUCzWuRy91XyTDqHgNb/AvYe+zLABJgRbc0t7diolXUw/basQ3Bm2d
	H/SP1VmM26BxLpU+a0R8rC4EyqQog==
X-Received: by 2002:a05:6870:8263:b0:456:5582:19be with SMTP id 586e51a60fabf-458c1b24576mr1955115fac.38.1785421820045;
        Thu, 30 Jul 2026 07:30:20 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-458c2947cc5sm1964872fac.11.2026.07.30.07.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 07:30:19 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Oliver Sang <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev,
	lkp@intel.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	"Michal Hocko" <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Shakeel Butt" <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	tim.c.chen@intel.com,
	vinicius.gomes@intel.com,
	ehab.ababneh@intel.com,
	thomas.falcon@intel.com,
	yu.c.chen@intel.com,
	philip.li@intel.com
Subject: Re: [PATCH v4 4/5] mm/memcontrol: convert memcg to use page_counter_stock
Date: Thu, 30 Jul 2026 07:30:16 -0700
Message-ID: <20260730143017.1568456-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <amr1lhRiYC64kYNY@xsang-desk>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 30 Jul 2026 14:56:22 +0800 Oliver Sang <oliver.sang@intel.com> wrote:

> hi, Joshua Hahn,
> 
> we are currently piloting AI integrations to help enhance 0-Day's performance
> analysis and regression-detection capabilities. Since this is in an early trial
> phase, we want to ensure we build features that genuinely support your workflow.
> We would love to hear what you would like to see from AI-assisted reports, whether
> it's specific bottleneck explanations, a cleaner format, or filtering ideas.
> 
> Please share your thoughts and suggestions with us to help guide our development!
> 

Hello Oliver,

Thank you for this sample fix, and thank you for the report. It helped me
realize that uncharging should return stock, but only in the networking
side (and not the lru side, since it's already batched there).

This is a personal style preference but I like to keep reply context as
minimal as possible, I think that the AI response might not need to keep
all the performance statistics still in the reply at the end : -)

Otherwise I am a big fan of this (for my patches, at least) as an author.
I'm wondering if reviewers and maintainers may find this to be too noisy
to be sent out in the mailing list.

Thank you again, I hope you have a great day!
Joshua
