Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBD83242BD
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787331574; cv=none; b=aAJXNpKUGNFsmED8ATqtPbEzntnXdipwQaN0xhKPAjc4jV2w1f+D111pEdz8u502k33+j5wn+wVdx87ij+28mu2n8+/8N4BKtTEb3/jItXT9GFAfE0nixVFUGxjS2SypGOryohYgHK8aYHAycxePuay9KPLKTYHjTxNDaJt6A7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787331574; c=relaxed/simple;
	bh=EsfepmfSMGtC33MRHAs4PmLvOsXAz+kfpxNfNQvy8FU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oAXFJZ9/X+6RyFnH3czilWz9p7yPaCN2Bt751huQ6Z8pnkcWfXtqkgJYdX5tEGhRiZfVrcPW5p4+Q8GrLX6+rkWWeKh0pIMGn6GQDrAnANCWXKsbav/EME/gPioHBQuj23CbMjT7FQJfIff91VFt/ciw7rzfgjqx6N4ksmHev4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F5xNC3RS; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F5xNC3RS"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15ca7a7ca9so147214666b.0
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 09:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787331569; x=1787936369; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xokLfb8L2ciLmaqOTXaVllobp4qCHV51wagGKoc3yqE=;
        b=F5xNC3RSrHsWv7Aw5nTkZym5AjECh3IEw6E0UIdRqEdR2ll0oqZlhgYI/fBtf01ZMn
         q6tUNGoajogKT24+/JajkwtsqG8tFj/wNPE+Jtet2jdHFAuFiuFDLNzszHqLbyC/gpMr
         QLFZGF3U2CH/FjQd4gklI9meS7uNTrCxbLvXJ5Nrr1TIqtIKP5bDU2Cafey5YeJR0BkW
         0+uFESkPLv6GAjQARfmmmG1zUDVfeTshku14MMjVUKXTG+4A68w9+YpJSrqhwLhv+8uE
         /fqmqRBBRUp3HXcn9ZAGSvYRyHGlHoO0CbYoaonXB7kBeL/p7BoUEdlPJSZauq/tikej
         61VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787331569; x=1787936369;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xokLfb8L2ciLmaqOTXaVllobp4qCHV51wagGKoc3yqE=;
        b=hphvYo7OaCcw8O2QAB7S0cHevgUeUfiNP+h6yNUCGsR9G/uZQMItrqp1WU54g39urm
         0GMuACw+MjITl39u1lqBaI7Xn4sy1taqoemFKVOGV/e3qxrsCIYKKAfyUiy7W5MhpMq1
         LKDPNDHg0eW5VttJcJJtfeggkT0G/BBbbdwO/wDNOs9ssUrXWZE6EGCBuB273qyGfACY
         fujw9ZFmhwUnMj65RBlAkCd7QZctx3dpfeCXLYCsT+DcVL5cxTnbOvBWYt4Ey38uUcYr
         BW9+ObmhAkV5g0upM4qNEph8hbsY+qBM1kKJAWULIoAAQU3WTyLJazDxxIkdKQGftkfX
         Jjsw==
X-Forwarded-Encrypted: i=1; AHgh+Rqulyo4IYzIUnS+k5hISincO7wlwlQ5498FSoNeurnizItrRIcuLNmy2oXLsGhC9Pma4MeQ3+W/@vger.kernel.org
X-Gm-Message-State: AFuF++lZ/8ytGYJtqMTgpYXg7m9LmSBzcxIpKaKRWMvs/7wzNtN4Z+7y
	l6rbdC/PKtaJRYYCpVDXtBHJT3vrG/bskhMGpq3wivwVFzdSgqN3GOmJuivi+Ra3jujd1bgZKei
	89yabTkY=
X-Gm-Gg: AR+sD12WwEpAMcQXwSUmASdK5K4660VouNaeKrmSzRGxJJYaJ9tCUOUB6O39RTI2UxR
	VhnENi0AymZ6rniRK71t5CrE5Nf/3NEp8ZApG9kmdQypTyYbK8fQommNECwY7zxmPiTOhfb62GL
	W7kqbcQWuGVL6xKFg3ujFXiSAfXfEjn3sXk3kh8PVucovD6Xc4iLIf1hCk+PkXZEfVuSEybQa3P
	iRueuDUjQ4zU4HqH3ckQkBjPBntLj4Xv/bleU7IWaYHhptnZWXqUmezUnxuoIr8l3W0xoU2rr55
	8/3OXnH6TpQ/sCVEO2MS+XbM/yat3R6vXr3hvASJytDAdNpAZv8HGvuLZ8qpyBj2WgSKuM6MqJd
	aeG3QUKO9Tx+6DMq4USJlD0eVbSLBjRBEBN+yg9nzK4ulXYklkncq9QSYbCBeJ6e/r4rWKlg3Uj
	B+Kzio/ngm0cxOofcDbOfYwhta57d1z1f+Wk74Cc/GoXyI5yf+4HTcxbvsptZUqQixtpWR5zpma
	Q==
X-Received: by 2002:a17:907:9602:b0:c1f:e9d9:64d4 with SMTP id a640c23a62f3a-c246a60c587mr751214166b.11.1787331569333;
        Fri, 21 Aug 2026 09:59:29 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff178289sm7713116a12.30.2026.08.21.09.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 09:59:28 -0700 (PDT)
