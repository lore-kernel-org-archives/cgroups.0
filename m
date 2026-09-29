Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A4737F32C
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790689685; cv=none; b=hVzc1bYOPcjzRPNk/j8MytBQC9WYVE0sKEpvSwcBVbyKlCbkjAhYvWaVgA4OL7jzoysij/CxQNmffx7zOSjEgKgn1Pd8XIati57uKKRmCjcvzABtdNib0j9Yr8VT/v4k85DOnJc8bmFM9qWImyTZJOTUHBrKZrMPKhs13Vj2NdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790689685; c=relaxed/simple;
	bh=kjgT10zxt//mFsH7+VNUVd3BXTk/uv6Q4vKSQsdNPzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FGVdCYJ1zpvhrGK4aBP2usLbLj/U6t9LlZi8l8jYx8nQq1wAriJ3f9eMMpcdgLrmT/IH4LWWf3njqX/uJjvrdGg1a20QnQmNtz6CUQJkINfUWze8uegOuwjQU2aa37vGxu2lOy6khean4x5IyCyQeBXmjP6WCK/RsdBv4+kgi2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LVfVys6S; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LVfVys6S"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4887840c529so1530142f8f.1
        for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 06:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790689682; x=1791294482; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qHLrFhBog0zePI2Kd8NF40LmUZLMJqPvBQK1I/mAWro=;
        b=LVfVys6SwHSgrU0A62mAMrxcE1nd6vp6KYCNK+++gQJIJvDxNc0jy2pwEmIj6mFbiy
         ZHh3PM3vmFtOSa4STgHOjZ6TMRVFyYXYxtoDA8OsI5cRNF4QOMGbaHa3wiKsi5k5Gpex
         7peES1HtjLJOHrqasCe52sH3csxjUpr/6lB6qggRNPM9ph/+daJ6I9/4QxAqmRNyp3No
         uAy08vkV9cREVELwhmfc8Jh9auZJFaAluSE/UosHYgtAlIPa8K0OpXgEGoQ0UDGFmCSZ
         VZOF854V/3soz8Li5X6aYT0BS1l6Th9FkT2a35ENTpVbGYcSLXjwtCTfMmIRJLEVTXNb
         KVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790689682; x=1791294482;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qHLrFhBog0zePI2Kd8NF40LmUZLMJqPvBQK1I/mAWro=;
        b=r70UgsWaCMW8ZqVlmccvMdOJ8VREg5KIHOlf9Bq2xDVVpgQ689Wu6Z0XVgWQkCW1to
         EAGkVnIxhaHK4tFpqa3tbqpzLqCxKX5mNt3ATIUuEI4tyn6UJYz7TN0IiQqLg3G30ct6
         aYELaDV08gRhGXA+vH3FwdUCa+sBtggLz1rVcANi0HhO/e9vLk1kt43LvKWCFt2/nVU2
         IhgaXpJa4zCFc19kAYoyc1CkNBf22c9qCS5dLcVoqaePMhBkKhts7+em28zB6lodui1u
         /yUpuyNhTp5glGAYAxY4tVxvbpL5TvVuyCViylD9MHdkmOYRSBku19IbNfUVmLc4SHg4
         f9+A==
X-Forwarded-Encrypted: i=1; AKwUvBy0Azh706dyMbZGO4MXTfAMx182DuXpeymSc7U/FHDpvXV4wdPs2hkWYODcmv1N8Ski+GlfT4A1@vger.kernel.org
X-Gm-Message-State: AFuF++nsarv7bVDXUiq5BCbg6ZYdwDxvArptg1812MjpVpBMstazRDyY
	e4Mkz++KklFK5mDYeWsOFwYDITjL8YnIeVpXQjiEmMKVPnlwAM2vlgnZJ0E1tDrHU/Y=
X-Gm-Gg: AYBFou2z7jRXLiNnq6lELO2JSoYR6zXwsn5UrQBYK6XyQF2yHH3LWYxiwmqvX2oxRWa
	MapAn6dJPKQhDx50qB+w8gH+R2jIquqtJdMIpWZg3G0yp+XxjLeQ+NfBLozAKTWQwvN9Mkcgjfs
	czXjKV0QQs3jyIBU/pLJgA9rc/cocT2IX3AAnr1yx7jdPA3UvyOdK/BgM/HEtpqgBqfdoxVCnfY
	RAGwBJHSiv5yibsfupRWaqTQyBpfI4LH3DTmG0jiB7kaDFscWKEPI2+eXUhZqudmJr/PvMT0yKb
	EOETpfYbVjtcHlEgOSnXmW+bX+7x3ZXw75WQNtNeCwvUvBsWJi50VlXEc59y07mwlxz9dbUqiv1
	lamUEyc9cPEwrl/2ai6KWPG7hWdUv9Id23RL7Wq2SVFKlUoDoANtNGCzTP5cZB9Vuut5gwJJmFw
	od0I+QWBO1mH5xCqbU0A01/sNRUzavaAgGh2s2VjiagjDjOJtaMMw4iGGviXzOOVh+dvDF85x8r
	g==
