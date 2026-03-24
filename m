Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC8A2F851;
	Tue, 24 Mar 2026 20:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774383887; cv=none; b=iCWTwTx2YHgYkHxStRedri1QrfVuEVfFs9d7jcwrvPe01vWmiZq7zMN26R2ZiPtSJsW4GkK3Rf5xY+jWowFwaahfn2l/YpLUY4BisWiM82qU53EvQkkGxduVM+p3tCyLQ6fFwtgViu9UfmuKiUZpXa7Ql0xsD0WYEn8ngae3qpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774383887; c=relaxed/simple;
	bh=VmaD37WXPGQSvuLKFT2fUj0oK545HtswXhwSFdPLL0Y=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=RtTcJI4wY+hncOloxfhQfOa3tdREHZleJ4XAtMFzD23I0/Mm1mcsgEGryEXeyM04ebdrdxcMRNUmOc++n3FTSSMXM979UOIFUq6dHoz9hSummoiRa23MMNejnypNxj9Rwr/FhjjhvxDRH3Kc5x+StPLQD18oT7OJS75Ay/gCiZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q27bvadm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q27bvadm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD81C19424;
	Tue, 24 Mar 2026 20:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774383886;
	bh=VmaD37WXPGQSvuLKFT2fUj0oK545HtswXhwSFdPLL0Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Q27bvadm9GzPvu7ILSMzZTKETNMWtYzz7B7V8fcgdJkdkYQFNz82Ul2I96b3GrpVA
	 dTH4ixzjVVobuZDzep52okqXRhAphweaPRKGDnqUc6Yuq/ZSJZsD97KuwE1ja9GQq2
	 NstQ0y7RjHxfLWXQA+9s9TZiPk3RQ5hk3GddWOHUWcJsU3vxbk03w11budhExtHAId
	 MY4otC+aDuk5IRt3cVqloFdWluwoNhO+ZILrwia6bF/fXPQ3YaBCznH7JFIW9TN4aW
	 1KprZUKhQNabw38zj0y7yJypkkX3w3eI27ISA9YzJ9QoyFmfMAHgC69UPUv0LMp5eH
	 /OfVfzlB6KIBQ==
Date: Tue, 24 Mar 2026 10:24:45 -1000
Message-ID: <3ef922c6cca93c9dc6f928394c416d57@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Bert Karwatzki <spasswolf@web.de>,
 Michal Koutny <mkoutny@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v2] cgroup: Wait for dying tasks to leave on rmdir
In-Reply-To: <20260323200205.1063629-1-tj@kernel.org>
References: <20260323200205.1063629-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.0-fixes.

Thanks.

-- 
tejun
