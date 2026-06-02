Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDC83438BA
	for <cgroups@vger.kernel.org>; Tue,  2 Jun 2026 09:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780394065; cv=none; b=C6At9Q9XWKL2fPe9BzpkYrZ9C/3h/mf36HNmOKpGPYXsLeeHH32BKQr1ZSYkt0D+eXofC8IboDqCx2aqB0fw+oDLjWdse5AuFC7y9xOYsAOax8qLQrSEdPtZG8EEwZXQMr6vtI+L38idxdm9gUCXrytTpX1lTtsN7nqK49xd2vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780394065; c=relaxed/simple;
	bh=vMyl1APG9x8rbRIHZ/UaBfkgDRSxXmKHikG67TQUrWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvKJx9G536Yhsp0cZ3IYUSadwuvoA/W1662+jLrREiNpyA7NTu79Oo5/QSg9RMNiQeYbWoWWLnsFwResd0tIQLRQIamIATaLwF1GknehcAg6xBJCdtqySQcuAftghvEM8tAvSXFpjVZUQKvdmiRGDLoYzyURQ6PQTV19mA6J7yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=QceMoB3l; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="QceMoB3l"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4903f7a90d1so100656835e9.2
        for <cgroups@vger.kernel.org>; Tue, 02 Jun 2026 02:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780394062; x=1780998862; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PLkbX1HVnS/So1qJRm5FqYtfb6XONO20D/jzobgweiY=;
        b=QceMoB3l4CriNafjAglf1J0msJy28U8jXl7bCq5JgFSPHcM7XFBRp/AF7mVsAwMHwW
         ZYIEHfN9aXYSS8qrxLw9auHTHvekkA2TWQ5N/lAzTeMAkbxdIEkj5UhgrjLbP9ZFXJUx
         JtpX3zdi9C6jGugO/voj3DSYMxymELo7AVhtdw5rWYYw8XU5v1OCT4MVnduG1lb22B3+
         5dDIJeBQl5Y3eDFf6ikVb+YJNXEPn6qrhtYl8RFfYuG6Cn0VaKU0oxsUChq154/iQUWw
         Y5EgmFikUCh4VG1GzGS8XBbZGNy1Jhztl1oYgb0OJBRGqlypVDD29aex+sNg1HcwcP+K
         aa3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780394062; x=1780998862;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PLkbX1HVnS/So1qJRm5FqYtfb6XONO20D/jzobgweiY=;
        b=o4NQdKnCIk0cFH5tJKJN1aPHAB3vMki6VB1obFSqUCzo2QInGfkuhvjhfxi1LNcau8
         h+7fiLVy01oCQboMR6ZGXYJjS3W7gOo9q+D+OrShu78oa2yJsDX+BkJ6dIPWvGy+arFL
         Pv4Z+gEmGsk2EmCiABrsNMhcoiNLEm8z0D/6F/BBvzS4cmdDMsVQXocbYoMblucQVdJx
         6EjC486hfy3JU0cSE5gStdtG8fVJTxGKyy2AcGlSf3CnvahbMeulfAAdzo2yGVVUXV99
         7dlcHUe+Sn0iTFjEsNTNCxe4V3wwg0WmKKCgn6cvtlLlUlaJ2F8DcQzlr/TwOhrEmTFv
         sC2A==
X-Forwarded-Encrypted: i=1; AFNElJ/0s8B4YFTtWBeYuH7UseuU75fuw9SoHrbqAc2rCODEiqi64weGHPaEOcpWs9uodmy3Jd/NU5ZM@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjctstfb7E2F89QRTRVOcrHUk9uQfcsDzr+4223QpeeGdAd/lb
	8JF4BvnStmqKibFAuQmn3bPqJGNKLTY1fPBAjTAdhzJzdCd2sBqW5xpVRSmiaMcG0vY=
X-Gm-Gg: Acq92OFxd9XQFIwCOPNPzvrMDOD75nnkv5GgDd4mzEydX0c9aVZ5jignuX5vI2K5z5O
	JLi0p5wfurw90bRAg3h2P9/jyqlphsYcwPbwushFobMAvs0OEHulLos43eMzFMofqArLfKAs7Zj
	UgwnYNtaJQSrSefnR0cRXaShNSlXd0z4UaYxb9SEtkEckaHxLVSRihrAWGdyNpXbCeSCNIXd5Lv
	WLZOjXHrozZggPUE/hZZGsFiTtp9YAlhHGUagrEbUTvni4x5z6aZvVnDzJgzfgKRJ0WY6iFNDeH
	wRVcMa2kKI/WcD+r8IuOvgPHx5FNs+KyI8RFdbkwccBDUwvk7dAp9aokdBhPXx+1d5mTcZ9Ldx2
	9gnfg2R3qN7bvf3hGxxPT8u03C/SQlGwB6y/X6BdfA8n07CydBE2lqaq9CUolkwFi4fcpUF5FdS
	mU5chlfLa3af3Vc/E9yq5nt5StWqHNrB0=
X-Received: by 2002:a05:600d:848a:b0:490:9d1b:f06b with SMTP id 5b1f17b1804b1-490a2943afamr189761525e9.26.1780394062160;
        Tue, 02 Jun 2026 02:54:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:2ad2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ab55d39csm35194975e9.35.2026.06.02.02.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 02:54:21 -0700 (PDT)
Date: Tue, 2 Jun 2026 10:54:19 +0100
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-ID: <ah6oS7wiGB4u4-eR@gourry-fedora-PF4VCD3F>
References: <20260528124133.c88c27b11a8ea0ef05e494f7@linux-foundation.org>
 <20260529152616.2308736-1-joshua.hahnjy@gmail.com>
 <ahnRIDBk4bQ3xX2q@yury>
 <fe33c767-ea11-43e2-8732-f752c9c1205c@kernel.org>
 <ah6X-RtVX75YP7VX@gourry-fedora-PF4VCD3F>
 <c98eb14d-b878-4eeb-91f0-d2b1d4407e1e@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c98eb14d-b878-4eeb-91f0-d2b1d4407e1e@kernel.org>

On Tue, Jun 02, 2026 at 11:19:49AM +0200, David Hildenbrand (Arm) wrote:
> 
> According to the report [1] syzkaller can trigger it. There is no reproducer,
> though.
> 
> [1]
> https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
>

The actual implication of this report is that there is a bug in cpuset,
not mempolicy.  

  mpol_rebind_mm+0x3ab/0x680 mm/mempolicy.c:569
      ^^^ should never receive a 0-node nodemask ^^^
  ...snip...
  cpuset_update_tasks_nodemask+0x22e/0x340 kernel/cgroup/cpuset.c:2777
      ^^^ calls guarantee_online_mems ^^^
  ...snip...
  hotplug_update_tasks kernel/cgroup/cpuset.c:3882 [inline]
  cpuset_hotplug_update_tasks kernel/cgroup/cpuset.c:3985 [inline]

Relevant code:

void cpuset_update_tasks_nodemask(struct cpuset *cs)
{
... snip ...
        guarantee_online_mems(cs, &newmems); <<< critical call
... snip ...
        while ((task = css_task_iter_next(&it))) {
... snip ...
                mpol_rebind_mm(mm, &cs->mems_allowed);

Seems like maybe mpol_rebind_mm should be called with newmems, not
cs->mems_allowed, though cs->mems_allowed should never be allowed to be
empty, because that makes no sense.

Just eyeballing it, I can't say whether calling with newmems is the
right thing, or if mems_allowed should not be allowed to be empty, would
have to dig in a little further.

~Gregory
