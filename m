Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2587334C1D;
	Sun, 26 Jul 2026 07:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785051157; cv=none; b=qxlNQ+h0A0TQ2ecUFIR5CBujwMYgPtVGQ5Qk7SHZJgsDfH+yY5NH6lUvf1mLd4T26gucLOX5ZXP6PPhIiDvxYH/ZzoaHqMAozS70dks/o0GWThBzaiuJivYW0j6Vh+FsDrIA5epKYmYtnxwLMBsXiGQvjU+dXN0TZUh6fzj+wXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785051157; c=relaxed/simple;
	bh=Qu83u95aH6gT9P4AXX8GUi+ou0qYHVYyUm/fgtjr4Aw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Z6G0Hds3JHN5vGJLuN0WisdQRD56WMMzGS+43M8M6aZ4T4b4QMdKt+wJR/Dw4hk8e4en9DhO4yVEfCrhGOHHHKzwc0jJFu5IJ7vT2aMjxLV6AIbfF/N3hJmvPFfojzoKXxu9WKSid3diXyVo0gnQP8NQZ1SOfsPehoRqIqMISqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBlKZV+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBlKZV+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C571F000E9;
	Sun, 26 Jul 2026 07:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785051156;
	bh=KI+6lAX7CS/wnVTdgH5jpRpOWEa7uEjjc/ng89HMrhM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=dBlKZV+FZxECL1EhuNuqZfUfClTa5tmuClojddbGuhIwOr4Y7GZTzBK1Hk0kT/4U4
	 ag3EWFPFq1AROaiJZ2fK8tBlissSrZrc/Bg3CVInCMNAOh/TrsVgOJyQI4wPayLVM4
	 cCK3p24fkBN1bJbnBRvW1zW+OriTol8zFf5k0BJMCRfZDGg3wcerj3NFT62qtyOvZ7
	 J21eJ5rRohRGlyYbQ0JJ5s+ycxkjBmE1s2nX4K5besD7EIpCZeRfoNlt1IIpwuVRLh
	 CxJW0tCLz+k59cDOSycoYOhdcGXxEMA5Rb/Eeectv2vr0NhdYRVn4vTnDfGPkMN5Fm
	 hMz9KOll19oBA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, jgg@ziepe.ca, 
 parav@nvidia.com, mbloch@nvidia.com, cmeiohas@nvidia.com, 
 roman.gushchin@linux.dev, bvanassche@acm.org, zyjzyj2000@gmail.com, 
 shuah@kernel.org, tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org, 
 alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, sidraya@linux.ibm.com, 
 wenjia@linux.ibm.com, yanjun.zhu@linux.dev, cui.tao@linux.dev
In-Reply-To: <20260716132316.1495242-1-jiri@resnulli.us>
References: <20260716132316.1495242-1-jiri@resnulli.us>
Subject: Re: [PATCH rdma-next v3 00/14] RDMA: Make device names unique per
 net namespace
Message-Id: <178505115342.4046214.13697578772610862537.b4-ty@kernel.org>
Date: Sun, 26 Jul 2026 03:32:33 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 16 Jul 2026 15:23:01 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> RDMA device names are unique system-wide today:
> __ib_device_get_by_name() checks a requested name against every
> registered device regardless of the network namespace it lives in.
> A device in one network namespace therefore cannot use a name already
> taken in another, even in exclusive netns mode (netns_mode=0) where
> the two are otherwise isolated. Net devices have no such restriction -
> their names only need to be unique within a network namespace.
> 
> [...]

Applied, thanks!

[01/14] RDMA/core: Pass the net namespace to the device name lookups
        https://git.kernel.org/rdma/rdma/c/8d010293845e21
[02/14] RDMA/core: Handle device name conflicts when changing net namespace
        https://git.kernel.org/rdma/rdma/c/fa8f67f797d53d
[03/14] RDMA/core: Support renaming a device when changing its net namespace
        https://git.kernel.org/rdma/rdma/c/8fc673bebd07ce
[04/14] RDMA/nldev: Report net namespace move errors through extack
        https://git.kernel.org/rdma/rdma/c/e11553414e1e90
[05/14] RDMA/nldev: Allow setting the device name while changing net namespace
        https://git.kernel.org/rdma/rdma/c/601f3fd97dec05
[06/14] net/smc: Look up the pnetid ib device within the net namespace
        https://git.kernel.org/rdma/rdma/c/47b9ef3c0013e1
[07/14] RDMA/srp: Make the SRP sysfs class net namespace aware
        https://git.kernel.org/rdma/rdma/c/e9153a2671194e
[08/14] RDMA/cgroup: Disambiguate devices across net namespaces
        https://git.kernel.org/rdma/rdma/c/c4ef67e5aa3e08
[09/14] RDMA/cma: Document that CM configfs cannot be net namespace scoped
        https://git.kernel.org/rdma/rdma/c/bca2c9d781bccb
[10/14] RDMA/core: Document the SELinux ibendport net namespace limitation
        https://git.kernel.org/rdma/rdma/c/4ad1fe8e25e41a
[11/14] RDMA/core: Make device names unique per net namespace
        https://git.kernel.org/rdma/rdma/c/625ca0d94cb13a
[12/14] RDMA/rxe: Allow queue VMAs to outlive ucontexts
        https://git.kernel.org/rdma/rdma/c/22fe73aef39f27
[13/14] RDMA/rxe: Implement disassociate_ucontext callback
        https://git.kernel.org/rdma/rdma/c/acf9cbb06f1fad
[14/14] RDMA/selftests: Add rxe_netns_names test
        https://git.kernel.org/rdma/rdma/c/ecdcc8a455b784

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

