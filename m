Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428794;
	b=o2+qlGGtrxXQ/Tpy6s0FilB3EFnPwwSF/6nITEBqdKB5smbzN78ZKWnmtvLbL5PB0jP6
	 ZdpAilKnmy9rnB+EohcnkXF9mRgpLbgh8ZpXDm0QZJ4RoyRYq1kDAHacxMuPKjdyX/8wD
	 p/VmfT837ADHUw4XU93a1WkIh+lGpj7ax1laVkEMkR4EyzukPPVYlnK2AbcX6netngtbN
	 XK4o6UGsHba/QjgPSF57DmzGRYlQq42AEU4GdIgZIz/MISnXRrMffbT+1My4Dy15LZ9Hl
	 qW2eEtq/Wr2ocPkcGgga0oSa8h7yktMK52Jk88MZnPH/+vglEeJuM5nLR05qhnPyR9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428794;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xyTvuDZR4vVjsu5EkFdRLe73DiEeLvv3Sxajh/2hgAw=;
	b=q1nDkxxlHRLLkUH2N4SVvfdSPBBVHWesP4FV8r856bpYJXxXq1YY/mNqOkYCSlcEQyHV
	 59MZaQ458QIN4FLcNoIyrQsz9m/RoKoTbzIWyxHMIvxS0GIXRL9s7v8cjjfxl0i/7E0RN
	 9GCygR7JFpht5BibI1mP6+3044Ia2l8ZCZHyrNFmbbUBAgG8mN6KPpaiwVXq8Ai6LSeR/
	 edUDZO+lkfrlGnQOGxeNEx4xLJ4JFY3hQLnzKwk+Li1hui7bmhmVD+UBE0PykHxZkwfMm
	 1uSdDIxZVTXaxnT99rBDvx6dXQuH/DJOWPAsCsD2RIuCnFY0zyGdRggRhcX6qNhIuHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Kp2KrA20;
	arc=none smtp.remote-ip=209.85.222.169
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB29606A31A
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 16:53:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEB29606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Kp2KrA20
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f20c3aaa5so225292885a.2
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 09:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792428792; x=1793033592; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xyTvuDZR4vVjsu5EkFdRLe73DiEeLvv3Sxajh/2hgAw=;
        b=Kp2KrA20/3xzTbAjDtHlmhYQmbFiJx10VCE8OuIUOcqpJPslRJgPWH+o78XyJjW3e9
         fNomFrSSCAE+fsuGxR6rrpjfcfLhF2REBqBc4EREzVaIrchFdFCbG/8TJS6RFkxDxaQh
         2tIfGJH0/Rtt9xtLeBOLGZQ/7t46v/L+7DYFLwj2jXwFQznP4LOJWKtY3acXbTRtOPrk
         /wSSwgXNcFqZ6yggReQJ10Q9p44znRL1+/67A/IVdA0PtrT5YW8k4kg2jaHguNxU2jEq
         nJLi7a/IQNZaWIiXnmEiGoWHXbv+16oawNtlFVEFp2bMFLkRKhYLT594Bnm7GRys6IeE
         4BKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792428792; x=1793033592;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xyTvuDZR4vVjsu5EkFdRLe73DiEeLvv3Sxajh/2hgAw=;
        b=G4xJTYC/e4p3v06Ayu3lgDAhnsi12Hib9ta3OSO2D2Gi3JvkhD/209jwTR86FNPJEo
         sHK4HKSi9Xyt2ARDuxjSDvt93KnOA/VLyYacZv1F7ciyZtg0X4yV0ynR5g3uIKdVsjN6
         2qYJ7ru4eP4glzTZVMm8Xo/6Z7FHm4kTx7ADOjl+l/wu/Tr3TzsqJcXDnAimwdey/Z2p
         L//ncm99Tq6mVXvpWHzXI6aXaEZrxQoBtL1DHqPdWggPNdeyTPFx5p91DV4qzJtKORU6
         Q9RT+Ttbx8VKrFnGLghvYC4npoubwjYRcIvGFrNwWlB0xVwEg84ZjdJr9nFp89VKgb+p
         X98A==
