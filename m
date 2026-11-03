Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717540;
	b=Bj9Phn9gAl3joL4euYqPZSjL3412eujJcqi6PRJmrUeU/WA+zvjodg75LZeN22VmqWb4
	 VWZdIo7xeJCbvgr1U6KElTP6eUZ4ONhMMvcfc5r1rcuPmyP5aElfhq+u0EcXp5olWwol9
	 5YujprU045WbPON2jsUrS6nIq32/8vDif3Fo4OU4v7n9R2prlfJcElXVSbk4Le1JxACJ9
	 gQ/aNR5rVdlG1wYZjGnzcT6/TBqdyxaezL1gDffLQGi1XnhWTf7qY6TG7OURTjfEkX6cr
	 HcPzMFpcKJcaj46+NCP0vjyKGFCubyLLZ593I6zH8MOD7sJWvqsjvAfR7Ta7AlmR9Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SXrZFm5c7Y9YEJYXHf63c7OvltqSiN79R5Fh6JHirao=;
	b=drXkNqBjg6eL+GamPdpqmwtxOXRRV6aB1sEyrX5KqFPCv5LO/evqyc7tBSLhwfXlAxnK
	 EVFOYaZtYzVQDkBfMP42DNgUErsq/NOoBchCuFx/N8PppUPTDDRLoKYTSCvsfbc7ZpZMv
	 5QWJj6Rtt2i/NM0Ywjx7Heu6fxU5sD6ujf98XNKogTAJv29+v4a+AQ++SpXVd/DDvq/v1
	 PWV8NqPI1O1bjPbtWx0gTQGklnluLlom3VVc3MyGbqsnjcAMU3cx5ZdBF9610WErvkryL
	 /h6i7Qc8lYYCmIVpiGVGOpdh7nt5QDIiZFUvCBAJA8b4YZK5hZ7h9w6tvOjUcsdysww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RWYySZfx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9A460A2611;
	Tue,  3 Nov 2026 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RWYySZfx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1121F00A16;
	Tue,  3 Nov 2026 14:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717539;
	bh=SXrZFm5c7Y9YEJYXHf63c7OvltqSiN79R5Fh6JHirao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWYySZfx0rRUBHS+D6mQrv70dNgBDuLHIhEJF/nZaakyJBbj16IsQUC/oHhhp+GL9
	 eDEiPZPHHZTInSBMx+M9V4sQyMUg5Aa1V1epiUXOfbz1vyR11VxHwAAtNvriqi8yM5
	 Getoowq88Rw6kMDDSYuGHHKqRlAqdEJLPOEuZHQMK6GSgWz0kRqbp8kvTVsuE1y0vd
	 mfyGRs/5LnLLdRw5S0lbZXvQturO85V2JjHTiIyqvcnDgz/HGODZIA53opgqDL3zSA
	 pVFmYtWkMNWSZsMZyXAh7q6jf43oTEbYSupvgYA0FRV4kz1Bmt/dibNEIktSQDz8xR
	 YPRAdrqElfHWw==
From: Sasha Levin <sashal@kernel.org>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com
Cc: Sasha Levin <sashal@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	=?utf-8?b?5b6Q5pmX57+U?= <xuhx@hust.edu.cn>
Subject: Re: cgroup: fork vs cgroup.procs write race in favordynmods mode -- v7.3 is affected; please make sure bf6fbf46b5ff reaches the stable trees (repro incl. uninstrumented natural hit)
Date: Tue,  3 Nov 2026 09:51:55 -0500
Message-ID: <2026-11-03-1-daily-reply-0007-re-cgroup-fork-procs-race@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3d753a39.1d66a.1a1a13d3452.Coremail.xuhx@hust.edu.cn>
References: <3d753a39.1d66a.1a1a13d3452.Coremail.xuhx@hust.edu.cn>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> This is fixed upstream by bf6fbf46b5ff ("cgroup: serialize migrations of newly
> forked processes", merged 2026-10-20, already tagged Cc: stable #
> 6.18+), which v7.3 predates.

Queued for 7.3 and 6.18, thanks.

-- 
Thanks,
Sasha
