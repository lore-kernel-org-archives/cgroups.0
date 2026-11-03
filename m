Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793740266;
	b=qr4CdgpM9dtVclbGUvDkQo5BK5iYDSIteq2GwQld8yMqQXX29iuDyKW+of6x5O9CdBkP
	 ZfP/Gassx3kWue8/ZzM3AsVFbvCPhV5fbg0O/WceU7755E4MV+x13GwA5/8VZ0sildTG3
	 wecTnYH+XSfX7dyURUS8AX//MdW+uuh8BxaNZ/FVvjH/HQPTx62/tv5HftyPfVGzoQbto
	 O3quPflKsYVJT+c7t5aP17oIZJwG/XdjA1PPw7eRU3lWs4q7OvX7rTBqKZoQ3eJ6s10S4
	 5FhDEQUkSpkXaheREQaR5CV2VlhJi0OuHqopKghbyyFk4D3rDiw+Xp75VbOPTzi2zpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740266;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Date:Message-Id:Cc:Subject:From:To:In-Reply-To:
	 References:Content-Transfer-Encoding:MIME-Version;
	bh=Gwb0yhNA8ovJvghC21bfjrqEFSJ/3LvirO9QqnwCwDw=;
	b=lApkmjk1/AxFeZGmuz4bshK5XuY0vGzpYRHFyUuCMe68UDRlou03gADow7vkb0K+98Dy
	 B1XPAgMWP1O93Qo6CRxcJ3RbCHoQIox6Ci7a4damRAg2GhBhnlzLdGXCRkuX5Fq6hWyp/
	 Xp3fB9zhfyaKGIh0yD+42bE1i82G+0/94UKjIU5z9RiooYkiHzCtgCU52oXAuXAyIy3DN
	 RlFgvjz21k6Id10rhuBDENlVM+3cEG9zRHDP0hVC5aw1iA3Ct6Tdx2pxy9dPdgCFlfudb
	 JFRBY3cjHvwxW+8oS/P3fFjYRKLcKoZt9GbZNPKx/9Wtis/VY4Xl/bJsfbOIzIye9ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UhZ1BGol;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF53606D832
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 21:11:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDF53606D832
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UhZ1BGol
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd3310348d2so557770a12.1
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 13:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793740265; x=1794345065; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gwb0yhNA8ovJvghC21bfjrqEFSJ/3LvirO9QqnwCwDw=;
        b=UhZ1BGolaieZt0ciUt1eNUSO1jnqrZLezwPTtss4f70Tsc5fUSV8VOEhI9jMVcYZO5
         iJb/lR6lPJIQehJBdRf4dB1F9HIwHEXwOEMmB8hwjYB0Bew1QHtbGXYu1zTRI3gNE/1J
         dsRudaBjgrqKBYhHsOlTvPuF+UELoPGlrMsEq9vzHBeld+ORdxtbF/Tg8ysHXe7yakJ/
         Ks2rt8FXRQCx6gVAzFE/fUZBzmTdTbRkztGG9aejbQTx6aCWUGkj6pI+DYsdlcwGunMd
         mvN/lJ03hbePC95887nHA9wPdslFAkXrrnqBVPsibCSgVNESlLENiTbH/su5cwlaVLP0
         CA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740265; x=1794345065;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gwb0yhNA8ovJvghC21bfjrqEFSJ/3LvirO9QqnwCwDw=;
        b=gIx2NufFTZKQdv6QkfOug3/t/Cj8+IqfUBEmSf362zDZ0zIaNKVqPgX53Nz7qiWpoj
         glZyb3vyQepTLwdztZ8ffuWBpdjxeWwlf6byXt1CfedJHaUIF/MztE/57WjuXPm5inQX
         oGjPNYXEXUyUc4AKZ7YXUsJj9Gdhl2Q1qphJ0tl25yz9FJmQ7oC7/ds3Qfh4jcmGQ3y9
         +gVPmiRmypP/jpVDv9924GomjKEIg9ihj91/p3xJ087mk3C7ueuSG96VKRAnk2mWpc+Z
         o0Sd9kVLZMz9vTU8GGZDTdKzS0EaBQkP9JY0AoFNqQl0i+VHfXUDsxv94Ad8Yiz53Xxx
         kTAw==
