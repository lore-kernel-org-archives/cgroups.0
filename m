Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB908455626
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 20:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788466079; cv=none; b=QvSyATcgFv2h0ntv5/L3hYp9OhzXrOn9RUdGRExi/1D7oTRMo1zgi5DXtGNISjga1uuiMDZ06cQ2uq1PH7osbPevsk4X3ht2PkecJKeYu1USesYXDkdQvCjjP4537ulCn+q8Zpsb4IDQ+mCk8mhFTu663g/NW9jH/hWmEcXABdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788466079; c=relaxed/simple;
	bh=KKQRjTnbbi03SF4QrsbxyQRZEuOt84yDjPrhPIt1HPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oh7eaJy8tCXlUUwLCldajOXBfDpQbIfvsG8uMlLzfar21G6aSoDwiXQrNpG6Sc3gm5hcH7ynuKSueOUiQDFVNfvpeagIEZV05vs2/DXpL4tj+dKPzFUPPK2vKMvoAavcXg6IpxmAdblQEL/nKJW/VzDZ4A8PgcSaZSFklfyO8uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ls+YW+pf; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ls+YW+pf"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-482dbe4d247so170378f8f.2
        for <cgroups@vger.kernel.org>; Thu, 03 Sep 2026 13:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788466064; x=1789070864; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e7urBqs1yQ/qOhZ2GYLJeqmnou9jkoySIxXngdzIimQ=;
        b=ls+YW+pfZ7GyxdxELlYWV95YEIKJN5IsFaDyIWkbtjYroz62MWSP4hqE3CQYoBM0nQ
         B5uzSCrZvAffTcfDw1Ie8NXseYvD0hB/k4Gh60o1aUFjKc0483+fSVWqimENRKQ6RyPq
         t55YwzBFCd0IdylZP7lJzR1ZjgpiQY3tSsUQZ2mWXFebRYKFFz/N6/HDAaipGM2O+ysu
         jn4vHjINlcCK/ks8IGvqNAIJjMeWxV1RXaSv3YVhjm+BxLnoB5mt3wvL32HdR3p181+A
         xA8zCgWyAH051FpD/JybJIprfmNjBuu6CVv4Z5s6HMN/lnKNGu98Km90rV4Zn4U5W0YV
         0vgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788466064; x=1789070864;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e7urBqs1yQ/qOhZ2GYLJeqmnou9jkoySIxXngdzIimQ=;
        b=nhfnY9MM8jDkg8u6RjXf2GQLlLBMNNL2T+5Jf9JRMatJRQNmdam8MaDN3Uq7lUIn5u
         YkK6Y8zaSJ0W/YYOJHgejTF4x+R9zhH7NzBjsEyr3tX/E08Dv0nA+sidwbWgM0ZTTUXs
         SNliuvC0cpf50T5Hy9slDWI+62hshRkTNPFk9TYoJ2zNJyRY+XFMagwbvK7ZZx4kKT4S
         SGt3mI6C7xZwgqkPVoG1U9UG/vkdhDm+friodeBXfR7dx6PXxY+cydMrlaRpr3glZ3sN
         xq+QjV4YoMsWzDSb4R4zcdhnraobyctmQu8DCyhF9SmLyYLgerIvf3SvTCcsv/Tv6niV
         4sIA==
X-Forwarded-Encrypted: i=1; AKwUvByKfqGs7ccK6Fa1DYVVFQEoiaQygdS/Ru3fnjf+Nf94wtKaQ7oLYai4pcgijxkcsAuFyD+Zx1zX@vger.kernel.org
X-Gm-Message-State: AFuF++kkufyBGtdlQLi7azwNIIM/H43O00EyEgYa0BZ+kUNy3iBSv3Ed
	vdZnsBzMDQK0kSbVr2/SExrvQHeHzHLzMX7ijUwZyFTunXn5y+6WPEM1
X-Gm-Gg: AYBFou0J99P3lb0VLoq3VO8ThlczvqoWkTppxeomNiETzggN/x5A+6Iriozfg9Impux
	toiA8weHmoIdiPGibxErLF0oXGnkk4ehtozmvi8gEJIpNDiCPzzwH2JzqldUpnLTHy5FNYr6Fgb
	wTkE3mAFz6/HyWULtgeQdKUIIjpmxjGIRvhBVcfei4TBnq4oba21FBxymJ4kQnFlVG5loBHAqNq
	bhvOLgQWR0sYOPYdr4GVknfKzSLxpDPd6yhUf1qCQhgyiP6Jq3s9zHDqmpTLGEsMKTtYFzIJ4Tq
	W2pqywFpYGLM2ww+nYxtYdjg1rK6AITahsnS+2q1d25vZJJk99/oa1HEFcYB6FvU695VILuW8Vr
	7ibRFhmkTuG6CtLNnKBSxPfmmLDapUb6J8YXBszRZBW54/3+nBVbltN1TVrstXAC2u3dncz+h8z
	6h1GF/hGNLHylsnnPE5maEuLvDiI9zwSeTjbFKysdtVhHr5SXGCR8sTpNAaG+s5BHjzSGN/vVtQ
	qYtWe5dKuy10NWZqK3jgW4=
