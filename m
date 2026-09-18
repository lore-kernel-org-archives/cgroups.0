Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E154F3EBA;
	Fri, 18 Sep 2026 13:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789737789; cv=none; b=CxF4/XE4f3Ge8XJCFZukIjQT1XjxIZ2DVV0DcAlDCRQx9HMM3igoBW+7r/K9cDJWdWSs0nL/cCc4UBbgPme8hGy7IO+nbMiqrJVxyBgZbeI1Qjpi7XUHVAT0su72dB2U7KWbxSn9H+vST+sTiqG9uTrNR10StfcJre0JOwOpGdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789737789; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAsvRPLKc9UivTR2xMQW91u9pxRa8h3h0V81JI6uwDdgu+5N45RylQ6NN1jF7seoxCuM1E8Lntm75lnw4y42jgPQxCKEEhVMD7XRX0g/gKWMPh4WpvD/jG2GJZ66LGAHpgI3dsC9nig9JcjoCHIq4aeF9bRSljKUF+RKY7hcMJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YRdLxeDB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YRdLxeDB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YRdLxeDBkvpoZx0Xh3Q6p+9koV
	i0mE/T53rYXYAd2gLS1rmkV05YixdngIIYTc/fZcC2Tio0E59vlGIAI9kTv6l96dj+wRd3HtCOM1D
	Itu3Md4tmNNG9reEaxLaGDo6/KqVm/Qi9d06josGjJD5IMOHDjl+PqB+J6wWtQ3cZF7uUnh1gGjBw
	Cf5gm9m4BgFCeppB/SiYFzOvxzovQ6tnXhq8P1MdwSZznG04FaVMMzxRUpn3o1qGauHAQTrz0mZPB
	RQYMTmHVetf9LP8si2zRhkcaOltfoanCS4B5foT8fWyM4Yqw5aeNNBavG13ZuAqih2DjSRFO53CQv
	e4oRbRHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7YYU-0000000EV4j-2WcO;
	Fri, 18 Sep 2026 13:23:06 +0000
Date: Fri, 18 Sep 2026 06:23:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
	hch@infradead.org, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn
Subject: Re: [PATCH v2 4/4] blk-iocost: fix stale comment in
 ioc_rqos_throttle()
Message-ID: <aq07OoI2Ay6NMcoW@infradead.org>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
 <20260916085304.1080271-5-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916085304.1080271-5-cui.tao@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

