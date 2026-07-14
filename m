Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9683432B108;
	Tue, 14 Jul 2026 22:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784066978; cv=none; b=CFM+KO34MDttFpk2ogG6IbSXsNh8Tm+gZnVJr6jCMhaoWAsq91ckfdqUNQ6/QDTKZknZhg7n7HETklI25BwfTnHJaIuldD0VTM4W2aLfzrkUxeFnKslouG8dR9E9YrEAU6AyxwAOvL6bDGMnVq/Nc7UYJsaEkFuxgEddm0X82Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784066978; c=relaxed/simple;
	bh=B5uyfCIszmwjjq5v8/VeVww0Aill3CuVw8R8oe2lbH4=;
	h=Date:Message-ID:To:Cc:From:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U0FGGmpzq1uJPnwUoNx4hE45oDp8eoGSp70N44BfmqkPu+GL2NFdKXSb8JdiixJpRtuCavl6hTYvpH5QU1kXp5XCbhdf/O+hBxIPBQC6hNA+wFDfkz1/y9H5yoYchrN6Ehsda6EPEjkl1vzELmsYzSprm+0ISmPr91xnV95rNQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgUvvaPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgUvvaPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2687F1F00A3A;
	Tue, 14 Jul 2026 22:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784066977;
	bh=LFlgzQECQrDdonMFLsDXQtPgInSoiKKb4T41DNzYsQs=;
	h=Date:To:Cc:From:Subject:In-Reply-To:References;
	b=kgUvvaPk9+Cb2xz2LPxP5PBJ+qnwBudV88vGc9QCOMc3DIiwbct3wfpcGw1UDixas
	 iIN4n2OktWuTErfRBu8Oh8iRL8oWjnD3gvFVbBFeL1YY40mYX1upOZltE3ZhxHRuJV
	 8m4JKft07enHltFRWYNdrZwxcNzNIYtW0w24PtBDP7tT7Al3bgJTRis699ziipmxjO
	 I/lAOdqdcVx0J6YeOLPyz7hJEFQx+VrJvR1DZy2x8pAOccXVnEOtS6QC1MHgZxIuiG
	 /cX17EUF4qbrOgbgmoYxHxJ/yDuKFMWGldtbplm3srCYKxzhZe29DpIZ4uwl+kA/oe
	 VI4J3KbKSfDSA==
Date: Tue, 14 Jul 2026 12:09:36 -1000
Message-ID: <7e40318f1de2594c9aa53d2a2dc4324c@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org,
 muchun.song@linux.dev,
 osalvador@suse.de,
 david@kernel.org,
 hannes@cmpxchg.org,
 mhocko@kernel.org,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 mkoutny@suse.com,
 shuah@kernel.org,
 cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] selftests/cgroup: fix missing TAP output in test_hugetlb_memcg
In-Reply-To: <20260714021511.1063700-1-husong@kylinos.cn>
References: <20260714021511.1063700-1-husong@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello, Song.

Applied to cgroup/for-7.3.

Thanks.

-- 
tejun
