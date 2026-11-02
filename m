Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640586;
	b=uN2uTDsveUM+kZZTQynpkETgI3OV97DJH8Wzn27m8ulESun126N7SLyGUnoGho6+fZgk
	 lKJdAPqHonBf1jiRDX4/t9W8o6NQsB2QdDt2anXgdZCKyxLm+Hx3eaOBKDnUMf2oi4/6F
	 gIinm3UBycA9MLVDOjUFV7lz6XWawpDDUmSfWkobh94XO+/IrKd+l6Qu0QXWsgp4YoXnD
	 yCWwC80OtmFXW4rDKbmP07q9qfQNPFJQ2OFR8qRiiA3Fc5spshEy5/ks/xNV4QqiXiCp8
	 P+AWV+9qN12VnTmfCJs2H+Qm58C7rYLbfHYIEJI6LsH6OSZVvyqr+VwbpFicM+AG5Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640586;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=lBnwm37qIsrm7xDbTxm53J3mLY9DT6w/4rBjRvoMZdE=;
	b=s0vTAXxXXJ8/7pi+MNo39DEKc1jQ7LIbvLcKk7Ib01yu/44Kn3nDq2ILOr+93UlIi+WU
	 XLVoW7pOnF2VLSW6draqgDhJner5TcImv925tYTDj8ZikJYCuY79OEfsMAY5D2Lnk6ttZ
	 Blxv5wV1PCAXvZQ5j4ZA8rMDzrnzADp6PD7sSKzcDhsU66g0bfTcaNqFcG1aH9eGt6s5G
	 QaHzrBbrrv3E3t5u1cRkgPzBlCfVHnXHnHZ1pqi2Q4Yg3U56O9GuhI9vwqyCqjk5ryul2
	 iLNgLxeOWXw62AbYtiLABOlNS5ZLaPMidCN7RC4uKWX5fXEP70OOGQuKQb8qFpDq50g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=VljADhIU;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C73606A32D
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 17:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1C73606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=VljADhIU
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48e3b22e971so1660829f8f.0
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 09:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793640584; x=1794245384; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lBnwm37qIsrm7xDbTxm53J3mLY9DT6w/4rBjRvoMZdE=;
        b=VljADhIULemmV8tvaeTQVmfqUsL+izWnCkC5oYi4KOzrHim9grJRjRxHOcWm2EPF3r
         Wclx8JcLDz+igdrUFF4fi6Zdm9tcyYE1BaFTCMpYiJWRLBBXP+QCxoytS3PgZqsHJPGW
         +bDUd9LIjDcG065kFmpe0R8+P+kDeXGL49AQnYz/AOxMW1kaMhpEpy+QXQk/8bo+5loi
         wm5PMfz+1kRz6N2L26srC31WaEOZi5zsud25l0uiivStl0eIf8TeDxVcXrisI0bff9lh
         8mzV3C7fc7D2F+ROsUuvar2jSoEJA0as2si4RkMu89NHk5jwkTbNNOEzjfZNZCv3Lf0s
         2NUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793640584; x=1794245384;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lBnwm37qIsrm7xDbTxm53J3mLY9DT6w/4rBjRvoMZdE=;
        b=qw5SNfcycKYf+X148Xx4cvTxyKjvaZ8YrTOT/pOQNPGgqx9Zh8cYc0B7n1XiRDS2LO
         79/ZR4/BvGldvRuAVjwcHdSEwz5j+kwqe3yOxvtJ5pSG1yXmzesn/qyH7b3KxihknYVx
         oZDW5xUy7J/R4Bq3zZ2GOL8xpslQLe+QQqKAJwk7Y5s0C7jzzEW/xifhFzzQVdkaYHyJ
         hY3MaRSm4wq8B8vhUSFApjSC4eiQX1lgxQ735YAwXATxm7CRhJdpVpYOzUJPnIgc8Ynw
         ujd8Zfexr00S+NoExIIby0EMh2dG7ro1Zqo1mXmJA/31VWcfhz0Gn/6nG2ARaPrIh4RH
         ou+w==
