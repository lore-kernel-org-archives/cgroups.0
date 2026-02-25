Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50AC24503F;
	Wed, 25 Feb 2026 05:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771996735; cv=none; b=OgInNiHavq/4A9N+uJddgL4tdjeHuKApZGl9J4ByDq/S5M9vZpW3LgKzGxik74kd95EYgTtUwUZeJBZi+JxMOkZhX83bTLJHYXwjh3NA2seqgaz+tAxYmr5KgieyTixBdGwtMVCrqpAPmFmFzWIirnSs3qO/KP/RRXP2UD7zqpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771996735; c=relaxed/simple;
	bh=DfxJoosJCQnMT8gV8lj98mkQC8yV1P2fhMvsqkuYFg4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=dvVIQWoF7Sj9C3YjQeg75iGlJPTqosAFpYQ9COizy8YCJadJhfJHXnFA4GpXSQm83lDVknPTSqWO0YdqzAhA093A5Ruf5IRwaZPH+DIL37p3nQkT/9uZi81Tm+Il/ohrMS6rcnexEQrDbBTzhpsTBeoi56CwCV4dJPWp1ehAPkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1MSPMs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1MSPMs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0C2C116D0;
	Wed, 25 Feb 2026 05:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771996735;
	bh=DfxJoosJCQnMT8gV8lj98mkQC8yV1P2fhMvsqkuYFg4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H1MSPMs11qHmro3gp4uAPALxeSiDaJJLL40qO8L7CQDrvCOps5eN3G9Aact5KbOFP
	 d37fpYV2m7KN1EAtLAn+qMlkN5owqMeYMrmVq8S1R/s5u8isds0UIKGKREAZIZ1V9W
	 nxM+I3/Dgh8UJHjkVrFhgKzDBsmdGKWsMuo9SpUwDNm7OtihMyV0GhL9cj/Z0pEjEc
	 PxhyOG+vaZ+Cnon7wSuw02DmYrTiXFwk5MaJcidnZsP3jxBMEdDVjUdMg08MFDUwSH
	 aqO2OK+iJRdSPnO2zaihysisZz0nBDJQ3D+HWWkvNKYEfCT89eTapI/vSulfo+YkdP
	 D5/AxDf1pyv1A==
Date: Tue, 24 Feb 2026 19:18:54 -1000
Message-ID: <03a23ae6f036702bbb862a6c9ba66a03@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org,
 sched-ext@lists.linux.dev
Cc: void@manifault.com,
 arighi@nvidia.com,
 changwoo@igalia.com,
 emil@etsalapatis.com,
 hannes@cmpxchg.org,
 mkoutny@suse.com,
 cgroups@vger.kernel.org
Subject: Re: [PATCHSET v2 sched_ext/for-7.1] sched_ext: Implement cgroup
 sub-scheduler support
In-Reply-To: <20260225050152.1070601-1-tj@kernel.org>
References: <20260225050152.1070601-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Please ignore this duplicate posting. The correct thread is:

  http://lkml.kernel.org/r/20260225050109.1070059-1-tj@kernel.org

Sorry for the mess.

--
tejun
