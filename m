Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.36.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787032;
	b=Py9zVSNXXktLmY0QssvyzMa4/GY6h4U+GmQKldTAxN0qy8xlr9MmbQ1HfvZXfqDgD3l7
	 Vc6RosEB32jAX1sy3vDk697iDqK0HweI4J098FDTLD3wWSgy/jJeY6FQkXSR02QEdiTf+
	 pvbBhwYarjjj+ZYsqYOQ1v1POsMF6uDojZVWf1+dVtj0QsXYHNh4ZuVbWIodGD2EPwx04
	 +02uLT+HE5w7CMQVf8EzC5ZLuzarDeAt+LMtPJfVIu4Tf+GGYkrH2L8Gd1roOFFT+4En7
	 HrtK+JEqVQp/Z3FgWnuy2KWzAc9XGn6zVJiJQSihQnlpo+nMOFOD49h2bu+YqGo0qxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787032;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=iK1SoSRXvGm+gcMYygRdAKL4r2UZoigCfjdZJjBIYFo=;
	b=zlvt3B60pWg+1xXaVHoFPwhyZpPPiDst89PfkvdEvVpTojc1EbLepYXRPEej5GmpQFOU
	 GvfEA7tQg7Equ5+s+WTnI3pDxIHxLIjJ7tr4x/zcMIwYfFJAvebStgbaBBKqgi+6FwPJ+
	 PdMmF9TFAi1ryHOfoT+lv8AFdTyFg0MrcymDOVoRKUwi3DI0CIZ5AzbPB8qjtK8y3tJ7n
	 7XnckJZ6Q0jgt17k4fnfbGyyDWh/zb1qj134P2+pnzlvXp/O4Gof2jle8QaqdxMOYYUOX
	 Q1YV/IyMeRQ2A35F0MKfjQHeQtRMuT5vRTQWgLjdaCT2w2pFmjBQAZ+j9Tf6qIfN9WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	arc=none smtp.remote-ip=139.138.36.225
Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4DA606A326;
	Wed,  4 Nov 2026 10:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB4DA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1793787038; x=1825323038;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=id2vzE+xcY7nItlqYwJdzJh7OgqLKeLjWS+ogyye2uQ=;
  b=FPD3k+WPbMzcQm82s1r0gmJBZFf5KGRG8x0e7CmknsQTw8CZfOCBgpMK
   k+Hopm45mWBdfAVANvV3Gsdb6oXoqufOhQTL8PIDATSBZUtPT2/QHA0Q1
   wb938nN+9RpenrSyicTl6g6vetmRLgM/w1BpJHh7VYjaeyrpxS0VrBrRJ
   tnLZM69VnvIlqIKEuAUPr3Idi8sRB0QeCsYiX1Iru8MAAWlO0SqoBaZ4/
   jWzX5rBB3xfdnAZ4LkYLRPr6M8d7bzxCug9Lw3FxhTAF/ZMHybebV0RNG
   MwzwXkt1lZ/q14QJVhcHUN+lGe1wKhnWEwZOIADvUWvBS338eOquy5xdz
   g==;
X-CSE-ConnectionGUID: Ee7Y8ealTE23cebkUWZNpQ==
X-CSE-MsgGUID: qcTgsVhwRoO0vvc9tEM6rA==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="246775297"
X-IronPort-AV: E=Sophos;i="6.27,195,1786978800"; 
   d="scan'208";a="246775297"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 19:10:30 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id F1F6C10000C4;
	Wed,  4 Nov 2026 10:10:22 +0000 (UTC)
Received: from az2uksmom2.o.css.fujitsu.com (unknown [10.151.22.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id A92AF18026EA;
	Wed,  4 Nov 2026 10:10:22 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.61.160])
	by az2uksmom2.o.css.fujitsu.com (Postfix) with SMTP id A75AB140010E;
	Wed,  4 Nov 2026 10:10:18 +0000 (UTC)
Date: Wed, 4 Nov 2026 19:10:17 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, cgroups@vger.kernel.org, linux-coco@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [RFC PATCH v1 1/2] KVM: arm64: CCA: Add support for configuring
 the Realm MEC policy