X-Forwarded-Encrypted: i=1; AKwUvBxCgQfX1vVrBEQi/21iZCKSM5dK/tDURdU+ajBHPKWnXjJ00IdhcOSQi51omg5IYEY5tPpQTlR5@vger.kernel.org
X-Gm-Message-State: APuU4Z8erPI3LJwtrWBMJIO/S+neB/fO/1tTnHzP+aT9AFNeZO7KUav/
	Fabav10Mf/lrcz/AEWNnUEYyfcj05Zj1gqIAxwycVH8Smqua3vsT9WCmJI2U6kxbbcw=
X-Gm-Gg: AYBFou2hxEkWEDGigtr1Um8KvlH2S2w/i5nTGvQdW3ib1Dgfel04v1RON9xmdExje+v
	eP4pdgF2gCDWwKyHq8Y4rdWQtFx5pjvHGG+fs5oumB5UFU+rnBdjDEz5sDDMkdL5fqeimDEpUgt
	JE536UzYLz4TbeMvD+K8ftXlwx8HZ/oNVdAn7bG7J0KWU5PQExvwJ51RfRyztgVS1DRx1UfT7RU
	nVbm/09+aazmj7IpsTHkxkgEaWx6yuTm9D4NCXo+7pKihYwYmt03VHjLsDfQ+rwisR1fyrek011
	GBLOyQsXT0bQ+mSvJM3cQ9XHajPDKvkKTSFutZSpm2NA0d4SJcqmIveyBwm3d6VB5WDoi6Jxdav
	HfcfUqE1KRFgLWN0wBPcV1sOIXlKAEo6p55u4KtkHUme9BR/17qyP3gCvAn8XT+wy3ZPO2FKcnC
	dG4oaVU2Bk654MPtvi7WQ1pNOeTZJnOdlDGMmy1gdpWiFOFFZ4qHppy0ptU59SDIaD778KH0zPK
	Q1yLiCLxFj70DdTvNOhV4aTJGAe1Uszi7K6KRXE1YhuVByTQiVbbIkAoSkfIv0vpKgm7J8wURJW
	mbN9zVmmvM2JHdvaZJj+RTDRvLKO+02+6cOcgrc=
X-Received: by 2002:a05:6000:4b04:b0:48d:f391:5c45 with SMTP id ffacd0b85a97d-48e6e4f8ae4mr26540418f8f.42.1793640584164;
        Mon, 02 Nov 2026 09:29:44 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80306sm22600959f8f.33.2026.11.02.09.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 09:29:43 -0800 (PST)
Date: Mon, 2 Nov 2026 18:29:42 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tao Cui <cui.tao@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <aujIhsampHnzcl_5@tiehlicka>
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
 <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
 <32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev>
 <7ia41p9341lv.fsf@castle.c.googlers.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ia41p9341lv.fsf@castle.c.googlers.com>

On Mon 02-11-26 16:52:44, Roman Gushchin wrote:
> Tao Cui <cui.tao@linux.dev> writes:
> 
> > Hi Roman,
> >
> > 在 2026/10/30 14:05, Roman Gushchin 写道:
> >> I believe we want to delete this code sooner than later, why would we rewrite it before that?
> >> 
> >
> > My assumption was that v1 would still be maintained for some time
> > before its eventual removal, and the goal was to reduce the coupling
> > between the remaining v1 code and the shared core structures during
> > that period, rather than to rewrite the implementation for its own
> > sake.
> 
> I understand. But personally I don't see big issues with the current
> code caused by the v1 stuff. Maybe I miss something...
> 
> The proposed changes on the other hand create difficulties for those
> who use v1 and maintain some local changes or simple backport upstream
> fixes. Of course, it's not a reason to not change the upstream code if
> it's justified, but in this case I'm hardly convinced.
> 
> > If the expectation is that the remaining v1 implementation will be
> > removed in the near future, then I agree this work becomes much harder
> > to justify.
> >
> > Am I being too optimistic about how long the remaining v1 code is
> > expected to stay around?
> 
> Well, Idk, it was considered deprecated for quite some time already,
> so maybe announcing that it will be deleted in a year is reasonable?
> 
> Shakeel, Johannes, Michal, wdyt?

As I've said up in the thread I am not really convinced this is
something we should merge.

-- 
Michal Hocko
SUSE Labs
