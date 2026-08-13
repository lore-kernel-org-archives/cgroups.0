Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219F74963B6;
	Thu, 13 Aug 2026 17:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786641030; cv=none; b=V5QL+UMSRkh2fS+SSfVzqmKSI0lXJ8IGtmScAV3ajtMS1sHUGjl5Z3j0WHfzMSYcyWvCVz1ywi7zZ2npSuyouPM1SJsmOHPhY/eMbF9aVxkL/2B3oDVVSfdcU7Ufe5hTqkfnhOtxH60T2zT9masa+FBD7uWchDC7gkeKW2BT47o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786641030; c=relaxed/simple;
	bh=AovqIHQqwVYs0zTuniHpmPmij/s519jnqC8QcN6eRkg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=EeSINYJL1c0YRiYykThOeSuETfEkxjvOyvPy9z3Z78HLE+Hx1kM9cNImagzVAoXAQ9HFIMk0Ri92YgR0SkiBddGE6EsRjOpC/Tn4v4fe3urehqiVZUXyReWPRN/Qoqb5PEuN2TityTKKm/XpCzGKXM3N4e8bPiXtylh5mQECjdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VZMs9BSL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZMs9BSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7904C1F000E9;
	Thu, 13 Aug 2026 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786641028;
	bh=AovqIHQqwVYs0zTuniHpmPmij/s519jnqC8QcN6eRkg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VZMs9BSLhqcJHv/n5/8VFzJq4NFzFRSkUm8gOz5tKm2NQRT+zV238NjX+Lw5XqJKr
	 2/6vHcVgvHOLjizE2yh75eToaV/jChcIiW1Wf7O9xFLCmVrqeeU+8I+3oZeREtosil
	 QPacW1QAY9z36wXhfIPg7nPRwB/uVOB9g5ZLgAXAFtjAVmOiogQQnw47xaeRRQ6+A0
	 +WVbletTnZTmPZN9tg9YxD72r8grCGi9oUbdsGR+qK3Nd6U86rpwEDPE5S5C+p4LFW
	 cTZd6ahpwN5cOhULuEcqBHM5lGdmRl7vOxLjah7fyrfrJa3HIrok2DdPrqJEhvSIJP
	 nHuuZ3NO4Selw==
Date: Thu, 13 Aug 2026 07:10:27 -1000
Message-ID: <0ce5924ac519d20fdd0af60e2a775396@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Rui Qi <qirui.001@bytedance.com>
Cc: linux-cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, lizefan.x@bytedance.com,
	longman@redhat.com, shuah@kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: Preserve CPU hotplug write errors
In-Reply-To: <20260813132807.1160861-1-qirui.001@bytedance.com>
References: <20260809082111.3827531-3-qirui.001@bytedance.com>
	<20260813132807.1160861-1-qirui.001@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.3.

Thanks.

--
tejun
