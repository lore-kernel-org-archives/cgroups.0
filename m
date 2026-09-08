Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F3E383C94;
	Tue,  8 Sep 2026 19:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788896148; cv=none; b=SZDiNwhsSfwWnR6m9GsR01QeTxKOsKvHddMwTcFiY8VPJKx0OpbQUQBftOpj/sQOm5VDQBbExNzW3pcD6NbmcVY/H3xY7XJmh5behgB1MnL9YWHHt7B47dfQBTMh8w7FBgFHWXWuNtZ0lBY5AQwFxhxcvM9dM79xIHH58Gs3Tsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788896148; c=relaxed/simple;
	bh=puNaSsoRPzUyzqrSVl9WhQZ9fpPfxDMXsDboVPuqzus=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gYIUFe3EKfxznBWqOAz7CiOrtofUsCUgm+G3/ghySy+DE1FPRvua6A0rFqkFEZb/WjXME5ePXAundGv4yBmWB/1xpSDVPCyC4YSYUBHAyXOxP9d12Bv9vGdhOTAJqqXqAlrL3n9SKOZn+ZXneuKao8dO0AJGpUxkFS/pEbpyGm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOPhH+F+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOPhH+F+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203D31F00A3A;
	Tue,  8 Sep 2026 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788896146;
	bh=WolyzUd157bE++kDXNHMj9hUMxfHm8ex+v0MBUpJpBw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SOPhH+F+vW60uwBQWX+EzBSIH5s5WG9Z+Ht/Xq5ZDDGq1NcXdDQyjV180d6q0JWi1
	 Kuc3mDQuRCoRRI0WtMlgBkH50auRqR0ZrESuoUnf4CHQtfVpCJ5usAyWGAgn3RPfD3
	 xEdrNiIKx88ps27HGKuztT1r505Pl1sd47y1dcx/FLgHytQLsXDJeYcADN/ivyzMEr
	 ANBPU3VQ1kf2z8NST+b2kwiRJ+i2WOGHvi0qTMGqdy5idtnkyzz2izIUKvs7OKXuaT
	 nglBZRszvJyuKz+3BU3fwtB/iKpsDrCCrwwf6RcnCFdNLYbP3fOP9s1s8xUtSpKctK
	 4JkDAmftF7Caw==
Date: Tue, 08 Sep 2026 09:35:45 -1000
Message-ID: <3247fc048b011380e5374c32c4ac6af1@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+bb2e19a1190a556c01b1@syzkaller.appspotmail.com,
 Tao Yu <tao1.yu@intel.com>, Tejun Heo <tj@kernel.org>
Subject:
 Re: [PATCHSET cgroup/for-7.4] cgroup: Make the offline drain interruptible
In-Reply-To: <20260902230313.530839-1-tj@kernel.org>
References: <20260902230313.530839-1-tj@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello,

Applied 1-3 to cgroup/for-7.4.

Thanks.

-- 
tejun
