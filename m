Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795623312;
	b=mxo0oeQ5hbnFXJbtJv4BRUygZ3FGpJVgpu1fIhQ7jOnMDt8rn1OcMuoskePEUqawvY43
	 kDICpYnB2jIHYryr8Dos3Ig7k9GeGwo/H5XL6KxpVRxBO1h8SkbHvu6crfLAVdXCZFzmT
	 Wzz6XUEKHmS+Vd2p/9uy1g9UB5tQatiO8oLm2ZvBqnpjfgmZk6fyFAEG+P43t95+90Xj3
	 0wiUMkUMM+Sz+IsANyvNqXwSKXB01YbBMC2XdbRUSb+2rr+cD9rnzuiyIzC7MF6lOIKbt
	 SYyO2V1S/pyD/zK20zr4GS3yb1l/Iki8W9UAG/97Qm0tQdpdiBPKl0C7voiagukBm7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623312;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=ikIAQDWUd4oIdUiwPTrXqLa3Yct6IL/NQnfK5N4xiCQ=;
	b=r0bZkFX4Dq1wHVpp6xk00g9KjBpt3tVng1fHNqczr1Vu1NVETZ6seVwCunAy2y/nt/9n
	 tmAa6NQSpTgmeS41ccZeAT3NWWuk63DKZv0cEEtJH4m4spdfdMwIIFbmYih4FZcrOSDiR
	 /UdD0NeS9q0TIuCafYSTVe7KXGs11ZRYlSVSXVO4Lv086Zm/9uDzQBUQ6m1C4irVjwIV1
	 7kF9baBXgQnLt1fsQBKwd2DmRMdy7IMtMwpVLLp/IbMtK23Oq8k1ZpzcczF2zw0zk6Hef
	 l6Auyf50Jfd/SauGVrEQH5UoMPEBh3QeLNOoLRr/4W/aoVmR7CIsLqxw9lyMsaRoBdg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IdTL0HtM;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Oaboe2PV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D74606A326
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 16:15:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7D74606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IdTL0HtM;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Oaboe2PV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795623310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ikIAQDWUd4oIdUiwPTrXqLa3Yct6IL/NQnfK5N4xiCQ=;
	b=IdTL0HtMlI+wajX32FgXTOb+xjON5XrkAujWRoeb5Lq67DamPkhlDy5WQTIm8JBsihVQgb
	AMTIhnK32ZXqcyMcdjMxwnPvE0KsfrUcEwxu7fuIndz53HnTQ/0UKu30+fJV5CfdduNxMj
	qAVrMyctzgZiuYiQtGspRhW6hnU31b4=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-OGAA5US-PGiJBIvbyyvjFQ-1; Wed, 25 Nov 2026 16:15:08 +0000
X-MC-Unique: OGAA5US-PGiJBIvbyyvjFQ-1
X-Mimecast-MFC-AGG-ID: OGAA5US-PGiJBIvbyyvjFQ_1795623308
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-5727b04b81eso3780089b6e.3
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 08:15:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795623308; cv=none;
        d=google.com; s=arc-20260327;
        b=ERQLAC8nPohUzFT87ZfxRlGw7jZzQdBm5AnMq/S8RAsiNDxPhQbHSB9pt9uiruEeXo
         ddfFzK5GvQdg5x/3fYCKnQw3TgDoHQaGfwrtJOX9TP9jXh8o8Rig63/2X82IKAr1u5ND
         ZmhJegt4s9WNEefba+Q8zH425CoW1UdgbnudEhGlm8T2QVe+bBoI/4JUa/qWcAMsW3vJ
         BZ1kX4tc9MjqkXQEHJ6VUH+vObuj5CXjk/QB3f1wCIYBuFm4lrd7GkXMtao0TlynJ6v8
         0pGLZ10C6l582zdUy3NAy3ED9l/fKX18bDSpd52Zp5vV+8qZ3T41PNgZFp2n/PBhP9de
         h6dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ikIAQDWUd4oIdUiwPTrXqLa3Yct6IL/NQnfK5N4xiCQ=;
        fh=sOOZ55HvTBp8CIMZpa0mgvteWXzELyCio+epOUEssb4=;
        b=UZQfDnI8mdpEwvaQBPBC61WB2ieP4omDdQRihhE4UMpBBe/pRFOtZio/yAd+s3GO0/
         7IwSsX43liNBhC04EhF6YbyR+SOJnj0MX7DMugWEV+/nWjQ4S1o1ZDWGEErnjyiCVWh/
         5tgDn4WPjzfRMHqC2wRsGCo/jvEwfFvrOCJ2FOrn8lMrogpPd4k5/uxhtDKMnvzp4z4m
         RduVhpaBMlJPUhGBs+kSl4Tnf9LCiVVg0vz805ED8J0zXPaNyq+HdjqWI6TLxq25JEw9
         56tDvFr03ZaB2qK4mU4lN14MhEEbqO8lfyxuQp/vZXIryjVqPvbf6EW9kFhjoEhcaQW4
         SR3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795623308; x=1796228108; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ikIAQDWUd4oIdUiwPTrXqLa3Yct6IL/NQnfK5N4xiCQ=;
        b=Oaboe2PViWEq0So+RnJIvBpWv2oUca7oKSNLSN5zUE12qFEh9X86SM5/OLsXeOXi+6
         RWkCRzvujLvMNWJImzFyaBBUfHz1maUpS0OWk2uzBZDHGMlpdEYjbxXJ2/ub48Gcp5EN
         woInw3NN9bnwKGBS9YGiETO6kydhsqpStsdrKsuPAIGandvGDLJdMi2WiWkDptm0ykgn
         nQTgHVDIisjPhEXWyy8MXTwdSBHfelPMk+Z0oAPzgzbQCKQbhYIA++VXiZ5yBcE/NYl0
         PGAVVsQAVIC5XVK6XfJv3BPY0hpI6cDWN+S2bBdFA3W9MQ73CncOjT+pWt4x5GVmWR4j
         6P3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795623308; x=1796228108;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ikIAQDWUd4oIdUiwPTrXqLa3Yct6IL/NQnfK5N4xiCQ=;
        b=1j+923izAAF56N1N5Bg2LETI8hCTaH+tHh5cUwwUQ+TX/2NieKc88bj/kibSQ6gHmZ
         K9o5gBKW1Cp+jhhTJFIGmVFdkig7Ab6Fx8CaQ+0y6zywgZnjzMljVKgbKKoSrxzyw/z5
         HDeUqJzVSE6vCDsFxLCeUI8805FuyA+dU07h5CRtFi5XOIzwYGpfFARmq4viik65t5qU
         HgkWEbybwXNUXNlLShlEbx3337DYsMiFiYJq+MTchY29Ae69yvz4K9Ivi4ZQrugK15Rr
         WLQ6qbOa0g2brVSTWlU8tsLr2JoQITpRxksJyJwUWxeha2CWV8W+KymwK3VW5uLD1H7u
         VIqw==