Date: Fri, 21 Aug 2026 18:59:26 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Noah Elias Feldt <N.Feldt@mittwald.de>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Dan Schatzberg <dschatzberg@meta.com>, 
	Peter Zijlstra <peterz@infradead.org>, 1144314@bugs.debian.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: refcount_t: addition on 0; use-after-free, regression from
 260fbcb92bbe ("cgroup: Move dying_tasks cleanup from cgroup_task_release()
 to cgroup_task_free()")
Message-ID: <aoh7Kbt_WbUcfUxh@localhost.localdomain>
References: <FR6P281MB6118B1A758F3278BC9BA795AF0DB2@FR6P281MB6118.DEUP281.PROD.OUTLOOK.COM>
 <178682274912.1759826.11422695267451330087@eldamar.lan>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dtl76bd5brgzohej"
Content-Disposition: inline
In-Reply-To: <178682274912.1759826.11422695267451330087@eldamar.lan>


--dtl76bd5brgzohej
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: refcount_t: addition on 0; use-after-free, regression from
 260fbcb92bbe ("cgroup: Move dying_tasks cleanup from cgroup_task_release()
 to cgroup_task_free()")
MIME-Version: 1.0

Hi Salvatore,

thanks for the nice report and sorry for not so prompt response.

On Sat, Aug 15, 2026 at 09:41:14PM +0200, Salvatore Bonaccorso <carnil@debi=
an.org> wrote:
> With an additional reproducer provided by Noah, I could bisect the
> change down to=20

Good job.

>=20
> 	commit 260fbcb92bbeacfcd050410fdc2d24ab15044400
> 	Author: Tejun Heo <tj@kernel.org>
> 	Date:   Tue Oct 28 20:19:16 2025 -1000
>=20
> 	    cgroup: Move dying_tasks cleanup from cgroup_task_release() to cgrou=
p_task_free()
>=20
> 	    Currently, cgroup_task_exit() adds thread group leaders with live me=
mber
> 	    threads to their css_set's dying_tasks list (so cgroup.procs iterati=
on can
> 	    still see the leader), and cgroup_task_release() later removes them =
with
> 	    list_del_init(&task->cg_list).
>=20
> 	    An upcoming patch will defer the dying_tasks list addition, moving i=
t from
> 	    cgroup_task_exit() (called from do_exit()) to a new function called =
=66rom
> 	    finish_task_switch(). However, release_task() (which calls
> 	    cgroup_task_release()) can run either before or after finish_task_sw=
itch(),
> 	    creating a race where cgroup_task_release() might try to remove the =
task from
> 	    dying_tasks before or while it's being added.
>=20
> 	    Move the list_del_init() from cgroup_task_release() to cgroup_task_f=
ree() to
> 	    fix this race. cgroup_task_free() runs from __put_task_struct(), whi=
ch is
> 	    always after both paths, making the cleanup safe.
>=20
> 	    Cc: Dan Schatzberg <dschatzberg@meta.com>
> 	    Cc: Peter Zijlstra <peterz@infradead.org>
> 	    Signed-off-by: Tejun Heo <tj@kernel.org>
>=20
> But there was the suspect that the matching commit might be
> d245698d727a ("cgroup: Defer task cgroup unlink until after the task
> is done switching out").

I see that after 260fbcb92bbea ("cgroup: Move dying_tasks cleanup from
cgroup_task_release() to cgroup_task_free()") it may be possible that
tasks on the dying_tasks list may drop their ->usage to zero (since the
actual unlinking only happens in __put_task_struct).
Most often those would be skipped due to PF_EXITING except for the case
of thread group leaders (which the reproducer stresses) whose refcount
apparently can drop to zero after task->signal->live > 0 made them
iterable :-/

A band-aid fix could be to use tryget_task_struct() in
css_task_iter_next() (I got that hint from a LLM) and "skip" zeroed
tasks. I see that commit fbe3fb103596b ("sched_ext: Replace
tryget_task_struct() with get_task_struct()"), assumes the iterator
always succeeds in obtaining the task reference (which was the
justification of tryget removal). I expect that sched_ext should still
be fine if dying_tasks with zero references are skipped. (What are they?
Tasks which literally no one should be interested in and they're only
waiting for __put_task_struct_rcu_cb() to be called [*]).

(I'm calling that band-aid because it'd resurrect usage of
tryget_task_struct() and it keeps the dying_tasks list a weird place to
be. If anyone has a better idea?)

The commit d245698d727a ("cgroup: Defer task cgroup unlink until after
the task is done switching out") seems a reasonable separation of the
stages to me.

Regards,
Michal


[*] Except for io_uring_drop_tctx_refs() that calls __put_task_struct()
directly (no RCU) but I'd argue the same, that those should not be
possibly iterated.


--dtl76bd5brgzohej
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaoiD6hsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiB/QD/Qx0ZJRbpqviaym2eUhdy
AMfR99jU7RJJ+BnLU3zCy5oA/0JzSShj4XvDjSj7Pk9/fS4IW6CghDVOxoYWP5Od
1XkA
=22up
-----END PGP SIGNATURE-----

--dtl76bd5brgzohej--
