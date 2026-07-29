Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5B743C067
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 08:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785313318; cv=none; b=MMIQEFBbrmLTy4GNDKYQLlzAuWCOQ7w7W2CUlSl7ffEqBUMk/gHn1ULLYvprmnn+QJ/3vieut5Fr3l3FHIc5gEgIj+lRLB/mvzK9wrj5j6Y3ziXd0XL9MpFrwJX92wlvqU41FtMoWgKZO7mFQefz6bDECuAYlP5/6QdUDPltOwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785313318; c=relaxed/simple;
	bh=+8wOGBtVS4sbNe749HEkgNACNioF9ncWq7rqnq7Wl/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+WxE/T9ApylXHwJVlZfpL841TonLGyF1UAp3lipmXFn4u3C6ZTCvNZqFAEd8Fo68iGtTG6AO1WNVSCyYXzOcwOIF6q0wLzHfEtAL3ncBRBsMUuJI6K/PPZBOs4ItPMesJCGr4IvzTwCMKucb4g820RJYfLDYHbWMvW88woNf7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HCcbdCxt; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HCcbdCxt"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47f81a3ccf9so507002f8f.0
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 01:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785313307; x=1785918107; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kf3hEdsSYCZNTX5rn+lOkaFGwEn2EXdhe7ejyIAKxL4=;
        b=HCcbdCxtTwGoucjNU9lvXHqmarl0kxkJlKUIjk9KW9gvUD00+zymykIIMzuE0TgOvg
         MNSXBsw3VD/XxR+ejcmvSpuRDDtf8bAVT7X3EnpQxsTYpz8nsXfZ3FTUK9k5VVW7G5Tp
         gA0U0Ld+Br5HzYyip88c++mhSYKqQWlvUHVJZs/sKOSZSAMjZ8guz0ItsQXscDRYlQyf
         sv/w7gl1ApDELxeZPEgUo+Jmql699nKzPwcw/AiT4iFlifbZvj7duzi12rQcp15KVC+W
         AJOewvx5I7mHoHofm/DVc0MQPUlkYwgIiqwjL/VJGeasY8vqXGBISIYF7iQm55u056Q/
         j67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785313307; x=1785918107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kf3hEdsSYCZNTX5rn+lOkaFGwEn2EXdhe7ejyIAKxL4=;
        b=ceVyovHCedLQEDLacvzengA9DqRKQR+A9srEfk+s5v4+VMik5lPOYqi5GWuXcL7mBr
         dbXk7vwyj/e4c+rIxg4XnFA1rZuMTfLxAZjfEFE7pVXzJcA/JhgmaZxZ7laABiAFTWZN
         W4p+9qplcajEo0uE6m66tvwqATE1I2C1ECtnkK8ZOkxiUPw4rc04c+M0EbULW3iqOLjd
         U3cUx2LpaC77roWx8b9WOo1n9DV0vkKfMrtiofnY4ob/3n6tLnOgGi4Rv4c9edFmWWtx
         O6/cbrO/L0EbNQtcwXQ3+PI4TwPsWyJn49X+qoaZF3Xb2H1njzywDnfO4Cpp5S/Hyvy0
         vfXQ==
X-Forwarded-Encrypted: i=1; AHgh+RrpvI+P4TxcnX6ELZheu5fKYb2/znc7BM79KPbjmBOY+lNj8exc/VoPQ3S4S+3zHJ/rUOnVQEOU@vger.kernel.org
X-Gm-Message-State: AOJu0YzW2xacj6lwp45NnclypSBuzmFec4jKxhw2ABUUAC1vlVLAc8f4
	bzS8+hlfkQj72tAUH66QRcoQLatn3wlzb4PDE4PT52qhooC0rUxHg6SOKsvwa7HyoeI=
X-Gm-Gg: AR+sD119k3tajczNtOaf+yWUjIbE+XBflxChUc9+9XwqOGWJrM+xyI4TazQXOLAgIAT
	AQ7jM3Xj+cWIzDNpz8GKfqI/MScBX/jID7JRIimgyBheQPWud0YBC6X1syykzYaKKlMBqIxLEEJ
	a1ALY9AErs8v9dju/u6qEyByCtdVJqR8wSEUcyqN69vYjg5lk5qMhkMaMqyTQwpohlu+lKpvZ/W
	gjOIZCLNuX8PI9aOk61X7mLxh2MWyVwLU3rjh3zZV1XBZYfYJWNbaTYRx5O0jxvgg2mRXTntL7u
	GuncAnf7gzjj7U/uxrBMbxHV2cg7yfUvifSR8+Kj0E1IiGMT8GtbwvJ+Em9BsvVwtZqAoS3eiAJ
	b3jJQI0RzBpjZoC307brLFZ94qMI+uVYdpYcec/wys2n7xtzio/VSnsV3kixF7ZWPYh132CPlBK
	qboxqC78/sLhtpSVzTndrJuS+D8wQV+V0IWR9kOLCwkwTFQ7UON5zEhpr8k80ymwImXErM
X-Received: by 2002:a05:6000:22c3:b0:47f:9567:e63b with SMTP id ffacd0b85a97d-47fb1f26115mr7562586f8f.55.1785313306843;
        Wed, 29 Jul 2026 01:21:46 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b0ef1asm5812361f8f.19.2026.07.29.01.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 01:21:46 -0700 (PDT)
Date: Wed, 29 Jul 2026 10:21:45 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amm4GQP90D6Ho6Rw@tiehlicka>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
 <ame7Q-0eVRrtt34j@linux.dev>
 <amhZ645Nhj856JfO@tiehlicka>
 <amjeUV3dAn7KPQgK@linux.dev>
 <amkBvRSJm5rgiV5Q@tiehlicka>
 <amkjTk7Jc1q4ubxj@linux.dev>
 <amlkSmMZTWrT4rau@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amlkSmMZTWrT4rau@linux.dev>

On Tue 28-07-26 19:25:57, Shakeel Butt wrote:
[...]
> Now I have much better results. Previous numbers were on a VM and now I have
> ran on a physical machine and the results are much better and consistent. The
> baseline consistently shows ~90 seconds exit time while (tsk_is_oom_victim +
> MMF_OOM_SKIP) consistently show ~3 seconds exit time. I will send the formal
> patch soon.

Thanks a lot for the testing Shakeel! We can always ease the check but
if the more conservative approach helps already then this would be my
preferred way.

Thanks!

-- 
Michal Hocko
SUSE Labs