X-Forwarded-Encrypted: i=1; AL+hErEttzx4Fd1CxwoR5pzaIAFpXK3e5W7XZD2Aas5MEyf0arBfO2OOR4Xx8WsaM91DoaPt2AlMivLR@vger.kernel.org
X-Gm-Message-State: APuU4Z+mMwxYsaNsNKMRA46hx271bUc23I6az8XSQS8HwEyrhf8b84jp
	0fEChKGE5WZyoZnBEt9uOfrj2/HW2kUd5ftBv8NxWlTyxK6Dm/pjbd+HFGBK3/xSWpDE8nL9qxF
	BpAtJ7vUYo3wbp3jltfGU8r78yQZ4xOXGI6dBWQyXbOXdjXraERyzpCT6bmcS9QaaF+soBQay9Q
	NnJclIZ7z7XA/OgmIZ5iepHA/TU26UZkWiNQ==
X-Gm-Gg: AZFdTZer7bI53em3ZAd3sJyQty5ry7x3ExVKtOEYPu7m+p7i3o5uKCEqmHzdIGnTvMe
	Kg44okQOdn+bj7Eg4cp+2nsw7qUK766xP4u6C3DqElSZfL8J6QoeHsT+ncGyqAGpJpCHxAUCusF
	H//Rybb0Ipw14LBU8fYqLPwe888r8TBxKzhho5EfCHTgtCj8v/UkqDdcgz
X-Received: by 2002:a05:6808:1a10:b0:564:48f3:dfa8 with SMTP id 5614622812f47-57a0a111c93mr20349857b6e.11.1795623307660;
        Wed, 25 Nov 2026 08:15:07 -0800 (PST)
X-Received: by 2002:a05:6808:1a10:b0:564:48f3:dfa8 with SMTP id
 5614622812f47-57a0a111c93mr20349798b6e.11.1795623307221; Wed, 25 Nov 2026
 08:15:07 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
 <20261124-v2_20230123_tjmercier_google_com-v6-6-dce12fa03ad6@redhat.com> <CAJ2a_DeDF+9pbLKS9pcX4Tot4xZZ-K7HydKnDjW6TWC5bvREzQ@mail.gmail.com>
In-Reply-To: <CAJ2a_DeDF+9pbLKS9pcX4Tot4xZZ-K7HydKnDjW6TWC5bvREzQ@mail.gmail.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 25 Nov 2026 17:14:55 +0100
X-Gm-Features: Aa3M54qg8B1tVY9MI_hj21-3fP47U-BOsj1Lrj8qIxJDIaifgpgCHqLTs9bOP0k
Message-ID: <CADSE00JMSXm4Vi5aH=k3VgLL__EsdEZgg_PqkSkK0LQumj1SUQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/7] selinux: Restrict cross-cgroup memcg charging
To: =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>, airlied@gmail.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org, 
	echanude@redhat.com, mripard@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026 at 2:50=E2=80=AFPM Christian G=C3=B6ttsche
