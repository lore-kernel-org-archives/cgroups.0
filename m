Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.13.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794399652;
	b=Tbv1K9q8umfq/pDKCpQ+ZOD0X9Qzx2SmRUcCJd/Ng3bncOq3/y/gSav7eOXsRLvCr6dO
	 TivOWsTyB/vTUn1FCSMXjYYIqvicD9ybqBic6DbJECjs59wyKL5/87LfDhJflDdFFiQBq
	 38Pfqoab7xPXw2A8YxNQcCCYLHnrCyk53jCT99HRrUPkvBM8EA1RXZ785gEnr0lDBMT5S
	 vFDVJZzSO1P8Z8RS1x/djrcIg4fMFol5lIYgKCmzQO0SbSxTiojLbRvStEXsYPbCKVgDN
	 SBL3QZxnJyesFCeJSxDkD/EHdcaR94NVpujiU8Ss1QhzBkY6YTTNBx9afTNI8vA4qtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794399652;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy:
	 Content-Transfer-Encoding;
	bh=4R7AlVu0KKxyJKqIxy2nyuf2wvMo6Z36suAc2KUbM/g=;
	b=q3Inuntwt7k7Z4dGH2TfaeqC9kc/emPA84t7QsjzIQBqWwp+tAyyPEUwjaYO+2abgShY
	 onVWqfGHlxcM6ydwbcEtJhPNzuTt3iCtpfIqodQsAq6q+53AP8t70iBWGAItYeNfD3dfz
	 fU0sFs7tpr72HemwjHCiu+GoQyB8ArvBZ5+MGKwSgu89oJWY1w62yGKD4wPYvPCPlOFdP
	 vYS/0poBkkcubU4qEJKCPAecHZ7D8Utt5Yr4MrIy9fRkvxGyIajYC4yD5Dd/fHTlbLat9
	 H2yaOCwE6SrGuyeqx7Y/nrIRUauqY+eMl++pnyAOQX3nEC2WMvPixaLSJ6vqMOBnFYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=r5IsAGa+;
	arc=none smtp.remote-ip=52.13.214.179
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8494606A326;
	Wed, 11 Nov 2026 12:20:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8494606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=r5IsAGa+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794399651; x=1825935651;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4R7AlVu0KKxyJKqIxy2nyuf2wvMo6Z36suAc2KUbM/g=;
  b=r5IsAGa+AGEj//078IM2laq01cLcB/G7fvGe7S1X3hDe8/lP/IsuZsj6
   b+885D4XZEJ84m2ETjvZsW5ApxqLnPi4DHGdZFenfPQV581sJKx4QgXxg
   k0YKt7qfEqqnljNdAVFlQMCXg7FE5didyiWsGPOiiEAJ6QWhKwgCZpn5T
   GafPiJN6nj+81qrraLsj3KaGATZnI57WCCd+EBUUyuufgG042c0vyjGJh
   m8RCwSBelzQ/vO/UE/SuWRZAKA+Kw26xug13KjhGe+As5h185k2yA5Cdp
   Zdiknm4LzAVpSCsTLQanjvfwXNtsZI3NcYB419qdT+wd34lpNgUm0AVlO
   A==;
X-CSE-ConnectionGUID: vOcIWaQ9TryzBkvjITWbGQ==
X-CSE-MsgGUID: CEa1KDJARp6SlAGeMjns2g==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33687110"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 12:20:49 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:2064]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id 2b19eaad-eae1-4b65-b738-4396258f975f; Wed, 11 Nov 2026 12:20:49 +0000 (UTC)
X-Farcaster-Flow-ID: 2b19eaad-eae1-4b65-b738-4396258f975f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 12:20:48 +0000
Received: from dev-dsk-sieberf-metal-1a-7543e84d.eu-west-1.amazon.com
 (172.19.116.227) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 12:20:44 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <tj@kernel.org>
CC: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <bsegall@google.com>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>, <hannes@cmpxchg.org>,
	<mkoutny@suse.com>, <void@manifault.com>, <arighi@nvidia.com>,
	<changwoo@igalia.com>, <skhan@linuxfoundation.org>, <corbet@lwn.net>,
	<rdunlap@infradead.org>, <cgroups@vger.kernel.org>,
	<sched-ext@lists.linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>,
	<hborghor@amazon.de>, <fmubeen@amazon.de>, <dwmw@amazon.co.uk>,
	<karataev@amazon.com>, <sieberf@amazon.com>
Subject: Re: [PATCH v2 0/4] sched/fair: cpu.max.runtime and idle refill for CPU credits
Date: Wed, 11 Nov 2026 14:20:39 +0200
Message-ID: <20261111122039.47687-1-sieberf@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3bdd435fd868ed7ca7ea9061e5966b7b@kernel.org>
References: <3bdd435fd868ed7ca7ea9061e5966b7b@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Transfer-Encoding: 7bit

Hi Tejun,

Thank you for your prompt feedback.

On Tue, 10 Nov 2026 10:10:41 -1000, Tejun Heo wrote:
> If a burstable budget is something useful to add to fair, can you do
> that first and separately? It should be able to stand on its own.

That works for me as a starting point. I will resend just patches 1
and 2 as v3.

> Seamlessly switching tasks between the classes in partial mode has a lot
> of other integration problems beyond this one
> [...]
> The sched_ext part can just be a feature of your own BPF scheduler,
> which you seem to be using already. There, the credit level is just
> state in your BPF maps which your userspace can read and set, so the
> maximalist version can wait until the need is proven. If you want a
> handover between your scheduler and fair, that can be done from
> userspace.

The minimal viable bar for us is to never lose track of CPU credits.
With patches 1 and 2, the userspace handover you suggest covers the
planned transitions: on roll out and roll back, userspace reads
cpu.max.runtime before the switch and writes it back after. The one
case it cannot cover is an unplanned exit, a BPF scheduler erroring out
or killed by the watchdog and falling back to fair, where there is no
window for userspace to hand the level back.

Thanks,
Fernand



Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07

