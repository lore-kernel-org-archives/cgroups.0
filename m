Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3713B1ED0;
	Wed,  9 Sep 2026 18:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788979429; cv=none; b=jC0Yrou5kAVR30M5VVMyi6+JDKu+ARqED6PBdD+T35Xw1lgm+bl7fjnupjsZiSQjiwmR/tVvzS/bAwopB8wI84V9Cd9pkKxS9ROCydjULYkU3zNfPHpwfY9o80ui4Fcbey9InemTGjzbuAlohP4VepKLFV6UK1W2piZnLG8IqBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788979429; c=relaxed/simple;
	bh=/ABAap94S+dePFPdwnvUg8PR0sbDbzMv42XkVKTqVR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GSh9QV1EG5RkPvRMtStRc+Av3UHqzuDvfyniq4TV9JvDR2LzZ8wNy75RyP+WNnzeaOvSHQdCCBhRkALqqUwVoRH1xnglautSlprMS5clAP4xO801hm2PgkdkbZIA8H+nKdrSjeX8TIdu/TrDTeqQSWEup38xpqe0kD5vjsq/XXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIdiZAtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIdiZAtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7D51F000FF;
	Wed,  9 Sep 2026 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788979428;
	bh=cBO086qLSBOOKWmDT9TG7Y9H6Td1it1Mgr5V18SRHdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIdiZAtBo2In6rb9LsXbLf3z6fGM/GGY+ucwjosNGwZEyFo7paekLwcwLMZvxRanG
	 PTthba8l7QoWRmJ1XhNegyKr4+BuBnWg3F8PA+E/mDPZ6zL0BEcHTRzLfeaSxDx+nc
	 dSh7Gq6eW7Q0Ph0fZXh16LXjwA+6tnXdYRhFEoq+sFonkP/erJa6/5Oy1sxkAIouI9
	 VzBzZQqqPv4iJ0c8UCphKKHG6grWAZwYgxQUiTiGlnC/ETnDe65nd7g2G4iDTzsDRU
	 RYHmTn4WXHivWkfSq/TTjwkVkFBaE4qTizAxuykJK/GpnqyB3floJER0UjRjl4UpDa
	 nyf/VTRgA6HJQ==
From: Tejun Heo <tj@kernel.org>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal =?utf-8?q?Koutn=C3=BD?= <mkoutny@suse.com>,
 Jiri Kosina <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 David Vernet <void@manifault.com>, Eduard Zingerman <eddyz87@gmail.com>,
 Viktor Malik <vmalik@redhat.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 JP Kobryn <inwardvessel@gmail.com>,
 Mykola Lysenko <mykolal@meta.com>, Nathan Chancellor <nathan@kernel.org>,
 kernel-team@meta.com, linux-kselftest@vger.kernel.org,
 cgroups@vger.kernel.org, linux-input@vger.kernel.org,
 sched-ext@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
 llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Emil Tsalapatis <emil@etsalapatis.com>
Subject: Re: [PATCH v4 1/4] selftests: add shared lib.bpf.mk to build BPF
 progs and skeletons
Date: Wed, 09 Sep 2026 08:26:33 -1000
Message-ID: <178897839380.2.8401342105193256410@kernel.org>
In-Reply-To: <20260908235552.2610256-2-ziyang.meme@gmail.com>
References: <20260908235552.2610256-1-ziyang.meme@gmail.com>
 <20260908235552.2610256-2-ziyang.meme@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Ziyang.

This is an AI review. The finding below was reproduced with a local BPF
build using the posted lib.bpf.mk.

On Tue, Sep 08, 2026 at 04:55:49PM -0700, Ziyang Men wrote:
> +$(lib_bpf_vmlinux_h): | $(lib_bpf_vmlinux_stamp) ;

Please make the stamp a normal prerequisite, keeping the empty recipe:

    $(lib_bpf_vmlinux_h): $(lib_bpf_vmlinux_stamp) ;

Changing a macro in a supplied VMLINUX_H updated vmlinux.h, but the same
build left the BPF object and skeleton unchanged. Disassembly still showed
the old constant. With the normal prerequisite, both rebuilt in one
invocation. Touching the input without changing its contents did not rebuild
either.

Thanks.

-- 
tejun
