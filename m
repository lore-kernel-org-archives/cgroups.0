Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171414BF949;
	Mon, 12 Oct 2026 17:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791827674; cv=none; b=IrU40zGkNv5tlRyxzZ+39lNL3NikV76RsZcPsneRB911RVqgDoVxRdrxfJsBBerZBPF02bpSH7VdH3jVF+AWOYyC4V/TUimSXipSToMH9YwmkbY2TpMSiX3covUClpY6LNQ29F5xNrpBD1joj5gsXMdXHz1ATGn2uoNxuV9ojPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791827674; c=relaxed/simple;
	bh=kLSX2Ro2HWGI7Fh9+P6OSqPAck+JcNG0zG0hBmJ1LYc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=nhR8UbwazIV5P8ckf0go0Fy8VXCCtA8ptaxA9oIXBh5gxYlWbe/ctx3CHeldAnzAd/mpgNYuixM1bTyGtXhto97SYcM9b5OhGYWdrOJAY9pInwHiHwqeHMB0KC1qMJ2iFRba4zmeJd4Y1jAH1jVnfKc2Jv8ffT7uUTTorFvRnwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSoU5XdG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSoU5XdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AAB1F0089B;
	Mon, 12 Oct 2026 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791827673;
	bh=rMujrI8lLZx0jPDkA1pBj0BokSSZ+ugGW7v9I8KU66w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dSoU5XdGQY98S3RM2/HXphQ1TvIguDoI97weXubRnk/Zf59ejp9oLaY0RnM8O9mQL
	 psORs/zvOzsOGvllgOAIrd4TXwsGatD0hrmT+8a0F3C2QlGQUcZmAo30uyl2MATc4E
	 TPiUbmQ+og0ZyBM8x5dcuK6U8bJ85HwzSD6C+z0QNj1EbIY4wQjftTkFS6k/j2+nxl
	 L2Y9tEk2KJmIN14GGeXQ7pBba1WgSRRrljFL8PPRWrTQ4nlM42PoujR2VY8Gq1BjPi
	 HMp3b3LybrHRc31bbySJz+TJBWv/BugCTQnQflevpq9SN8b0SBfkwer8dHpykWaVqr
	 HhECV75CDaxAw==
Date: Mon, 12 Oct 2026 07:54:32 -1000
Message-ID: <43b2f07f0d8f0fccb3f44fd89f25e0a7@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"T.J. Mercier" <tjmercier@google.com>, Amir Goldstein <amir73il@gmail.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: memcg: don't close an uninitialized fd
In-Reply-To: <20261011223358.2327625-9-sashal@kernel.org>
References: <20261011223358.2327625-9-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.4 with the subject capitalized and the Fixes tag
dropped.

Thanks.

-- 
tejun
