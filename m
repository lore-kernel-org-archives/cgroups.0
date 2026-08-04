Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B55D42AF88
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 09:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785834174; cv=pass; b=pTLV2yeZ6hla0ofR4JPgExdgYQrXw/8mKODIlrxlT26UYUbgEGlTJ3Q0gMe8/gNaRIaeFjUqBBdK+6XoBvmRtt9hfIAhiN70fxgFLlrhmklOK6MyWZdKxeJj+B7wNHguakpcQWcx7q9d4cxV5j45N3kdzaHSCOG+trfhYMUXGes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785834174; c=relaxed/simple;
	bh=R7jVHNmBM0eBYoWDUxnQQaAUT1i07hDcXmJlNwl2ogA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nejVeMQjuzmZOcgYzy7+lKlqHEhoRbAVbLK25BRVLPK3A8lbx2S+aEV35O/MEnfxyVPDCq28OOgZnGMfXQVlbx5DwgsA1S1gqYLpp8+DKRAk7Tr36HkSSJ5LQ2r1X4RRB8XMCAvHPmwfSFKwg25SNLDDo6lOv2Jp0NimsQkeroo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AbshysIc; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AbshysIc"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1f7666a90bso641832666b.3
        for <cgroups@vger.kernel.org>; Tue, 04 Aug 2026 02:02:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785834171; cv=none;
        d=google.com; s=arc-20260327;
        b=q/KHZJ/itoKu+NJlN7B9+Wwqkyehrs59aJkwT1zOG93+fBAi73qWLr3+X0aJ3Hjp5e
         hJM/7giwiY6+M02k3TqZK4FYJsUpCoP4fAJc9JlrkaenrTBMWpFOKrAzXWGw35ygtqvw
         m6SXuRUfaF6uMQV2YoIxDzsAUJgPPZ4G9Vi5KvVgQhZucirUaaZebEdCpAspsVIoJzbz
         yI1TGZVEkve4h7loA8pXKwwpa7TyMPRkE0i83RjnaJFzx6C7EsreLtrdEHnoy9pLmwQ8
         Uhb1R0jRowQKStv8xReo4W+d/rJF4SxldHDZ6oslpiaXtkLIbVWG9HsETJ7klZptW1Sq
         /t+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YPbJVpEvEjkzXxApzbzq9RcS5e8mgRxGKQKifiE/dUo=;
        fh=n9pXZUqbMqBqW2FDkVJ4mD8zRnAk9aKARn7QTNsx7y0=;
        b=gz5lC11u9RWjdBSiXiG701UuMnF/JYk3swxG4obH38kOFyvCDSnjQK9It8+PEA5MbF
         49l6DYt5KTOIY83+gOPfRh9VWdyBoGb0c2CQlMo97hVnqWp2vJHZU4YAVfyAgFvTVB+6
         /CZGa0YuJb1ab7fk2ndShN/Bmb1xZ+5o5tVxpY2ia9hncnwvWueUywMuIvgYvUe8/tOa
         JyiMi0uonRBIA6gldGW0xgJEuTUJB4sORXUW8rUG1DgeVgmojnXDk4sLipfMiIOc/XoS
         uDP2C08cgUD16r/b2cNjaf7vocCIxyCqNVyPEpjJpdWsSfEg0HWmLYkqYkfDeQeDVMuB
         dbKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785834171; x=1786438971; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YPbJVpEvEjkzXxApzbzq9RcS5e8mgRxGKQKifiE/dUo=;
        b=AbshysIcAupdsHrUv92HF56NSyiUgd7lc0YZ6bs9vsP4SnO6/N33zYrAst1d9rwFRk
         868v7FiL3rdlcIISwWzw5VptifSTDqQsoMlVk5BxrrLpPAn4xmDvWk5You2urD7rsk+6
         5QfmcEPua1fsOT2+Zmcq0ULEFKNuzE4WSffk/k1rZMKHHq3q57hIalWP/zbxxLYuFZiQ
         8EyWmMFnZVQbmFfGcznqbIcojKXqShutoYt7cKrJtmCqQuxc7sksEW3WpZJOvtDp9G+a
         fVkbuNUftbFgfzRynIq6ge3+Qxpp8SNGMsdJo1uyg9CBeRO6FIpAnG6hyfl3ZNwnV5ti
         Wa2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785834171; x=1786438971;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YPbJVpEvEjkzXxApzbzq9RcS5e8mgRxGKQKifiE/dUo=;
        b=j1HF30/NLavs0qLbXH3Q0NwBM4z2nFtNdip8FDxt/4L25/AdWlJc1PN1qUDXSkd+R2
         Rn/19B4qgnJtVfI2zZQIGy6AWTEhuE8BZskz2A4ZZX/annGFZgwUsgltwbA9MqmDO6tD
         39/BSNKeF5ay9AtE2m3jHyqOtsTjxaKZknvpnzwbC3RuBDJCNa/bYPoh7FDbkSveXHxa
         YWHjRW6NErtdt46OmmPMASrKn76H8Rmk3ShQDnTBAYnltK8LqpT2MlfdfEmd6lfFriTQ
         47n8A6FTwmau9MdhZjIehE8sQjMfSOXcHaLqK+E3abIuAvw8njm8J8XNRP2mz+GDV3pO
         YUpA==
X-Forwarded-Encrypted: i=1; AHgh+RrOspHxzkkMiYGDmPAmKhCtsD47We08Q4fLaXaWCyVm7wtWDNj7oJOLq2ZNSeyJOgShVzprbXqO@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbyy2EQEpeT+sinveaT7pVHWWH0kP8P30gjnWVvoE9/IwQY1gA
	ivejYfw9tjxpzr4ncS82PL5RUucolWFCFbH9BejEGg0rZYPnQearOIqDyDv9K6aRyWVb0MXBiU+
	xqpurwyVW7aZfcCx9G+asRyXr/3ttPAQ=
