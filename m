Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E743335838A;
	Sat,  5 Sep 2026 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788613892; cv=none; b=bwe8CRPOROUKr0ZOcbIj+7blxa47XkEZ1DHFIuM5/GWTMlzmd0Oy3FGXxoV2h2xXTRREJjvc+TivPDGDzYbBRPKuN/juaBTclkWMFC/wHtjXF4nIqHLzSqwY4GtirqtOOnd+bRThmwjYQL7BJKnwc0wHk9df2wbenMGN9A2dmRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788613892; c=relaxed/simple;
	bh=HvW7qdH8/2X3TXbyAoHR4OeyZ8dbsH74G+yO9hseOxo=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=Lg8ypEbQfeRhiPFPXYVJiOmEEBhw+9r8zI9+9HXoGI3G4988gPU1h9gxmqFJnb54vH61ToLxBpPbc3wZ8gjUi0jouYWwgoDokoFw1EjzCkVt7lF2+zpcuSvf5+kPYL7xdcfXn4+yJQRY1W7Kj0l9CTZK3rMCTYAYdovEEHsqWeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=RgJxU+wL; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="RgJxU+wL"
Received: from mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:86a0:0:640:75de:0])
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id 5DEC6805E4;
	Sat, 05 Sep 2026 16:11:19 +0300 (MSK)
Received: from i115078296 (unknown [2a02:6bf:8080:89c::1:1b])
	by mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (smtpcorp) with ESMTPSA id HBKB1P1jHCg0-wDVHjtHG;
	Sat, 05 Sep 2026 16:11:18 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1788613878;
	bh=HvW7qdH8/2X3TXbyAoHR4OeyZ8dbsH74G+yO9hseOxo=;
	h=Message-ID:Date:Subject:In-reply-to:Cc:References:To:From;
	b=RgJxU+wLrLNRyLtyyqz1/UFI7ai6tFmNvTkeKJ1K1aTcxrCLoJLnpRENii6pe1LS2
	 2vwRf5FDrSfHjHk5LZKN+8wa3J7n5LuEa25u5T7lDlvKPFgVNGq7ETIDCGX5uZ1sOd
	 MaJY9gZrz4V23G2VuCccsEfS7CfCHzELdH//Ykjc=
Authentication-Results: mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
References: <20260903-throttl-truncation-fix-v1-1-c6a864c8bc17@yandex-team.ru>
User-agent: mu4e 1.10.9; emacs 31.1
From: Mikhail Rudenko <xyzzy@yandex-team.ru>
To: Mikhail Rudenko <xyzzy@yandex-team.ru>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens
 Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] blk-throttle: reject IOPS limits above UINT_MAX for
 legacy interface
Date: Sat, 05 Sep 2026 16:09:26 +0300
In-reply-to: <20260903-throttl-truncation-fix-v1-1-c6a864c8bc17@yandex-team.ru>
Message-ID: <86v78jrgga.fsf@yandex-team.ru>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


On 2026-09-03 at 14:54 +03, Mikhail Rudenko <xyzzy@yandex-team.ru> wrote:

> tg_set_conf(), used for blkio.throttle.{read,write}_iops_device legacy
> blkio cgroup sysfs knobs, parses limits as u64 but stores them in
> unsigned int, silently truncating values above UINT_MAX. In addition
> to being an obvios correctness issue, this may result in division by
> zero in tg_within_iops_limit(), if the value is truncated to zero.

Nevermind, there is a patch under review [1] which solves this.

[1] https://lore.kernel.org/r/20260722102459.253189-1-cui.tao@linux.dev

--
Best regards,
Mikhail Rudenko
