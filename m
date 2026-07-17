Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0FF363C75;
	Fri, 17 Jul 2026 17:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784309028; cv=none; b=V9EAOFrv0tDGrEzPE/Av+PEuahezjwCyJfS4HQE2Mr7GfpFl/k3qMAzP2mwPixcLhsc3/vagspC4L78c+RJ4jHiqqyWLL7977GB8oYhTD4LDceQDqa+3/ZwmLGSOebXAQoYfa/7fE9bsLbSmRh883mYPiXJi8mgUfQH20gl46+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784309028; c=relaxed/simple;
	bh=tdWGKVVcgjaXdiXcargTpEHifitIC4OoPJEbZncmgCk=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=DwjCscV0lv2MkXSRb2YdTpKC1qtM+FOGQqkxjUmJZd4m4N5JSig/XX8HgZghs9/gY7DrJNtQL3R68Q1F8ntLorduAm5pAYIvdclIujP33JfrVbP84PLoP6Z13MTd7EQEmusdfpZkZzrnw4xQVaTxftsJhjQlMfRC29hYPk2T77I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2KK5/tK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2KK5/tK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE741F000E9;
	Fri, 17 Jul 2026 17:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309027;
	bh=IbA/BXXjvosDWLcMWG6krUDoHwzlCV+5Z92ydNxMS0k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=E2KK5/tKMDUjpNTKwbrhLR0NSIFsK9exBlUoTRhX8En+yLUTADCVCoTyRTCmSYdBD
	 awU8wIDEI/33iNEfqWBNIkimnHMWXcMaXOo/5pXBp3Taz9YZwoleWa+Ii0aTmeuWwc
	 am/hT9VHTpLo7HQzY5Tv44nEQyaaJfnl+t582HAjOseAbYDQdgGleY6+hsIOveVRne
	 I8c47X59KBUex4TnprXC4s1e1uVQ67mUE0ZuIec0Gv8m+Wo7ExlbKNaOCsouXsBxk/
	 YgDTT6GxWjZkGtIjU5PuHRmbCcArxdk0GfS/aOE0VBC62pwNI40vB8guTQ9xBBj2CF
	 wfJH6Py/oBR0w==
Date: Fri, 17 Jul 2026 07:23:46 -1000
Message-ID: <1fa5781a5ed080e7368e2bd121a4a5b4@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Jian Guo <guojian@kylinos.cn>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: Remove redundant cg_enter_current()
 call in test_core
In-Reply-To: <20260717110606.298368-1-guojian@kylinos.cn>
References: <20260717110606.298368-1-guojian@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.3 with Michal's ack and Tao's tested-by added.

Thanks.

-- 
tejun
