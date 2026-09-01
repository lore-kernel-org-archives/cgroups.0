Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD27843CE46
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 15:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788277355; cv=none; b=XThn/ynLU2xDcJn2HGo0B/42g1sYNmVlHREPanHR7+cs0l/5UJByr//pfkKhp6Fv8uPfX9AU9VI1ApQCh/AydYGyuynf44YeMWOcC+yoSzxcMPZ6OtvzAOQ+LgCCca0taqt7jNfkk1/ZWOu+RJp4EzKaQisiP8JGBpNkZEEgwi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788277355; c=relaxed/simple;
	bh=RBnLTyQSCm6tW8zb3Zz6KWI6jSV9F+kLJd4khg4LEIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAbWmMlciLPMy2seZ6l+zo+/xqHksHIHJwQH8C2oqjI99k11pBKOUHATwcbVlLAkHdpnjgCPwaqtyzrYorLgJprxnllt6gDVEs4cEENZ/ygLJPSxfcLQaabH9u+TtqsStCnpvj9m4BO946rcNmvgt4RczVcnnwiX5QLmmlMLBx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PpeAMdJR; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PpeAMdJR"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48441fa5c37so18642f8f.3
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 08:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788277352; x=1788882152; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ieYVRl/yPqLfVFpGgKDnoBwKi1G1iwV5CrGT8xV1YeA=;
        b=PpeAMdJRd36oblRB6veUx5CwvYNn0hLOz13gcwNeoTIHJDgGl3AiP+ao4ozbKR/mo/
         U2c/I8yKpsisAh2QOC4+NzD1GWUwJgbZ+44FqBDaULJiICXt1TDz0yx+pNFT3jGDY22d
         wQ0nBHK5QojJabwZV+APm/hSdWzB07g4fEDoZ4OZ96yAB6Yl8lHLEIN+mzCSajJNOWRF
         7ITqVJQGEHGmiNQMpFyY52nY6vVRuGxWV/6lQK3SEmpI31xFGp5VhyXbNNf/wmUsx2XU
         rGmKZEhD5w13TQPAtXMTbRgmrQHGp0dyDwPLq69eWupMgCD8+dmQIp5pbqOKqDN67kjZ
         SoiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788277352; x=1788882152;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ieYVRl/yPqLfVFpGgKDnoBwKi1G1iwV5CrGT8xV1YeA=;
        b=e5O0Ys64GKTXG+Fp3D0pLS7jDrVerFLqnV5PfXYSIMDw4n06aVh0PN1siNtnhPggdV
         8SZVJlqxzfxNIVLOMjExpam5usx/XiL1uK8QDQCQQoaEt/zYvulnALijn51yN10j4Ga2
         gn027IaC4igl8wJPVHH4Uj7ikVYw2MG67TwrAtfE6HDZO9HAe/aS8k2UBgtyTupNV59f
         JBeu+VxlCWDQ9LVztiHEVu+J/WsVzTO/gsg9B1NB8KiMfIgfDLBIpWd1PhlckieDIF0K
         spRQdW1NunFwIO04DQg0XVcMHgbPpMtuIIOKmlO7Y/ilD8y5SSmYr5wxlM+kl1hgBzN0
         em9g==
X-Forwarded-Encrypted: i=1; AHgh+RqzRgxvhdA1p7SOndg9KoBa2BS82Zfnw9xvaCdgqbXtSGWYMebSE/BPbAEDXRRrkA0YtlAyuZ2E@vger.kernel.org
X-Gm-Message-State: AFuF++lzdt4Goawpz9txjBHHDDvNIiMJd0I00s1mNCoG0A7tXNsmHDT0
	dFKrOACSEUnOI7v7MGW4CUrRH3UUfyYQV3gWJPHYn9LPSUMJDvibzKvTH1mNzbQkROo=
X-Gm-Gg: AR+sD12TT/p4KYYhknkR12apPacwXLhY/N6p9ObFjBYJsPgpu/bqeHx9sOjJtG8V3Ka
	+j9TqMpt+QFp7UCbV5ZobrAZ6eFNOivagPKfaJ4ZtlDH1aObsY28GRaxD9lRqUuj9kI4lcCKDKq
	YR228dsyjM/Dl3raiX9JQOIGHsdIHlfnuPxwM3OR4lOWwxqTOSs/ualH19WYK/2YzK+k++1GZMH
	0aKRi66sAjiTVsEBYnDbItPollEW55swrkW2s/UAv4hgOwFmi9J1Su9kH6Xi+7ZgyNbpU+rIlDS
	wZ6faZrBtcsBQm3bTes4um8QAhmu1nekpflC74cKBqLFgzCmZrqu1JtF386a+erc0mHL7T1T1NE
	E2sUhEOdSHI8BfXa4gWdL1vTMQ7p2r+D5b/h/pSuk6oEjcEcOvZfU2zccBE884aBRauWnA2RDSS
	W2W1BI/rUAA54ogaMmyluvzCpwWa1C0i4nKxGS9SmgjJmLSB2CcoSEN8cSEQ+ii2oNdVs/GFQ7
X-Received: by 2002:a05:600c:1e0f:b0:49b:9113:e04a with SMTP id 5b1f17b1804b1-49b91c19c77mr582161655e9.1.1788277351867;
        Tue, 01 Sep 2026 08:42:31 -0700 (PDT)
Received: from localhost (109-81-87-32.rct.o2.cz. [109.81.87.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b927d462dsm171147105e9.0.2026.09.01.08.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 08:42:31 -0700 (PDT)
Date: Tue, 1 Sep 2026 17:42:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Stevens <stevensd@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <apbyZgB_Zu-DK8pN@tiehlicka>
References: <20260831234339.280376-1-stevensd@google.com>
 <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
 <20260901142552.GG3004@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901142552.GG3004@cmpxchg.org>

On Tue 01-09-26 10:25:52, Johannes Weiner wrote:
> On Mon, Aug 31, 2026 at 06:04:57PM -0700, David Stevens wrote:
[...]
> > There would be no guarantee that memcg reclaim would ever be
> > triggered, which also would also stop MEMCG_HIGH events from being
> > generated. Overall that seems a more serious than just dropping
> > userspace notifications like is done for MEMCG_MAX.
> 
> I'm leaning that way too. It's an indefinite error, and it's a freely
> programmable surface.

I am really curious about the indefinite error side of things. It has
been my understanding that these NMI safe charges are a) rare and b)
there is userspace running so eventually any discrepancies would
resolve so the excess is temporary.

-- 
Michal Hocko
SUSE Labs
