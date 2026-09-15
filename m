Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298773A1A55
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 09:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789463289; cv=pass; b=W/MXjcyq6iMqO9pgXz/ofEuLE5qw6DxYFCjzTKZYUoDLOJ06el2bthHU4+JzJA8JaW+mggERbBOjtCB6WNdcPN1LF79kYCB4jfjsnEswsk+AEN5evJdmLImJ94kG9YjQf5leXauBAdo0ILevPA4IrFXvwfGIlO4KPBDKAYJDq5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789463289; c=relaxed/simple;
	bh=YhxPKw+0F370XaAgA0d55WGySacBzLz8rZGCOhUWrTQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=X0ffU8zz4okUfbGs9r4cb1EFLXGzyU3qA7XkqtNSC53G5cT9A2dY35fnJwubTNmnPM2hVwnVLQuSY3EL3zeOswbyWK/UCqNuHO+Nvq0W43CrICBG1m0viE8h3ySZ7Fm3jjF5rF75gnzpnHd+V+ItV85D4L0qnyNyhGMXMyNDc2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEvFEbcL; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEvFEbcL"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab201ecso2702189d50.2
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 02:08:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789463287; cv=none;
        d=google.com; s=arc-20260327;
        b=exzPs0J7GlT/IvNsz1NRRjj5/jbNAZAqLtbKdRJYZrLJP3F/L6TvfNQQBTdCeQYEqr
         AEZm6TkZzC/rW/Bao7buRx3UqGXckMzsGSNcgC2xhziD5BPw6dUy9b0kzgrdm+50adZZ
         GObeZgXVgalra54Xjx6Krar/gPYAC0pPFID3LOSUVgUiaJrQEgWZYnY6WKMrko2xntYf
         y2iSElC1phZcW4WBumGUxakpadup0KbzC77JmmUmKlBz1+UaIHOLdk/ypbiSrxlwiils
         vP4DyIZWGEyPqHLwvXcDW7GyclTU3vcUNFY38KWbt8G/8aIz2DjLqqcgKLI6lwfw11aM
         pe/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Gu8o41I2XXzRYGs0+w6OrfrzhP1q+smJSphMsWAZ4Fg=;
        fh=zdqouoeU6k/zhjs0RsqWHYjwKVLjiG/NtS78oZg2wIQ=;
        b=YuDmj5tq+lpH/lCNLMiN0WtM0kd7DV7EkSZYB4d1MI0icjDsWxmemETqEB70k1OoY/
         hsQPtZeKyuWcIxdTLRzZnQr8ikkLJn5X1UAst8Lr8RNMqAjixD84I/sgisjuztHoqMM5
         IrzJyB71ZfWwOqORuTIAYtZg1IXmhH3JKTNqx5DRnBEkJgFFlH08EsIcgJAeeuktEPpH
         g2lPnX2mmn0aiWyFDmlLEp52SZvggVkRDAPgdHsCMB2yux7by3SGrgAbAjLhMaRkIw2o
         nUmMixk2R7GU9uDNvU9OOQsUVxoFTLq3oqqG3tLwxn8wfCnHYi+fdAb/ytYRoeCKP25k
         R/sA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789463287; x=1790068087; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gu8o41I2XXzRYGs0+w6OrfrzhP1q+smJSphMsWAZ4Fg=;
        b=YEvFEbcLWIsnob2/9wr685FW1dGze+2VREXNlBQybzf36JsG1h4CDQfuXJh/JZP6gc
         pyHdx/lB5lhPtBjkZp5IXHJq9+toAyxAaN9AvYBcJSKMqT7foJtb50nasP6/F4QV+LXf
         8JPw70YWYxi+oGy8h5379uJHXVxyb8pOCrR3D9tveMfwy42ku62mubvkEuwUmRpzF132
         SqVUg8/EvgMkAMjsr/5MRhUWRndKxHu8JVY/DflKnG6UrlIrf7JKSeNwBnyasmp1lzAv
         HJGQQJWKrF9AotNosfq/AYmXsYmU9j255NNLaz4XdSPx0Ch5GD+TIpHHmZClblmOX6zc
         L6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789463287; x=1790068087;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Gu8o41I2XXzRYGs0+w6OrfrzhP1q+smJSphMsWAZ4Fg=;
        b=SN5WgCtkDsJj/clAxaIgWtsfgFW6TXDQY5ncJ1Ee266/JH7ZQgOOo+CpQyY/vk1glJ
         c+g6DkkAdnaaYg6g+1uZZ9LGUWiJTv/sF5VHTmAy73gdSw9lA7l1UZ9QV+e3XoUVYZIp
         XfYR/Wwb7p8b79gVSOKSasaenUyS+bHIOi94SX2JHompVJYT16FTyDfV3o6NLGoywpw4
         x4JruBZRAjLJxqpfl1LB0GV3QvXgTUfvDxRKk3IlrU4CWburcV4sqF51rILEXnQhwzBc
         rga9gKotzXALr61hwCMT6neY5ck3USkEJHgOlBm16re8roavinRksXpjOtG0UMi5x9bx
         kPBg==
X-Forwarded-Encrypted: i=1; AKwUvBxji/CV/G1yA01aerIk+IPtqqbVQh5N93UFVOJStS3qGcEuRItdV9xgB0UzO13WdQgRfn1TDSEl@vger.kernel.org
X-Gm-Message-State: AFuF++nyvVfu1+pfN3iXIjVYnzrW9X+I7R7c+JQpMLWJPieRmJBfGqOz
	kUIrAUihJAY3hNC6F4aTC+Du9V2ObLjHRStI6DwfsQBafP8xF98GVl/rwfTuC5w2yn6YEkSPP3I
	jZEPRWaAEJiA8TckhvjyQfTA/sFMFlTE=
