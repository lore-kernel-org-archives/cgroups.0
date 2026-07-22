Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28E64D991D;
	Wed, 22 Jul 2026 11:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784721211; cv=none; b=qgGOVDnrb7oHblUhEHPyNy7CgtvQIDVlYltSgeGLdUADT5Apr8jbsSamjTM5FlHJlT+tzTBhzCJAC1bVO15ekgH7mJ78seh/g6tKk9e6DFjbK7ZkhwypYmCGzHftr1eu6yTgMGvBquRwzG97uMhvXwoTyONaNTbVQe/LJvRXwGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784721211; c=relaxed/simple;
	bh=tyzG0VpolMxUUEbPHphc8yww7AdfUunLcuNFxweQUeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=es20mXw54Wm+AwghSOez8IHjWJWfPeGQBbZP3XZGOxsuxHhdx21IX6kOd63/JM+yFSfigEktLvEOp9Pi3U7Tc6en8zBD9N04Afy8urF/vPmnUmq/pFtryUPZpgQ+jOk2aA5fk5+7BZEPujPCVyYMGQWG7n7190l2tZ8XTn3UFmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O7lTPb22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7lTPb22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCF51F000E9;
	Wed, 22 Jul 2026 11:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784721209;
	bh=DLWAQrUUd6Ntz/9xjpIwkrPDdAK2z+x/UbLbKGN4Sl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O7lTPb22BxgDj5ZIzSo42qn7BwomjHFrT/rz0GCDS9yBFLZDCchb6aSTpv6dT9awW
	 yW7xvbkcNqLXqIWAGjB3srve3gNNrubjyJ5mBmCHTmpzFhwvfPhS108BoYeMmkHdG9
	 VTvOFIcDrw6gIJ8ytD4+d35MJtGa2KcD6zlSZN7o54KTi1yzmBMTYALFTxseC5T0j8
	 UA90m6MnOX7orwZAqz8I6FXC3t2QMSmqqW6QmMWaMTF6A/gO5Xl3jknALYx6INPaou
	 5xE8GDiE2VTcNr8qYrXivB/VSM6KrfYZdGoZ2hBd7JLqXbRmBFFhL4m3ANpeGVj5//
	 k2OsssQ/pkhZg==
Date: Wed, 22 Jul 2026 14:53:23 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-rdma@vger.kernel.org, cgroups@vger.kernel.org,
	netdev@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kselftest@vger.kernel.org, jgg@ziepe.ca, parav@nvidia.com,
	mbloch@nvidia.com, cmeiohas@nvidia.com, roman.gushchin@linux.dev,
	bvanassche@acm.org, zyjzyj2000@gmail.com, shuah@kernel.org,
	tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org,
	alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com, wenjia@linux.ibm.com, yanjun.zhu@linux.dev,
	cui.tao@linux.dev
Subject: Re: [PATCH rdma-next v3 00/14] RDMA: Make device names unique per
 net namespace
Message-ID: <20260722115323.GY110966@unreal>
References: <20260716132316.1495242-1-jiri@resnulli.us>
 <amCm6nW8IttsHGgY@FV6GYCPJ69>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amCm6nW8IttsHGgY@FV6GYCPJ69>

On Wed, Jul 22, 2026 at 01:19:00PM +0200, Jiri Pirko wrote:
> Thu, Jul 16, 2026 at 03:23:01PM +0200, jiri@resnulli.us wrote:
> >From: Jiri Pirko <jiri@nvidia.com>
> >
> >RDMA device names are unique system-wide today:
> >__ib_device_get_by_name() checks a requested name against every
> >registered device regardless of the network namespace it lives in.
> >A device in one network namespace therefore cannot use a name already
> >taken in another, even in exclusive netns mode (netns_mode=0) where
> >the two are otherwise isolated. Net devices have no such restriction -
> >their names only need to be unique within a network namespace.
> >
> >This series makes RDMA device names unique per network namespace,
> >matching net device semantics, and adapts the users that assumed
> >system-wide unique names.
> >
> >Scoping reuses the existing rdma_dev_access_netns() predicate, so
> >behavior only changes in exclusive mode:
> >  - shared mode (default): names stay unique system-wide, no change;
> >  - exclusive mode: names only need to be unique within a namespace;
> >  - CONFIG_NET_NS=n: everything is init_net, names stay system-wide
> >    unique.
> >
> >There are two users that cannot be made per-namespace and are
> >documented as known limitations instead of changed:
> >  - the rdma_cm configfs tree: configfs has no network namespace
> >    support, so it cannot represent two same-named devices;
> >  - SELinux ibendport labelling: endports are labelled by (device
> >    name, port) from a global policy; distinguishing same-named
> >    devices would need net namespace support in the SELinux policy
> >    language and tooling.
> >
> >Tested with the new rxe_netns_names kselftest added in the last patch.
> 
> This looks like good to go. All Sashiko findings are false positive or
> unrelated. Care to merge? Thanks!

We usually take extra time before merging complex changes touching
core or UAPI code.

Thanks