X-Forwarded-Encrypted: i=1; AKwUvBzg21WomcIOgt4Zj+ykdEftlip0wmblUFwbizVSWubM99heomzqL1IRLxZ4cx7xPCFUIg4e/DWb@vger.kernel.org
X-Gm-Message-State: AFq9FYKeLoZDxRsQDRHoABSxPAZtQhIPJWJ5h31/2zgLwO0Xzoc9uiTJ
	O76TD69PUWM/nWn+C0+V5X5EJ13I2yBQpMqCP5T1wyeyMxLBOpEwKUGK0CdAyMtPNls=
X-Gm-Gg: AYBFou0HnsV0tE//auBhC+5/V4a5ovNkhnR73tQfVQblMHarTp2K7gsyPCW87n5dm7e
	mvaWRumNSmBpNe7xp1gfrGZ71FRbZX8B8ijtrRXT5AdsFqXeavA+L5vzqergHn2mJ2Ve3crYeeJ
	2ZREZEOhRLQDL+LuQKXMOX200I1+tHL/W5g+P7zS73Nu+3JqCzF9juNVny5tUsqOSv3ILvx666W
	cEphLJ9/WKZT6wlzuZnH9e2pk7l6l2HIBjkc4KUfdK4bBwEMsnzKVqNaN5CDauRGfU/asan6BAm
	xQooX1Jw214LFbaHB5+z88fJCR/XeEsRiEiNDdFNQDekIGSHtYoT/FhMMToMakQfIhfFhfTkTU+
	Xp1lu8Vht4Kgp1zUWYkcwihqErYaDbVroYFEsw1ddYb2AIcS/hnWEs8TYvO3M9Vd4pduep6n8jR
	gV5C96M+aLpguQkvI7gXIhrVgAagIFOoHt4GPozFcX/UI6VQSy4iEyOKq7qOO8QdKQGJJphiD8r
	8NECeWSIC6CyY0wdUNTEfrPIr69aWsGCk4NbQokCHuBettGLppFpue+QmvUl3Yr0w==
X-Received: by 2002:a05:620a:7106:b0:93b:db80:e0cf with SMTP id af79cd13be357-93f29db7f0fmr1372869985a.60.1792428792624;
        Mon, 19 Oct 2026 09:53:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4b0d7c74sm1529985a.35.2026.10.19.09.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:53:12 -0700 (PDT)
Date: Mon, 19 Oct 2026 12:53:10 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com, ridong.chen@linux.dev, 
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, akpm@linux-foundation.org, 
	mgorman@suse.de
Subject: Re: [PATCH v2] cgroup/cpuset: use mems_allowed_seq when checking a
 policy nodemask
Message-ID: <atZKl0yVl5u624o1@gourry-fedora-PF4VCD3F>
References: <20261019162138.3271947-1-gourry@gourry.net>
 <805cfff2-1856-4b48-9afc-174a56405283@kernel.org>
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
In-Reply-To: <805cfff2-1856-4b48-9afc-174a56405283@kernel.org>

On Mon, Oct 19, 2026 at 06:41:50PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/19/26 18:21, Gregory Price (Meta) wrote:
> > A cpuset update changes the task's mems_allowed and rebinds its
> > mempolicy in separate steps under mems_allowed_seq, but the check
> > reads both without it.  This can cause a spurious numa placement
> > miss under some cpuset/mempolicy combinations.
> > 
> > A reader that loads one mask before the update and the other after
> > it can see a spurious empty intersection and drop the nodemask.
> > 
> > For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the
> > cpuset moves to mems={1,2}, the policy is rebound to {1}.
> > 
> > The allocator can race and compare the old mems_allowed {0} against
> > the new policy {1} - which will result in a dropped nodemask and a
> > misplaced allocation on node 2.
> 
> And since this can have only performance implications and not cause a
> functional issue, we don't need Cc: stable.
> 
> (unlike violating a __GFP_THISNODE allocation which could be quite bad and
> has happened in the past)
> 

Agreed.

~Gregory
