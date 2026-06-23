Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795CD3ACA41;
	Tue, 23 Jun 2026 20:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782247521; cv=none; b=cbanH0DdqHBDMJT4f/KgvFrP1JMzDI7iJiy2CJ7QxQb2BrVssMZeqR9MCkfOVEuF6+XCVZqGhl6sDmfU3Y5GHhPf1MGX935yVkj9V7O1yHxWPiLlC6YbXufWM3UBMJgN7F7fARpMa6jPMADXB8GVampqEhOxtQiYnA4dggqYoH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782247521; c=relaxed/simple;
	bh=TgQ193mZwAfjhmDQmgpjU7n1cGp4ogtA85u6FxjWLRI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KNOmSwb0+G1DWbJkvOu0xyqbt+ELi5mjV6GBGaSuAseJ3ZtW0jPl3o00SuNxurCF+dg8H+ZVkQJkNAIFEbSnVzQ6J0cCIOwlP1CxWxzjFwWc3ChP7+086TAI17CvOM/hcEw0vKmlbZ3l3l+NHE9QgdNeIEcN9+SMpcv6qI/wFCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6vpCIpH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6vpCIpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00501F000E9;
	Tue, 23 Jun 2026 20:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782247520;
	bh=HeB7xZnuDs/TEcIKXn5nTk2Jy0itlcqx7vzVd0ZePtI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=C6vpCIpHcDCGe6ZMcJJEP0+Nz3+p6knyFyKDQZGz+NjKRDoZ9qk1Ti0o8I+agBJkZ
	 UFoH6JHRau1Hr1o4NWUKNtke+olSavbfY/S21PiOWPcJIoBa4zL1vrFFLaQMr1EAZE
	 /+8GyCioZL7Sjrmp1y3pVJCPxUp4fdhS7fh5uHeV8XOG9HFjdMohaLr4VnYS6oM4eh
	 Lh5+jZ+43F6Oa2JJ2lUEyP0QOl+AniJnA0YsCw27hlgWR24Fn3Nm84An4Xdg1mgJl8
	 GqTHcX4qpjrYhhkvY1ECCBJgWdcD9dXTVyr3FCr+bWMrIEWOJtcrmV1bRwQclDesIg
	 IAVXt+CPJuY3w==
From: Thomas Gleixner <tglx@kernel.org>
To: Jing Wu <realwujing@gmail.com>
Cc: Jing Wu <realwujing@gmail.com>, Waiman Long <longman@redhat.com>,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 cgroups@vger.kernel.org, Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v3 08/13] genirq: Add explicit housekeeping callback for
 managed IRQ migration
In-Reply-To: <20260623043641.2391662-1-realwujing@gmail.com>
References: <87cxxnegqa.ffs@fw13>
 <20260623043641.2391662-1-realwujing@gmail.com>
Date: Tue, 23 Jun 2026 22:45:17 +0200
Message-ID: <87fr2dkmua.ffs@fw13>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Jun 23 2026 at 12:36, Jing Wu wrote:
> On Thu, Jun 18 2026 at 22:27, Thomas Gleixner wrote:
> That said, I fully accept the architectural feedback: the on-the-fly
> subsystem modification approach in v3 is wrong, and v4 should use the
> CPU hotplug machinery.
>
> We are open to coordinating with Waiman on a unified approach that
> covers both use cases. Before starting v4, two questions:
>
>   1. Is the "no boot parameter required" use case worth pursuing
>      independently, or should it be folded into Waiman's series?

Sort it out with him.

>   2. For the hotplug path: is CPU-by-CPU offline/online the expected
>      mechanism, given that you rejected the cpuhp_offline_cb() bulk
>      approach in Waiman's v1?

I think so. It makes the most sense.
