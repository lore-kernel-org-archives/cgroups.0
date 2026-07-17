Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE752C0F81;
	Fri, 17 Jul 2026 01:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784252280; cv=none; b=B9fM7GilHwRzOmfGg+IiQsXT5stfz1U7iI+NEa0Qq2yjle50NwEmmH3saEHS3f+onRCJDb173I3Q4IRqFpVAuMCM3zn0Mo1Ag6RBGi2rDTlTCD8QVNh9sHYsRI/fOX2I54K1LuHWquMeq2teMEO9p296RO1VWqFWSawrv/S33w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784252280; c=relaxed/simple;
	bh=+4qV4iMuqjNYYclLyURVg+3Yz6/QyGSgI7KXwJ2cEVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6Bn0MHyHC8uzhsmqkF0aMrLeCg9yUDuemwhMBDCquFay5mLKHq6hneROal4Ubl6TtrRNt10AsR5yEEiSJQRFanEyGc1PI2FarCfJiTKgICyHT5lDRqE+K4gecj+d+Xsm6uwgNv4hWMxAnP9wt9ljevoVUehrSYWEeyOdA/PT5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSYJVlQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSYJVlQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889D51F00A3F;
	Fri, 17 Jul 2026 01:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784252279;
	bh=xN419WW436l578SyNHLzWNkb608Pt+kwr5S/9FasBuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSYJVlQ4fC7uO0KLm3AlZrzwHOjDsomXGsHbc5bAM2X7Vn0ud4aUw0pABkFLvTfVN
	 aRECljuCPqiuxyBUi6MF6NR55JptJIdbjAT0WjiCEf6rxAuyBjbV3keZzQrC55YDbZ
	 OiefZuvUFkL3PXu371YUMLK0lsUgw7fDfI8buohIug5BBIgh+qP3Nhcazx0e0fFwLa
	 KATSqm2TVMTJJDvMJENiUs3DXkalFJZYVmL0CaU3lrktZ/UWZwGRM2P7955333ia20
	 OboH+1gQLRK3c2cSMS2CprtEwTSOIToHPODGWyERqnbiu/wH3xQBncwX3Z41TpzGAn
	 XdfWG7wOsAqIw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	chenridong@huawei.com,
	tj@kernel.org,
	lulie@linux.alibaba.com,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	eadavis@qq.com,
	chenridong@huaweicloud.com,
	akpm@linux-foundation.org,
	surenb@google.com,
	dust.li@linux.alibaba.com
Subject: Re: [PATCH 6.12.y 0/2] sched/psi: fix race in pressure_write (CVE-2026-52991)
Date: Thu, 16 Jul 2026 21:37:36 -0400
Message-ID: <20260716232340.0009-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715083245.32115-1-lulie@linux.alibaba.com>
References: <20260715083245.32115-1-lulie@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Jul 15, 2026 at 04:32:43PM +0800, Philo Lu wrote:
> Backport of the CVE-2026-52991 fix.
>
>   1/2 (94a4acfec146) clear of->priv on release, turning the UAF into an
>       easier-to-detect NULL deref.
>   2/2 (a5b98009f16d, the CVE fix) extend cgroup_mutex to cover all
>       of->priv accesses, read ctx after taking the kn lock, and NULL-check
>       of->priv. It depends on 1/2 as discussed in [0].

I'm holding off on this series (and the 6.6.y/6.1.y ones) for now: a5b98009f16d
moves the psi trigger write path under cgroup_mutex, which means the psimon
kthread gets created while holding cgroup_mutex and introduces a deadlock risk.

Tejun has a follow-up fix for that which is in the cgroup tree but hasn't
reached mainline yet. Once it lands, I'll queue your series together with it on
all three branches.

-- 
Thanks,
Sasha
