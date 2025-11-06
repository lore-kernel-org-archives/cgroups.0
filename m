Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E6D2C237E;
	Thu,  6 Nov 2025 22:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467480; cv=none; b=rTAvBSfQXnPlrKUxrhvnRYa0rEp77MsvDTMc05gmHPDdy6nAsmtLyq2DJmG5af4BSqApimNSGLkORWLEmt/XO0aqWy7+6x/SGnN1c4uER/CiA3d/X/onRJ+b3l55zk1F8NCcJ/xa3H4A59ZWchvdGQ0QQcetdtYZipMSceWLTaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467480; c=relaxed/simple;
	bh=TKgkmuIjGpzoXdV/N04dl1nUJWvbygOAWmTO0UUcwmw=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=hzASmoSFdNMFeK2c78BoM7eEUlCdDKml/hIF3633s9S7PqzKbJiQFyqGLPWuC9YdlMbIATx+5RCixVbcTQXJc5mOyYNvysBTSb0ivQb5QRn93jy1wz43mWzWx5wH2nJXymJfG3vpQ8AflfQ5F+GT2fQLAxoG0nXGIniNoOyuEBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6wNmjjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6wNmjjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4D9C4CEFB;
	Thu,  6 Nov 2025 22:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762467479;
	bh=TKgkmuIjGpzoXdV/N04dl1nUJWvbygOAWmTO0UUcwmw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M6wNmjjO0YtNOk2/v8H0YNDI6KdWKSYnTwQeYa1KOKcYwb3KETAkFB2J+KYy1BUOu
	 BT1aaK21ifyI55HzGuqm+9xviVvuSROC0zai/Wgjm19t+P5huRKdWi8Gd6Gfxx+2XC
	 pCc2G/Ufp9wcnmXYCpNYARqAipMlq9mWH8JnwmMaQlmsfeJxGpB23GsYG0s3ZE073x
	 EWeyLHozUKqcxBvO+g0EaUP4G1CwDfBgzGG1drKopYNy+Tfy5Y1ia/Fm5RetuFZ8Fa
	 FhGfsHORj7R51JhEAKu7BOkrB4RNJwl3jbnMOVKqvu4TXtgSGyWDDB4ZaOkqDSrCVW
	 nL7NNQBH6dEBQ==
Date: Thu, 06 Nov 2025 12:17:58 -1000
Message-ID: <3039cded79ef28de7d684b659e7d5191@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutný <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH cgroup/for-6.18-fixes] cgroup: Skip showing PID 0 in cgroup.procs and cgroup.threads
In-Reply-To: <2016aece61b4da7ad86c6eca2dbcfd16@kernel.org>
References: <2016aece61b4da7ad86c6eca2dbcfd16@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-6.18-fixes.

Thanks.
--
tejun
