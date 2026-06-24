Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0242C8834;
	Wed, 24 Jun 2026 22:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782340448; cv=none; b=uSycMPV38YLsTDRxd5ysISHuV2YDCK8fDeMrA4nZ8j1NUqPOFPgSFQhNLXrfPnJ71sF8TSpujg6LmVRwTa3zSairDLXLVyr5zcbmeFQQiCwMS+o8pKPraV0siB94QoO0NfvaoCNHldJYHoGru02eiIWNuurx4o7SlOWl8Xkdk+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782340448; c=relaxed/simple;
	bh=jii3cJiVzwMrZB4rB2WKhpoWQtBuM+AjGlyEzg1nA6M=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=dvqjtMoNtvXV4LGWQxYSlc7lc32CWlM8W6qQ2z+YTWZO1eObstyYDHTvQItJLZdE9ir4QE9NtziVkRnOgxiY2RL/GWDs19Hpw5OGw4Lbe8mdduLRUxQOSEC0beAJ1LtGpsJDX30FpxdOPKxE0B7jDRww7PgNsPfBD4Ab0DTuumI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGR132xp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGR132xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2C01F000E9;
	Wed, 24 Jun 2026 22:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782340447;
	bh=jii3cJiVzwMrZB4rB2WKhpoWQtBuM+AjGlyEzg1nA6M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KGR132xp4zKrvrBYJBccPaNSdBiSD0Bs6OC0/6nmN8DFF5KhKV62NFad/GK3gwRa4
	 Q/jURN8ktJGPK2feIYHxp5IlKZgx+cj2o85I99MxnECh1M7Slw3cYMl5r6l/9sityk
	 3r/cM8cSkQnrMeHQ9NvNisLq2WL/SnDBGH4Gh1yhHoTVmPF8EeVpYL0Rpy+jMYL5te
	 GZsp3yMsaVu4dQOfewsFNFw54830FLoHSQ5N/tK6UzhQm1oqTJkjLQNtg0CL0VwL6Y
	 PphDxGJdsGfUbvuE1i6oJDUC5TIXb0mTdIhYAHT3+nJCRACK7Q7UzgwXocNmZPB1qu
	 FLaSelRUQuEkA==
Date: Wed, 24 Jun 2026 12:34:06 -1000
Message-ID: <cf1e52e639fc595ddd5b1bc7cd8dcdf7@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: syzbot+bb2e19a1190a556c01b1@syzkaller.appspotmail.com
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	mkoutny@suse.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [cgroups?] INFO: task hung in cgroup_subtree_control_write (2)
In-Reply-To: <6a2fb248.8812e0fc.3c3fa4.001a.GAE@google.com>
References: <6a23a4b4.e4db5ad2.3b7dfb.0000.GAE@google.com> <6a2fb248.8812e0fc.3c3fa4.001a.GAE@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

I tried to reproduce this locally with the syz reproducer on a matching
PREEMPT_RT + KASAN build and could not trigger it, including looping the
minimized reproducer with the matched controller set and high concurrency
over many VM-hours.

Thanks.
--
tejun
