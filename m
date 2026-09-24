Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8EB41CB5A;
	Thu, 24 Sep 2026 08:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790237996; cv=none; b=RJR2MHLphi6jX3xChl/Kpe1WOZ0bE1zYHe87ziBc3bk1Q2VJT7TZHxWvbh48kpYd/m66yzqGsROmulf48TqbQkeXvM3R3/hImszpRC+g96DIfdR8ZrL8/82uJKPx7+xxkEjGbWRVCRpkOVA+PqR7ZQ3koJhPFT7VOAkTBiOz3TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790237996; c=relaxed/simple;
	bh=w2+K2LbP0v9cCvqVXTptkRcsxtP1P8QyUZRGHR8sj4k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YiAoQ8wq5ZemUEd678LiW8RJtxMN/VNExHM8PbAYbjnjAUYmlg0eWbyV0MoSQy3RDzOh61TCI9XKDu+bAcZT+gb/rpr1fItQDWf1g/ApXWPeYKxUXxN2mty0mXsX0lYdVMLOIDA1Of/BtGaQQZabpMakhnozzhfCuvV06b9m28s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b=Apn+T3SX; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b="Apn+T3SX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1790237980; x=1790842780; i=efault@gmx.de;
	bh=54ZnaI9yQEPU26k9ZGZ5tF2ieRE8IOsASxRnDSllEkE=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Apn+T3SXqoGP8XGHiM+n9g3YsKc5A0/uKFJZVga5jCGYWCNJwGYMtlgneOLMAoti
	 ZIwaf4l7E02Gkl8fY9mlucWVN5svvg7vRBoja6CsrqamUPx8AQmLivYB/oK/sVIBn
	 e0Oboq3AHIiB1nsqqkVjv+objHuT2AIX6v+udWUkSsdtapqnbCAFPPFVvbVbIHd9O
	 K7gxmAx28ts4Kc3oXk2RnqEmJapVLGX7UUauxDCYh1reU5rJn8hV/QdkuoY0rZdM8
	 X4Dockr7mdKY+99bkYTYLCUAumv0fAqtWnDIQq+NzOUHjDuhyWF+xvSmNP5w2gZDG
	 8zG/hXckji99JNYjnA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MfHAB-1wYv951BYx-00n4zU; Thu, 24
 Sep 2026 10:19:40 +0200
Message-ID: <128e93ca1424630546e39f9e9c1377f8185f7644.camel@gmx.de>
Subject: Re: [REGRESSION] [PATCH v3 7/7] sched/eevdf: Move to a single
 runqueue
From: Mike Galbraith <efault@gmx.de>
To: Chen Yu <yu.c.chen@intel.com>, Aishwarya Rambhadran
	 <aishwarya.rambhadran@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
 longman@redhat.com, 	chenridong@huaweicloud.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, 	dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, 	vschneid@redhat.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, 	cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, jstultz@google.com, 	kprateek.nayak@amd.com,
 qyousef@layalina.io, Ryan Roberts <ryan.roberts@arm.com>, 	chen.yu@linux.dev
Date: Thu, 24 Sep 2026 10:19:35 +0200
In-Reply-To: <arQCykkkCnADu5ek@chenyu-dev>
References: <20260605105513.354837583@infradead.org>
	 <20260605124052.227463677@infradead.org>
	 <bd81bbec-ee59-401a-bec6-116196ad3a34@arm.com>
	 <arQCykkkCnADu5ek@chenyu-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Provags-ID: V03:K1:Lk9fD2m5cDYNX6mHVuJvgd0wH9EKrvcgXYam52bqKcjsCzKCKWM
 DOXW3kEArH0qjGCEPEoG2avqEp8PZd19Ck/P+TJ8tLj24/vya4ZjD9ytF7l9jyYhESuwlx1
 iwlqwG9V5d1lMm68y89SNtK8b0WS0d8+DXjrbrYNoy0AAEwjEO++rVVPShQZG+Rhf9wpact
 9S3o3224ovl/hBlYWFmnQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:OmQDsuX3hCA=;IsedYFHmvfSeffPG48DNbpmu/lI
 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
 ukofECCGCBaF8n9yg/bI5G

On Thu, 2026-09-24 at 00:48 +0800, Chen Yu wrote:
>=20
> Would disabling WA_WEIGHT help? I happened to find that this workaround w=
orks
> for me to restore netperf performance (though it is a throughput score ra=
ther
> than a latency one), it seems that task_h_load() becomes much
> larger(also on sched/task_h_load):
> echo NO_WA_WEIGHT > /sys/kernel/debug/sched/features
> https://lore.kernel.org/lkml/aoxah90s0bQ4tcUW@three-body/=C2=A0

A long while back, I caught WA_WEIGHT causing firefox's event thread
pool to stack on a single CPU.  In that particular case, the victims
(32 of 'em in 8 rq box!) did nothing but go back to sleep, so no real
harm was done. However, I also measured modest real stacking impact, so
gave task_h_load() a floor on GP.

Perhaps weightless burst stacking is a bigger deal for some than it was
here?  That firefox event thread burst showed potential.
=20
	-Mike