X-Gm-Gg: AYBFou118ckLAiwjsOhLrsJmKipQzzSuKq4x0OZqyZtQTLdHSveoL3+AJVrvLh+rUUz
	uYOAJ1TuzdE7RXSS0AvCgcGDIPXSlY0B8OG03RzluyN2QOTLwFeHFbQBufcjQ15aJzyeuJHE6iS
	nZhi6sVnuyd2UbRjl1OBZ9AluKk+IeQCAB//JqCMAH9nX2U3Jhseop6qD59xMukjmWDdXEj6tHs
	/X5swTLTzN7Rw6idOGFuhZQjaZRBlEe/s/b5lTBtmOewaM/Oup39IMkNiqbzCGNZtrnV6LcHRDB
	ESDIyL/ByaYefcamtgZWluYavEtqaQxWtyBXnwu0eMQ1H9PHgkTetZA=
X-Received: by 2002:a05:690e:e8e:b0:671:4b50:4628 with SMTP id
 956f58d0204a3-6714e1bbd88mr1691227d50.97.1789463286930; Tue, 15 Sep 2026
 02:08:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Cyclinder Kuo <kuocyclinder@gmail.com>
Date: Tue, 15 Sep 2026 17:07:55 +0800
X-Gm-Features: AcwNN1WKYt_LA1WL9vjWYb6kVe2gAIA0jbDKfrsHzKDJpkWLSstkxuDMf5Ww6rU
Message-ID: <CAL8qZ1bxzBXReej7M-20HkBwON9L6NZKZP96bs7s-e=j-_Gg8w@mail.gmail.com>
Subject: Subject: TCP receive memory accounting before accept() with cgroup v2
To: netdev@vger.kernel.org
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, shakeel.butt@linux.dev, 
	edumazet@google.com, roman.gushchin@linux.dev, kuniyu@google.com
Content-Type: text/plain; charset="UTF-8"

Hi,

"Resending in plain text; the previous message was rejected by netdev
because it contained an HTML part."

While looking into whether Kubernetes can allow net.core.somaxconn
by default on cgroup v2 nodes [1], I tested how receive memory is
accounted for connections waiting in the accept queue.

I understand that d752a4986532 ("net: memcg: late association of sock
to memcg") deliberately moved memcg association to accept() time.
The discussion also explicitly covered data queued before accept()
and charging that memory when the socket is accepted [2].

My question is about memory containment before that happens:
if an application delays accept() indefinitely, how should the
receive memory of those pending connections be constrained by the
service's memcg?

Test setup
----------

- Ubuntu 24.04, kernel 6.8.0-53-generic
- Kubernetes v1.35.0, cgroup v2
- Server container and Pod cgroups: memory.max = 512 MiB
- Private network namespace, somaxconn = 65535
- Server calls listen(65535), initially without calling accept()
- Client runs on a different node

The server container was privileged to set somaxconn in its own
network namespace. The host's somaxconn remained unchanged.

The client established 256 TCP connections, then sent 64 KiB on
each connection, for a total of 16 MiB. The server subsequently
accepted all 256 connections without reading any data.

Results
-------

Phase                                     Pending accepts   Total TCP
  Container           memcg
                                               accepts
Recv-Q       memory.current  sock
Baseline                                 0
0                 8.49 MiB             0
Connected, no payload          256                        0
     8.49 MiB             0
Payload, before accept          256                        16 MiB
  8.49 MiB             0
After accept, no reads            0                            16 MiB
      33.82 MiB          25 MiB

I used ss in the server's network namespace to observe the pending
accept count and the established sockets' receive queues. I also
read memory.current and memory.stat in both the container and its
parent Pod cgroup. Both reported sock=0 before accept(), and
25 MiB after accept().

The data was already queued on the server, but its receive memory
was only charged to the server's memcg when accept() was called.

I did not exceed memory.max or test memory exhaustion, so this
does not demonstrate a node OOM or an absence of other network
memory limits.

Current implementation
----------------------

I also inspected upstream v7.2, although I have not repeated the
runtime test on that kernel.

sk_clone() still sets newsk->sk_memcg to NULL, with the comment
"sk->sk_memcg will be populated at accept() time" [3].
__inet_accept() then calls mem_cgroup_sk_alloc() and
__sk_charge() [4].

I also found the discussion explaining why simply inheriting the
listener's sk_memcg is insufficient, particularly when a listener
is created in the root cgroup and passed to a process in another
cgroup [5].

Questions
---------

Is the pre-accept accounting gap an intentional limitation of
memcg socket accounting?

Has temporarily charging pending connections to the listener's
memcg, then reconciling ownership at accept(), been considered?
I realize this would need to handle different listener/accepter
cgroups and the root-cgroup listener case.

If that is not a suitable approach, is there another mechanism
that should bound this memory on a per-service or per-memcg basis?

For the Kubernetes change, we are holding off on treating
somaxconn as safe based solely on cgroup v2 until we understand
this better. Pointers to previous discussions would be appreciated.

[1] https://github.com/kubernetes/kubernetes/issues/134194
[2] https://lore.kernel.org/all/20200222010456.40635-1-shakeelb@google.com/T/
[3] https://github.com/torvalds/linux/blob/v7.2/net/core/sock.c#L2542-L2547
[4] https://github.com/torvalds/linux/blob/v7.2/net/ipv4/af_inet.c#L761-L766
[5] https://lore.kernel.org/all/CAAVpQUDUULCrcTP4AQ31B5bfo-+dtw3H8CQGq9_SQ7d28xXSvA@mail.gmail.com/

Thanks,
Qifeng Guo
