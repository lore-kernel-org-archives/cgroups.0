Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F803DA7D2
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 21:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786570928; cv=none; b=mdLTJ399x5ofm3ofC92QjzY1DYQpFtxw0Kgdkzxcxj6jLq8Tt9XcCoovd2VfA59hrqw9mNj+0hubV/s5Zwv/AR5AEWi2pptciuCSjAbz+xahUGs0oGZyryX4uvcQYBZDT8xs966x9Zz2Fe7Uy6SS+3xZFmn3e+6GTjeddhpzYNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786570928; c=relaxed/simple;
	bh=2F5NhUpezBCQsHKeIjnstp2S/raV+rcTxDfwPc9Xn34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unX+ZV4DifeaoJ5eZp6pUCvf8FJFbGIKOAotdjgbbp/0slPvqCbJ2MO0lBFVvYNCJHCVNu1MRrXaaTmdJvUG0Kb1GlimNsYJ1ruK6xANd198nuUWjz6iucd6SfXUQN/hLm9SktLeDLfJvgxw/PRRWbZlgMYPcb697Z7oRKlGKVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sAGLz20o; arc=none smtp.client-ip=95.215.58.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sAGLz20o"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2F5NhUpezBCQsHKeIjnstp2S/raV+rcTxDfwPc9Xn34=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786570924; v=1; x=1787175724;
 b=sAGLz20oujmdhnsRRK6qg2hMlCcTDv1U9jld1/2X50p3rVMtLUPzxDRYOvCwz7W0GKnndwV4
 yDpuqjVL6ydhs9jAEPd4GQuEXoH/Zqm0F6LNXa0MmLD2F+zubJJTNDP+HGlK9z7Fz2y9+mBc7fm
 ca5cRKcUueGhbPFMy1iKp1rI=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:48::)
	by smtp.migadu.com with ESMTPS id d28f7b4220e49d71;
	Wed, 12 Aug 2026 21:41:54 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 12 Aug 2026 14:41:49 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	cgroups@vger.kernel.org, david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, mhocko@suse.com, muchun.song@linux.dev, qi.zheng@linux.dev, 
	roman.gushchin@linux.dev, syzkaller-bugs@googlegroups.com, weixugc@google.com, 
	yuanchu@google.com
Subject: Re: [syzbot] [mm?] WARNING in set_mm_walk
Message-ID: <anzojtrifviGUjLN@linux.dev>
References: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
 <6a7c6670.3668565d.e8814.0012.GAE@google.com>
 <20260812140358.343927ad8d0955b67c4e7ad5@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812140358.343927ad8d0955b67c4e7ad5@linux-foundation.org>

On Wed, Aug 12, 2026 at 02:03:58PM -0700, Andrew Morton wrote:
> On Wed, 12 Aug 2026 05:26:24 -0700 syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com> wrote:
> 
> > syzbot has found a reproducer for the following issue on:
> > 
> > HEAD commit:    f5bbbfec59b4 Merge tag 'probes-fixes-v7.2-rc7' of git://gi..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11f44c79580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
> > dashboard link: https://syzkaller.appspot.com/bug?extid=12ee2725d5fde63a9c96
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d11149580000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > current_is_kswapd()
> > WARNING: mm/vmscan.c:3800 at set_mm_walk+0x210/0x270 mm/vmscan.c:3800, CPU#2: kswapd0/111
> 
> Thanks.  Shakeel is working on a series which will fix this by removing
> the calling code.  But it isn't a minor patch.
> 
> Shakeel, it would be good to have a backportable quick-fix to make this
> warning go away?
> 

Actually the first patch [1] of the series will fix this warning and we can
backport just that patch to the older stable kernels.

Do you want me to send that patch as a standalone?

[1] https://lore.kernel.org/all/20260811203203.3456029-2-shakeel.butt@linux.dev/