<cgzones@googlemail.com> wrote:
>
> On Tue, 24 Nov 2026 at 14:05, Albert Esteve <aesteve@redhat.com> wrote:
> >
> > The security_current_memcg_charge_task() and
> > security_current_memcg_charge_cgroup() hooks allow security modules to
> > control which processes may charge or transfer memcg memory to another
> > process's cgroup, named by a pidfd, or to an arbitrary cgroup named by
> > a cgroupfd, both passed in charge_fd. Without a policy implementation,
> > either hook is a no-op and the restriction is not enforced.
> >
> > On SELinux-managed systems the only limit is CAP_SYS_RESOURCE. A
> > domain that holds both dma-heap access (today's only exporter that
> > opts-in) and that capability, can charge memory to any cgroup outside
> > its own subtree. Since the capability is all-or-nothing, SELinux
> > policy cannot express which targets such a domain may charge to.
> >
> > Implement both selinux_memcg_charge_task() and
> > selinux_memcg_charge_cgroup() using avc_has_perm() with a new cgroup
> > object class and a new charge_to permission. Both charge_fd flavours
> > ultimately charge a cgroup, so one permission covers them and the
> > target type keeps the distinction: for the pidfd path the target is
> > the referred task's SID, as there is no cgroup object to take a label
> > from; for the cgroupfd path it is the cgroup directory's inode SID,
> > which comes from the genfscon entry for cgroupfs unless the directory
> > is relabeled.
> >
> > The checks run when the charge target is resolved, before the
> > CAP_SYS_RESOURCE baseline is evaluated, and apply to every explicit
> > charge_fd target, including the caller's own subtree, so policy needs
> > a rule even for self-charging. Policy authors can then grant
> > cross-cgroup charging selectively, for example:
> >
> >   allow allocator_app_t client_app_t:cgroup charge_to;
> >   allow allocator_app_t cgroup_t:cgroup charge_to;
> >
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > ---
> >  security/selinux/hooks.c            | 19 +++++++++++++++++++
> >  security/selinux/include/classmap.h |  1 +
> >  2 files changed, 20 insertions(+)
> >
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 6c4c64d6e904..76a714107ae4 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -2204,6 +2204,23 @@ static int selinux_capable(const struct cred *cr=
ed, struct user_namespace *ns,
> >         return cred_has_capability(cred, cap, opts, ns =3D=3D &init_use=
r_ns);
> >  }
> >
> > +static int selinux_memcg_charge_task(const struct cred *to)
> > +{
> > +       const struct cred *cred =3D current_cred();
> > +
> > +       return avc_has_perm(cred_sid(cred), cred_sid(to),
>
> Small nit:
> `cred_sid(current_cred())` could be simplified using `current_sid()`

Nice, thanks! I will apply that for the next version.

>
> > +                           SECCLASS_CGROUP, CGROUP__CHARGE_TO, NULL);
> > +}
> > +
> > +static int selinux_memcg_charge_cgroup(const struct file *file)
> > +{
> > +       const struct cred *cred =3D current_cred();
> > +       struct inode_security_struct *isec =3D inode_security(file_inod=
e(file));
> > +
> > +       return avc_has_perm(cred_sid(cred), isec->sid, SECCLASS_CGROUP,
> > +                           CGROUP__CHARGE_TO, NULL);
> > +}
> > +
> >  static int selinux_quotactl(int cmds, int type, int id, const struct s=
uper_block *sb)
> >  {
> >         const struct cred *cred =3D current_cred();
> > @@ -7683,6 +7700,8 @@ static struct security_hook_list selinux_hooks[] =
__ro_after_init =3D {
> >         LSM_HOOK_INIT(capget, selinux_capget),
> >         LSM_HOOK_INIT(capset, selinux_capset),
> >         LSM_HOOK_INIT(capable, selinux_capable),
> > +       LSM_HOOK_INIT(memcg_charge_task, selinux_memcg_charge_task),
> > +       LSM_HOOK_INIT(memcg_charge_cgroup, selinux_memcg_charge_cgroup)=
,
> >         LSM_HOOK_INIT(quotactl, selinux_quotactl),
> >         LSM_HOOK_INIT(quota_on, selinux_quota_on),
> >         LSM_HOOK_INIT(syslog, selinux_syslog),
> > diff --git a/security/selinux/include/classmap.h b/security/selinux/inc=
lude/classmap.h
> > index 90cb61b16425..1f1f2fc4d35d 100644
> > --- a/security/selinux/include/classmap.h
> > +++ b/security/selinux/include/classmap.h
> > @@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] =
=3D {
> >         { "user_namespace", { "create", NULL } },
> >         { "memfd_file",
> >           { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL }=
 },
> > +       { "cgroup", { "charge_to", NULL } },
> >         /* last one */ { NULL, {} }
> >  };
> >
> >
> > --
> > 2.55.0
> >
> >
>
