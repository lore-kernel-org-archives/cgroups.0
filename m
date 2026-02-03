Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8C43A1E60
	for <cgroups@vger.kernel.org>; Tue,  3 Feb 2026 14:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770128209; cv=none; b=jsZ8HvjXIdD2xwyEYMFeuTC+3H0t7yk5myINUHHMY9efFXV+FUKPuzmaS7P9+jlKKdz0MUn1LW+3P8AuENw+KtO8UZnSdnucgdcSTnEA4gZDjpkN42pZhk+NMZ4Kn1euM5SHWA80PoVypwRRLAq+EtizA4zFP6OWptIgldADSg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770128209; c=relaxed/simple;
	bh=/8AxLODon1dXJN5bmJReCIQSMiZZtx0ZY8XTK2Nzshs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ol8eUhBtG6jj0dssCSK7GDLY8FmG9g7StcnZ9GL+vsMTImYap1oaxnQBLvfUB+A47fz2GCy3yoUe4An2b/p23++MkX47A3q7/1RSB3d/cyhumZg7QpunzcpOfuSmJ6pWjlEJRyV3q6kFpKUu80fKa1B6uXQ1Fo3/cnQ5683gYyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PcG1pqvc; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PcG1pqvc"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4806b43beb6so41731565e9.3
        for <cgroups@vger.kernel.org>; Tue, 03 Feb 2026 06:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770128206; x=1770733006; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ID8QrMDweWZ/fIr/Kd9rCSwycKGCPJRwbxZfV8aqlY=;
        b=PcG1pqvcq3EihGWOtnuBK5lyITufEXcOd/wlSWMJIOs8esMNQL1MoEmxqVezthODp5
         HUQN6bV2smaiGL3oiY49zg/wyZTf3XiFhd+iBNIPEK3Ul7fivmL9E5KR9x42kPh46a/n
         Qu4msneb7WhOm8oyJO3wF00B9bP7IBB2UyjkpEtPiFjUN4cJoHwwxs0INv8P3a9OAnct
         hiAW41kvWk9lJv9o4KtLgOJ53O/mf7EkPZoec9ZXm0GpXEYisHDY1L/juCjS6uNps5p0
         rAslJWK1twzA1QPz6bTRKR3MsQpBIqk32P9C828UUuCTEmdyJfwH32bJECTLaYcWkbje
         Km4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770128206; x=1770733006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ID8QrMDweWZ/fIr/Kd9rCSwycKGCPJRwbxZfV8aqlY=;
        b=xOFaWqOMvEV5IyPo/ChIiunGFhQngy1wnEYuk6GH8U95kN9OCcWKkVERpNLs5SWdpw
         JwmMJJH0v+XOrHqgQEl3434aa48PuprPbH4GcPzD1JfYF+x80ZHN98NZFi+ByepwrcPe
         LyI55HzhakOSBem2qPHazBj0PtqNgPbWy9iNxzOtsCNF910VD6j+1Gs6k7mpzkxiNwRh
         HU8PFUGX5jW7EkEk6vum/FH2U5+NKmDrc0mFetQgpnePg2htLd3/UY90+VBWiu7/dz0s
         5era2JEQXcpwewFCRcdjr/4i6rEZHIq/olZWsot4UexQ7uJSStYlQLsqtQ+WHMX/Mv30
         7qhw==
X-Forwarded-Encrypted: i=1; AJvYcCWNt/Bn0OjcRWM435ywf9TSGaNrJvw9zrNmOKmrx0rb+6hq6fRnxnH0jJFrHpnY70YPJXIw5YYW@vger.kernel.org
X-Gm-Message-State: AOJu0YwDYFpiy9zdQOs/8iM4926mYr18QqaYvIdN+x+bf6kW1DeiFtqg
	9HUtmx36ALrHKpIivVS8uZ66R16WObaJmB59mcnMKNctwLRc4vIn134Gma0mPoQ1wIg=
