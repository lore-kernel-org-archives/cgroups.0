Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794498349;
	b=Gru+cIvp9AsASOOVxKGCwvCbW07nkRKvYynBt6r607LuJRnNAedtGvtTcUCK6K8c6X48
	 e/+IqrnC71gLUBEVfOKDpVrfIk5ZQSlGB8cTpowBbOonekaguELC3t6ULSFGg/7a5OIOv
	 G3krXwc1YdtxQ5zVbv/txSyGXrh37grO43BDqzxwKHNOa2V2pyobPTRaidc7NK6gO1igP
	 cSzC7J2xiqPE4CW8r+8K5QV+fM+qeryYXE1jNy0WvnRU2JgDvxnCmBUeuuXic8+1p++I5
	 Wnop+z0KqJu+AhScrl8V3q0lEv3mOpYGj139peSOeFmpebHiXg0rJx9qHPtafj+G6Nw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kA9f5sjuaRG2vzctzCp8dttJKbGRMLmrAhhg35dIa8A=;
	b=NOVorzWeO8vQYPAA2ZgsUAvLKOe8ip4e9y783TjSWfgLcJadI+j5EByFoWxqexX5gt5R
	 KXCQ4QV0cL47lW+cHS63v2xn5e4S1BkeGMBACpO+X8S9rPjp5nWW7O3cjWcoH1lKBmZto
	 4Kl8W8DKl2b6wMsUwc6oWl62AWHO3LsmpJxk1rfR0KeSAqpFS7FQwSfWCfpUEbP923snR
	 EcQ2Poa+0e/Yixnz2Iy/lS1SDF+KKvHcbw5XwBjFnFxPA1PfzQKP/yHrOQQLLsVDn38hw
	 6Rg+3cqvcogiQCUw28gPFVJJz1rxeUYAPTDeiqSrMB0rXMFAVaaCh40s0hlRB+Vjxqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t5IAeqLQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10061606A330
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 15:45:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10061606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t5IAeqLQ
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-498f5fa5103so1637981f8f.2
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 07:45:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794498347; cv=none;
        d=google.com; s=arc-20260327;
        b=DAs0AMS12yPNUpimh8XyJhpklu4mMyUujxkk7IzOxSY/Ebu3esLgGzr+MWNCSv8tc+
         0v0P4dEsv3ORRzVdkDP8UXl9r9j9yPktpf+m89FQtNwoxdS3zlOZmCbZoUmTRldk5XZ3
         LQjWBOAUZ+kEYRLrdVrsIlpWiS1iu64/uS4MHIZA79iaPSEChW+MgZmLOBblGdVHrKqu
         +pwwavLyYUBZtFAy0AKgqKPbmTjwrhmKLM0J6AIyTTpHsBIGgVYWK/kmibnNJB6phoG/
         c0qIAzdXBnKhYlBwTVp3cxEyQKtmgLw1mYRc3V+tcBZc1cfJaxfF81nkK8I5pEeSsK3Y
         z4nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kA9f5sjuaRG2vzctzCp8dttJKbGRMLmrAhhg35dIa8A=;
        fh=l1dTLE8zzlv+km4SEofu40TIdbowFMPPOY9qYgwmR2U=;
        b=AzVdYOg4dvmbm68XvqtZiaM6xOHRuo1lBnZDNyVWZucy/NseSc79C/l1faCalYvAU7
         MVl0xHpOqGN8wMEh+UVwgLRon24WGiDRfGwjSIwoFSRfIE6kleP9rM6vdRGyRqnSgrcL
         avr1yfomUPsR+KewVPVaS7KB1c0T9ch0PnbSQb4PvJxX8+P5fFUkM7CqdXRVs6PwKziw
         kQ5SnmGqRtfj4fljiKZlZfs7pLDihggevFIA68y4+6B7nXUyUU4Dl8FK/sJEmDccx1lr
         PwG63vp3GP1n3Eo21cbFS2sB39xYRlTdqauUPu7z5FADx+2ar8A444pGqR2nfds0hK6j
         Abgg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794498347; x=1795103147; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kA9f5sjuaRG2vzctzCp8dttJKbGRMLmrAhhg35dIa8A=;
        b=t5IAeqLQr9OcHYi8yhMFHhoseNHSIfksSOPQzSaawIg5iGhwqBaIMRcFuPa3Gnqs9c
         KWukp4xG7jDNeBEGoHt6R7U+ONdyuVkFP1gp1WXElW+hb/h28JMjMSdKuFkknOiz44nZ
         ybH0dhS7SYOkJ74wvVginP3x47g32Ylcswl51n2b3oU/ME6V/CkJ9Youba4Xjt5pQiXg
         /yBG9eRep4q01kfLVLJF8cTYFmXXNxJAXedGxNQvDsihb/w2j9fEgFSoPbaCxjwC+fcJ
         7vapEoboNwU+ernq4iLWgpDUl299l+KVASTIyQMUbTohCjjjvstkQuOo0kgw4Wcp+WF0
         xEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498347; x=1795103147;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kA9f5sjuaRG2vzctzCp8dttJKbGRMLmrAhhg35dIa8A=;
        b=Z5mbMlWA3W//bEnAoSYCAh0qCr3OBxDh89P5glPbPIwedqOfnIRAqxDfGfrhY12QzX
         xek0P196+9GN65hRnN2F+/EmGt9Xm5X9aFPpXajGKdc/B7UGEod9szFCpww394TsrPKO
         XCBwB3jBFuECUxsrR8S8uSQL23ik7OoH8JlAilrb/1uvRtuGPMV1IK2ewO6mYUb0dP/4
         D8MSwi/0lAa/8HEhi0vX5/R8RSNNKLRAuM7a0vaWQlxmYwMT8PRStvFwtj2+wqP19qY/
         DJ3fCYBbC4a6nKxCvAO6xd+EoZXI4yMG3t8ZnpoAb7/pBVlNCZ5se6/eKZITJGjJFLvl
         +9uQ==
