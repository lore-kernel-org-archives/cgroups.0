Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8121A7264
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 05:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788325478; cv=pass; b=EYQWX2F5+Kzarh7TGHD+nPaaf9F0dOum/c9g1fDjj4y7HYVfq/lshvS4j3JLEbcOrpq6H3c7DkVbhjpe+vJezD2ff1NUSlYZkbRfFXpjm4jsxRniTepEu+qnKTHB0EC4bVSiHfFHr3MRVp7dZyIw5c4H9MMurfspacxo1byPktI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788325478; c=relaxed/simple;
	bh=KeJQVDSbogynnxpMuf5nC3Gv1fLjaTff/br8PpcWI6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tnp3ckTcymH4iASHjIOWVVpZ8z4fKilAQ+Mgksq8ujn9l07I3ME36El4bPhbo0yqRG+cz9/ymyF3gAGqnj0uwYN9GUPn0KqP8COaRWmGeaOsHaTGmOM0/W6advUSjRihSbhfkGBkchC+BulLLux6ogLe5nJrU6FoL76YyOQA694=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fURFub86; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fURFub86"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-485538d3499so111232f8f.0
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 22:04:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788325475; cv=none;
        d=google.com; s=arc-20260327;
        b=TheKzQwUUTXEWc14bs+vDfB2iHDUazYmYkJsVYrgLoUBpL9y+HZtEquhhK/QMDkRoq
         AvvKz1l3qmxm9AJ9SpdX8qml99rpuNKtAB8iXqTd2ACeQjMWbroEElUkke/W5AlJ2A07
         njPjaQgScdssgd/xB1dXoomCrvaymq93KrwgFj43cIOB/JvFdzBH9jzJBCC+7HBKt4MV
         kl+xqReUjHI6cSSnlSG1btouLR9P3TWeogIrzMc1hwrjZie8fwqPlD3xD8G/6x/lK96S
         RhbED0Mdl8v+PUz4JxpFOvV0EFBuNp8I7ndAAbe8bf4UH2gY2MLNEdMM5b5y8EzrQq90
         hzig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KeJQVDSbogynnxpMuf5nC3Gv1fLjaTff/br8PpcWI6E=;
        fh=1IVR4CZZkw8wB7FtPn3lUQs4heOZeZ25oy9dv32vnKo=;
        b=QSLY8q9Q6XICq0s2OfWOma2QdAkyT20NxqaHW2Fcim9+3qIEQvYQtrAeLtKgAh92v0
         /OLE4h8PyWPtuDNox/tNHR6DwBjjuaf2Ta8hLyNAS7y8wPyruunzpp1ZMfR/mKG9vmSj
         8doiCk3zrYqV4nH5xy1Xo36j6GyIOMQBFh3wPslVElgfalWA3QhOpsrEpgzNBJsQT9qy
         lyH8/rKvzuqUw31mkRd/pvdgsAtq2GYdgS1QYrVhPMkMhDY4NGxduFOeILLMrsZ1jV27
         zPui0FJrhptkodMkij1H4t5rVEjZg0uXug9aK1BwRlDfKKSdKP3v7HUu6Yp4a1sSmOAX
         +rMQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788325475; x=1788930275; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KeJQVDSbogynnxpMuf5nC3Gv1fLjaTff/br8PpcWI6E=;
        b=fURFub862GT8xpnQXqxVrktzxtTG6V7Lo1lhT9HyCOjYjzPrS3GyBRLb/MoIVs9U4W
         JY6cx/Dl5A5FS0ueNJOfrkj8FRYQWph5wzOI2mJF0miSaY3OOxLhR40G8w5Gif16sSWb
         5FD1W4GKx0FBSYqCx6AyEwJBHA8IPHRUqst6EtBf7WP+ErXNzwj/H2XcK55E7NmKbWV7
         y3zgT4zj8fm0W3FNjV1N87JzwKj8OW/prhmK0WZL1QRu1m1vGlwbawian2Y2iTYoAVKf
         2UFgccJXwi9vzFWQqH0ac5C1egx1dufwytnqZthdEcybdpn1yR47DMQhoTgP1EaI9Z7Q
         vibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788325475; x=1788930275;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KeJQVDSbogynnxpMuf5nC3Gv1fLjaTff/br8PpcWI6E=;
        b=f/ewbU5Alx4L9vaJJbtiPKgMBQVlDsttc5orlBCHDnvjFy90f2Mp9Gkt0G8sg22rG7
         EZPdO+ZuWrLn3a9AP68xswmi/PoQQKsWHC7wPPnTZ+Ib9aOsfWxaPqYe4tb9nDqMDmcy
         KrS6pJmE20CxWZLGbAjNfGST/2QvQEuFQ+2uLmjnO7lqEo72EqWqPYmqhr/7nXW3sNwm
         1t3T5ooCJppoXthrwS1+2IrlbQpbBMlCLI/OIUGCyIIpYN9/p7AZo95H/oJJ+z5V4I+H
         xeabhVFlZYbJ4E2t4K72OdSJxSoaxZIhYn1sx4xFw8wcMUfctbhL1OQOwuiI49fZ18Pw
         X0Yw==
