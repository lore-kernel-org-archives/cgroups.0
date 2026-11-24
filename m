Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795510349;
	b=GekV/OckoZ95A3ncLtK13imLFVpt5co8NzX+cbOPQIgo3Rp6xc9xf6HO7Ll30BJqzhC5
	 fI0DjhECRmAJtBCvD4Lpw24xCfWG87Y5YdgjhjSLsjguIvnx8QnqkOukyt411mITIm55W
	 Mbdcy7fuOoHOfXWMABCiJNuA4ONKWLUzIK4uxcK6h9U04f39fDDxtEea4Vw/FdfbdeHFx
	 XA0q1GagDNR6KxqacRkzwAHPrsIF8j9GiNRrhAGHCbS4Ii1/Bgi5aAu80Ow+WcLh7cLAG
	 Z21cLC60//UbfCVLWN5NMdjc5z6MBTw3Zfet4Jr0loWoU3lbJgrb4G+cQS1UVfwyrYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795510349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=R4vZ6P/pxgMeaZu3yTIBPWC7zlioL2LZflk1ZvJYOpA=;
	b=afQl6LdfkPoifBqG5RkPbVnC5RkQqukieCB+Hn3LSuLIna8wQB9QSf6XLJ9tfUo/ePy/
	 t98ygeTGQqVbVzCX0XhPNybNhf8CWi3KXZtXYuVNjS+zFc7urunZ4pYL1nvhC2RQp4+1a
	 EJ7BgtuC8ljuPEHL08XXvREQM3S5SJKUBUSm05SQRKpdtpXoNMOvTyTZEIwzDbioYKZNy
	 9zHIN8wCdIdQcn/ZqPl5L/h/79QLLJoZRm2Ekd5Oa7Z1exMuDK/lYepyzWGgqJSTLmzde
	 fP4tKZ9HU9VXcw34I5H+gtv8CFoTxjZU2Wz61CSDSIJGE8PDPzA+blZP1ytOgCSRsjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=d7IG2u9A;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DB6606A333
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 08:52:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49DB6606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=d7IG2u9A
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-498f5fa5103so2490626f8f.2
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 00:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795510347; x=1796115147; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R4vZ6P/pxgMeaZu3yTIBPWC7zlioL2LZflk1ZvJYOpA=;
        b=d7IG2u9AWHFx3qsnqfn5HsBFDPsO5McZsDh8QljqpcrjY5WD8b4X2rTXvEc7QsNghQ
         K7apN5vvj1bWCTT0FFKWSPoDDRjyJ37nL+y4OMdrpSXTloTMQRm1Kg6ZpwxLs0T2mqpG
         hO/JLyHDV32yFz+jWyGdcDCv3NNhmESnKseTD4l8i7JNzlT+DPhgkUFCf6v3969GrulU
         IW/MKEe2GnlZRHUADED3hJy5qbOHHMnoJkWBAV4WoHb2LnUooMeh+a7BrHiorUqYLKL8
         vQ4mGviXtdzYDbbwry63Uz4WQ/wXSp43JV8CGx6BaEMo/+irzIWtTtWy02ROZohe2NjB
         getw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795510347; x=1796115147;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R4vZ6P/pxgMeaZu3yTIBPWC7zlioL2LZflk1ZvJYOpA=;
        b=uCUxw3nK2GB8Qe73VXw0Go86SlRCgeInVs8fKDO7NHUPrGusu5WJAwcLryw4hBITfQ
         g9Bac3n6jmMr/MIyjrDIWzs40/CL1iH8n2FMhy1jgYf49+99+YQHVvhIW3neiMN5UkSc
         hYup5jKENNo0mLg8FUfQS6qVT2EzYrEHgTY+iHaj5cxgqL1+2I37o87Mk+XIs6yYvHpb
         AEhrHAiSaxzNlf8JdzQkH9FeBje0SSiKEK4tWW0QEwzl9TaSn5yupsnpQWcD7IQxBB56
         9Hj1TIHtW7ToIj64u/TiwtJlH5FK72/4N6zZC/YE4THj5iVAgVe5p4fPT8CjzjvQddRn
         Apkg==
