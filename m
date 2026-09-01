Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26928370AE5
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 08:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250924; cv=none; b=KENiesKb0G4VBM9iDEMYoNu+nScy0ZQXu6/x3QDkxkHgLu77vjSaDVZE4EpkPpgefNaPD7kttZCIMnA6EEyJVDiRq8kSfdPQ6OqwIsVuEDB8RSUk06Hys+SOtTUe9A311nynyAweZW+GV219DZeAOJ8hJOOvUgO040mKknBXX14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250924; c=relaxed/simple;
	bh=q2ef4aVgRZ0IRRYARvgwN/BgJu11vID21E9V5Gms9O4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=myxo5lCfoNxWW+uGr7fRFReyn+M4LR62XcEHTvqNIA/A1zLrVHp4eaHq3KFca7pvq7ubEzyXTkYselFjYKHbTl7tAdCElnomRvyDxyGGIbhrHNgi2d+LtEkG4Jy/sEEI48PUFJyDCtK5e8+ixnzptQSNGVtrxM15MLLpZj3S0SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6b12ae7394cso820084eaf.1
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 01:22:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250922; x=1788855722;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Fxsg3tyZFfDboYC1KLQNAGrb0RmxM442yXMbJyS8HSI=;
        b=MLoZgEptPAG87I/duKkMH3BoU5kuqlqXZqKko6XCeKUOmzrnR3bYVOGnvc0jJWMvkc
         +Out8SptO+9XVKwEYZB4xFc/wf6eoFsut4YuBup/vBZvU+uljYvTPMvgBgrr6jeWqrCs
         AFwze/igxAVoV/KyyxtptL33yawjFRvm3FMWqgek+KJfU6tUy0/JX8Ed9PzZdGArY90k
         q9ymWRF2KWgmtpr6aglpIwPOKRFS8zgwDqcU1UyWJ6xkncKO6GC2H81NHNeucIuSgKdo
         HpdSbebzp92IDgVDlIzkt+QTBQ5ZGBHX3DJO89qQXctV8TQfd8dPDVGRYr2v+R4nbBcC
         pGeQ==
X-Forwarded-Encrypted: i=1; AHgh+RogjQ/BiTAoR4RW8tVvvjiLN1KDEjbgtM9UUYZzg6pnO3HNrveOMsWYXBf083Iab7cY/NZY1/j8@vger.kernel.org
X-Gm-Message-State: AFuF++l9pQ5ssPQbGIWAX9lMBNVDpkOflHjUNmb2/O4V1sxx1OzBxelU
	yRzyKTNePRTCeWj5QI3CPlX4FZIP94taFDLxfJHubf4jVcLh3L3q6X9n7R2oVuFjhSOA0RJzDcf
	aw4NvILBu/kYzUUrC04bTRqtPgsamQLjXHzzR5uZx1eXTFAubfYkPsheDEDE=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:7049:b0:6b1:a812:9871 with SMTP id
 006d021491bc7-6b1c66855d6mr31267352eaf.18.1788250922028; Tue, 01 Sep 2026
 01:22:02 -0700 (PDT)
Date: Tue, 01 Sep 2026 01:22:02 -0700
In-Reply-To: <20260901014303.417027-1-junjie.cao@intel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a968b2a.08473e0e.15b4ac.0000.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in exit_to_user_mode_loop
From: syzbot <syzbot+2642f347f7309b4880dc@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, davem@davemloft.net, 
	edumazet@google.com, hannes@cmpxchg.org, hdanton@sina.com, horms@kernel.org, 
	jackmanb@google.com, jhs@mojatatu.com, jiri@resnulli.us, junjie.cao@intel.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, mhocko@suse.com, muchun.song@linux.dev, 
	netdev@vger.kernel.org, pabeni@redhat.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, vinicius.gomes@intel.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+2642f347f7309b4880dc@syzkaller.appspotmail.com
Tested-by: syzbot+2642f347f7309b4880dc@syzkaller.appspotmail.com

Tested on:

commit:         abdf623d Merge tag 'wq-for-7.3-rc1-fixes' of git://git..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=123d1379580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9cc692b98d9b4fdb
dashboard link: https://syzkaller.appspot.com/bug?extid=2642f347f7309b4880dc
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16f7eb79580000

Note: testing is done by a robot and is best-effort only.
