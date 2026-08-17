Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9732C439F71
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975805; cv=none; b=a/eeTCOkIFzEKJ8XwIcv6MK2GSZT0sXmtC1elPRLHQGrH4yzfgowC5mMObQYkT0TPqO7/n0WAp49LDGnH8kuaWqil71ceWXR+MLacREUMI7EoknnTAS2xNdbx8Y9pn3ba4XV2E0x4xe0byZ8xlSXsnKmn/2YOZOb66zzzzNYIZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975805; c=relaxed/simple;
	bh=8IDnOBUcoPx547bRYBTR4KUHldQID+VjR0lkpI/78Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mOSFBWMTlyqQJv3c18twsZca4ga/a4Z8YBjNlrbLNR0qve+dKD/NdeGjZxcrsKoGLQ1ObK+HgAapJ1nFZHHx7keNpqdW6S7emE/4IAlX3n0E72Hu9xXZGDB0iKsCExkrv+qt9wOz4EixfVsUmDYIKTW4oMAupAvDPSwmIM7vIvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eoQVSLdw; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eoQVSLdw"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49802c418b5so36707935e9.1
        for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 07:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786975802; x=1787580602; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8MKoSFy0sjpfHZygpH5fwT4llQ68LAYzLIxwAjtZT14=;
        b=eoQVSLdw79ijYwViNDJc03PBN8sEa0mXXqOAwUz3sCXHAEZTNAlXtYmr9FPP/34im2
         KXEb6lY3hUNDV8XWk9ebxkv+xh2kae30ef/7Ir4W9pxffsDBCk3scVzMIUZV0hi8pzVq
         NUgbUCsyOnWhAMveFfowR24meh19E/ZSrw8XREq6DVKJfRRyiYVFGdGv/5H0CCRO2m7Z
         FFLfnxEJR9BcJaSOv62JPDuEOx4CiVRy4d0nKahNnAIdv0KsI4I+OOugEeSnCwPmsimM
         d9iicZ6aV6Ai0l11Fpwq6t61GWDW6ESRY5s5GbMh6NmvPFJP39EyJgP28f6hQ0DMhqU8
         Cisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786975802; x=1787580602;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8MKoSFy0sjpfHZygpH5fwT4llQ68LAYzLIxwAjtZT14=;
        b=mKQkG3eRCg/LQ0TJzGFfqcO/BhzjBK88sr7ILfo/WNBsK3I2HekYtLEI2WVANgrd67
         Fm9S6IQHKVHtdEb3YmhIlcH/HfLD7CECkuxug2Kf5FCdx/2ARYVwwngnuGFu9kzwvo7A
         NNETQyeQh09NrAQXxLX1iLqCFjvQxXCdZDbhAtoMdNKBpPk+XDeboodhZQuFd5iu+FmJ
         /bLCUIe3QYMBIScArRJOQhaYVwEI45fx8smwAFv3Ty3qrmqNaKNQyvumQkjiHgyHB2yL
         pSH0egLEsEOPRTL4pfoc/rww/4EsBjesA5ccyPjkSM9AQAXfySD10mqh6uk5t4bTNcxk
         noKQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro5fqrfchaqfOUEVslgbBiDpZOINysxEBxOD5hTTxTgLxygDU3GoKWsnO16GmvjoAZsdI/poV0s@vger.kernel.org
X-Gm-Message-State: AOJu0YzX0RmzE8+sz0llaymuhtGpswhx4eH8pGVFpzLaGHegp+iFjYtu
	UH9OMLYThUkE+YHd6zjxZFzPjUmPfKCCpiiNota0PfFMApb+smwMZt/JqvqEmRJZ0O4=
X-Gm-Gg: AR+sD135hr3ukKfS8F6x91gqlH/t5kk2pqyxCsfay1uPdkpaLO3wuOo4K8wyCfwBO27
	DdpAMNNMx1G6XuMRpeqrdx3JqgNrXju2S0ph+Q0io2KI6RU9zY12AlLAa+PjHSFZWwy+/xKMYQ2
	1X9AEkEdiBHpJ0E1sDLu38RN4H1jr9TunZ+1Ls3LeOWg+5arQEbvxyTV1Dv5ID2nrxoU8KZsDPR
	FI6/7sHFV6MOjMvPsGtrKVTIrHUoIurDxeNqnLVRzbyBp/uIaP8bi+1UeA4tK9bcJbGbMCEwmrh
	LDGeDp1qafy06W9+E4/E75YVWscdWd8zvntcEfzBxrtISAyxkRpL5oDTKRXvEYeFe3CpDf5FioJ
	JzPc/+swFMD9t25IC4AZ+bdZ/G4zqv9C7bqNyY2+SLxe2hgvloJyYe+HTh9LI6vjVP1Byb9Y8fD
	7NwcOXit7o/OA67/Qz8h7ofJDOlunetyiBAuu4B/i8mxgN95EwJPf3RCnIC+q3phxTWb/o6WU=
X-Received: by 2002:a05:600c:3b8f:b0:495:4491:b8c2 with SMTP id 5b1f17b1804b1-499906ce446mr290282905e9.3.1786975801738;
        Mon, 17 Aug 2026 07:10:01 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d078523sm45861335e9.6.2026.08.17.07.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 07:10:01 -0700 (PDT)
Date: Mon, 17 Aug 2026 16:10:00 +0200
From: Michal Hocko <mhocko@suse.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, audra@redhat.com, bingfangguo@tencent.com,
	cgroups@vger.kernel.org, hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, zhuhui@kylinos.cn
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
Message-ID: <aoMWOILN9A-GgXJN@tiehlicka>
References: <aoLGzZHS8kj53-ey@tiehlicka>
 <20260817131221.44761-1-husong@kylinos.cn>
 <aoMMr6kEX7pW1dSF@tiehlicka>
 <eef3b61a-a8c2-4b2e-b560-c2dae129bb7a@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eef3b61a-a8c2-4b2e-b560-c2dae129bb7a@kylinos.cn>

On Mon 17-08-26 21:58:39, Song Hu wrote:
> Hi,Michal
> 
> 在 2026/8/17 21:29, Michal Hocko 写道:
> > On Mon 17-08-26 21:12:21, Song Hu wrote:
> >> On Mon 17-08-26, Michal Hocko wrote:
> >>> Is there any specific reason why the memcg stays in the cache slot
> >>> without any pages?
> >>
> >> consume_stock() doesn't release the slot when nr_pages hits zero.  It
> >> is kept for the next charge of the same task and only gets displaced
> >> by a charge under a different memcg or by CPU hotplug.  The problem is
> >> that the offlining drain skips empty slots, so the css reference they
> >> hold is never dropped unless something unrelated displaces them.
> > 
> > This doesn't answer my question, really, does it? Is there any good
> > reason for this implementation? Why do we need to drop references
> > remotely when we can do so when the last cached charge is consumed?
> > 
> 
> Fair enough.  There is no strong reason.  Keeping the slot
> populated after the last page is consumed only saves a
> css_get()/css_put() pair when the same memcg charges again on that
> CPU - a micro-optimization from the original single-slot
> implementation.

This would also allow more effective use of the stock because it
wouldn't need to throw other stock away when refilling.

-- 
Michal Hocko
SUSE Labs
