Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5634331EB0
	for <cgroups@vger.kernel.org>; Sun, 16 Aug 2026 00:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786841049; cv=pass; b=S9xv3RFL3e3oIacGtnVjvrs+yDFet2wIiy0jCNuf6KmeL48pwQ+X1+SLGNNHi2/cW+Hy2PXLfGF54a0G5u2X1Q6MrThAdAAN8CfQQJD5FMLcXU/5nVRp6kLbFCNPuOzfMO+MrAYGZBhkceji3Q7PXBn2MHleW/ZS7VHag9euDxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786841049; c=relaxed/simple;
	bh=TLm3DlieNyZ+YZQmLXjzsHNdTqbNaOr1k1Q22XpWOWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ak0Zt/3AXc+fSarFywCGjiVgbqjmbYZAxj3i3m1/wyLzuR5HsNPYQQhgMA99gLtEMw9r8NwWCs3QnWXIL5Ow6iZc9yFXSFybnBzBUYzdG0tSFD8Gmspb91H88IZVPD08PUuV7L4RmLL8pLql6zN0naRIsBE6SCm/LsUvXartDTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dndlf+Bo; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dndlf+Bo"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49557167508so21998815e9.1
        for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 17:44:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786841046; cv=none;
        d=google.com; s=arc-20260327;
        b=RPZTcyTzwn1NtaqzVxyjhendXAH29RGVSCKHJpB/OlOp/db7d666IZL7Yx8hGA5hkT
         QRwKc6X/E1J01owE0w3ElBqBUGcl0Crwb7cPXTtXGake6EuJ2L1DTLBqnk1P2op6JcBy
         oM8sXoTBgXvpXAQ/o5MJ4zpXnDh745RxdLHjt8CPN1PkhZS7PsHP3C517QlcVkt59XFo
         K035Q5Gv0VGxAp8/2vHlLgOMFyrOys8/FsAaQUKmUI+dYd3K8qBjbgtWTziF2R/2jKiw
         InFfa8bNh12RDv4rT2yPYrWeqUgJYXRKZqExTeUEv+U0Tj7DA4DZtELRECqSkw+XVnRg
         Xw4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z6iaB4PCz9gZx05Kn+SlYN40/DtxMK6Wv5kNuPofiZY=;
        fh=SILnxcKGBy70REjH6P0H3cbmyjml11smbiCxbV4lYZE=;
        b=AgNwLV7EfCDeDW9QPlcOGp/Dtycb+jCZAeKypc0B7tkgCV6Ma6Kar4KLkYRLXovKRS
         AvFXvti55yU2OygSAJA/8QFR+jw1Xo2ETcWwTLRHhS/j3Dwk7gGmJepKSD9HY5MyD8N3
         spBT8HTdm4DfUMilnoMIRcwEiQu8HAqhhtUXvvAZZyzVPXJ27D1/vFQn7me9GmujRlo8
         snc3kw1xdleobQKt+UmGk95bQkZDWnofGFF6cvQjmlIZJthQDmTM6Y00FPuabq0oKpIa
         H/ceJnP33n1TipLEf2gpUkoJpvOJv2xUgEqVwfyRbqZdKTYJm379Bxkcnngkf1CXkIOK
         X01g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786841046; x=1787445846; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z6iaB4PCz9gZx05Kn+SlYN40/DtxMK6Wv5kNuPofiZY=;
        b=dndlf+Bogz1E9bSDLvplLJdOxI9Uo2TWVhE3wUqGYAzyW8Y/E1scNsK7cMzHUZ08H2
         UtAw/chPqdqtdde3mXGynGjucChrD8g/9Ftx11LZgqP2V6vrOISWcmSe1J9/kD5xd58g
         NhkP6zs/DfhPNsXuUtX6NKHRadiQ/ADG+hHC+sT3oelCwUu24Gz+UkQyUbbfTbxr++fA
         vqiRh6yWThhj77Zqa80y8IxQ3caFeLRjM+rIrSNK74uWQuFKe8aIwq0A+rvvma5cawQg
         I/ApJrj5WRdqe2QUj7Y9O0GGcPoRbbWPLm0A4qdYyzZy2KwS2NkMfwfNAXxNxwi0GdCW
         vQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786841046; x=1787445846;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z6iaB4PCz9gZx05Kn+SlYN40/DtxMK6Wv5kNuPofiZY=;
        b=JT47ZEbiJYneVdLhC7wt+QxU3ubxpVe9VGRiJUJq/Na0EHOjqv+d+F+T1YEDCJcf5W
         g8sru1ooAOHFtkV3ysw8GAQQWfpeOww6In6rxxKM2N740q7754vFTmNVE0Q8GUJ8ck20
         MFaS+v8qydzuDfStgDraFjnifbQT1VzyWULcZ1yVBKl7N96Cc9/CoO+drx1OEOEfl9YQ
         DFWkfJ2a3+NT97Rs5EEYciPqU+l/LyoW0b9ifDaEPRioqzHmxEU9yat7o5zqGgJIc5dQ
         83ZjkAXyNjtvzX7b4K7JHz9YF6nFtx3nvOFkfaKpEcZb+gHqithfNkX9moU2Namm8WuQ
         x+IQ==
