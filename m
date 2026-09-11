Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505E62FF641
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138311; cv=none; b=qo/yaGiKGN5kikU6aRftMkT8VCE6ZTy+nyWKOKbThWFeLToXcHyBKCQ2nw2J+u5eb/NwgoaKCh0MqpbVazXMrYy511xx2r6v/p8TTvQHabQx1aNfTXP6E+XaXlyt/00AOSu9WKBiAuH7BOF2j6iOR3ZDR0M3DaIFnpiwCEzBd7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138311; c=relaxed/simple;
	bh=C1wfo29qWaAcAxwz5mxTeUIlcZvdOFe+Tr9RFjljMak=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=JB1WVkM1vI8ERAKVq8WPWudR2JgtumOMwzKiZ1DklNv8o7rjxH3e9jkRGSsnQU8mZdNY4gc9HFh55IuJy24Vp2HTVocINipCar3Xc9ow3mcUzFGYj1g4rw/clhq+9oCJds+8BzGjQ8O+p2ldxQ387W9JG+d/TgMBUAhBBZNO+XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TebA8vf4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TebA8vf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F411F000FF;
	Fri, 11 Sep 2026 14:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789138309;
	bh=C1wfo29qWaAcAxwz5mxTeUIlcZvdOFe+Tr9RFjljMak=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TebA8vf43DVWIUrP5D1aAGcNCpDNFw5X7kohiYCHPBWW2J7FXDuqVcMGkA0D35buO
	 d8GVBLcC/afqZb07suZbuS2WdOqyw44nQ68k/HPsITX6y6fl7SrJ6IAHfyG9UppJmL
	 FmEKyvL7k/visVjBJDZNt317g01v4OvuCkvYo8ytlrqDcUeckc5zVZ57E6D3tDDvOJ
	 K4KT4XtEbDReuBKsVZBlD+txBdzXJWuUpRHaOQvnLEStqpoysNV9a+BzIbedABhesa
	 QLjNtBrRNfieKp8uSdAhy/I3sC4WiAIx+YjwM9LUbIotaJ1yMxkXygvRaaeWphYhHu
	 yUTIfR6i5mqNg==
Date: Fri, 11 Sep 2026 04:51:48 -1000
Message-ID: <3ec6b19143e4af0c9891cddb8acc2eae@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
    Michal Koutny <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: Move cgrp_dead_ task+iwork into its own struct
In-Reply-To: <20260911101900.984420-1-bigeasy@linutronix.de>
References: <20260911101900.984420-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.4 with Michal's Acked-by and description typo fixes.

Thanks.
--
tejun
