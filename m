Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=50.112.246.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794471117;
	b=5WhoU6UEPaO6jCjGeCxh9XdNyIW+4P3wUZoKzTvWqBzN/ZJQKevnY70PTlRdODkTdRo7
	 NcFlWk7f4PVSU6lkOLZAHxG3Gv57aH5QI5IcireGTv1LylXFUwRqAbfjhZfaZzabp9RHS
	 RXBDtkEpO0aDEOGQW7fYEYqhX3tU7BFEAi7VrgENzDfu93X98IxUbJW36Q8H6gBdreb5X
	 QH70XMssCR24I+ErIznCc7yV0hVO/guG0Hx7Ktx8RNS+h6iQlv11r2ifdHypmHQleHs5n
	 46dYLiiPzwLE1Uw2YPpKtlCsSgAu4N3U5LyJ9/Bsn9yc8p/NgiRdkOnCP0GvPfsZitw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471117;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy:
	 Content-Transfer-Encoding;
	bh=yRwejwn52j/pckFIXfpb6iPXXl8i/31yG967frHncGQ=;
	b=2ZvXGcw7ZcqV7lhFR6S/I8pJa4flyNFRJGv7jevc8SlauEYpBWPI7906VY46qRJW0yyR
	 HRsEWX85QbC0WDOQ39YU104grCq2p7B5F1qAZaVFzAEZDh4sFj5GsqNE+85DngMAr+8St
	 dap+YcrdG8uYSQnmDPDP2Rb2b6ySJJQipja8E5E/Yeyj7xAKz7RrHWl4lGfQbv7by+Q5w
	 CNMnZ5ZPP2iEtglMbhPmCFx6PIgnOWAp/X8gOphz3BjhUduNlskY+P3hZiGWh3MQ5Fsdc
	 ay5ASlifbo1kxA++x/yr62uHHkPY14Dw2wGtDI12VdrWhYTueskE0XQi9z3EkTzS0QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Eop3zxX0;
	arc=none smtp.remote-ip=50.112.246.219
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B94B606A32D;
	Thu, 12 Nov 2026 08:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B94B606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Eop3zxX0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794471117; x=1826007117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yRwejwn52j/pckFIXfpb6iPXXl8i/31yG967frHncGQ=;
  b=Eop3zxX03l9RnQYMeBxTQelYygV5Tsez/u/Rer934FkD8eqkr65+A539
   KlAIohQfZFEGz8vZMTWPDnQNUNXaBr5KXE7I/zQF/Zr074EnJfbGySRnC
   j3UM4iK9qabTNowb8Bj9j2NP1v/KVNS+YwDSuYCD2Udg60jo8U+BVsz6d
   YcM+7xk8q8gF8qFvHWPDdt3qR9ljF7mX+SxVG2ZgyNRc3mFqFmSkIU+gg
   ynvrGnNjF9qWVdga6e9KgDKZDdRcgUdXPae4GYPWJ6lmq7M2epQDceinE
   HhE3zJpGyVSjdMFVs2rOeR8BXdIdtZm5HY0mha/wFDcbqLQH1F/3L8S/7
   A==;
X-CSE-ConnectionGUID: 88UP8YXmSku6Ng9uIsV3zw==
X-CSE-MsgGUID: BDVhN59CST2+sSodA55VWA==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33570827"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 08:11:54 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:28378]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id 57c27c56-a479-41ea-ac2a-2ef1fd33fc35; Thu, 12 Nov 2026 08:11:53 +0000 (UTC)
X-Farcaster-Flow-ID: 57c27c56-a479-41ea-ac2a-2ef1fd33fc35
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 08:11:53 +0000
Received: from dev-dsk-sieberf-metal-1a-7543e84d.eu-west-1.amazon.com
 (172.19.116.227) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 08:11:49 +0000
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
Date: Thu, 12 Nov 2026 10:11:44 +0200
Message-ID: <20261112081144.38224-1-sieberf@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <e795d4feb4a4e7ca4cf24f3cde9e301b@kernel.org>
References: <e795d4feb4a4e7ca4cf24f3cde9e301b@kernel.org>
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
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Transfer-Encoding: 7bit

Hi Tejun,

Fair point. I am happy to focus on the fair patches for now.

v3, the two fair patches on their own with the bot findings fixed, is
on the list:

  https://lore.kernel.org/all/cover.1794398404.git.sieberf@amazon.com/

Thanks,
Fernand



Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07