X-Forwarded-Encrypted: i=1; AL+hErEUxnWYI850SaJMP70oroWHKI8vRZaaPgfqmSSIOVN2FZHn4LgLrawkpzbx0UzhrSxvGca3yUgQ@vger.kernel.org
X-Gm-Message-State: APuU4Z9bVnBXUT/p2r1CvPCjv3X/c0QjlrmtGRm/RsWw8nx2SJU6GQIm
	KNd1LGRMGDVYpNcpE8aQ8v+A5Lq1PqRfKQ4sIskIkfanO17PZ+OYEk3p2YvI7+Sty58=
X-Gm-Gg: AZFdTZfiVom/Ii2nAwg8UE7e7BIU5xezF0BjwJ5a5IsmEcmKBAD1rlt74xX3h0DJL/S
	CVA8R3xBDx0EqjMlLY9XNJbNtsOad9dDmdD897lSeFDu2b/o0Zvxu3Qc9DxqKSckRDHC30jx4zS
	TAwCVgvVoil/h/Oo6q5uqhElkGf/qGliUqTwYsgnsXXF2+iH0fC+hDHzP3AjtiDMy4irobgR+c1
	a/FZwLvM1qCyoCei06X5sHFmvKBxoHuSD5ZPyxzubDTgXRpaYNunlzMY7VockEMkNRFPVQlFT0A
	aVCxUO9xUqk6Fs2AXViP+Q8WGu3TQXiewKZ5MXZZ5kNgxEsZBsyM/Dx9a0OyWQPCvqLIIBRwwmW
	6lKe381Qr6sLxzTzFKEqCbFeRFtwmBWQWUKfTh6HC+Rxk0PTEVOZexOhnFBRAkwUqBh8tuIXdlI
	O/fhqvKZ9q49qIDaUdzH7erUo7+z9DpdudO9w3BVAcZ6UcI5MJ4B46bXZsYhnDqsF4mT9O/8Kja
	7IVj1/Wa2ovGhqp+6mGAs21Yo+YcBFJtSzyge2tHr6+O1mcwx70/PU4A95144E66T5QAqrXcav0
	yFpme1OiXijYzDV7CqgCTwfUzJhJb3T556aJHpUtdPpZnPZ9tc0HIttC6NTzWdlA
X-Received: by 2002:a05:6000:26c1:b0:4b3:b495:d5ad with SMTP id ffacd0b85a97d-4b3b495d6efmr9273447f8f.23.1795510347681;
        Tue, 24 Nov 2026 00:52:27 -0800 (PST)
Received: from localhost (109-81-82-199.rct.o2.cz. [109.81.82.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6bb989eesm26747447f8f.50.2026.11.24.00.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 00:52:27 -0800 (PST)
Date: Tue, 24 Nov 2026 09:52:26 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: warn when memory cgroup IDs run out
Message-ID: <awVQShRRwF1IfEws@tiehlicka>
References: <20261124020800.2313930-1-shakeel.butt@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124020800.2313930-1-shakeel.butt@linux.dev>

On Mon 23-11-26 18:08:00, Shakeel Butt wrote:
> Every memory cgroup gets a 16-bit private ID, so a host can have at most
> 65,535 of them at a time, counting dead ones. A dead memcg keeps its ID
> as long as any swap slot still records it. On Meta hosts that create
> many short-lived cgroups, dead cgroups held this way filled the whole ID
> space. After that, every mkdir of a cgroup with the memory controller
> failed with -EBUSY: systemd could not start units, and container setup
> failed.
> 
> This was hard to see:
> 
> - Nothing is logged when the ID allocation fails. The only sign is
>   -EBUSY from mkdir.
> - Since commit 8290f45995f5 ("memcg: move memcg private ID refcount to
>   objcg"), a dead memcg is freed even while swap still holds its ID. So
>   nr_dying_subsys_memory in cgroup.stat can be 0 while the IDs run out.
> 
> Print a rate limited warning when the ID allocation fails because all
> IDs are in use.

Not that I am against but isn't the issue clear by observing EBUSY from
mkdir?

-- 
Michal Hocko
SUSE Labs