X-Received: by 2002:a05:600c:3b01:b0:49b:4d64:bbc4 with SMTP id 5b1f17b1804b1-49cf81f1592mr4839615e9.8.1788466064353;
        Thu, 03 Sep 2026 13:07:44 -0700 (PDT)
Received: from eldamar.lan (c-82-192-247-196.customer.ggaweb.ch. [82.192.247.196])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce58d1c9esm68315165e9.0.2026.09.03.13.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 13:07:43 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id A8CE3BE2DE0; Thu, 03 Sep 2026 22:07:41 +0200 (CEST)
Date: Thu, 3 Sep 2026 22:07:41 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Dan Schatzberg <dschatzberg@meta.com>,
	Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
	Noah Elias Feldt <N.Feldt@mittwald.de>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] cgroup: Avoid iteration of dying tasks with zero refcount
Message-ID: <apnTjQvt_FbQfm_r@eldamar.lan>
References: <20260902161653.1051794-1-mkoutny@suse.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260902161653.1051794-1-mkoutny@suse.com>

Hi Michal,

On Wed, Sep 02, 2026 at 06:16:52PM +0200, Michal Koutný wrote:
> The commit 260fbcb92bbea ("cgroup: Move dying_tasks cleanup from
> cgroup_task_release() to cgroup_task_free()") extended the lifetime of
> tasks on the dying_tasks list.
> The iterators have provision to go through dying_tasks because of
> dying threadgroup leaders or explicit CSS_TASK_ITER_WITH_DEAD, however,
> it was expected that such tasks can obtain a new reference (that is
> possible before cgroup_task_release()/put_task_struct_rcu_user()).
> The tasks after cgroup_task_release() and before cgroup_task_free()
> are subject to race when they may or may not have usage count > 0.
> The iterator should not attempt to resurrect tasks whose usage count
> dropped to zero. (When that happens, __put_task_struct_rcu_cb() is
> already imminent and the returned task_struct would could be used
> after free.)
> 
> As a band-aid, filter tasks returned from css_task_iter_next() only to
> those that have positive usage count (whose reference's lifetime can be
> extended).
> 
> Rough illustration of the possible race
> 
>   R (reader of cgroup.procs)         T (thread)                       L (group leader)
>   ---------------------------------  -------------------------------- --------------------------------
>                                                                       L exits, signal->live > 0
>                                                                       cgroup_task_dead(L)
>                                                                         css_set_skip_task_iters() // skips only cset->tasks
>                                                                         list_add_tail(&L->cg_list, &cset->dying_tasks)
>   css_task_iter_next()
>     take css_set_lock
>     css_task_iter_advance()
>       leader && signal->live != 0
>       => it->task_pos = &L->cg_list
>                                      T exits
>                                      --signal->live == 0
>                                      release_task(T)
>                                        cgroup_task_release(T)
>                                        release_task(L) // zap_leader
>                                          cgroup_task_release(L)
>                                          put_task_struct_rcu_user(L)
>                                          ...RCU...
>                                          put_task_struct(L)
>                                            L->usage = 0
>                                            /* L still on dying_tasks */
>                                            ...RCU...
>                                            __put_task_struct(L)
>     it->task_pos = &L->cg_list
>     get_task_struct(L)
>       => addition on 0
>     drop css_set_lock
>                                            cgroup_task_free(L)
>                                              css_set_skip_task_iters() // dying skip comes too late
>                                            free_task(L)
>   cgroup_procs_show()
>     task_pid_vnr(L)
> 
> cgroup_task_release() is not synced via css_set_lock hence the race
> possibility. (I'm not 100% convinced about this LLM-assisted
> interleaving, multiple css_task_iter_next() calls may be involved with
> css_set_lock released.)
> 
> Fixes: 260fbcb92bbea ("cgroup: Move dying_tasks cleanup from cgroup_task_release() to cgroup_task_free()")
> Cc: stable@vger.kernel.org # v6.19+
> Link: https://lists.debian.org/debian-kernel/2026/08/msg00220.html
> Reported-by: Noah Elias Feldt <N.Feldt@mittwald.de>
> Reported-by: Salvatore Bonaccorso <carnil@debian.org>
> Signed-off-by: Michal Koutný <mkoutny@suse.com>
> ---
>  kernel/cgroup/cgroup.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Salvatore,
> I was able to trigger the issue with your reproducer on 7.1.8
> (occassionally, not always). With the patch on top of v7.3-rc1, I cannot
> reproduce it (different base though). If you can confirm that in your
> env, it'd be good.

I tested it with the additional poc which Noah did sent to us (not
public) and with your patch it survives. 

Tested-by: Salvatore Bonaccorso <carnil@debian.org>

Regards,
Salvatore
