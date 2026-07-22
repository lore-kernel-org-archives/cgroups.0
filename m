Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C6A4C8FFA
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 11:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784719149; cv=none; b=qDYLzEU1MSWwbK+/w0bgsX9u+aKRx4smymn6SvOizJHZtVUWmOoiGcpCyj9TEz6Tl2EozOpPeFb1dT1RhT6sAOivkEAm+khL6TfDTCmYMnvlM8aQ5D+J6LJ+fTW+haXZf2+z1LI/YYyFU5FbQhyW9o9ROH4HJ/T1lx+zSxYnLdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784719149; c=relaxed/simple;
	bh=K0lJdomABA220xXQvjPrABsUyrol06jwDg0S6PXXfsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ieQO6TaBi75lMM4DxKUi4+1U+mpiK4047SDE4NEbmsgd7eEqvl6ipP7pT4jNqnlNXXZwbN8dmKR4upQlCdNxfxHsZVqdC5PsnE92q+VP5xwY3yoFuJC+IzTX7728KXBpBhqgB88FulnkK/BAIba1EPA+YaNrUsdx8051rYvjvnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=oh6xSitz; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="oh6xSitz"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4956242332dso25955935e9.2
        for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 04:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784719145; x=1785323945; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LRmXc9ZZ35HbKO4lnkGdwQFDA/KG04ApnL+4+6Y1E0E=;
        b=oh6xSitzv14cXiEehnSpN/lNNwBLwRIos7nCfJe57HvhwV3Miu90A81J+FmVquFNeg
         WZnf8kOuLCwtrpALmFC30uyKE36wRSwYfzjjcEIK+85FnFPpEgKTrlESpGNO8E93IqWT
         iihMO0kPefOqHw7l0c+5fhZeMkKP20CON2O6UFEulprF03uO0lrJvBQrX/QYK3//ajlj
         ECSFmXjhGAVuhRgrWYcsh9X7nHkCtxk0itlQpc0DHkrcqEFKmBKnEBeBIh6ZVWPI76Zv
         dZq0q3WNs9FFUeopq+8FxcJKGS4CsiPB1bV3nq7jGX2rhhM7xBBVWpVP87+EnTxph9Jn
         Tc7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784719145; x=1785323945;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LRmXc9ZZ35HbKO4lnkGdwQFDA/KG04ApnL+4+6Y1E0E=;
        b=mKmfaL4Gck4MCZTFDkEfKy3QbfXxj8ReHael5bPjKcdf8WIZsAJ/M3LDfb681mmFXN
         yhOwUHvKgdHSwTfVKmkRntv9C0CUjcZ9X/xPartMD9M5Radvqq9jGJmK3AhuHA5RpqO5
         z9N8bFO419TyKnujwluhPPY0bJFhqWIO4rT+DwuKdqr2etuiIFpn6S29Ang5tWWlT87h
         WbcwswwQ8NeOlQfpD51PUGp1a1GMLxXlZ4N92ofS9oA1MPGWimtVCpkFWZ6lUGMT6OhT
         R8wMy0gh292mk1MVG7M3b1XHBeT98v854D7TrZFa1E8RHfP5nrIBb8Dd3o7G1BY8HUa8
         7nyg==
X-Gm-Message-State: AOJu0YyKHiSVYzWpN0VOW/67nDu8cFQeucNVc1FkwxYdOPEeGfd2rv2v
	o6BlfkNbml39CUsN0kpSZl0++9BSEHGuOoSsr/Rjlg3zYxtQRHhvUZ5aBxId7e2+JgQ=
X-Gm-Gg: AR+sD10BDg5AsQ0QeMUfk+ywg0CuOpjBw8xgwghhJqo7hN3LldZ2ULM8Lh31+IRZ9eQ
	fr4vy5UH6u4W0aVYk0uOlJFoJbZh8EfJIraZYU18TS3/FF0XsMiEvzfZ9THqzoh8fqV3sO5cQK9
	s9erUanb17aBvhafn10FupwfZLYXgJFCuZRMJOC7XfElD3wfRhsDJfJhMVnaygUg+mCjg1gRixO
	CnXyMa1ag62sg+eKQ0nBWYCZLwWHZzjGHUlBPAEfbKGK2pI07yzpvc1hbrmkY6PCcayClpoMVkS
	GoLD4lMGYD1yxZf1bh8dGCKuqBs1ISgB/+u5BNhQ959WwBPVNKDptaGiMWxwQP7eNFl1UTTCMe0
	0f6O+Kwd4NQdgBpo3wseZ4dyowDYn/qcdNwkH8ptSefQEqkcbsawDFEkgd/kXCXXQE3TvvxW4i1
	FZkZRFnpQSAY2cw++d5ih0KQ==
X-Received: by 2002:a05:600c:4ed1:b0:495:6485:226b with SMTP id 5b1f17b1804b1-49566a820aamr70694565e9.22.1784719145296;
        Wed, 22 Jul 2026 04:19:05 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956b72fac1sm43347075e9.1.2026.07.22.04.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 04:19:04 -0700 (PDT)
Date: Wed, 22 Jul 2026 13:19:00 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org, 
	parav@nvidia.com, mbloch@nvidia.com, cmeiohas@nvidia.com, roman.gushchin@linux.dev, 
	bvanassche@acm.org, zyjzyj2000@gmail.com, shuah@kernel.org, tj@kernel.org, 
	mkoutny@suse.com, hannes@cmpxchg.org, alibuda@linux.alibaba.com, 
	dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com, 
	yanjun.zhu@linux.dev, cui.tao@linux.dev
Subject: Re: [PATCH rdma-next v3 00/14] RDMA: Make device names unique per
 net namespace
Message-ID: <amCm6nW8IttsHGgY@FV6GYCPJ69>
References: <20260716132316.1495242-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716132316.1495242-1-jiri@resnulli.us>

Thu, Jul 16, 2026 at 03:23:01PM +0200, jiri@resnulli.us wrote:
>From: Jiri Pirko <jiri@nvidia.com>
>
>RDMA device names are unique system-wide today:
>__ib_device_get_by_name() checks a requested name against every
>registered device regardless of the network namespace it lives in.
>A device in one network namespace therefore cannot use a name already
>taken in another, even in exclusive netns mode (netns_mode=0) where
>the two are otherwise isolated. Net devices have no such restriction -
>their names only need to be unique within a network namespace.
>
>This series makes RDMA device names unique per network namespace,
>matching net device semantics, and adapts the users that assumed
>system-wide unique names.
>
>Scoping reuses the existing rdma_dev_access_netns() predicate, so
>behavior only changes in exclusive mode:
>  - shared mode (default): names stay unique system-wide, no change;
>  - exclusive mode: names only need to be unique within a namespace;
>  - CONFIG_NET_NS=n: everything is init_net, names stay system-wide
>    unique.
>
>There are two users that cannot be made per-namespace and are
>documented as known limitations instead of changed:
>  - the rdma_cm configfs tree: configfs has no network namespace
>    support, so it cannot represent two same-named devices;
>  - SELinux ibendport labelling: endports are labelled by (device
>    name, port) from a global policy; distinguishing same-named
>    devices would need net namespace support in the SELinux policy
>    language and tooling.
>
>Tested with the new rxe_netns_names kselftest added in the last patch.

This looks like good to go. All Sashiko findings are false positive or
unrelated. Care to merge? Thanks!
