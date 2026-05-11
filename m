Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69423C872B
	for <cgroups@vger.kernel.org>; Mon, 11 May 2026 08:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778488567; cv=none; b=H7lmQkfSgpbcLkGPXtT1PpLchWjm9RmS6R6dXYJ7ymAq8TS5ALiJfkgtr8DkNGLnoT8Q7dib0eY+wPnYR0ew5fE57Y47PlNZ8ip4PgE0soL2lXbj7vx+BsndWhLU+lS+LK0TvDso1EnIEsL8cJy2ivn9M81IQlZLnhVbyvkeXag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778488567; c=relaxed/simple;
	bh=/EBK9Za3dzKeST6xzL+uhXsqga85E68iUDnkuLoGL9Q=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=iFx8BvmxI7ZAvmOFRCvfR8BDrXMyKvAdj+20+P2VQ4PcUP7/HQwXIY+dLrrEdu9tq4UJbiopUun+/h33dDOMlHd4c/6FmLDuC+VegDQOINpJKk/A7Z3yHy9w894F33oxAHrezXraPIx0/xTJ7PZ8WAZ5Qv52lfejqOUsU5fLpsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHSosQNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHSosQNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1484DC2BCB0;
	Mon, 11 May 2026 08:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778488565;
	bh=/EBK9Za3dzKeST6xzL+uhXsqga85E68iUDnkuLoGL9Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EHSosQNWCAyeUiTyCCE3Q9c7AIySd6FQcEdzoIb9PTz3MQoRRuY7xmShz8a/escLC
	 9j6tWffwcqd/tPt2tHM3D/OUiu2PFl2z0SPHhW24xPgg+E+ao9+S7iDlRJGq7n9w05
	 x7E71p9/OzBKWokFFoQbLXPAwYbZmrzYN7Otvs3uETXb6tgGujGaCVGgGq+dqJBxcz
	 0cPr2RRbJUXXoApw0woGLzqTg6ytZxahyH7fFTu8vIyTDw312Mt2huarP52xMAuxIs
	 /RcNg6a1529dAEAO8T97n8oozgam4uukwcWmEQeE6/p5ZoSdDdCZoCpaafZa+F3s0I
	 m+7QYAEuV++Aw==
Date: Sun, 10 May 2026 22:36:04 -1000
Message-ID: <2d0dbeae9e3bfa4a5006964c38d2edda@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cuitao@kylinos.cn>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: fix misleading debug message
 in test_cgfreezer_time_child
In-Reply-To: <20260511062520.256160-1-cuitao@kylinos.cn>
References: <20260511062520.256160-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.2.

Thanks.

--
tejun