Message-ID: <ausD4yiI7gSRFsqe@FCCLS0092175.localdomain>
References: <20260724094120.166536-1-enju.kohei@fujitsu.com>
 <20260724094120.166536-2-enju.kohei@fujitsu.com>
 <46d78aa2-cacb-4efd-ae62-3026f5fe9b3f@arm.com>
 <amwrnJ1KhllC-gVu@FCCLS0092175.localdomain>
 <auio781Uu9Zzyq3i@FCCLS0092175.localdomain>
 <46c28259-086e-4948-8c00-183f9e62114a@arm.com>
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
In-Reply-To: <46c28259-086e-4948-8c00-183f9e62114a@arm.com>

On 11/02 15:57, Suzuki K Poulose wrote:
> Hi Kohei,
> 
> On 02/11/2026 15:19, Kohei Enju wrote:
> > Hi Suzuki,
> > 
> > I sent the message below off-list a few weeks ago, but I'm following up
> > on-list in case it didn't reach you.
> > 
> > Since then, I've started reworking the series based on the
> > kvm_device_attr approach you suggested, and I'm currently testing it
> > against v23 of the CCA host support.
> > 
> > I'd still appreciate any feedback on the ABI direction, as well as
> > whether you see any concerns with posting the RFC series while the host
> > support is not yet upstream.
> > 
> > Thanks,
> > Kohei
> > 
> > On Fri, Oct 9, 2026 at 03:15:23PM +0900, Kohei Enju wrote:
> > > On 07/31 14:09, Kohei Enju wrote:
> > > > On 07/29 12:47, Suzuki K Poulose wrote:
> > > > > Hello
> > > > > 
> > > > > Thanks for sending the patch. Please find my comments inline below.
> > > > > 
> > > > > 
> > > > > On 24/07/2026 10:40, Kohei Enju wrote:
> > > > > > Introduce the KVM_ARM_RMI_CONFIG ioctl to allow userspace to configure
> > > > > > Realm VM parameters before the Realm is created.
> > > > > 
> > > > > This approach is something we tried in the past. Another option is to
> > > > > add these as kvm_device_attr for the KVM VM, under a new group, e.g.,
> > > > > KVM_ARM_VM_RMI_CTRL and add the following attributes :
> > > > > 
> > > > > KVM_ARM_VM_RMI_CTRL_RPV 		-> Realm Personalization Value
> > > > > KVM_ARM_VM_RMI_CTRL_MEASUREMENT_ALGO	-> Measuerment algo
> > > > > KVM_ARM_VM_RMI_CTRL_MEC_PRIVATE		-> Private MEC Policy. By default to shared
> > > > > ?
> > > > 
> > > > Hi Suzuki, thanks for suggesting another option. That looks good to me,
> > > > and I'd be happy with either approach.
> > > > Anyway I'd like to wait for feedback from the maintainers and other
> > > > reviewers.
> > > 
> > > Hi Suzuki,
> > > 
> > > I'm thinking of respinning the MEC policy series as RFC v2, as you
> > > mentioned in the Core Collective WG last month.
> > > 
> > > For the ABI, I'm planning to switch to the kvm_device_attr-based
> > > approach you suggested instead of introducing a new VM ioctl. Before I
> > > start reworking the series, do you have any concerns with that
> > > direction?
> 
> ...
> 
> 
> > > 
> > > One other point is that the series still depends on the CCA host
> > > support, which is not upstream yet. As a result, tools such as Sashiko
> > > would likely be unable to identify the correct base tree and may not be
> > > able to provide useful automated review feedback.
> > > 
> > > Personally, I think this is acceptable since the series is still RFC and
> > > the primary goal is to get feedback on the ABI and overall design rather
> > > than seeking integration at this stage. However, I am aware that posting
> > > patches on top of non-upstream trees can sometimes be problematic from a
> > > review perspective.
> > > 
> > > Do you have any concerns about posting an RFC series in this situation,
> > > or would you prefer that I wait until the host support lands upstream?
> 
> It would be useful to have the RFC on the list to get an idea on shaping
> the UABI. It may also be useful for people to verify the end-to-end
> stack, including the remote attestation flow. (the branch we have is
> ancient)

Thanks. I'll post RFC v2 soon, based on the following branch:
  https://gitlab.arm.com/linux-arm/linux-cca
  branch: cca-host-mm/v1/integration

> 
> But nothing else, i.e, code correctness or functional reviews
> etc (that rules out meaningful Sashiko reviews etc).

Thanks for the clarification.

Thanks,
Kohei