X-Gm-Gg: AZuq6aIHuFbgmNl+uo5356a1m+sh9PwaYpQmm5dWOb/h5PpfhWR4O66kQOrKW0zXZwT
	gtn3lOjL+zQGLz+eLLzcGpntjkhmuhPVhIfPdxeIYgSd3WSVBljzWvBLDZW00rBTEk9WWrRADZ1
	ruU3E006zRDp/k3+YXMuRlegq9x8MzcxjNHbnLvCY/KOF829nxuERCl0YLNxCKNjtsNKP/vukB9
	gRxyH0a6wdXETv3GvlCTyEGqBgF9qF3WnX2CS9OVRDOdI4ZlP1TMW8cRhYt5C2cgYJN5YNTVz1q
	dnImN8w6oZJnUGaQFCmNsPxCXcPV+J57Up9TB1mQgZ/xeWmtZSozxqgiVSnXZb8rD/NRjYeIyGf
	mHs6QyMblIOxPc0XC8+59k+JOZR9JQT93i1k91sXNr64PT5P8lDvZ1h85rXh8lP7VfdHhwLreKH
	wmMJWOHNWpOx7rRVpyq6rk4FSNmnAFkJzJixjOIOh4wA==
X-Received: by 2002:a05:600c:4fd5:b0:477:a219:cdb7 with SMTP id 5b1f17b1804b1-482db213bc7mr207307515e9.0.1770128205951;
        Tue, 03 Feb 2026 06:16:45 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4830511cc93sm77479295e9.2.2026.02.03.06.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 06:16:45 -0800 (PST)
Date: Tue, 3 Feb 2026 15:16:43 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: =?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>, 
	syzkaller@googlegroups.com, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, 
	cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yukuai@fnnas.com
Subject: Re: [Kernel Bug] KASAN: slab-use-after-free Read in
 __blkcg_rstat_flush
Message-ID: <74zggmy53vzdb2q7sidvasnnlih5d5b4rp6jb6ibpka5zg7z7x@enl7iqw4prji>
References: <CAHPqNmwT9oRpem3J3erS_W0uSQND47LGGSBsNxP8E6uSUish1w@mail.gmail.com>
 <aYFlZf9p4cY0rIbc@fedora>
 <ffzrfu62npwacsl3225qqyjbhd6oue3x3rt46l2wcyp5oq4eli@26gvvst6hrmu>
 <aYHXzyRJbzFSohNm@fedora>
 <l55sz3sgogoyniecolvzscjamxqrxlzgk7w7scds3tt42z6atj@nrfvjqg2agib>
 <aYIBR6eeudRUQ9q8@fedora>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="czdjhrhidmglbtjn"
Content-Disposition: inline
In-Reply-To: <aYIBR6eeudRUQ9q8@fedora>


--czdjhrhidmglbtjn
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Kernel Bug] KASAN: slab-use-after-free Read in
 __blkcg_rstat_flush
MIME-Version: 1.0

On Tue, Feb 03, 2026 at 10:08:07PM +0800, Ming Lei <ming.lei@redhat.com> wrote:
> I can't parse your question, here blkg_release() simply needs to flush
> all stats. Why do you talk about preventing new flush? why is it related
> with this UAF?

What prevents this fix:

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -169,14 +169,6 @@ static void __blkg_release(struct rcu_head *rcu)
 #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
        WARN_ON(!bio_list_empty(&blkg->async_bios));
 #endif
-       /*
-        * Flush all the non-empty percpu lockless lists before releasing
-        * us, given these stat belongs to us.
-        *
-        * blkg_stat_lock is for serializing blkg stat update
-        */
-       for_each_possible_cpu(cpu)
-               __blkcg_rstat_flush(blkcg, cpu);

        /* release the blkcg and parent blkg refs this blkg has been holding */
        css_put(&blkg->blkcg->css);
@@ -195,6 +187,15 @@ static void blkg_release(struct percpu_ref *ref)
 {
        struct blkcg_gq *blkg = container_of(ref, struct blkcg_gq, refcnt);

+       /*
+        * Flush all the non-empty percpu lockless lists before releasing
+        * us, given these stat belongs to us.
+        *
+        * blkg_stat_lock is for serializing blkg stat update
+        */
+       for_each_possible_cpu(cpu)
+               __blkcg_rstat_flush(blkcg, cpu);
+
        call_rcu(&blkg->rcu_head, __blkg_release);
 }

--czdjhrhidmglbtjn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaYIDRxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+Aj+dgEA0cidUUMyuxGYzXMVhB4c
GuMLXVmDCaXI2MkrAu9fnrgA/ix6Pj9MOlUwhhBGeilNbf3LyFe5dTTzN3ds/83C
JIAJ
=HP1U
-----END PGP SIGNATURE-----

--czdjhrhidmglbtjn--
