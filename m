Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B41448A2CD
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 11:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784634819; cv=none; b=XimcLUreu70IPoamfaHnJ9tWBvXK7NusQJufTY1tcjLo9ji+VGQQWeU5N2aebh7eODA5U2K5QdcCMIKoO8xBFIp0TroRoqdbCjlD2DiYN40KapCk+6GGQ/CPbQHoR5OMvNUrvsbhnsVo7LewqQ6UiTJNbwNfBk+tWHKyuKmsTAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784634819; c=relaxed/simple;
	bh=c080ZPrbNO1Vf6BzSNkC9ZsTFGUEe2eEEeJQ+zZ1bW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFUdmvzqUTaogj5hqXtTfPQ49ak7SGgBUEa2dHU/OxtQLXR8wovpH1fGykEiYKbTb0tLAdtf4q4PsGXqdp5IeHOyBnGxeYFF235R3kqDfReW5/Qrn22LfaBBU0KWjFPX/7wo+WUJTZ0X5Rwoava0ZFVzHvstS5scfgD46gjIQfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=gh0ThyLE; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="gh0ThyLE"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92c7a0a701aso867668385a.3
        for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 04:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784634815; x=1785239615; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xFtff+4rtunUzbDu3zAPLU3jEyIS3Rtob9OmN7SZ7ok=;
        b=gh0ThyLEcamR5/GEAXZTN0da26P+DTuM1kFdLxJxgaMHiTSBFDi6HN/rOaSFsVYzb+
         AsK47uwmIMv48xgSHyOSnHgE6Wv2b6/D/Sj6O3U5mYi7AqfPeIj2Zs6m5Bh3cJpAVJhL
         VNlC06KKxIs56zPyn87fWD3frNF3lUjBARjbFOAVyKzRZPOwl78JwI5hx20VtIfnh4Kb
         r9nh7QnrFqz8zN9O7sWp61TM89ftUkIz+yc3kXiKa9AAHJXG537iAruzxXwizhqSfw7j
         B7xTMDwE4qaaCsstVRTC+J7hNfDt2FGZvkEkMZpuEgWXgHIyiOuAosFZCNIDcEj8sYl4
         uuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784634815; x=1785239615;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xFtff+4rtunUzbDu3zAPLU3jEyIS3Rtob9OmN7SZ7ok=;
        b=Lg+aJHcvNG8nYX+KKxxLN+O58Qt4xqPL1gyYVNFdQqQh8ooFNMDCsJ5ujX+iIAAc0X
         zgA25d8vsJyrMffAFevwNhMz7gyKglte52qdkKOCkf2j97FrYC/UlqdZ8xqqCa2e2GtR
         TiBxjJodg+1a8PdhmLFZ1pN+DWvtSwimzCSV0Odi4XgNMjf3bucVeSN55xHLOEWaCKCs
         TF+mRgo1v5S4orGLv7jpofZrl7CFOC96gT+KjJ94Nvl1v6YtT/6FQZ8wG3E0EBi6q4PN
         3vG8JiS5iGqzXIPsWJT5PpWZ7VtJl6Zose9naBR79uo3AoFQk/GMbZ5pBSMezCBOH4zL
         +L7A==
X-Forwarded-Encrypted: i=1; AHgh+Rqr2qKe+pGda5YreV2L/SOHVU1l9P0a6za7gZ+YFJe3FyXdstb7Gm8DMXtct7Tp9HFZa96H74Tv@vger.kernel.org
X-Gm-Message-State: AOJu0YysvfPLtpYluoCQw/8S0Vb8caxDFBeOfmMBBfIUnApSnDK8Aj7A
	uUCEsE89v8oLEeHYj/3lVqNptx0nr+yVt/bW8dniZcUJ8Ax/WIQMMCR9fxvdg4XNH5Y=
X-Gm-Gg: AfdE7cmUW38iW54ZwtlzErg06eAHSXCWC3qXJvYE7e6Dred+1Qo74xAMEmrEzP8if3n
	e6FRrDow14vaiZRj3Av45HbtyVdg3kcr+EANnBECd0AWzMKUAZw1ZsPMfp4Qhj1zVlOrWMyz1JB
	yjhc8Rdw/c5MjcQ3hr1kzz/x531NztdlXS6UZyXhRTioJjlPfTtFEtoTJVnXvAaPIZZ4ff5C+V2
	JnxQ1N6+CRX4NQ5f89mLFyICf4LEW+US9Z7VOqR0CtJYHtejnLbEGGeEaPzweZdRtIlUshD+5bO
	+hLfNnfm8sA7zW9OMLLKCroc4ABB76k7KPWsuM3qT3xn9QfoY4EP7U0hFw5bX3vU3hIbUR4UPmA
	lFUPnJOv0iytXiBMy1xfoAbxxrJaJ37tFNrFQQnYr2hp+70zg+GwcVSMqeIxef18o9Tc6agZcIO
	vd
X-Received: by 2002:a05:620a:2781:b0:930:a3f9:93be with SMTP id af79cd13be357-930b41e3f78mr1494400885a.45.1784634814831;
        Tue, 21 Jul 2026 04:53:34 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b52dcd31sm1081955285a.2.2026.07.21.04.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 04:53:34 -0700 (PDT)
Date: Tue, 21 Jul 2026 07:53:33 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Barry Song <baohua@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	youngjun.park@lge.com, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, hughd@google.com
Subject: Re: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation
 failures
Message-ID: <al9dvQtSwAkKSvQ4@cmpxchg.org>
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
 <20260717122514.51514-3-xueyuan.chen21@gmail.com>
 <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>

On Tue, Jul 21, 2026 at 04:15:13PM +0800, Barry Song wrote:
> On Fri, Jul 17, 2026 at 8:25 PM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
> > @@ -5495,6 +5497,9 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
> >         rcu_read_lock();
> >         memcg = obj_cgroup_memcg(objcg);
> >         if (!entry.val) {
> > +               if (nr_swap_pages && !mem_cgroup_is_root(memcg))
> > +                       *nr_swap_pages = min(*nr_swap_pages,
> > +                                            page_counter_margin(&memcg->swap));
> 
> This looks a bit odd. Could we decouple *nr_swap_pages from margin and
> have the function always return margin instead?
> 
> I don't think this function needs to care about the initial value returned by
> get_nr_swap_pages(). While folio_alloc_swap() may depend on it, they're
> different software layers, and we shouldn't couple them together.

Agreed!
