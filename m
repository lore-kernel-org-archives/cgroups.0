Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795434579;
	b=axp/rURbPShH9sbIN9oaXnb8z38rQ6dEc8niIcAt71z7TPablKipgo59eoIZ1kWVEzOm
	 0T6dTntZFAmh4fcssKeH2nguPLW23WV94uGHia8lBv7tlFpF9oounabwDk0OIBiB2gzTo
	 yz73LLIkCKwr4TSuNnDDn77HHEXcBh0SkRWwHTaF2xuRZn52GqIopL0XsmRc9L+7qYYtg
	 +D033kFYuJOICnY90gqziG89sADEa5B9fA1mDcU+Nx4DLV3bw8sTwftPQyLvNC8LDiBtc
	 JtqY+phjxvdcyzwj8KFM1Kd6tO7Qf+qmHQYPlQZRvbfRak/jiWVHMHKyMe6q7gpZy9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795434579;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=nZFSp0goL8XjmcYoGXv0HxNvOIB0a28cVRyu5V9lYRM=;
	b=PScVCNFSkXH2aAuD+iAFllBisozCA3hk9hixgtzoVHLtW9vBE9zjUX3NAMizn346uwhg
	 OOCnJtnP0C5nRzxI3BOS2/RW1G+b1RRfBdl0NXLpvKSfW/4bGYMJNqNKBcN6R31jxbYwh
	 jGBphOyi8ra81JjMcFH5SPgrXfeBLhoeqtYSdermisKizgzrfma/s+nLzxAtiegwbT5L7
	 NVq+9A9tmCmpk94zUn5C1aUb07JQVM1czhP0qirtbM1ZHHgrhaE96o7mR/w/MOL4yXCum
	 aXAhryo8NCRuhKw5lXUy6Zr1gaAqor2KTbN0LK5Ib/uoZmRZcOrFmPOs3Q8IvnB8wfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CzUJIbk9;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AC2606A31A
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 11:49:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67AC2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CzUJIbk9
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4acb44dcd7bso2578147f8f.0
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 03:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795434578; x=1796039378; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nZFSp0goL8XjmcYoGXv0HxNvOIB0a28cVRyu5V9lYRM=;
        b=CzUJIbk97RZ2hv1oL8OKSUCjOsRQfOXST05apaPBzb2vINocN92T8ZptDqseWyI2RI
         8KKSfak1QFhbNmJjX66MObskBf3cv63LbqDdu2APUhvGZv6/l9tP6YyIFPHHRgHIM7Bz
         L79AO47Tq2dupE75ljLoRerpugPVVwKfyJ0lepNWctiQSAt+ge9mp4tO0pooda/u7IB7
         EvDpfNbRbgGeTzJiMvSoCZif477XtDiURd7vEb4QJSb48uerbqp2RK1oc2IRPp4FPT7D
         aFYaWcyagfP73qCY4Q0ZnxekA0gU2rv/InDAtUK7p9kbHXwJoJOS9O/teV7XvW8t6Z+a
         L1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434578; x=1796039378;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nZFSp0goL8XjmcYoGXv0HxNvOIB0a28cVRyu5V9lYRM=;
        b=gQgm0wLc+DqofEJaxqFnapolkaFrAGHl1y2tfFdIe+VUyMP4AKq1fGAf77OfQKyHaa
         yltWCJH9fKeGfqbMmv4/wPE+h0Ze4afqNWK+nZJoocGw7N8Uz/Ayz8V2PnmFMn+ag5/2
         tw6pwCQCW2X9t0/AAOahmVrt2CIX6jyE+sTTp8metPgdmDWIosacq5c1OplrhUZpBWaF
         y4t/k5C8EGcZanla9dpd6m0iKg8Oz5JD1zh3CEJzO5c7rpE3/iMi5sB9q31MZl6gbqlZ
         Tc8IRMvU7s6ZWzN1F2S9vhb0QHdvovtFnL2W3IoXvDNyQ/jtMwHvZEe5WxnaOe+QvtIy
         4LQw==
X-Forwarded-Encrypted: i=1; AL+hErGTy97v3QBFy9Tq+aLbEotiUQLNZA7en8vsFbYhEa60SlCO/l4zsb0mRTuC0JRSei9vgudrcqkj@vger.kernel.org
X-Gm-Message-State: APuU4Z8ux6nlY1+dJKlmVh7EHvmHUexU6PnJrnbXJ74BWJV5huhajnux
	6bBs+SOdOMwTCaAEbYl3UXmq99PporLUC9FnfHOaUf2SgsZekLUiJJKgG6vMmhZQBpY=
X-Gm-Gg: AZFdTZek35f8AC8T+HFMmrgsRV+KIeubieosHVauXhpfD6GSm8N7ppq+oeaUv9EJFBt
	9yF3+i5NRiX31jMutYElsd7GXwOZvIMTHkIXQ5EJQNpaChGs4xUgtauVYPGv1yIGwp15KTrR3zD
	XwWjf7hgZlhnIqY7fulKmmwIUpshsz3lweWH6YWnlGVTwY2qhUiOUT8QHP01d5Iz6TKBsS42JMB
	L4vE0uXf44e+nmeXOgV4dXlqCR52jdELne+2whWQ0PRBJtakTpIyh8ko/u6hiTSX0XA19/wYPhL
	K2mbH1CPt1Kn7FN5KJDyFDxlBYuUCYACeCxixUhI+ecj0Yk752/gDtkouwJDctWXa8EkpoGyHkG
	zLPq6OWdmhr4WwvWmXylzFTqmbszKlHDkrH21n1VyoFJf1VFXSSNQpyMwfiDjj1mg/wbWHFUzNI
	ZkT3xgPRfSS7vRe1359kr23Kk1RxINrcbYBdGxGH8npJ4bTDcHREclunzu2eycag5dNkob+aSB2
	XAXbBvTvsD1/q3HLp+lUDVixPhTOWghsMsdeiIOEEJ+iuacWRrnujRaHtTJiS+jxKR6OQtgKAVY
	tYws8dnixLujPmljvNYZsyX8WRbak+mEUyx5wbIr3Wj5k/SRaKTfKcsri6V+zbqW
X-Received: by 2002:a05:600c:3b1a:b0:4bb:875b:3d91 with SMTP id 5b1f17b1804b1-4bb88820bfamr238565805e9.30.1795434577759;
        Mon, 23 Nov 2026 03:49:37 -0800 (PST)
Received: from localhost (109-81-82-199.rct.o2.cz. [109.81.82.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884ab091sm495277235e9.11.2026.11.23.03.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 03:49:37 -0800 (PST)
Date: Mon, 23 Nov 2026 12:49:36 +0100
From: Michal Hocko <mhocko@suse.com>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: tj@kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, penguin-kernel@i-love.sakura.ne.jp,
	mkoutny@suse.com, chris@chrisdown.name, cui.tao@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Message-ID: <awQoUGIBitX_uvpP@tiehlicka>
References: <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
 <20261123113951.1771223-1-zhanxusheng1024@gmail.com>
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
In-Reply-To: <20261123113951.1771223-1-zhanxusheng1024@gmail.com>

On Mon 23-11-26 19:39:51, Zhan Xusheng wrote:
> Hi Tejun,
> 
> On Mon, Nov 23, 2026 at 01:13:25AM -1000, Tejun Heo wrote:
> > Maybe the leader can pretend to be in the new cgroup instead.
> 
> Thanks, I'll implement that and send it to cgroups.  The memcg scan can
> then stay on CSS_TASK_ITER_PROCS, so this patch is not needed.

Thanks!
-- 
Michal Hocko
SUSE Labs