X-Forwarded-Encrypted: i=1; AKwUvBxn+zfhJv40kJxOhDPe9OIkI1O6/Us9IhVudBRB5WQ1Z9pkFuXyzfPE1fMIKz+SCmU6O5+cLLSS@vger.kernel.org
X-Gm-Message-State: AFuF++mkSGt2Iv2/lKOvIMFyTBss9O5pgELnRBLZUQQW42FxiemVsbjr
	hNUwYyD8ryePGyZoGGVqDzBHHxUtBm4f6jpSWED72KWJdgG9YffXIIn7wD9/zrAxNwTJB0uYUIc
	71Qe//4Ur9olaGk0qxLHW/b9JLAQSK5I=
X-Gm-Gg: AYBFou2xZg/xL9R0nfzNH3cQ48FGvuHJ8NimecRjZEzQ/mZO+5Dk9rpjMvVDWgWZXAf
	fYf9FdOr6LSO9UcfUDyxvxtafGeiw6R+wrR193kIRHfuM2KylfAkdwsfDBEPb025IyEgePTfT7K
	Aq8zbdqbI7dsS3LMKp7IPC9Gpkyr6t1mxqwV7qZ6OZDbR19fCMO0fajcAh5ABMeBmMw0M/BT2QG
	AXILGiU9461sNpf9tlPSKUR7ftH6OhI+vzuQQQ8r8/A8L1rUq1QEmWtebsPhRM75HwNcSVATtiH
	60lkAbcB+cn11Uphhl/mcb+QlNA7xmoUl2FTQCigH8cXFn0olC6rUI0xQuhGBU+tS2x3oHmOG5L
	XNkRB4RCOhaPAtzwYv0nr+TVbnaBM
X-Received: by 2002:a05:6000:260a:b0:482:ea99:6166 with SMTP id
 ffacd0b85a97d-48488df7809mr3404647f8f.7.1788325475488; Tue, 01 Sep 2026
 22:04:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260901232834.22221-1-joannelkoong@gmail.com> <CAO9r8zOTd5HjbDfMXuh+VHLGCAkHwyKx4CV-rjgBuxTpEZ6THw@mail.gmail.com>
In-Reply-To: <CAO9r8zOTd5HjbDfMXuh+VHLGCAkHwyKx4CV-rjgBuxTpEZ6THw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 1 Sep 2026 22:04:23 -0700
X-Gm-Features: AcwNN1WnU7HEpDTsnhuHBNOj_YFTBtEsrMXSe0lpTN9YaSozig1ywRedLbNVFmY
Message-ID: <CAJnrk1bFG5X-pQK2UX8Eu_bPTqD7KLn6cqek9uifrriDBrPLfQ@mail.gmail.com>
Subject: Re: [PATCH v1] mm/memcontrol: drop non-hierarchical memcg-wide stats
 in non-v1 kernels
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 4:42=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > +/*
> > + * The non-hierarchical memcg-wide counters are read back only by the =
legacy
> > + * memory.stat and by reparenting on offline, both of which are v1-onl=
y.
> > + */
> > +#ifdef CONFIG_MEMCG_V1
>
> Can we query the boot parameter instead of the config option here?
> IIUC this should work even if v1 is only disabled at boot.

This seems like a good idea to me. Maybe we should take it one step
further and gate it behind cgroup_subsys_on_dfl() to cover any
CONFIG_MEMCG_V1=3Dy kernel that doesn't use/mount v1? Not a memcg expert
but afaict, if the kernel then switches from default (v2) to legacy
(v1), we could populate the state_local and events_local arrays from
the aggregated state / events arrays in a .bind callback since
switching from v2 to v1 is only allowed if there's no memcg subtrees.

Thanks,
Joanne
