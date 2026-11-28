Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795827434;
	b=wMKsXoA6eP4Env6w90xMmDVtCDv1I4m3v6Lr6QkOlkE1VJ6sCNx9FJV7vC+fanDG0MqY
	 cIlFBQMdwgbF2aT518LpWmRXlIAaNwY8U0ADCVCnLMZXjPdiXlqnF+GFhrQuWcrJPK/SF
	 jpSVCB+AlE98hRaEvFaYysTItXGsw9ZAAgseE/itZzzwtDmKopotFJ8Lb2Iz6gZYXGRVm
	 lZX7VL9KBVuvqyClq0LCREMMmQf+IoRKfw4Angj2cvNv30XDNLiwQ636CYvhgfOG/gkPY
	 5VnZWhpEpavtDOIoCrDhuYBjiTQ74H05XzdBeeKIvvVGjW0iqOa69HniiBkcMe4S8aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795827434;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:User-Agent;
	bh=wlqqG4ragrnBG3kIbCybUs0/KOwqWAzi+ZO0z7g/NRY=;
	b=Y4Ic2I+bhyZSbd9kMSIh281/SE2Wl4iaGe2TwQNvZRdFnfFTJFRYr5q2z5albk+t41hF
	 tuXWSTwHIs/0rLSFY80bbgnuJfr0F1za3s/0P8K9OtY4IklBBl9vuU7oZwwOMujl8x9Pk
	 rT0gHm5tbAN8gFT6x94U7BGV28WPYPHh76tcj/G86ZS6aKuDMatTaQ6UB65+JzCWws1JT
	 Zm7HCvduQYnSvcyvPTr3SXJPUOwaFKWuyXl/wyx1AILQNOTURBBi3xV62yKAogsHju4iv
	 40eLqs4Y6IY25jQLISz3GGXctHpM2ueA2cxzfkU2h/nhiQ9OxpjIfDWzRGaIyLWj+1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=C1mkJXCI;
	arc=none smtp.remote-ip=209.85.128.180
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E98606A31C
	for <cgroups@vger.kernel.org>; Sat, 28 Nov 2026 00:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6E98606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=C1mkJXCI
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b4fb5d96b3so131783947b3.1
        for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 16:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795827433; x=1796432233; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wlqqG4ragrnBG3kIbCybUs0/KOwqWAzi+ZO0z7g/NRY=;
        b=C1mkJXCIpLkt8JNKyS0smGUjMBNpX+eUmxEBhz1pCUi+tcqO8q3OQNR2pwPtR+XeLJ
         0JcHc7OYWkCm8K5+Gz2alY2hfBPzSXfMKabvA4BM6/oxeufS/Y8Nvnp52T9Zh1sVbaw+
         yuRMDZQTZP2E1Ur44LJtAMS3wH5xY9PSrQIUQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795827433; x=1796432233;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wlqqG4ragrnBG3kIbCybUs0/KOwqWAzi+ZO0z7g/NRY=;
        b=LD1Uzi4etec0xxqUWFYMvKU9n9s85TT8odpegLk58ia06RppxNWwoVAC1/CRQqLDBK
         D40O9+se79YCZtMGTmwFqYuQ/RgYspeo8zmY5K/4+gwU+ES3JRjK7Sr789JsrDhQEki8
         2nJFAz63nYsDHlNf8ETMevWPUqBjVHdyWeGAY3IHwBurhR5zjwIf/hog/L/z8+WYp8Pp
         S4p0Ow83tvqOOG+Q3AKGktQlDeijbAekRbz/eF0MKz0zkD0YGHSF6byMgxlpwGzFuwgv
         NHJSyO5ctzcT2yvo0U99QBcHtQ/xThNNJAJYTCURDiKp4AZqAjhYzKT8nex/o0dtMJkM
         4kDQ==
X-Forwarded-Encrypted: i=1; AL+hErHnubBC8OCDj+KjQia3S67vqW043B59X6AsXfuS0gpef134tgaIEqxsl+IiCmpmhyupKTcOqPKy@vger.kernel.org
X-Gm-Message-State: APuU4Z/Fdp4wyMa/mZvsGJNKoaWgoehWI2z/HDY7o/UNq40Hom4KV6qM
	Ecg7XmyevT6S7lkpRUP1ijPHFkbSkOpO2sQgOoiyXFx6lrbTS4P6UjqNQ6vyHJ7qSKE=
X-Gm-Gg: AZFdTZc2SfpU3Be40jbGOYXEsbaZaZAEZe28cIYI51p4EQuRgMKH1VywpNm3bnxZgSh
	aE6Nv2xZtqhnxsAEHLEXmMU9HX8dCSKpv9Pu5dhIZ5va1dw58NSQ3vVzTexjPIblEEodJVihI9A
	2bUxPlbY8JHnhtJ9she5hStCSl6LmXocJwcO4thXs+UobVEzsKfi3DobUBZz4HChGmZZtnQl0ke
	vWt3VByOdAP9SPspujDdhAaDGkmRiRvbLYlsOK6ifk6Al8lnPi+BrB4VVfMKOhG4PbOBHhBms6G
	4Snv2VghIumaVzX5SBY9dg5xiisVmdylUMkA9vwVpI/ubLTzBuVpSbGKozHidmpUEvuVwIqwBwA
	XmXC+YdYll7dO7GduLD5iRrK4LzU9+/Bay1Pt/82Nvw2HxbVr8tA+aEBj8llkUFWkhpd+0/1TK9
	aAuVUqZanQNYpM9q+wj724yGYQrC+ZmHSgmK1oTOScIOOnc42jwOqYWsHqxGMhRxvXxeWUPjcbt
	hX89KOZdgsb13FPfwebHkUVDtLBnrcVG98RSwJKjmqLN0zmXEUoxh5xojhJUrxgdQD2dqOeOx9R
	bX3g8gTnOaT8tSYKnNq9+toIpZAxz19nBk0w4jqQTc+O+BX3xKA6REFwUkRU/fZpPmjtLORUdXm
	shEaS7HwG0Y94yK14Yf8NmJY9DNw6CHV0DTI8AVnt+VtnQo0nhFAZ0jLGlGPNZdW4X2FllESN1r
	qfVAzKcXKqQYdBW14XEQA7Iqd/A5fysNeYqCMt4EMMGtM3/+6sVHwB/N2C2gPFhzKs0F9ZsXl00
	rsVzhGrrw3KXtpeU7QTMfA=
X-Received: by 2002:a05:690c:c1b:b0:87e:645c:182b with SMTP id 00721157ae682-8b5204dda89mr106486127b3.26.1795827432517;
        Fri, 27 Nov 2026 16:57:12 -0800 (PST)
Received: from [172.20.0.2] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52028d628sm99080227b3.8.2026.11.27.16.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 16:57:11 -0800 (PST)
Date: Fri, 27 Nov 2026 16:57:10 -0800
From: Chris Down <chris@chrisdown.name>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>,
	Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
	against filesystem freeze
In-Reply-To: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
Message-ID: <awom5tLa6tNWPZYK@chrisdown.name>
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
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Tejun,

Thanks, I've reproduced the deadlock against fsfreeze and have verified
that this patch fixes it.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris
