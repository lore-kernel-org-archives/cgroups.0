Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793897046;
	b=okD1jsd0Oj+R9moetYzPTJvHNt0xF35PDcbvib4+I3vXxfiFs0btpFOAMBTUnw4E/KLm
	 B9pWYX/JADSEPksSEXK0s01MUfnhU0nyDakZ6flcpi5sB+vrKhcvAVbTg9y7+SfqA+IMe
	 OhK2pZhh+mQMLucXOO8X6KZg0ssdrrV1r+Zn6w+I1HO6n61kAIf5Tnkb19HUCFaWRuU9O
	 G9dBxd0zkVcCL+MvavmVyhv4rwE80NJ3E04wBjihJmFJdMN9tRrH3pnjA6/LMsty3bmBV
	 Q/QN56SXsl6n8CDjNSziqcpmR1KqXHcEpme9xM45NSgs3eJJtbzP3tmqKFzPlurSRMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897046;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xa99gepi22SogAWQPeAgc0EROoR0OAvZegPBJ3DWXuQ=;
	b=hdZ9dK9zV7iVepTWjTK8/l1T90mWwByiJvScW10FsM5Ac8k5dDwMRCwzmn/fYk0M1z8m
	 rCo3MZaqmYd2T2P1yteY5894EOFTiRDNpWY/4kmvH7HtCNL/1o8EGlD7iD4tp3vDn6pko
	 idPs0eEiLM/CSySl4EpPRiioa83CapFzMD9hnCNO/7z7g9IAxbMfSUGgq85KKGxKCl2fv
	 hTWMGYAtapJLDWVx0MGktmMa5ll5C2Crnca6a7kU50UVkedvsmHqDmPN9yQ7Yf9b4+mr5
	 6REcDXVGs2nyeBvWwDx3ukZgPtGN/C0rsuHHurcAAqAtvgKWC5hRz2fPhcFrn7iYVFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x0a4hyuZ;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E0B606A332
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 16:44:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27E0B606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x0a4hyuZ
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c4649b35bso1766400f8f.3
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 08:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793897044; x=1794501844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xa99gepi22SogAWQPeAgc0EROoR0OAvZegPBJ3DWXuQ=;
        b=x0a4hyuZR9bNPDK9sTp8JRC5Ve2YkPdwkHoycWtq0ppzB1zEDNW19cJ21e3yDVmmEt
         KPk355x58nrqTShOgSKA4QiZgEwGa9DqNwh7dlSHDIMwx6CPOY6CMn+zsgGKeLwCuJmk
         WAVlMYcQXgsb9r5/E60ot47kzTDhL7fG5KDezw4ldukrLDqj3kW4FPsWAvMoRAeikQwL
         uLtK/ljaMtp51WBPY+FRO8VSTHxQuLwIdLN2x+lu5E0iCsWJOqdc6m0/Idj7X0lc37Ng
         lE+IgGKz8xuUF2Zg5zkcXL9Hue6rqEcCs6uixr6rLYCeHXlXxfcsMxkDpA+Kty/tDx60
         TyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793897044; x=1794501844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xa99gepi22SogAWQPeAgc0EROoR0OAvZegPBJ3DWXuQ=;
        b=Q1ENG71QpyEHaT0XoYvnVWYJnC2twJWCf9HPdPSdUI9zWuqs7GnP6l2l9Kwy1eg+jJ
         RtWoYx/mo7ePqIiPcP4IGXh7fmmmpFNgIrzYABhI7umzmZP5GvFVKPNqfix0KndTmJ5y
         8NJQ0AGhb0yQF0JBHCXzywDdoS6mBy55qp4HHv6DcdL38AS8XBgGDtz5F1032vRTXRxq
         KqvkKoEwm4FwcWtV/HP0bzpSnm/LXz3AZ5j31Yu5u/cLOEVhIQht57KKlOvgc9SAh24X
         9EfI9ANZSC16cbz+Y7FvaA3uTZLebQU84jDLJTf+q3ErdnZGglPdRashZjE3QJYHxEAV
         X23A==
X-Forwarded-Encrypted: i=1; AKwUvBypVq8nbt3NRAZisumWqdelRPhaPfeDGqVzn5JyWksntCw2dRA7TE63FdNXqF3MlPe+rHPv2gV0@vger.kernel.org
X-Gm-Message-State: APuU4Z8Qkxz2cpUlSEnB1fK1ap8BDq/sGZ7IhE/DrY9iZnieXv9Kv4w1
	nwGK9wqCPprWJYFTD1M543WNgxvwwBzgAVtIjoo6Yo8HHU/GGUTWnhzC
X-Gm-Gg: AYBFou3WI3RGB8JFIsbIJYUJ5PbcSie2jEYfhvtAuS5F8d4KTtLw4IYxRxQ3SL2k4dy
	ojjoZ+E3E3IincOYos2wUD7gnFeyfFJr0sNFf6mT7/9TpsgcFB35Lu0KkA4nVMTeatptsuHyJjq
	U6lrDfVym4YJbXut49911zgGXbjx2Ud7Fw0H9rBVxZpyIO67SwSxNmY5UaDcSWHQavDH/M2jAvx
	h2g/04ofG0U8XTiwPg/VG4tPe/HEk6ByNAPHCWgN8G4o12ffh1Ff9U6E44D08/OizzcgrDOz4ri
	zbhpDvceX5s8Nf+QWFCb8KZVWT2MBV5mmaESk5LkUBK0gpzi8s9YH5te9MTxPVBiJwFZN2E95pP
	76PGz/AcXX28GlUNVsujoavqTPbU2QRMXTtCwc7VUAYyW7HLwqUtP7f/gmcZoPmCaqdi+QxixZx
	LM3PsDNOpL7F8hmRPiDM2a2w4LFxxMVXcaIkJIYhIqOAXW1N0YYi4Uq9SSBxej3q6exAd8aiwWA
	jnNXyD+ebJblLyxcY46VohCGth+UhJVaR/glcNLCim5+EpMhIivM27Y04EqOSS5TJcVjAsQ4RtR
	RM3NaNeyk+oTpe+yeqdEsIYPEzvMNnTlCZ1cltt23X1e2MrKgnnHNcI051owreLC2+LTbXH+j2A
	KZ8upV34VZBWxY5ifHuIUsjL+LuqM
X-Received: by 2002:a5d:64c6:0:b0:48e:4e00:b737 with SMTP id ffacd0b85a97d-492775f151amr306112f8f.54.1793897044130;
        Thu, 05 Nov 2026 08:44:04 -0800 (PST)
Received: from andreayoga.localdomain ([151.43.242.194])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fea18104bsm11441519f8f.6.2026.11.05.08.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 08:44:03 -0800 (PST)
From: Andrea Parri <parri.andrea@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	linux-kernel@vger.kernel.org,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Kayra Cizmeci <kayracizmeci@gmail.com>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2 19/21] sched: Clear cpuset_locked where the policy check retries
Date: Thu,  5 Nov 2026 17:43:55 +0100
Message-ID: <20261105164356.28913-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104211207.1392343-20-mathieu.desnoyers@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com> <20261104211207.1392343-20-mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Nov 04, 2026 at 04:12:05PM -0500, Mathieu Desnoyers wrote:
> The retry of the policy check in __sched_setscheduler() drops
> cpuset_mutex and leaves cpuset_locked saying it is held:

[...]

> Clear the flag with the lock.
>
> Fixes: 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Hi Mathieu,

This is the same fix as [1], posted on Nov 2 and reviewed by Waiman,
Kayra and Juri.  If [1] goes in first, this patch can be dropped when
rebasing.

[1] https://lore.kernel.org/20261102134606.242743-1-parri.andrea@gmail.com/

Thanks,
  Andrea
