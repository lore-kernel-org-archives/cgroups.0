Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794596889;
	b=m2JXDVolYLYZsAweDBWE/X6iW02ce+0cq8nKfL0cuD/ZpR0XBD/TRRR7G9u4PRC/2ENj
	 uEGNgvuUp7zMNWXMGxbh/8yJRZBbRqSOfj930L48PL/jyK1fsN4lZjBw21lPpc5L6m0Wi
	 nuX++wJNLyktJoEBdciHBfLxsSVx4sY/3qX6MKqqcCAFL1zx+rdxRMzLM+S8xFsbluEb+
	 c4HSnCc8bHHWAkmgels5jtHV5xYBawoTcIA1V8on4+C0YRxU0JByGrZhicMwUj2AJhSF0
	 r1FWjirkRNCyPAKKyTGbrpC/evqUQgpqcQi3MOaI9dmHjWyaP7JDZB4pbwL/jJbB6+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794596889;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=KqmAifuY47FhdIMeVG0SytAsRKNpaqSkIEqTblMNWCI=;
	b=AEA6sbTBKIG4LVQuFzgC52OlTcGE5m7wtvlEep69UD7/arl3btKTiWdp3C9W33C+UYcM
	 EIP5hgOj0bY4YyUDsmwn56bBmubH24oj3s0kTwRFNKrh9V9PBkBBcsyBvIjZ9U9B4nGth
	 NPjPCqQTZKRHowdM3a/HwW9Wn+q5DGoo+vWzyYtjCTeG/4VffVtISd/oXF6tYlq4okfHi
	 Y7sVYOjiHmGu0kKXD4AgG0kDk1HH60AjJ6YE07iyOwwv0lf4G3bXhws2Vwn5FpTjy40ON
	 82Xa6dg467j1X3GrYvgS9XIgmrBOHCvsj6jidFnTrL3vWNPGvS4+N8c52L34az1SaVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NW6ta6Qx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5102B606A33D;
	Fri, 13 Nov 2026 19:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NW6ta6Qx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04B21F000CF;
	Fri, 13 Nov 2026 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596889;
	bh=KqmAifuY47FhdIMeVG0SytAsRKNpaqSkIEqTblMNWCI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NW6ta6Qx1nAOdA+jZ5l7HCb0T94PZ3wn3s9Y38WnpdPQtPedUR0/juC2s19ko8/2g
	 ttlUvFw5q6kO2jGHeJT4SS/Fc2Tm6nzD+rP+qH63sr79mOzzy+pEICDOND7ZWvSKNy
	 i7RVXYk7HvZA86suFX8/Jgmi9v0sDBaVHTXoMSI5ux7AcbgfXkg+cngLJN88IDwI+f
	 7SjV6uI/eoyVzrNVlbuWJlPtvWo+AbazPx9g1fsONhd+/6gRWJBEyHdnA6PVtTCsxB
	 RW+Fci2z1bMbObJEvrKfrqIu8YXE5qDfHLEPu54COL3Q0Plr7ZZIFc/4ZtBi8Gc0C8
	 mfnGQPvTMcXLw==
Date: Fri, 13 Nov 2026 09:08:07 -1000
Message-ID: <0076998cf3693ad6d92b4bda775e5956@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Alex Kazinsky <a.kazinsky@ideco.ru>
Cc: Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, stable@vger.kernel.org
Subject: Re: [PATCH] blk-iocost: Fix overflow in donation weight calculation
In-Reply-To: <20261113110842.4189035-1-a.kazinsky@ideco.ru>
References: <20261113110842.4189035-1-a.kazinsky@ideco.ru>
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

On Fri, Nov 13, 2026 at 03:08:40PM +0400, Alex Kazinsky wrote:
> hweight_after_donation() receives usage as u32, clamped to the range
> [1, WEIGHT_ONE]. Since WEIGHT_ONE is 1 << 16, multiplying it by usage
> equal to WEIGHT_ONE wraps the 32-bit unsigned result to zero before
> it is passed to div64_s64().
>
> This makes new_hwi zero, which is then clamped to 1, incorrectly
> reducing the cgroup's in-use weight to the minimum.
>
> Cast WEIGHT_ONE to s64 before multiplication to preserve the full
> product.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE static
> analysis tool.
>
> Fixes: f1de2439ec43 ("blk-iocost: revamp donation amount determination")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
