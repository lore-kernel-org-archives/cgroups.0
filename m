Received: from gardel.0pointer.net (gardel.0pointer.net [85.214.157.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E45012FF69
	for <cgroups@vger.kernel.org>; Sun, 16 Aug 2026 16:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.157.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786896670; cv=none; b=fgDYwaS213Rh2N4dNAku0KLzwQr5aqWZ8NHuuG5GR4hPjhcCxD0H1MYTTaokFiCnriiu187b9LyZ8p2OQP3+u0To1s81uHjsffrM8LB/ji0Vsc5GlnkUiynPpp2r67byj1aSu3DdsQ8JDJ83xC88YN1wDaBn4F2lUMsesiagjNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786896670; c=relaxed/simple;
	bh=Ab89NK9oEEhWzKzs61CkpvdyHMiXlMx3PfUTYo1zYCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtOPYabw1ky3s79Vmc/rd9U6dUBEAatwP55eGBxfHv87mFJ76XUX1/aYyZmWJpbmC9r3wcxSyfM0A8cM6PszaVC3ahtocHJPP23aYH3Ek6Ei3WluHp8atPxyS9sn616tbUkMtVn1djKZ5I0KmarL/ocNu6LLGtL5diyNhfQscuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=poettering.net; spf=pass smtp.mailfrom=poettering.net; arc=none smtp.client-ip=85.214.157.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=poettering.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poettering.net
Received: from gardel-login.0pointer.net (gardel-mail [85.214.157.71])
	by gardel.0pointer.net (Postfix) with ESMTP id 58EEBE80648;
	Sun, 16 Aug 2026 18:02:09 +0200 (CEST)
Received: by gardel-login.0pointer.net (Postfix, from userid 1000)
	id 015CC160173; Sun, 16 Aug 2026 18:02:08 +0200 (CEST)
Date: Sun, 16 Aug 2026 18:02:08 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: systemd development <systemd-devel@lists.freedesktop.org>,
	Linux cgroups development <cgroups@vger.kernel.org>,
	Alyssa Ross <hi@alyssa.is>
Subject: Re: [systemd-devel] Purpose of init.scope
Message-ID: <aoHfAHdsX6kE9msj@gardel-login>
References: <b6dd3b7a-18ba-4b0a-bc5f-9c92d8b2aa7f@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6dd3b7a-18ba-4b0a-bc5f-9c92d8b2aa7f@gmail.com>

On Mi, 29.07.26 16:13, Demi Marie Obenour (demiobenour@gmail.com) wrote:

> What is the purpose of having PID 1 in init.scope?  Is it functionally
> necessary, or is it solely for consistency with when systemd is
> running in a container or as a user service manager?

PID 1 needs to live somehwere, so that's where we put it. Where else
would you put it?

Lennart

--
Lennart Poettering, Berlin