X-Gm-Gg: AR+sD1234Ci+MS7vJAAgdfVtkp4jpduXE75fSCpAO7+4MtNY7vWYz5aDQ5iSU9RJbMO
	NfS0ZpQ1TKOoryGYwWNFPgbZ+IqVipTOwSDz/y+T8TUpKNm+AtxvlROqzTJ/63Vha7tEf9u/4tr
	8V/tZkP1NwB+iJXIHTRWl10nI9lJugLOdFupc5+9wSPXJyDJh8T/7T3Du5Ff1hn1pNxgveslaHr
	n/yQv/YxZFGxy/v9nI+9iD0EJQQcWxLyVd5/VbbXj32VXG7kT8HuJMQv7o7e6+JvdAoC0YiMCgL
	0wuQSm/VvrOXQ7UGkUS5bEUdrYcutQ1YfMhf/T7GGif/oaxhW12E2cXmIFyOuEBGTJ4RZuG3uRV
	V4Q==
X-Received: by 2002:a17:907:e1ce:10b0:c12:9e83:643 with SMTP id
 a640c23a62f3a-c1fe80ba536mr808031866b.10.1785834171124; Tue, 04 Aug 2026
 02:02:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-10-4d8dad39dad6@tencent.com> <20260804074935.99991-1-lianux.mm@gmail.com>
In-Reply-To: <20260804074935.99991-1-lianux.mm@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 4 Aug 2026 17:02:14 +0800
X-Gm-Features: AUfX_mxviDVSBKqghaNUDy38yJaZv8oXyPQGSGH7tKu81ajWJM1faZVMEvEkl-k
Message-ID: <CAMgjq7Au8ApkQM9t12WcX3VREb2Xpa8o+KDKK4A4bDtzhjr36A@mail.gmail.com>
Subject: Re: [PATCH RFC 10/15] mm/mglru: make folio lru referenced times count
 a generic API
To: Lian Wang <lianux.mm@gmail.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 3:49=E2=80=AFPM Lian Wang <lianux.mm@gmail.com> wrot=
e:
>
> From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
>
> Hi Kairui,
>
> I am trying to understand the intended semantics of making the referenced
> count a generic API, and would appreciate your guidance. My understanding=
 is
> that, with the new encoding, raw PG_referenced and PG_workingset users no
> longer see simple boolean states for every reference count.

Hello Lian

Yes exactly, actually the first thing come to my mind is DAMON. Now
folio_inc_lru_refs seems a good way for DAMON to feedback hotness info
to MGLRU? It track the referenced total number count, and handles
promotion and refs overflow internally, and affects PID nicely. We
don't have a similiar interface before, folio_mark_access doesn't work
well for MGLRU for this case as it has very limited effect, only work
through PID feedback.

>
> A few examples I found:
>
> - damon_pa_pageout() still calls folio_clear_referenced(). With refs =3D=
=3D 2 it
>   clears nothing, and with refs =3D=3D 3 it leaves refs =3D=3D 2. Thus DA=
MOS pageout
>   may retain workingset history instead of clearing the MGLRU reference s=
tate.

Right I have a patch before:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-20-913619b014d9@tence=
nt.com/

Just didn't include it this time, series is getting too long...

> - EROFS zdata uses PageWorkingset() for PSI accounting. With the new enco=
ding,
>   the PG_workingset bit is clear for refs =3D=3D 4 or 5 even though the f=
olio is
>   hot.
> - /proc/kpageflags exports PG_referenced directly, so KPF_REFERENCED appe=
ars
>   to become the parity of refs rather than a boolean referenced state.
>
> Are these semantics intended? The DAMON case in particular looks similar =
to
> the madvise conversion in patch 15. If my understanding is correct, would=
 the
> remaining raw-bit users need a tree-wide audit together with the API
> conversion?

I think most existing workingset / referenced bit user can just
transparently transfer to the new layout if I change
folio_test_workingset itself instead of conver the users one by one,
and my bad I forgot the EROFS case this time :), will fix in v2, I did
convert BTRFS though:
https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-11-4d8dad39dad6@tence=
nt.com/T/#Z2e.:..:20260804-mglru-fg-v1-11-4d8dad39dad6::40tencent.com:1fs:b=
trfs:compression.c

And MGLRU's previous PG_workinset certerial is very different from
CLRU and is already causing inaccurate reading of PSI, the new design
actually aligned the PG_workingset defination with CLRU. For
PG_referenced, I actually don't think that flag was really useful
before, because it constantly gets unset / set as the folio is moved
betweet active / inactive for CLRU. The new layout still mostly aligns
with the existing MGLRU design for that referenced flag, and I think
it's clearer now: once a folio is ever seen referenced, the flag
remains and won't disappear (unless some user explicitly needs to
reset refs for some reason). And refaulted folios are definitely
referenced unless they are readahead, and we can try reporting
readahead folios as not referenced if necessary.

>
> If I have misunderstood how these users are expected to behave, please fe=
el
> free to ignore these concerns.
>
> Thanks,
> Lian
>
> On Tue, 04 Aug 2026 03:47:06 +0800 Kairui Song via B4 Relay <devnull+kaso=
ng.tencent.com@kernel.org> wrote:
>
...

BTW I suggest you to trim the tailing part on reply, that will make it
easier for others to read the mail :)
