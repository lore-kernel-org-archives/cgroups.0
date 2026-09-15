Received: from mail-oo2-f40.google.com (mail-oo2-f40.google.com [74.125.231.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885D04A8FFF
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 15:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487492; cv=pass; b=J6NVAq93KtqUoxI8cYU5HcT/VagcAg+L9IXCqRb81z4H0hP3G3vNF7NKOoXVjDv5roVR2Xjyr8F43t85rtyHsZBt0DZZttSovv9LvSylF2FJ+w64z/IKmsgczu2B3Hw3T1w09xtENQzusjA5RNx8C756wBWJ+wmoTKAZuZuzb1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487492; c=relaxed/simple;
	bh=ZE3WRf6jwHm44maoVxf+MmYa5OvKeyvnM3vE38UytZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VIM/ZWa7GzalGb3eYySEYYBTiDwF+sSUn9AFWLsfV79SMZdI6rBniY5n65xHkHZTmmHTbV9i6Qq0xcKA7HAZKpjkvaLj0qRstOb9OnKJba3skuEvS43iI7QmXiaf2m4bjXr/OulaG2fhzKE0Ie15vp0z5SSFdVl5K4aVv3TF8yY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gukKkM8d; arc=pass smtp.client-ip=74.125.231.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gukKkM8d"
Received: by mail-oo2-f40.google.com with SMTP id 46e09a7af769-80199394f52so382653a34.3
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 08:51:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789487489; cv=none;
        d=google.com; s=arc-20260327;
        b=bmd29a2mJNzexizRLiV7sTmJYFS3OTucbwlAUIuHTF3ayijbvG4xVirodCBd1YaciD
         IFx/F7LWK0BnZ59ID0hbtcgjAzaGApm9cgOw9In/BxDaOB6VP3A/gB6rloQ3CCpLHpw5
         OpE7/IQpnvs9hAzJK1lh9qCHyo4O+1989D1r+4oIFmTOH03mz/CMKZ5ovzkznUgOPV2P
         nAoEeZJpMMvyEbO6g/fzrq9lxKJ1iqNfYJe6zZBsWYD0w1NszjNCKBHROoX1Pau0wg41
         nXRInDomoHsbOI4XaMm6ShWi1kHSY2gWQhJm3iBR3qcob/8Om3Sl+kjSGlbbMuBB1ek/
         /Ziw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qLaU8Sheaee7OVZT67w7SriDUMjtz6t3Qx6H6/8vnfk=;
        fh=3Ye59s8XEWq8JuzlJb8Hfej6jvEjzHyHvioO3lVagTM=;
        b=aw+rfgMV6fqXdDCbjTvRVtN5+9Hx2zzH0hbwSLCXC3xOEmO+BmdGZAHjuow5nYFGKF
         y6lea/A5m59teVImUf7nDbpYjJ7REKK7LFRMS36IoG9x3/xUmrJTGNF5bfhPJv+psind
         coSXSwmSBYQyFxUhZt6lAFiZ2Xlk2tf8K/E1F5vLyaQrh6kivvd+GPk/j7NB5dqP5SSk
         JeEFLSIrC3urfqXq4YYWoTlJE3doE7/G4o2My602KILjeTmTpqCRt6sHAuhFR+dczbNC
         /7L/FiZg290CbqDBSr+Oxtab1FKIIIcYedHC6qDBFrWCke9UJIBjgzY/wQGppixae5ST
         bmHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789487489; x=1790092289; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qLaU8Sheaee7OVZT67w7SriDUMjtz6t3Qx6H6/8vnfk=;
        b=gukKkM8dVT4AU2K/S8a4Z5A1bLCxSmtuqOEAgZQ3pT9iobLe2mE4M+UVgfbY3jeooU
         0GwrpRLAs6h926sYYQgpdbSFAm6jn8VsovNqvoyOozxGwYjnJ6E3USmXtLGOqp9GflhN
         9SniHcESMVFD7ZkWz4KaNBypefe+tsZ/jwkJtAvkFD+ZTN8Vlknczzb0rdDY5rryMXOo
         trGXafboZlVTqMVrYZbpqohHrsvc6gh/0i0SoFQVAM+A0zjZ5+OjuvxsufT6QsBdZ55I
         pBpdUarEWkkkUgF9LZfgzVTaACTxXDC4gmUkXepOnNkTEUhQqcHRWCnk+Ac9iui044K3
         dksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789487489; x=1790092289;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qLaU8Sheaee7OVZT67w7SriDUMjtz6t3Qx6H6/8vnfk=;
        b=PzodlV4lVslMaxH8yfU1+U0VZ2fUu/51n/V90yXOvX2Rk2NsfEKKf/Rov9492dMZjB
         vSxPXzX4VYKNAb8iK7D7yTn/hccsEbxfZP+YWEZTPn9Vbxsd6pH00MID7PWuoDeDnftQ
         MHS7fXIyAgBPo3cwe2lD4OFsaO59rUo/Y5FM3mEg1bDO8yRqMyCaF80xj2+kkvKhOq27
         nDN+MgY+zPKDSimxTXEiammGoaNXUvb9Kx5ww5CmQoEHq1faLgKEy9ay6QaczF2RuZXh
         bgPYqoGWHwU0qFKH6kf48HLFWPzO4QwNEa+zhHaE64X6r1I9XCTKWpOarUYrQwXuYVFq
         Za7Q==
X-Forwarded-Encrypted: i=1; AKwUvBzp3y949a+F0Q/IGhTtCJdvgSjbf/evefYnxB+xQk6ev5oQQM9nkEMPblVuZuNCeDsQWHBuTGck@vger.kernel.org
X-Gm-Message-State: AFuF++nFSJBhFr9zXZVFQVzeHVqZsbA9RMjQQk/Ge+kZO4AZzDqYOWf3
	axrLcgUH7N4ooh/WaJ5JdJErbgi98SRlvcGOb2gRm4gE4kVXLsH2Y3Cu+fURe5NiXZzCIf1Jog9
	gc/MizkF3Awk+CN1uEtWJB22quecR6B8cudgwddl/
X-Gm-Gg: AYBFou13FmjrGfM7hrdYiCkF8KREQ+GcvbW51g0BiGoih4im5mG/y/izsqKREtLebTg
	kXMaG28x9uo7T0ogDorpBB3WxCxfUNKA/BHm+q88zlP/HL1gkZ6mfSnU2F7wqxR4mBimei64+KE
	bijievg6kgf+NNV4tS/oY6i7+Bvc06JO1LXbX2gjbHgbp+m39y1sXLkavUpkGoFnTpIElW8Hd5x
	EbM1HvpY6lu1pbQlAEK7Ek9LMCM/vs9UV2mhfLdYNf1aSk68+T/DJ5/JxtD4M/Si0Ui75okx+ud
	rfVJ0Wcft+lyPGVzxhSa+DIKuGisKZlCnyyztyhQsW+YHiez7hSTTyN2AW5LA5dWyXJEMx0/HJY
	GlDVlIaBWAM25p6kku5zTFRisc+ThJMpcTqW/zfZU5spybPrg+oM3EJG06BpK9AGqv2S4
X-Received: by 2002:a05:6820:f036:b0:6c1:d6a4:9268 with SMTP id
 006d021491bc7-6c737b1ca30mr1441282eaf.5.1789487488174; Tue, 15 Sep 2026
 08:51:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAL8qZ1bxzBXReej7M-20HkBwON9L6NZKZP96bs7s-e=j-_Gg8w@mail.gmail.com>
In-Reply-To: <CAL8qZ1bxzBXReej7M-20HkBwON9L6NZKZP96bs7s-e=j-_Gg8w@mail.gmail.com>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 15 Sep 2026 08:51:15 -0700
X-Gm-Features: AcwNN1VZxjUbgSRdsZo-3wXq8QiVHvk8HaQExXuqbOILOADwb7TrgLSgG0x2RqI
Message-ID: <CAAVpQUBWtdDe4dS5Sd6mETpxVdmvSrnQkBdfK=NKgoWzTJUomw@mail.gmail.com>
Subject: Re: Subject: TCP receive memory accounting before accept() with
 cgroup v2
To: Cyclinder Kuo <kuocyclinder@gmail.com>
Cc: netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	shakeel.butt@linux.dev, edumazet@google.com, roman.gushchin@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 2:08=E2=80=AFAM Cyclinder Kuo <kuocyclinder@gmail.c=
om> wrote:
>
> Hi,
>
> "Resending in plain text; the previous message was rejected by netdev
> because it contained an HTML part."
>
> While looking into whether Kubernetes can allow net.core.somaxconn
> by default on cgroup v2 nodes [1], I tested how receive memory is
> accounted for connections waiting in the accept queue.
>
> I understand that d752a4986532 ("net: memcg: late association of sock
> to memcg") deliberately moved memcg association to accept() time.
> The discussion also explicitly covered data queued before accept()
> and charging that memory when the socket is accepted [2].
>
> My question is about memory containment before that happens:
> if an application delays accept() indefinitely, how should the
> receive memory of those pending connections be constrained by the
> service's memcg?

AFAIU, this cannot be constrained by memcg, and you need to
configure some knobs (somaxconn, tcp_rmem, rmem_max)  to
define a sane threshold per connection.

https://lore.kernel.org/netdev/20250707213900.1543248-2-edumazet@google.com=
/


>
> Test setup
> ----------
>
> - Ubuntu 24.04, kernel 6.8.0-53-generic
> - Kubernetes v1.35.0, cgroup v2
> - Server container and Pod cgroups: memory.max =3D 512 MiB
> - Private network namespace, somaxconn =3D 65535
> - Server calls listen(65535), initially without calling accept()
> - Client runs on a different node
>
> The server container was privileged to set somaxconn in its own
> network namespace. The host's somaxconn remained unchanged.
>
> The client established 256 TCP connections, then sent 64 KiB on
> each connection, for a total of 16 MiB. The server subsequently
> accepted all 256 connections without reading any data.
>
> Results
> -------
>
> Phase                                     Pending accepts   Total TCP
>   Container           memcg
>                                                accepts
> Recv-Q       memory.current  sock
> Baseline                                 0
> 0                 8.49 MiB             0
> Connected, no payload          256                        0
>      8.49 MiB             0
> Payload, before accept          256                        16 MiB
>   8.49 MiB             0
> After accept, no reads            0                            16 MiB
>       33.82 MiB          25 MiB
>
> I used ss in the server's network namespace to observe the pending
> accept count and the established sockets' receive queues. I also
> read memory.current and memory.stat in both the container and its
> parent Pod cgroup. Both reported sock=3D0 before accept(), and
> 25 MiB after accept().
>
> The data was already queued on the server, but its receive memory
> was only charged to the server's memcg when accept() was called.
>
> I did not exceed memory.max or test memory exhaustion, so this
> does not demonstrate a node OOM or an absence of other network
> memory limits.
>
> Current implementation
> ----------------------
>
> I also inspected upstream v7.2, although I have not repeated the
> runtime test on that kernel.
>
> sk_clone() still sets newsk->sk_memcg to NULL, with the comment
> "sk->sk_memcg will be populated at accept() time" [3].
> __inet_accept() then calls mem_cgroup_sk_alloc() and
> __sk_charge() [4].
>
> I also found the discussion explaining why simply inheriting the
> listener's sk_memcg is insufficient, particularly when a listener
> is created in the root cgroup and passed to a process in another
> cgroup [5].
>
> Questions
> ---------
>
> Is the pre-accept accounting gap an intentional limitation of
> memcg socket accounting?

I think so.


>
> Has temporarily charging pending connections to the listener's
> memcg, then reconciling ownership at accept(), been considered?

Not sure, maybe Shakeel knows, but I think it would severely degrade
scalability, and the change may surprise current deployments via OOM.


> I realize this would need to handle different listener/accepter
> cgroups and the root-cgroup listener case.
>
> If that is not a suitable approach, is there another mechanism
> that should bound this memory on a per-service or per-memcg basis?
>
> For the Kubernetes change, we are holding off on treating
> somaxconn as safe based solely on cgroup v2 until we understand
> this better. Pointers to previous discussions would be appreciated.
>
> [1] https://github.com/kubernetes/kubernetes/issues/134194
> [2] https://lore.kernel.org/all/20200222010456.40635-1-shakeelb@google.co=
m/T/
> [3] https://github.com/torvalds/linux/blob/v7.2/net/core/sock.c#L2542-L25=
47
> [4] https://github.com/torvalds/linux/blob/v7.2/net/ipv4/af_inet.c#L761-L=
766
> [5] https://lore.kernel.org/all/CAAVpQUDUULCrcTP4AQ31B5bfo-+dtw3H8CQGq9_S=
Q7d28xXSvA@mail.gmail.com/
>
> Thanks,
> Qifeng Guo
