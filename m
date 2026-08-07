Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C063876D7
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 21:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786136811; cv=none; b=n+JYfQ2t61Es0w87BG0ILaTeKTwnDUlJZt4GaJcTOuMjxxaSw9sX22gxf6AL2zfmfyeqfLM2mDU0luzU4N5p2LSVFAm0avQnTQ4cB/Ww5fd8O5QV3XtUrtsKjgScUa5DVvq+vohQtTJYz3D+ePUxDPHSaCG03KN/3UB8y/4R1Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786136811; c=relaxed/simple;
	bh=4HDxV8AOnVYHdrgs0ibOVVOJXW1dukzUfV+AYeW4k1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbfIvrjRbknptrVlw0LgULFgejyVfXALtzTZWKV8CRM1SRaRgqIwlQFn3uJ2FIv+VF/FE7bsCBvEcOCeY03L/PeVLHN2uTXhEqbD0orZ4/Zw0/Nwb8z6i7LSJEySfsaQpg9IOGPhD4sfswfmqVJVncb9q8DOhUsM3W28t+J5M2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=gcaMQRk+; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="gcaMQRk+"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8f18d92172aso38778186d6.2
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 14:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786136808; x=1786741608; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4HDxV8AOnVYHdrgs0ibOVVOJXW1dukzUfV+AYeW4k1U=;
        b=gcaMQRk+/mKYs2TS/2kOOMwl9eaubMLIg8e54DEz+SU3tWtdJ9Kb2Z4gKrZXQRCUP2
         wsJo3WABgMXO8eZ6MxUf/mZHBPFsPpTvLf0P/SyPAIelL5Wj8sQ+SQ9yUaRGvn6C2MeO
         yMftjsgYDp0oDbDfxvcmlq6dTVxDl2ygVI0eZ1B+oFS0Fz8RE2LATY8NY/pQgqXDUOt6
         8qdIH4qbxmzv93rxf0cdhJFP9H8RRupBNh0hUFqRQsp0STNtWbeN3ohBK17rfWrwPAg3
         ymwhE4c8s7XhjXUfxlXidOg3jEOUNQqe4fPURQtzEYJ027AuCrFT8eftLlVRjqHtBw86
         p1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786136808; x=1786741608;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4HDxV8AOnVYHdrgs0ibOVVOJXW1dukzUfV+AYeW4k1U=;
        b=DrrFaZWrDYKHlnCC1sTaTLtfDiB9aXDbTYwVtIALbZKgLPu+TGgFX+VQVkLHCwKhBM
         jXdJ2dgUTz08HNP732L+WSN5yX3ySlLhVf2NJo9UhWg1W5tmrRHYrXEJyOSaXqTcl+Hr
         3VPBoDwmp9CeYCWRWR466vKYWG/tzjVbUK/QT3Z6RaRg4UNWt31lq579yy/qqCqpJJqE
         eoem8a2/YYPHhA45jTVgF+Sl6YaN4mabVZnOwEAzupylVl9Hqz0pKsuxbFK4cC5dzjo3
         NU/GWZeVlwHZEPZO/5Eo2hr4COpjMBTIvAQ4BJxy4QYjq62/xh5pwCI/zzSMuGsIuIWn
         k4tA==
X-Forwarded-Encrypted: i=1; AHgh+RrTGZ5mKJeBuBVkwSD+385gqtlbHrKCIe5N8OUaMde4yNT8yaM5RMW7l4T5IXtpt8XyD1wC31Ch@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2RL4QSI3mnXyo3OmkHivyvl+aEX5BkVYyjPhhNzVNL44vts88
	pyY8RcyK83CfVQeknaWTq50frbIwaxMvbjNA0UWVQoFDU31MpypaTsLNhzzvmtrO8ac=
X-Gm-Gg: AR+sD10kIqiC0PAbi/F7Jadva3m94M1bb6HS/orPousmW9Y/4mZ9af62NALxkMFhkzd
	YfXeBZayDLeIBDh+SxW2pA5quiAxY2d1fS+ejdYXPvlu05Lu7dKDPn9aw00P8z7xac3+Azgw85b
	hgeGq8MeRQ9oYLvMeg0XWhH6ZfyAZO762jT0IwPp0Hfiww55KZpdSHtXz1MzoCgzK89Nifg3kGo
	Oe4lgIi0dUhEMja3K1qUTNnWT+8IifGVA4KGV0+8JV16wcCv4TioB6/Kybr2o2vW5w2O/MXybY8
	h7qiyE3i6wGew9yrc7JTa779pjbRw1C2hdpTcY6yYDpr0Q1Lh0aUgs+gyR+pAu/DdxOFkZ2p4d6
	yOIV6ET/gB4txjqIBc/X/UeZmceoZ94wARACWNzO7SPfHIpAbp3tfD1qtuNEH7dIFkefbEmLM+F
	AnvKVjicGteYY4MEpRdg5OkGfvPkVmErEPeW6HCxe1OY0L5DwYw88Tvzh+3VQ=
X-Received: by 2002:a05:622a:2448:b0:51c:1117:c79 with SMTP id d75a77b69052e-52d0b193284mr158320901cf.24.1786136807783;
        Fri, 07 Aug 2026 14:06:47 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d165fc55fsm19974341cf.25.2026.08.07.14.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 14:06:46 -0700 (PDT)
Date: Fri, 7 Aug 2026 17:06:45 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, baohua@kernel.org,
	youngjun.park@lge.com, baolin.wang@linux.alibaba.com,
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation
 failures
Message-ID: <anZI5dXe2YhLoR1a@cmpxchg.org>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
 <anWAZ3T6Sz8bsKSo@KASONG-MC4>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anWAZ3T6Sz8bsKSo@KASONG-MC4>

On Fri, Aug 07, 2026 at 04:29:17PM +0800, Kairui Song wrote:
> Am I the only one that feel this returning argument is a bit ugly? See below..

> Will is be good if we just always check the margin use this helper
> on alloc failure? Alloc failure should be a rather cold path I think?

Works for me!

Sorry, I may have been the main instigator of that complication.
