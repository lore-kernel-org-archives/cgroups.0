Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A4A38F620
	for <cgroups@vger.kernel.org>; Sun,  2 Aug 2026 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785678032; cv=none; b=U3H4vzhGEZem0vpnAiju/lyUtNR8vYRl3bcjRVjBiFNC0kW6/yDkFdrV7UZGCCHaLTqIEWkhUGaqo2izDHbtKsK7Hx8rXUH9yw78waB2iT/1G1V5hZwEVJXez/1fRL5vuHgB70t3WplvfWIym9KRKhRt/WhLFTbkJE63I72Wi94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785678032; c=relaxed/simple;
	bh=pxv7uP1tEPccuwZjBPSg3jI9UmVBl3/FmdkcOZT12DM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CMdBMfxbv9FBUsVWOvUX10GiCIyNnJKM0esSPyRYjgennoN0I2jJLH1HcLkUM/bh3gJ8S3RT5X3bLmyaaLO3rNlQu/yJRZ019e6jld7m26KSZeUawmIKscdpO6ZE882qQIfbhkp6CFuEIaZEe1Iz1KgXRZsIOhTK1gV1vhC7lt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=barrys-emacs.org; spf=pass smtp.mailfrom=barrys-emacs.org; arc=none smtp.client-ip=217.70.183.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=barrys-emacs.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=barrys-emacs.org
Received: by mail.gandi.net (Postfix) with ESMTPSA id 6ECBD3EC9C;
	Sun,  2 Aug 2026 13:40:21 +0000 (UTC)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [systemd-devel] Purpose of init.scope
From: Barry Scott <barry@barrys-emacs.org>
In-Reply-To: <b6dd3b7a-18ba-4b0a-bc5f-9c92d8b2aa7f@gmail.com>
Date: Sun, 2 Aug 2026 14:40:10 +0100
Cc: systemd development <systemd-devel@lists.freedesktop.org>,
 Linux cgroups development <cgroups@vger.kernel.org>,
 Alyssa Ross <hi@alyssa.is>
Content-Transfer-Encoding: 7bit
Message-Id: <982063BA-EBF1-45FC-83BE-730C2569528B@barrys-emacs.org>
References: <b6dd3b7a-18ba-4b0a-bc5f-9c92d8b2aa7f@gmail.com>
To: Demi Marie Obenour <demiobenour@gmail.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-GND-Sasl: barry@barrys-emacs.org
X-GND-Score: -100
X-GND-Cause: dmFkZTEkN6YVAMOSMQYkhr0PHqkZ9nb0SMdk1ZmnVFaSIQwg1Bp2ia5BCkC/98RgbWkOoz2BB9xYVz/Zg83+P9nybLIQiWsN6CqeYckAMS0bMiU03yWP+9uVU9XpwWsP5cq/CJIya5yecYAKbuy00Q409D5bJwOxLaYSp7SdIv545qHz8ckxsvLbosG4x9Lc9plgyp6ML8vhaJi5/k475kwAB1FSorH9kamWBgxwosHozB3XWPhdZYaYUsup1ZFKL/1gBhNFTxKOw+hQG28PNLb90uGq8xwTlQiVNFo+hze+pAZbSbyeSWpqpGJOwOn7WOyA1w8YCKFCG7ocPI0UcXsHrWwglQ8G5WwxjEWZyscwJcYmB+PlAlbRA0AfMbx+oA1vEkpgGbmWX4hrrARhaHg4cUxIr+DnppkmeJ3SxFdX4EEVkBjXg0AUJnfRa+OzQDoehMAU6Z2QkNeH+DkOxSSmCMd0Ltz5xiVrPO5YYh5ILd8+p+iy+GS5tLQaIDU6gusUvJhxnfVevwGmbqevhGYP0ZheqnFrjDiW22zZzewQv+kRgkmL0rV4ZUkEYTTKSrVgdF3ndx02HVCmA38OEXXm623MnMQM8zxSV6Oi9GAZ1+Zmk9poAVHEnmHhjdnA7WV+up/tdPUEJZawQ8D/m4IdAoxsT1A7bgZQ15yIqbKSvhjthw
X-GND-State: clean



> On 29 Jul 2026, at 21:13, Demi Marie Obenour <demiobenour@gmail.com> wrote:
> 
> What is the purpose of having PID 1 in init.scope?  Is it functionally
> necessary, or is it solely for consistency with when systemd is
> running in a container or as a user service manager?

I assume it so that every process is in a cgroup container.
But that is a guess.

Barry


> -- 
> Sincerely,
> Demi Marie Obenour (she/her/hers)
> 

