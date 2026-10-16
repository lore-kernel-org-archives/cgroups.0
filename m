Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE53CF68F;
	Fri, 16 Oct 2026 20:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792181246; cv=none; b=UYCouov9Ky43saELUTadZmiRWYMzw4f4fZC+oQQDxRFVdnz6I/d/SNaq/bi9LQAjY+BO0VVzfOeNBUE8R5DBCIdm/PpYRtTfNnc4kkkhGHxr1ZqR2jMSLNZs6lTpgxta8ZBoecs6jnZqOtFPQ2JjHVa4hxCXtLU64LOiDrkmplc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792181246; c=relaxed/simple;
	bh=aFl0kUaeDRjAJuZUn2oQtj4Hu1baSzf/RZWziwL/ISI=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=d2n9iAph6Q0FaDhI90WeLUfuAm4cIzqwckKl9dS4tvZyx/qE0TuHMEymI/2MgYmPBMN9+FF11JfHsG+LvkuqcUMZpUi3tjwecyiWUpcDCXhZqlM68iud3d2eoG/ZbQmhUzAqdXW8SOF9tE8Yepe1FlwoZELl0W35pU+zPgeDEaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lx8fDKaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lx8fDKaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8100E1F000C4;
	Fri, 16 Oct 2026 20:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792181243;
	bh=xXIUexn4Je0YcK/ni6N9UfltQIEQV02i+femQibTGu0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lx8fDKaZkMmUMrKqukxYlAaXz2Cw5Rtk0N7H36bRf04QqUlCYpSew/LPyNHMAT0Za
	 LEFDMU9TUGxWJBMJpwbVmBhoRgxth2t7BU7TQqouCPn7gZf7Q4R1j5JMUipK2j75Sq
	 c2c2t/Y7d6PIrQe+231TZpIJOoaRY62fLnEPhYy29e9yI7rDxGkt8+YB5yl0ktpidj
	 uCd2nYdWaqTm+a5ewCcqc0nKs465c+9LgMISYcFUAwop8QoPi0MWMcRcso3+6m34vp
	 A42zXbsm2q72aXcPLdBQc2iYoyVHwp/jVcucnW+ARLA1hBOQNJFwyVzbsN/VnyZ38T
	 15yHjhZo0HnTw==
Date: Fri, 16 Oct 2026 10:07:22 -1000
Message-ID: <fec9516c8cf8a0366ecd535a967b66b0@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] selftests/cgroup: test pids.events notification
In-Reply-To: <20261015111243.1551387-1-sahaj123.sc@gmail.com>
References: <20261015111243.1551387-1-sahaj123.sc@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.4.

Thanks.

-- 
tejun
