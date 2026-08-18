Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1963928BAB9
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 15:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787068637; cv=none; b=GjCSPr0i002rb+RVDIwVENArcfx1nhX7Ydc14zqV9RIP9f8b047z56HGl+lcyWDJLM5+rSN6rN/GeIeCgO1sMrNe99FS9sfZA36qP5CPoy4DNDWDrHyY/XFyRi+BoQRkGrzAFJ3X4Yej3DU8c2Kzs2RSTqpyQ00Cg1LnG7kuAec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787068637; c=relaxed/simple;
	bh=jtRz0mEP4MuJi9M2/9rT3uxb5eFSZpck7/GTTf9Nkgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU9P8zqZ7xrKqLPvhgGOeUHo8SjF6d08RNmJAGMeP3OCdPlikyTdlBwR+LC4bqKZTV3BmQzkt4plGF8Ozdq8+ekNsdvZrzZYcCrunVvfr3it46bmEIALejT3vgZnW3EPDTadb8bwqX/XnGnjtBx3+JPWUJrk03K0hJAfUntzCn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oX6R/VMh; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oX6R/VMh"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e6b5737bb2so5564524a34.1
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 08:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787068635; x=1787673435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aJsNbFhcAvc23yP9oB4/NO35b1/oluJDB0GRajdvh5k=;
        b=oX6R/VMhJ5Pq2MuLM53VrxN7l/zzB7kiIArUgA/YpvuR45nfyf9T5xYSmzP6gUfETd
         T+7SCKC8xbaiPPsARX7JNZS3qddUZ1LN6lRdSwIquit7skG7473b1CVwLYoKPyqaImW5
         tre03gKrabsorvJ0muPW8erM6rFHQSrJ2AHE4q16k0aKO31uCUlJmWDEghuIpu/4Ieb8
         pHE8uMu898yd0Ssiz62x6fEf7wXsYzPifN68u4L3Lk4XnA87tG9irq3pM8I5Cr9EBK8x
         w2Bg9AUKiGYMo7vhRS2DW4v2XIPhX5Mk3+Wy6VvqyNpV5Uln/kSv70up7kLtRwwgrINq
         GIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787068635; x=1787673435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aJsNbFhcAvc23yP9oB4/NO35b1/oluJDB0GRajdvh5k=;
        b=FbcNY+Bvp/7z2V7D+9RgvFskibfqK6yfl4a3Ju03Q10adF68E7WbdSJs+dYRUfuXM1
         7Nw0Tk69cxOJT4tRzk44TyHjXPWSLC0tJJ592gsyQ/GWnzLHU72SXKm81dIfwZggwE8n
         uJ41hS2h8tcUaR0ngoj0qiRSvd6vEDZJ+t05XQj0JeiYZStSOdhZPAbeIVVg0J3Yxdkc
         e6ffOnnFHFhR6txvPp7nMBSTVcqir4CZYZt2NMyM0drJ0spw8202CL1r9zsCPT7j/DmU
         YyiWlP7i4spyCFDlByP5AXYQwL5uYeyXdKjKpZ1xHo+jGYh54AGSE7gffbcmhaB/Y7Ql
         YpUQ==
X-Forwarded-Encrypted: i=1; AHgh+RobfwRaA3MFmPL6jEzZ2uFep0iMZg28yBHJHM3vIG0oEXXx0+e5kO76c53vqgDLLbbPlMh9NerT@vger.kernel.org
X-Gm-Message-State: AOJu0YwMKo2Nr45WJDebpgsN5HqFrcwPuhVZPjoV+a1aV+p3qvb96KW7
	1JFbKvW/xOFuU2KQD6Aq5GCvp8XPi0a3Z5/Vc1sNpSeo++DkLUubm8LP
X-Gm-Gg: AR+sD11Cl5sfEGzMsd44s4hG40VfI0QoNbysYDHlN3XSOVSyLEnayc2Yg9dwbneqodi
	XC5gzsPRHoTfFPZnO3RA3hXizpl+aUzO/qcKHSL2EN1SjDRuazNiRd/I391YuiiL+RgVOSmfZ+s
	wTJ1DOGssMcVKhL3zxi/KziHBTcNEJbG0PN+AYtrxLzYU378uvRWWnnBuIdz8vpSjDXlrQbNgTY
	viUX2Qe+jooKxuwyd1gq0S9OvbhA8PVy4nmNWz7sJQwVHmx99V7SmOoo+3GLcMwk3y6+tDwEung
	FWjWxI1SRFCOjAjS4+YYCfv22fNwiEFVc12Exgc6InHz4M6ZhgGVkysuM++AWhvdvqIv2gbBcnN
	VThvTjwxJ7NGYTJIEol1R18BL3415NINY6Liq16VVJF/DX+unj+zYM0LulZfgSP+q0N8EfEWayk
	n/6+XormGbkpg48cb2bN2/bsBb9tC+J0aslSdgBNwTXb93kRtUnPNAlQxp22w/fO2+yncgA1Hl+
	y7R22wb5d7TP6k5n4KYvOFBMGLsoI9hhdxOq55pbSI5
X-Received: by 2002:a05:6830:63cc:b0:7e6:f7fb:9678 with SMTP id 46e09a7af769-7f423c38469mr9469536a34.1.1787068634964;
        Tue, 18 Aug 2026 08:57:14 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f41c0f3598sm5379975a34.20.2026.08.18.08.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 08:57:14 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: liuqiqi@kylinos.cn,
	linux-mm@kvack.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory accounting and control
Date: Tue, 18 Aug 2026 08:57:12 -0700
Message-ID: <20260818155712.882286-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aoQT45_Vu8KZ9rjk@tiehlicka>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 18 Aug 2026 10:12:19 +0200 Michal Hocko <mhocko@suse.com> wrote:

> Are you aware of a similar work in this area by Joshua
> https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/T/#u?
> We owe Joshua review feedback for quite some time but if I have to be
> honest the most impeding factor on my end is that I am not really
> convinced tier aware controlling is the right direction. I have
> expressed some concerns on one of the earlier proposal by Joshua
> https://lore.kernel.org/all/aZ2LC0KPF0xsAwAL@tiehlicka/T/#u
> 
> In any way it would be great to talk and compare your approaches see
> where they align and the discuss further.

Hi Michal,

I hope you have been doing well! Maybe this is a good opportunity to
squash concerns about the series : -) I've sent a new version which
addresses a lot of the concerns that David Hildenbrand had previously
brought up [1]. This implementation is as transparent as can be to the
user. I hope that this makes sense to you! 

IIRC you had some concerns about getting the interface right the first
time we introduce this feature. Hopefully with no user-visible features
(and only a mount option) your concerns there are resolved and hopefully
we can work to figure out what remaining concerns there are.

Thank you as always for your time. I hope you have a great day!
Joshua

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/