X-Forwarded-Encrypted: i=1; AHgh+RoyPA3TQnClrIzerv73Kf97VaUbjXKnY9U1uHaEKJ6qPCgW8aNyyKQLE25/Y9r4PBLeeMMSBgRw@vger.kernel.org
X-Gm-Message-State: AOJu0YwByeTcnbmaX5u8FGcW4tPhQcJs5LabS1oRrc7WnMU47EcVKiSh
	etbHv5iOEcKwdFlAPGZjD7QMBaQGTIwkSP92FjV3u+0P1g4KjTbDGSZjwmk2DkVDxYKMeGYGU3g
	PGe7M0q+L49DKgi0Bp6oP6lCl5Vp7S9Q=
X-Gm-Gg: AR+sD108ToXYAuybAuI4xIh3GBWkBwe4OOwHsMBDydzVD6lJq0+F+ELKX/5pz4RUegC
	5LUFP6OjxY4/9WmC0t9RFKNWGzjHj0hMSGL1L+pPsT20NT/XbW77OcMau08KdiYGXf/LlSKz2e6
	DJeBBi4b2JTVWXUu1VV7HOGA2/mrBzcLKJEzB5cYH/dn6BPlguuCjw38USHcio6lm2p6XLkbmkm
	WnX+WadP8HaqFhnDFv5ejqf9eZ2eLCy+T1D0OgeLo5q5pX2plmFObs+ny6SW7gRE58JzHfI7RHe
	JQhn+csmvFL7s9iZfwDpOTL2VSp9TRZZY+EluvnN+/L7WlhYrHkLE6fqvYUlKwYVj20scGRE/3w
	kr4oZm0mCiA==
X-Received: by 2002:a5d:5f8b:0:b0:481:4761:45dc with SMTP id
 ffacd0b85a97d-48160715e78mr24767349f8f.13.1786841045770; Sat, 15 Aug 2026
 17:44:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <20260806184254.3790858-3-nphamcs@gmail.com>
 <an85AJ8auvXQ3+nk@yjaykim-PowerEdge-T330>
In-Reply-To: <an85AJ8auvXQ3+nk@yjaykim-PowerEdge-T330>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 15 Aug 2026 17:43:54 -0700
X-Gm-Features: AcwNN1U63Z-1-cQDWvCFzi6HzhQd1KBrn1HsOOVGYJ0ezMThDvyr09qu6TnkhIk
Message-ID: <CAKEwX=Mrdk+6WF0s6gz-5N8rNPzz3gEgUF9SeTB4O78zXQcEKg@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 8:49=E2=80=AFAM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> On Thu, Aug 06, 2026 at 11:42:45AM -0700, Nhat Pham wrote:
>
>
> > @@ -537,7 +562,12 @@ swap_cluster_populate(struct swap_info_struct *si,
> >        * Only cluster isolation from the allocator does table allocatio=
n.
> >        * Swap allocator uses percpu clusters and holds the local lock.
> >        */
> > -     lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> > +#ifdef CONFIG_VSWAP
> > +     if (swap_is_vswap(si))
> > +             lockdep_assert_held(&this_cpu_ptr(&percpu_vswap_cluster)-=
>lock);
> > +#endif
> > +     if (!swap_is_vswap(si))
> Hello Nhat
>
> Does vswap actually come in at populate time?
> For free clusters (dynamic ci),
> isn't the cluster freed immediately rather than going through this path?
>
> If it is right, then just validation seems good enough. (assure vswap doe=
s not come in)

Acked. You're right I think. This got me staring at the code along
this direction, and I discovered another code path where I provisioned
for vswap's sake unnecessarily (cluster_reclaim_range()) - will fix
this in the next version.

Thanks for the review, Youngjun!

>
> Thanks
> Youngjun
>