X-Forwarded-Encrypted: i=1; AL+hErGrAp26YOGOYd0XhY3doVJhNid1SfdnFawHnyEY6ESzy0MsTIZDuPwUrupI09Kv9dRE0PQwfC9E@vger.kernel.org
X-Gm-Message-State: APuU4Z/MTMI1f1qbZXUnH+QcmKtKY9wjo2xqhSeGwJRGVZTcX4LaZy7h
	S/6brQoYpedmYxGYQ1n+3qHvvEQZRBZ6d0r06NXBnPF5VRBYtgULUwgBmPRhly5giIJmU8LORJ6
	bUG9tt6V3fGtAJhjQd9uwWxqxaXdHRm8=
X-Gm-Gg: AYBFou2WhX9ptu5SVFIm+0O9M9iiSBaFw10RcRLrZ8pK16KoafWORjaoiqeM73UstXD
	HdCbfF35EVnu4Kj8ha3iFQoTH0GZ/8rAZL+yM7VR/v5ntf183vM1xDdRa+tNP7SYtwOC8E/xdHR
	0x5enEGj+jo9zEjXzMvdDjXbgm9/HfBQ+O/UmRI/N2CObwN1cdpxZkQ1zryYp/CcADc0omFgoCV
	HcSW88xPFQ5lxd9r8X8TSxXZw1XcDndAooHVT2NB9CqoF4CNDtLii0+R0D2fGNr8c2VaJJd4CUv
	YzLEy9aUQP3L0/qWLMArj+KFC4pxkj6PgL3OQRMZHtgbsppY7/iuLa8QOPmgRxoGr77GPHwlGiS
	M4adjMNxJcQ7Ff2CqrFZXDTWWwGDlSIvD9/bhVnpglNP39s4OSJ5kSh7BSndrYVuJ7HWC5qgKNq
	0uZIPxBfZ02jt5oiqbZmNWb5xCyzjX/jCaiHxDwDrAZ0EyZgL8DbOK
X-Received: by 2002:a05:6000:2308:b0:48c:5304:5e50 with SMTP id
 ffacd0b85a97d-499c0781a7bmr11850028f8f.0.1794498347231; Thu, 12 Nov 2026
 07:45:47 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai>
 <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com> <CAEEBa3VA2vycMaRCe4K-qnO3SGCuvAqhECmjmk6PQC3xxERiLw@mail.gmail.com>
In-Reply-To: <CAEEBa3VA2vycMaRCe4K-qnO3SGCuvAqhECmjmk6PQC3xxERiLw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 12 Nov 2026 08:45:35 -0700
X-Gm-Features: AclHuK9YTgclXVDvcKdpOmhHB6JA7-MrKBIZCLI9W7C--1NSD0gtJgLIGYRP7cw
Message-ID: <CAKEwX=NVox_NYML-5Gg6W_gDt-j6gquk3sba9hmbvz-U+t=ehA@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: honor zero cgroup limits after successful reclaim
To: =?UTF-8?Q?Tom=C3=A1s_Senart?= <ts@perfloop.ai>
Cc: yosry@kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, tj@kernel.org, chengming.zhou@linux.dev, 
	mkoutny@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	cerasuolodomenico@gmail.com, linux-kselftest@vger.kernel.org, 
	shuah@kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 5:55=E2=80=AFPM Tom=C3=A1s Senart <ts@perfloop.ai> =
wrote:
>
> On Thu, Nov 12, 2026 at 12:28 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > Why is that a problem? Setting memory.zswap.max to 0 while the cgroup
> > has active swapping processes is naturally racy. The limit can be set
> > to 0 right after we check it again anyway?
>
> Agreed on the race, this doesn't try to fix it.
>
> The case here is different: with the limit already at 0, every store
> writes back an old entry and then stores the new page anyway, until
> the pool drains. It's bounded, so if it's not worth a special case,
> happy to drop it.

Yeah I don't think zswap.max =3D 0 is special here. We can violate the
limit by changing zswap.max to a value lower than zswap.current. In
future zswap_store() attempt, we will let it proceed if it shrinks at
least one page.

The hope is that in the long run, the violation is bounded and
self-correcting, because the number of objects in zswap will decrease
or remain unchanged after every zswap_store() call.
