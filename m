Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.202.70.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793240778;
	b=Xa6hkhr7YzFPPmZbt72Ap9XCwyNv5Eu8bmumSvYd3Dvp6wEFW8DQ0GWPb6fuPAEzItn3
	 8FtrdvI+GD2o0Zwl5AQQgKYM+DAdhoB+uzSpLnzsn4Nl7ILblJWCdxhH7dQYt7WsNFs9N
	 dP1I0vapyPHV0fLrIdEPwGTKTU7Y4ZJ90tgqSUpGRYMa5S3AKcQkFWrwKm3orGSlp0iIm
	 D8+ljTggcVBqssyVZkvLzzwPnDW1KNpDuIxUiq1BA+O8aebc3EMrcPWeRrmOJE5WQ1K9O
	 HU9y9tDEMwe7l914ZuUx556paiQsmQH0EF0efy+coDrBapeVmNAkuEmERsknOtWUd5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240778;
	h=DMARC-Filter:Received:Received:Received:X-MD-Sfrom:X-MD-SrcIP:From:
	 To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:DKIM-Signature;
	bh=yZ4XP4fKGqnpuaPiO+NAfSOHSAxR55No4ctGAN025pI=;
	b=EZ42eS6jlEQnQU5qSeeAIKD+OQs6EPS5WQc77sQJCbh95Yg5WiuNP3yvcpQn4Gf7NYJw
	 sJX8NXPJkZlJ4jCC47JMuNkqUs/YbmetIQdVI6WMecrsz3z2SR4mKTiMg4v7+m4W9crIo
	 sEIJG7CujWFwz4q4rI2kgIZH8P5vbEB+mO+j1x7ZLv7Q9A1jatYOQdmJEg/av8gz3aHC4
	 YKqSiv5BINl59vsZbGyA8REksEPfqq6iab9r+8Js07SdMsCLWAnI2KyBDx5xPYe9UbHwz
	 dAXpvRxNnkqy51DCAQNwqHBfe9PGPFNi+kimzYF6vUs2PC8ofFx+DE8rJDkYK4BB9dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=didiglobal.com;
	spf=pass smtp.mailfrom=didiglobal.com;
	dkim=pass header.d=didiglobal.com header.i=@didiglobal.com header.a=rsa-sha256 header.s=2026 header.b="D8kADA/E";
	arc=none smtp.remote-ip=111.202.70.125
Received: from mx10.didiglobal.com (mx10.didiglobal.com [111.202.70.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 3D3E5606A324;
	Thu, 29 Oct 2026 02:26:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D3E5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=didiglobal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=didiglobal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=didiglobal.com header.i=@didiglobal.com header.a=rsa-sha256 header.s=2026 header.b=D8kADA/E
Received: from mail.didiglobal.com (unknown [10.79.65.20])
	by mx10.didiglobal.com (MailData Gateway V2.8.8) with ESMTPS id B03691811D1B95;
	Thu, 29 Oct 2026 10:25:55 +0800 (CST)
Received: from BJ01-ACTMBX-05.didichuxing.com (10.79.64.32) by
 BJ02-ACTMBX-02.didichuxing.com (10.79.65.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 29 Oct 2026 10:25:55 +0800
Received: from ml-justfortest.ys (10.79.64.102) by
 BJ01-ACTMBX-05.didichuxing.com (10.79.64.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 29 Oct 2026 10:25:55 +0800
X-MD-Sfrom: daikunhai@didiglobal.com
X-MD-SrcIP: 10.79.65.20
From: Kunhai Dai <daikunhai@didiglobal.com>
To: <tj@kernel.org>, <axboe@kernel.dk>
CC: <josef@toxicpanda.com>, <yukuai@fygo.io>, <cui.tao@linux.dev>,
	<cgroups@vger.kernel.org>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<mathieu.desnoyers@efficios.com>, <linux-trace-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] blk-iocost: fix hweight cache publication and donation fail-safe
Date: Wed, 28 Oct 2026 22:25:36 -0400
Message-ID: <20261029022536.237304-1-daikunhai@didiglobal.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20261019125412.3123895-1-daikunhai@didiglobal.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJ03-PUBMBX-01.didichuxing.com (10.79.71.11) To
 BJ01-ACTMBX-05.didichuxing.com (10.79.64.32)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=didiglobal.com;
	s=2026; t=1793240763;
	bh=yZ4XP4fKGqnpuaPiO+NAfSOHSAxR55No4ctGAN025pI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=D8kADA/EdY5P16UThJ2by2idkC5ZqWOsl0p3X2z3mIJR7n/mhRy0uhcguH1IEgI2T
	 F+pvoLc76g6JmTD6pvPAdQJzZStPpKGwSEwLHmVLGis2RdNU/hAku5F7CqtDcAbvZV
	 y9IkETU8edH0xIzY3/Cep8qYGKlLzzcGiiB/XdJQ=

Hi Jens and Tejun,

A gentle ping on this series. Tejun has provided an Acked-by, and Tao
has provided Tested-by and Reviewed-by for both patches. Thank you
both for the review and testing.

Is there anything else I should address before the series can be
picked up?

Thanks,
Kunhai