X-Received: by 2002:a05:600c:4e41:b0:49e:715d:95ca with SMTP id 5b1f17b1804b1-4a00d778ed3mr39485165e9.13.1790689682061;
        Tue, 29 Sep 2026 06:48:02 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a013d1ea8csm2107475e9.3.2026.09.29.06.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 06:48:01 -0700 (PDT)
Date: Tue, 29 Sep 2026 15:47:59 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Andrea Righi <arighi@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>, 
	Changwoo Min <changwoo@igalia.com>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, sched-ext@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Protect is_in_v2_mode() in
 cpuset_num_cpus()
Message-ID: <20260929-making-language-254d9c6a6605@there>
References: <20260929084124.626693-1-arighi@nvidia.com>
 <20260929084124.626693-2-arighi@nvidia.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6lhaepxnk64h7feb"
Content-Disposition: inline
In-Reply-To: <20260929084124.626693-2-arighi@nvidia.com>


--6lhaepxnk64h7feb
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/3] cgroup/cpuset: Protect is_in_v2_mode() in
 cpuset_num_cpus()
MIME-Version: 1.0

Hi.

On Tue, Sep 29, 2026 at 10:37:38AM +0200, Andrea Righi <arighi@nvidia.com> =
wrote:
> cpuset_num_cpus() enters its RCU read-side section only after checking
> is_in_v2_mode(). When cpuset is bound to a v1 hierarchy, is_in_v2_mode()
> dereferences cpuset_cgrp_subsys.root, which is freed via kfree_rcu()
> once that hierarchy is destroyed and cpuset is rebound to the default
> hierarchy. A preemptible caller outside RCU can therefore read the flags
> of a freed root.
>=20
> The only current caller, fair's group share calculation, runs under the
> rq lock with preemption disabled, so it can't hit this. However, the
> helper already means to protect itself with RCU, and upcoming sched_ext
> support exposes it to sleepable BPF programs.
>=20
> Take the RCU read lock before is_in_v2_mode() so that the whole lookup
> is protected regardless of the caller's context.

This feels like mere querying of the mode shouldn't require such
constraints (despite it's needed anyway later down). But it could truly
happen with the novel usage (CONFIG_CPUSET_V1 && unmounting cpuset
hierarchy for some reason, I wonder how you noticed :)).

Then I'd welcome more structured approach with at least:

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 3754d697854b3..7f4d346cfb119 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -841,7 +841,7 @@ struct cgroup_subsys {
        const char *legacy_name;

        /* link to parent, protected by cgroup_lock() */
-       struct cgroup_root *root;
+       struct cgroup_root __rcu *root;

        /* idr for css->id */
        struct idr css_idr;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 227d09704ca59..a718b5f521fb2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1909,7 +1909,7 @@ int rebind_subsystems(struct cgroup_root *dst_root, u=
32 ss_mask)
                /* rebind */
                RCU_INIT_POINTER(scgrp->subsys[ssid], NULL);
                rcu_assign_pointer(dcgrp->subsys[ssid], css);
-               ss->root =3D dst_root;
+               rcu_assign_pointer(ss->root, dst_root);

                spin_lock_irq(&css_set_lock);
                css->cgroup =3D dcgrp;


However, if I zoom out, I see that the intention of reading cpuset's
nr_cpus from the scheduler is meant for setups where cpuset tree ~ cpu
tree:

| * This only really works for cgroup-v2 where all the controllers are moun=
ted
| * in the same hierarchy. If not cgroup-v2 or no cpuset controller is
| * configured it reverts to num_online_cpus().

Hence it may be just OK to do:

        int nr =3D num_online_cpus();
        struct cpuset *cs;

-       if (is_in_v2_mode()) {
+       if (cpuset_v2()) {
                guard(rcu)();
                cs =3D css_cs(cgroup_e_css(cgrp, &cpuset_cgrp_subsys));
                if (cs)

I hope Waiman seconds this -- if a feature depends on shared tree,
there's only so much that 'cpuset_v2_mode' can guarantee.

0.02=E2=82=AC,
Michal

--6lhaepxnk64h7feb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCarvBixsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhCYAD/UlpdCXDtTYtj0WFClDJv
lcSGHrDz7cPvflRpgHq9W34A/3HJN+/1r08+MxQdyj9ADbQsdLu35KqSk0v2lodW
WDgP
=nGEQ
-----END PGP SIGNATURE-----

--6lhaepxnk64h7feb--
