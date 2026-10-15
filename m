Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02434522F19
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792071539; cv=none; b=mCyYdmZZWCM51lHXvALwCbRVXp/+TtLuEJ9XEoU1A3FqU5L20tjxPyQrae32f6AnIbIEQyhbIrPNfX+1Zd9YguBJ3W/etTdQ6TfwudrSdjb0HenNLfDUr55dIowgjuiGebWdmW4GboDHylaVDnMk3qUt1hbxEYpOXkSFiiN9qWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792071539; c=relaxed/simple;
	bh=JpMB+Cvxnmk2N1cuA4FGoEGtr1Wa1vZOqjUDepOIA/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TocZrpoo9TchY8uHlGhcCpdexNNkjfN6Xosz7suOWK+i5n1mturQOpnFfQnIqVzx2rJo5xoYhwnjNmBmM6iFy1pEtfuL6C9K0L19rby/cvKUZZkWLs3J+5lceHl+NiGkMM2K3Zm1BLgwH/ReJdx5U/HbWB3e4QUCKACs+iT8MFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=NO1URF/Z; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="NO1URF/Z"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93e63522076so391114885a.1
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 06:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792071537; x=1792676337; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QFn7sojbGXNFhqbogZOUxB7sxcSHF2Ksqnd8lPmDfO4=;
        b=NO1URF/ZNMgkx03i2LvrPOnvxVB6MGp9uA5PlTPPNfjtpN98426HZq94TxXOnqCtkN
         CP1LA5jnN0j5JlWSVO6eGJKX+8ReJCZTwP04mxq/rYNt7JWZ9qDzjOdvxCdIJ1v5axvz
         rj7msuXVcVj4yH7HeWTPcDCJp0C8tNDY6jVhterCYjkaJodBf8ZYhqvyprXuNlLn4kUg
         DOd4X4aZ67WNqZEQPepU5I7wKeZ2UInZ4mJ6PQWG0n++HadmvrLQrXbx4qJpvB5UooUW
         VP+I8GQzA1xMoJWd6lrcOqFHrcMmpjwuWyeAfRSAblctuJ0yCKqDLDuHGtaAtdIKuUr4
         x0UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792071537; x=1792676337;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QFn7sojbGXNFhqbogZOUxB7sxcSHF2Ksqnd8lPmDfO4=;
        b=ri6CW+CZ4M6iRIHMooQou7nwCCbPEN5+r7AR59u9px5/b+hKqyeXOF+BNmqKDg3Wk1
         hQPCr5iwH4ZYI9jdVMWdTOSQEDI/yHsOdLQw1a+pognitDjdaLaW6if5QyHwXJ2BR84F
         Ixbgy4xlxcYQWIwcWwvN5zQB/GNTWvGZoHLzSFQNkyX2ZWf6FHqZEbnPniRXayiK1Jjn
         ruERGZmdbHSPesXqDIal61GfCThOTycA3sA0Wj2owm1BKGusVUOJnVJJu+C0NbYujf0F
         b/84PbtGb5mQjoxzeMElrQUG0K0i+3BPSLJ4sHiViyruQkXYkXWTr8WqKZJKojHe5ARO
         tV8g==
X-Forwarded-Encrypted: i=1; AKwUvByPwKQzc8fivs4IgMi0KAg3v/o9JyOrsALzY4uJEFYuXpdL//rv6CqoclQ7P0b9Q7BlUQtkGaDd@vger.kernel.org
X-Gm-Message-State: AFq9FYLSXOFqAql/eXFQTC6r6oOxqRgB8RuTo/EPkTMz1SB3BesQQoS9
	4exuHZ/AaVLNHX4zQinRkhjkh2k5PI9HkL4zef+W/K6+fofV4KgWEQj6VyyciuLqOyU=
X-Gm-Gg: AYBFou1ZVbisWfldyzh+2Nmp01bCTpmlIAL1bczhhtTQePHUD9UPsms3UXanYBJRUaY
	qDnlCA466/Acfl6XYzOpW2KLjnrcgUmb1niVbzM4Vgk2VizzUOBXGuXwYhFxlJcpG0FjmN/xbeV
	K1nSL51kbh0kfBESWdXxCX1Jc7vL94EFc1wWQrkS1CG6/soCPNbYW4NBTgo3rdx1v1Bvn1gHabk
	h2JNPqgqxEBH+0vDUrKLzoAZPBYrc75oIMaMRJHEitgmePCm/5PqRUtY9ThWLrihE/gPx0criZm
	smgErn2f3hE96GAS0f7W7cTAmN1BbgJtUOa+7U4nt7KfngF+AewDINEddLNCswFFI3aTbtmAQPD
	UZ7H3Fcgr6/j8BgxBET6xPbjJ4mMOZzVNMD/kDpeCwqAtpJ/ltiKhu53cv+hm76TPJpPZI6Kl2y
	r2vEPbfEDhL9hrX9Zemu5AjkDGGIGM3YDvFky1MeUb6zOMLZrmAXTGhInGwsz9dMP6rUPpvpxfU
	wkYCskjrpt7/bnMHxateB2gALW9v9LDBeRUOO5kJKp3POr7K+WW+snNnisNoRD3Vg==
X-Received: by 2002:a05:620a:1786:b0:939:6de6:9518 with SMTP id af79cd13be357-93ebd2607damr3020594185a.47.1792071536816;
        Thu, 15 Oct 2026 06:38:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef4f4986dsm774993585a.2.2026.10.15.06.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 06:38:56 -0700 (PDT)
Date: Thu, 15 Oct 2026 09:38:54 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com, ridong.chen@linux.dev, 
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, akpm@linux-foundation.org, 
	surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, ziy@nvidia.com, 
	david@kernel.org, mgorman@techsingularity.net
Subject: Re: [PATCH 2/2] cgroup/cpuset: use mems_allowed_seq when checking a
 policy nodemask
Message-ID: <atDUMtlM9Z8CPlRo@gourry-fedora-PF4VCD3F>
References: <20261014222456.2318284-1-gourry@gourry.net>
 <20261014222456.2318284-3-gourry@gourry.net>
 <8d611a0a-4ada-4536-875d-061492773e05@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d611a0a-4ada-4536-875d-061492773e05@kernel.org>

On Thu, Oct 15, 2026 at 09:59:31AM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/15/26 00:24, Gregory Price (Meta) wrote:
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
> > Simply retry the intersection until mems_allowed_seq is stable.
> > 
> > This covers the task policy, which is rebound under mems_allowed_seq.
> > VMA policies are rebound afterwards by mpol_rebind_mm(), outside
> > mems_allowed_seq, and are not covered by this change.
> > 
> > Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> Should the comment and/or code in check_retry_cpuset() be updated as well?
> 

No I don't think so. We're checking different things.

The loop here makes sure nodemask and mems_allowed are stable when
compared so we don't erroneously drop the nodemask on a race.

The cookie-check in check_retry_cpuset() determines whether the entire
allocation should restart.  It runs after the nodemask would already
have been dropped, so it can't catch this race.

~Gregory
