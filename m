Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792619848;
	b=nn+/ubJmMOPuNqcv3V7wmh+zzNfNovTxoZ9QmQRfeyO6soVc/V23kRUWr+RLmWm/knGx
	 CjnVZ9a+KK8c1AvoYTf51FfMVQ94kxypQFPCl9UZcpBXyp0xF5lINGcMsTl5tEO0GARP4
	 Lc0gEOLszjOkvRalhMeKGBYVZ+twqm6EKblDKkBYT5NWUBHx0w2F/NbSvd/FceiS4JEA3
	 fNcyk+5RwtXfp9sGmyY2DUa3yN5WymKYdYyKfQpAdGuZu6wX4p2G6urW45dT+oT6eLDDb
	 xyhbcCgvdoCBFTwjJcZdrAtUtamOk+3SINxkS2oDhLuh3D0D33hwvQ9tiICXVjZiWzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792619848;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=g1SAuxh+V8BJJlzZvvGKmODX7I1luUnKPYcmkjJ4SNs=;
	b=yGMfvrVjcCiT+5MJl3WkYXtbPjXK7YrVG6Hyr3v5cyl/WvH2ucbr0543IK2KRhlKNzvC
	 VOooGIujJjWa5W4lQDOmuR2rh96/rds5do5RRdKgcdIVW8LTf5eHXS8YINwbUIb0/OJ5g
	 JotauRzXRd0V9wA5xmYeyV87P94m1tEL3Qj1Sr/tMA5I5oe5H0JgfNYYSDhiMZqIYETek
	 h5fImalYzQf8c7gio6SDeFoS32n+kSN9NxbMHamRwzNJ1OR4TRpV8eFZGq5EXzv/W05DA
	 HSjZpq/LmNHMTvzngBZa2k/huS/JDcrbO05ZjPiPJM+OVRUVR3DRqS/OjmhG0Q2togQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="A5r/jS5Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8F3606A319;
	Wed, 21 Oct 2026 21:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5r/jS5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3E81F000C1;
	Wed, 21 Oct 2026 21:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792619847;
	bh=g1SAuxh+V8BJJlzZvvGKmODX7I1luUnKPYcmkjJ4SNs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=A5r/jS5Zs+T6o2Sx31lLhsBu3B7Sb4BmA4h/CKNIs+gs9nnZI453ubX5qtzsYK0MU
	 sDCgs+whVajIvPXt0TqKNnrI8kSDrA3/S1d+/aFiTTPnR1vnip3ssEjO6UbO09xc1V
	 UtD44LGC0xn9QQJYHd6ZXR1HyUhLzqrpOCyw2zC8YCGq04itofVUZn7iktcIt5dCo+
	 gYsVS/kEGXzuSHSSU9BGKcT2jut/PLtW0oAFDMrV4JIGbXxq9/+6ccNDbMMUQ4/2Q5
	 NOFk6sBxOvQMGqm8hWyMhW6dX8lQRsqqxw3lQBxG6zp/k30iJ4ODeMtnK91u+GDnVp
	 ZaMjn4+rPRJxA==
Date: Wed, 21 Oct 2026 11:57:26 -1000
Message-ID: <66f87058e7e811af340d920e654117eb@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: peng yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Chaitanya Kulkarni <kch@nvidia.com>, Keith Busch <kbusch@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
 Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8] nvmet: add cgroup_id to charge namespace I/O to a cgroup
In-Reply-To: <CAG3TDc1Ydhjx1GD7-ZCqmzYbZv5+DM0O7wPnzKLWJ1ycK9C2sQ@mail.gmail.com>
References: <20261002152821.410591-1-yupeng0921@gmail.com>
 <CAG3TDc1Ydhjx1GD7-ZCqmzYbZv5+DM0O7wPnzKLWJ1ycK9C2sQ@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Peng.

On Tue, Oct 20, 2026 at 06:01:12PM -0700, peng yu wrote:
> Hi Tejun, does this patch look good from the cgroup perspective?

From the cgroup core side, this looks okay to me. However, the current
implementation will block the shared submitter when throttled, and it
would probably need more work to behave well.

Thanks.

--
tejun
