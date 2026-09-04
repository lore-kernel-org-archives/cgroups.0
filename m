Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913684772B8
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 11:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521184; cv=none; b=m+ljiHiIK4voVdQx5fZ7tiX+TJGXL5t4y1FHgKCxbnSyeYH8MtiE1jRS9fRNQsCdwQzC8sfg2MAg9Neh+oCPSN0U6s6t5UV/NWjSQe2uuip3JQ0uwMFqi+WUJNpZzySrVbDpjVqyaChsgT817q5VEn/BfEfLeBF4ppbi20QBjJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521184; c=relaxed/simple;
	bh=gwHRlOCTEfwr+zDmVe85UBQhez2rBr46ziqlZtFiYNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8qsBvw2an7QRhuz5hk7GpECR5q3L5AhxM2q6Y88zYox4/HhIhvKG1v2DTXntx4/JxEGcZFpX0X0BjrOQ8EDu+CCkApG4Q0XxFE7LcTa5j6D7RMNjbp6YjJ8sbM2XLl25qb7pXIrYCjA//GjzbsLZlT8oL2bUNyN9h8PT5+Xbzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YGrg1f7V; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YGrg1f7V"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48436251906so966402f8f.0
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 04:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788521181; x=1789125981; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xnmnnz0v+/7VeH3rMzPKT4G/XBuKYQHbAvKkVS2pseQ=;
        b=YGrg1f7VVo6wgYTv8X2eoAxCNsS0SaR21z9WadIFGGj7bGAyj5sK4gJqPGaxObuVX/
         Pi8EqQ6q/ZQ0ttSYCau2U+W2T5e8X4X+ULh6ZIFgBKwrabam+rVGwy+3L0us68O1Y9CN
         TJ11qunozx7D/pXau/JABZe1shXGicQnO/cuAh5K4y82aOQQvUSvm1KQ/f8IT8tgJQ+K
         z2u+Sep6x1IxgmN3on+yYAOODmwlweiv8/da8YJT5yGhS9U/xBAggZ8YqNsB3/tP4G4D
         vnRRNzPv/z0ZqPj3CHwnnOUyqnIss5+YWUxC2qLbzgj4/lrT9wkvjGfJtKXoQKW7OO1I
         sw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788521181; x=1789125981;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xnmnnz0v+/7VeH3rMzPKT4G/XBuKYQHbAvKkVS2pseQ=;
        b=hqYQREvveKUGHqNK76xIn55EH+tAUeClnMftjHZ5POrrGnds+x34SFyEuBn38DnUpd
         O8J6lEktEkqYZ4Y+LBsCUk/6gGhBMD7+rc6+Hiw06bMWX5A2ahUZCY4vZysb8b6boapk
         6y46i3UVel7k80CMf3Y8OEPDuo90D8yYoPzrGMRPmIuXWGIuAQkUkRliLROy0SBD5PIN
         msryrUXvkFl0wXLmhVbkXmi1pzmKLIcYM+9T0tjgFIkhHDocNCMY28YfxwdOaqln7jf3
         kLZsI3yA5zJyR9xB34jurkPV0IUm5LwUfOQes99i/g/TDxF7P4IKMgjVifa4K11q0wAt
         ZpHw==
X-Forwarded-Encrypted: i=1; AKwUvBzjMGVKQCt/8G79CCNHZuWPkhVs/kwpp5duyeZNKDYAaGlOPjRJGOsTMCwWiraAokcsQqseAgMe@vger.kernel.org
X-Gm-Message-State: AFuF++mYQlFSrtlAyKhC3kTCvaiEnVrdhpJ/zw0tVOGCHcOmDu82Ud4q
	xoum/hz6wDW0DRSUe6ioIkJ4pvoveCVnAGc38E7SvYdxuwXHERjF8jifWNLrVupp1qg=
X-Gm-Gg: AYBFou2cK2XPp/aPj+jG6Fel+U3P2o8bY8Rp8GC1cBC7OLWY69A57g2TQYII5lj28Ae
	QLGCPU/eaAPa76RaUgrcRaMjvfK5m1r/QfoVoa9R0NNg/WDYO2muPGbp8aJuOcV9Wva39rQa1vi
	WQ82lxFXC5en697DOvwt/DAZk5/RIoiNRrSuGlGVyj1pCvWIjYHjbWvrXkQILZnW9eGK6XFfJQP
	fj5soCPvQZczEImXegtUm3Hzlcy3SGiXnEoub2dBFhcIU/HLFprwjQfUVoNILlz8qLPa1XkGEze
	YEOSwF+QBy7OhT2TJGHCnY7LRYP1+ifI5DKM87xQfP7Nz6dhWYz0Z7wp8zEPIiGjLi4GV8XeYjH
	KhvZ8P4kJYJXrjofSTuH1ZsMe1b60Vl1Lz1M/4Fcb4E08FYyZN2skNVElB5H+ZGtTRS7FYQFtyt
	hqua4MHM9S6RP+vy9Bu7JXIa4Hfd8BxTYsVq6YiSspgDerkaJZXgspd98bLglD5qUYYMo07LHMB
	A==
X-Received: by 2002:a05:600c:6087:b0:49c:d52e:d0ea with SMTP id 5b1f17b1804b1-49cf81e3454mr91305315e9.4.1788521180735;
        Fri, 04 Sep 2026 04:26:20 -0700 (PDT)
Received: from localhost (109-81-91-122.rct.o2.cz. [109.81.91.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm149377045e9.4.2026.09.04.04.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:26:20 -0700 (PDT)
Date: Fri, 4 Sep 2026 13:26:19 +0200
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
Message-ID: <apqq26054VDli46J@tiehlicka>
References: <20260831234339.280376-1-stevensd@google.com>
 <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
 <20260901142552.GG3004@cmpxchg.org>
 <apbyZgB_Zu-DK8pN@tiehlicka>
 <20260901205946.GL3004@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901205946.GL3004@cmpxchg.org>

On Tue 01-09-26 16:59:46, Johannes Weiner wrote:
> On Tue, Sep 01, 2026 at 05:42:30PM +0200, Michal Hocko wrote:
> > On Tue 01-09-26 10:25:52, Johannes Weiner wrote:
> > > On Mon, Aug 31, 2026 at 06:04:57PM -0700, David Stevens wrote:
> > [...]
> > > > There would be no guarantee that memcg reclaim would ever be
> > > > triggered, which also would also stop MEMCG_HIGH events from being
> > > > generated. Overall that seems a more serious than just dropping
> > > > userspace notifications like is done for MEMCG_MAX.
> > > 
> > > I'm leaning that way too. It's an indefinite error, and it's a freely
> > > programmable surface.
> > 
> > I am really curious about the indefinite error side of things. It has
> > been my understanding that these NMI safe charges are a) rare and b)
> > there is userspace running so eventually any discrepancies would
> > resolve so the excess is temporary.
> 
> So I think the question is what limits the error in both space and
> time. When you say it's rare and userspace fixes it, it basically
> means the answer is: luck of the common case.

Right. I was asking because so far we are trying these allocations as
more or less trusted (we do allow them to breach the high limit without
any pushback). If there are known scenarios where this could run away
then we might need to re-evaluate that. Async reclaim might be just too
late in those cases.

Anway...

> But that doesn't help the worst case that can be triggered.
> 
> Like I said, if we need to have code to handle that !allow_spinning
> case anyway, I'd rather just have a few lines of working code than a
> (lengthy) comment explaining the luck of the common case.

Fair enough. A jump through irq work is not that bad from the complexity
POV. So you've convinced me

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
-- 
Michal Hocko
SUSE Labs
