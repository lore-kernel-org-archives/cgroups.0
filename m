Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535044477E8
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 09:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787046746; cv=none; b=g23/G0MX9R5JKfRfJQfaKqSxajfC6RH50+bB0QoStFGB0S52IZHV4mHQYVlx9PHQ+HJ91B76cxtKv1cbZLyAPGcd9WLLOfpTESSNNN092kZ6+5r+Wc7aXV9mhIeIbTJaJ/vRDh4ecUapnb4QSFuQTpReMqPoe6Tj2ojP6wXn2Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787046746; c=relaxed/simple;
	bh=V+D/8GWaVoFr6lP9vCYb9JERaqL8Hy7u1uNy8umu5HQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QTagSJO6fG4H12alYbIqFDSs49YQTxicm4YHTtg+uSxZcdRn8PaRtIMO+PFYFFP2n30OYUX5SajnZaHzWnlq42TS52iVz1vtK2GsEMjgbCinoC+meIO6mw74WvWHCyjThy3PPFIwjnxJUz0JdM81eQ3By/SqFFpFxI/Qa/7qVBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e3pN03fb; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e3pN03fb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787046745; x=1818582745;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=V+D/8GWaVoFr6lP9vCYb9JERaqL8Hy7u1uNy8umu5HQ=;
  b=e3pN03fbk7W7QrDpd0/yZHWbmSQ65k6cvITmJDeNLdD8keBescQSV77m
   L1ZmSWlrK/Ofn3HCda5qBPDcRTXY2Wj98Vf9duWQJRh7a7aO2CA9F7+Uc
   hOQPmMfyOw4giGSZ1NeAAiFXbhi34mZyoUFsdflssDE1xHKfMfa7oluBV
   zj4EbIKFuenikHd/2PGxV+pMjbvRLxh8vMXnrXznMez8oEkxd3qfO0xvI
   JF6vGXjxuEqKoOLgH+U9uaYjiOgPuMnblgOdmZfi1zvgMqPaiTH2lI9V9
   Y3x2WiCzD4iEW9jAoXCfo2Q/ZXYd4zKFcAlX7iVFN8aD4LnQaeJW+ocV3
   w==;
X-CSE-ConnectionGUID: j3gBSeNFTle2Gn0gopdgvA==
X-CSE-MsgGUID: 8XYQp64tShy14uGvGIkeKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="87409529"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="87409529"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 02:51:53 -0700
X-CSE-ConnectionGUID: a/kComlGTwu9KQTR8YbPGA==
X-CSE-MsgGUID: 5WDSmiQaTGuKOTIR8p5TwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="270398236"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.244.14]) ([10.245.244.14])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 02:51:50 -0700
Message-ID: <66ff58b7b0396106898cfc54c73240a0dcaaf049.camel@linux.intel.com>
Subject: Re: [RFC] dmisc cgroups controller
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: maarten.lankhorst@linux.intel.com, intel-xe@lists.freedesktop.org, 
	cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	pallavi.mishra@intel.com
Date: Tue, 18 Aug 2026 11:51:48 +0200
In-Reply-To: <aoILQuck_EuxQgVh@slm.duckdns.org>
References: <894f9d44eae62aee5762495b4f90f9bdd2b5585d.camel@linux.intel.com>
	 <aoILQuck_EuxQgVh@slm.duckdns.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2026-08-16 at 09:10 -1000, Tejun Heo wrote:
> On Fri, Aug 14, 2026 at 11:32:54AM +0200, Thomas Hellstr=C3=B6m wrote:
> > Hi!
> >=20
> > We (drm/xe GPU driver) have a use-case where we have a very limited
> > number of a particular device resource (CLOS slots) that we
> > potentially
> > want to expose to unprivlieged processes for reservation /
> > allocation.
> > We want to be able to restrict per cgroups the number of CLOS slots
> > that are available for reservation / allocation.
> >=20
> > This is not a good fit for the misc controller since these resource
> > types may be added and removed similar to dmem regions. Neither is
> > it a
> > good fit for the dmem controller.
> >=20
> > Would a dmisc controller be suitable here? It would be similar to
> > the
> > misc countroller but with dynamic addition and removal of resource
> > types similar to the dmem controller.
> >=20
> > Any input greatly appreciated.
>=20
> Would extending the existing misc controller be an option?

Certainly. I think a main concern though would be testing of the
existing use-cases. But anyway I'll take a look in that direction.

Thanks,
Thomas

>=20
> Thanks.