X-Forwarded-Encrypted: i=1; AKwUvBypY6/WAO1YM1edTSl5TQtg6ZKWdXYoOxIbTGspcFyJRx+DwGvThB/V4eXR2g8NU9PxfkcMsf6s@vger.kernel.org
X-Gm-Message-State: APuU4Z82UhFmiHE/SfKET6R8GImC42y6NbRKLA6qvMmsWfIaq49Zi6AW
	PCjLTj+t0c66j22wLKtPYnuPv7+jyQuDqcIou56xphzACjfEoKciX9XI
X-Gm-Gg: AYBFou0MJodgmJUsKLXcYcfAAPZkFRpV3sCphiwTeA1SXYZXg55fgGeBM1knbrgvh4v
	ojvxceGVKCJ7s93+d751G6QPRbczV9QJcAIy0xz18s9sGdNph3PCRAEKQCsxzMWQLO+4NAUCWrq
	fZoB3FUEpJt9NKdsyzksAD0EgU3XFJn/1wPSME9R0yDqxe7k2IQvuuVPyf/AMQrll2+JlAeak2Q
	SRrS98aRw3fbxBoL3p6WzgrXL8mPBeTPcOqQ1uST48pIJUepcomx0OLe/f+iJJMN9qSYh7u4W7N
	e8Lcs8s813SvrZoWqgpwzdqGCE8eo9SaUcwL0GKa4RjJeHYzpUnzU19yTjRqwc0GjktXYtEifpI
	aGOLoAaHk6TlIxXE/xp3ku41y4cY3v4Q9rVswZndbPcBn+/MVcYv62yR2pYn7fhQUX9jdpn8jji
	e0OG9s9LvGShV5QV2WjDguk+kbBEOb+1XW0x9pJVNUvHVQL7vVU0IcfItQoTZdDRZwIFe6TUFhP
	5aH+hmeWuCW7Ep/D/N3akwr8QZ63tkuEg9wqpgwIdr6xLiyGBSwF4iaNZwbo0nGqMzuI8xiOE8B
	DYyVsPAijPVD+NiYP04GITT4x5p2TML18MY0Eav10zSEspe5fiFsnvrLhcmY4vCsq0n3WuJwAC1
	oURC6lFJaZczTwQitzfhzbXBGiramgZASqA==
X-Received: by 2002:a17:90b:5624:b0:3ab:d26b:c2df with SMTP id 98e67ed59e1d1-3ae89758b67mr7781961a91.27.1793740264860;
        Tue, 03 Nov 2026 13:11:04 -0800 (PST)
Received: from localhost ([153.61.198.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0944ee6easm336849a91.2.2026.11.03.13.11.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 13:11:04 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Nov 2026 21:11:03 +0000
Message-Id: <DMLVUTB5J1RJ.2QKOUW6UB04ZM@gmail.com>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Christoph Lameter"
 <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Sebastian Andrzej
 Siewior" <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, <kernel-team@meta.com>,
 <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>, "Sashiko"
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Harry Yoo" <harry@kernel.org>
In-Reply-To: <auo5G__ac1qA9JRs@thinkstation>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org> <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org> <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com> <auo5G__ac1qA9JRs@thinkstation>
Content-Transfer-Encoding: 8bit
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, Nov 03, 2026 at 12:21 PM Harry Yoo <harry@kernel.org> wrote:
> While this is technically true, this relies too much on the current
> implementation details and makes the code hard to follow.

Fair enough. I don't insist.

> Patch 2 is an independent bugfix as-is already. We should really stop
> open-coding slab_free_hook(). That ended up missing init_on_free handing.

Right. No objection to patch 2.
With patches 2 and 3 the !allow_spin side of memcg_alloc_abort_single()
is an open coded kfree_nolock():

  kfree_nolock()                    memcg_alloc_abort_single(!allow_spin)
  --------------------------------  -------------------------------------
  memcg_slab_free_hook()            -
  alloc_tagging_slab_free_hook()    alloc_tagging_slab_free_hook()
  slab_free_hook(!allow_spin)       slab_free_hook(!allow_spin)
  free_to_pcs()                     -
  defer_free()                      defer_free()

I don't insist on kfree_nolock() there,
but can we try free_to_pcs() before defer_free() ?
Like:

	if (likely(allow_spin))
		__slab_free(s, slab, object, object, 1, _RET_IP_);
	else if (!can_free_to_pcs(slab) || !free_to_pcs(s, object, false))
		defer_free(s, object);
