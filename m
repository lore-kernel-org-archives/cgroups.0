Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.139.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632754;
	b=K9MR/6Tg6SqWVq6fDy7ivRswl76l5QHIBT46blq4p0za/oPFFzEuDc6VPxCyH5+oqu+2
	 V++q7aORVxOzdLK399shBoauZdItET1BLBW6c992WExa+TID3zjn1UksgyqT+xhNyVkA8
	 yrXkYbaTwpGB6uVHOJYXRcnR2NRLpa1kDYrxt5BtRFuvfPniyRN7eyFFDlxT3RwcHPdIc
	 NUuxlKBCpVvR9ze+MmcOIvXssQZJkcmmYmwFVupnz5SgDjpfhN8dJpGFAvJkVfibnkO5O
	 V01s40lS6L72n5Rma096KSigkGlXiWHpS/TMzZnwDpzWqyE1kAGIi/4h3P6gWOYU5Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632754;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=2FPG+mPGP9zQdnlsD8pKX0+RJuv7/N+gUwaGNgwitNw=;
	b=KZ2/hxJbMp17RCP1/DNdzOOLGw3Idw2aXr+tzcEprg2d/6X/DLWgeW7wSavklkeG+b1j
	 fIlUUeN43lGK71NWqs5LTF8HLPAoyw5UHeSbTGbonVp70zHZ8d/KbU/WFLwQOgdVJjg1D
	 k+IP+Vqd026Q5vzBNvDVBvUgMBERBrE93Tjzc5tEkaRo58KwlPKHVSdA+w6tltTzqeWpQ
	 PhhvGVCaNl4/VUvg9IrWToFEuYDQbJkw9bid2Fw+5PQMGQq24uNbJ+NWwhb1KS/OJtHB9
	 ZeNGokdNhOC25K3xO+53pCHMk13mWzo0ESMUq5C3IUu/5kaG6un8G3txUBk7CvVAEqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=YKAb9fQR;
	arc=none smtp.remote-ip=68.232.139.139
Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF6B606C55D;
	Mon,  2 Nov 2026 15:19:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CF6B606C55D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=YKAb9fQR
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1793632753; x=1825168753;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DpaWUXaYUIkqMHEJy5W5Z5azKKbWy2hPbsPwZB7jiHI=;
  b=YKAb9fQRaEURzQR7hS9VqLSfxJkZBlhV3geXSIVtcZjScPu8MgRCHjKV
   RbUhyqGl5l2lsThOua2f0MPLsPkjK2/8k3fMqHsvvawJjnafb+d+K3x5O
   OI0TyhjvmSI29zfA5nDRpfTzxRAzYowos2AJ0Gbk/sOdTaBfk0MuE5wkb
   BpWsDPIN6KSlNv/PCA6ttKcq4ZcgShRqYPRn5JGcMBBJK6jiysmCvFW8z
   wGTSbdSgV5VAYrQSHFAtpHEvfityUBc/M0GLB4NMOC4U7D/6NNeUbQB7K
   y2dpd3sjZQqnhdKAFmA4NB1a1rppaBmP+OFd/q6byxQMcyBE/ROWvXgdS
   w==;
X-CSE-ConnectionGUID: IkEMWcHQST6hzBwsT6Hi6w==
X-CSE-MsgGUID: sXc7FGC1SA+1FwR+8Q9Yjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="264363229"
X-IronPort-AV: E=Sophos;i="6.27,191,1786978800"; 
   d="scan'208";a="264363229"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 00:19:06 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 418991C1C711;
	Mon,  2 Nov 2026 15:19:06 +0000 (UTC)
Received: from az2nlsmom1.o.css.fujitsu.com (unknown [10.150.26.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id E4A8CC011AF;
	Mon,  2 Nov 2026 15:19:05 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.180.215])
	by az2nlsmom1.o.css.fujitsu.com (Postfix) with SMTP id F0E73827901;
	Mon,  2 Nov 2026 15:19:02 +0000 (UTC)
Date: Tue, 3 Nov 2026 00:19:01 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, cgroups@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH v1 1/2] KVM: arm64: CCA: Add support for configuring
 the Realm MEC policy
Message-ID: <auio781Uu9Zzyq3i@FCCLS0092175.localdomain>
References: <20260724094120.166536-1-enju.kohei@fujitsu.com>
 <20260724094120.166536-2-enju.kohei@fujitsu.com>
 <46d78aa2-cacb-4efd-ae62-3026f5fe9b3f@arm.com>
 <amwrnJ1KhllC-gVu@FCCLS0092175.localdomain>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <amwrnJ1KhllC-gVu@FCCLS0092175.localdomain>

Hi Suzuki,

I sent the message below off-list a few weeks ago, but I'm following up
on-list in case it didn't reach you.

Since then, I've started reworking the series based on the
kvm_device_attr approach you suggested, and I'm currently testing it
against v23 of the CCA host support.

I'd still appreciate any feedback on the ABI direction, as well as
whether you see any concerns with posting the RFC series while the host
support is not yet upstream.

Thanks,
Kohei

On Fri, Oct 9, 2026 at 03:15:23PM +0900, Kohei Enju wrote:
> On 07/31 14:09, Kohei Enju wrote:
> > On 07/29 12:47, Suzuki K Poulose wrote:
> > > Hello
> > > 
> > > Thanks for sending the patch. Please find my comments inline below.
> > > 
> > > 
> > > On 24/07/2026 10:40, Kohei Enju wrote:
> > > > Introduce the KVM_ARM_RMI_CONFIG ioctl to allow userspace to configure
> > > > Realm VM parameters before the Realm is created.
> > > 
> > > This approach is something we tried in the past. Another option is to
> > > add these as kvm_device_attr for the KVM VM, under a new group, e.g.,
> > > KVM_ARM_VM_RMI_CTRL and add the following attributes :
> > > 
> > > KVM_ARM_VM_RMI_CTRL_RPV 		-> Realm Personalization Value
> > > KVM_ARM_VM_RMI_CTRL_MEASUREMENT_ALGO	-> Measuerment algo
> > > KVM_ARM_VM_RMI_CTRL_MEC_PRIVATE		-> Private MEC Policy. By default to shared
> > > ?
> > 
> > Hi Suzuki, thanks for suggesting another option. That looks good to me,
> > and I'd be happy with either approach.
> > Anyway I'd like to wait for feedback from the maintainers and other
> > reviewers.
> 
> Hi Suzuki,
> 
> I'm thinking of respinning the MEC policy series as RFC v2, as you
> mentioned in the Core Collective WG last month.
> 
> For the ABI, I'm planning to switch to the kvm_device_attr-based
> approach you suggested instead of introducing a new VM ioctl. Before I
> start reworking the series, do you have any concerns with that
> direction?
> 
> One other point is that the series still depends on the CCA host
> support, which is not upstream yet. As a result, tools such as Sashiko
> would likely be unable to identify the correct base tree and may not be
> able to provide useful automated review feedback.
> 
> Personally, I think this is acceptable since the series is still RFC and
> the primary goal is to get feedback on the ABI and overall design rather
> than seeking integration at this stage. However, I am aware that posting
> patches on top of non-upstream trees can sometimes be problematic from a
> review perspective.
> 
> Do you have any concerns about posting an RFC series in this situation,
> or would you prefer that I wait until the host support lands upstream?
> 
> Thanks,
> Kohei
