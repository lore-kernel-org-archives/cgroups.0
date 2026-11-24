Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795528212;
	b=B/Co1eROCYDgCGvCHObja69RR/zvJAXP1X+piWUHIoMvUOPebXeU2cQ/RGj6wXBSQ2pi
	 ltUJTunPreU1wSHMTTRg4oVMxaX2ZVXvzsdLTQ1KfVFpDw8gOTzsjGiOs48deHMgXd1KC
	 ydn7y+tP/go4mQhGES7R2LD4exAjWO1vu0cWuIHWkzlLtzyfA89vjAArabGX0j3INmbAa
	 hsUQIxFFaTea5CjCn3bKwDmwahzwdmwMe868Usd4cU8QU0c+/GmMVESa8UM7FvLPe1ASg
	 yjmTt1CVQBv2TDTuQV3JKfF/O1WAiM7yUo7f0611B9bu2QoLLdxQaXqFMgJOTb6+0lA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795528212;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=XTPCHg4unEN6vtUDvCIgxfYMZVabwQIC4dv3+3CL15w=;
	b=YiM7sDEQT9ZiwlO8z7HRO0BgNBUDSHK1K/BUPgjYUp65wDYmlVt2mKapEkZQK9o91EgL
	 k3GRWAOTBGd54JaACv07vJmX9HgCkU13oiLK52nuqWBO60QnhkGdwCZPo6Mg7WN5tYgrK
	 YDPoZBsaKQnPl4uDWOl230SxqQptO5zctlBCVhNC17RyS/cv1e0YQ1fe70M6i+PbEI3Dt
	 +NATSyzZth/e1+dIWdtvtF6BULBVRQayy/d2GasL8EEiiqqU7tGoVblQ0W8pSPgjU3C2F
	 R6gzF/FUsQiQF2KDQ0lGw/03U2ShqZOT1pZ0Zjdr4cS3ezjeMPG6pgvzYe/IzlZqXCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=A8I4Yhd3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B7E606A32A
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 13:50:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90B7E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=A8I4Yhd3
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso2913236f8f.2
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 05:50:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795528211; cv=none;
        d=google.com; s=arc-20260327;
        b=LxLBGqruHv7t/v3ll7mV7b9SeCIuqMrzbOWBr0ZOzfVt10MTjZlIA2cG+LHWABxnBK
         cqQMJExO6JNWpih7bTb1J1ty4LmTVFPuruuLrb5Tc4ASt1CRAFl9cJ8wHHbq5WrvEoa8
         YwwTQyEkVmzOoavZJR1jt4id4zFFHzreMaBBxnJURP9YnvTxZa5VnFmu4OFkPJ9Jxr0/
         y/DXxvLK0mh8gc/B628iOQpTk92ag1wN/0X6WDStnc+zZJH8gTRCXAF6tC5BpiMo/LBV
         US3VO82ISWNicdZoFUAM68XVWlivC9d4gcZnTdDFs9/wzSr4QS+RbqPug/CLwEa0nSrT
         XYRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XTPCHg4unEN6vtUDvCIgxfYMZVabwQIC4dv3+3CL15w=;
        fh=Bk+ehoYbvQydRI7iMdHr8CBcNhLdDizQMJnXFM45QX8=;
        b=BIhGEIyEebbtLq8zmuhSnx1ARZ+EdzKwDutWfpPn7J8ooyDNO2Coy2wYrlT1DqIWVb
         unTe0e6jt+LMzpIhNLnfyJnc2vvM0ahJc+U4UrstQH1sc8MxAVePRhN/3CegP1TK+ZgD
         i87RUSzKORZesWO+aHHSW1SZ3brcEm3sC0NeyIq6GIDAqKXdIkz5XG8wwpWWPpakpB2W
         muNVMBXC8SxfCZ4B7FnZiByy3mwpYKofnY9K+UFPv6L6BxQzOwwG4phVXGA5/Jji8QBy
         8Q3mVvIJqvk4iNzBpT299XacVSrAzc/mSgXF75IYc4BQGWsmP2sHE/Mt10yvOwJwBrM7
         3eAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795528211; x=1796133011; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XTPCHg4unEN6vtUDvCIgxfYMZVabwQIC4dv3+3CL15w=;
        b=A8I4Yhd3hz3WrVqqp6QMzsDrRJ3HJpUPxahpoSPUafEcj3SFymXcsAZEIf+a8ALG0Y
         V6s6xA+Ay4lWI9NhS7nxfL6F29mbmiE0uOfCYQxnOZUS20qgiOGqYoApJy9HRpK68tu/
         HSDE3IpIQJQ4GKB5Z7mVIff3PBnaum/E2gzkgJ+jFNG6YlWz7P5hX0VEOjoFbkoF1lDn
         8Ndrqr7MabRwOciYR7MGfzUJA7NWdJsl6TU8hPnym7YlbmO7JaMnO34+0kr0IDyXTgzd
         2RYMtv2kGAXDO2iT8hQ8hVHgIcSefON4ja9k6LVugyoh7mCZfqIgxnZvX+r5RFBAMb5n
         NOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795528211; x=1796133011;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XTPCHg4unEN6vtUDvCIgxfYMZVabwQIC4dv3+3CL15w=;
        b=rMd0s6QxyXURDfTPYPAb5WhkyRTNWHw/WOHbHD5xC9oqtvDglDBF4Els6VP8bQAihA
         RnTfbxCytl1h7Mfm6vEg2+q1JYu7xI36veDi+MYebRV9MHg+wQTpAfhAQtJ4s960xfJf
         2iYMGlXjDEA6wi1IiNoA6yY2nOW/qSiGdTOZ/6Dung/g4DFB98GmmAhAvrj3Ef1gYPAF
         cGlZ3nzaPgrRpA0JO1cnEw1q//SCgGzLIff1AGZpl86Dy8LjGHKsh8FVXo30Z7RBolyO
         neKdWrQNLT12LEdimNYhuHugAuGl2OV02yeDXZ3qRKRBiAzNRKdM6hpsiCQ6VnDD7QCb
         yQwA==
X-Forwarded-Encrypted: i=1; AL+hErG0m2ZYb3xJLS2y+qHErsMo/EAWEAbgmcVr5h6gvtqzA6QSae/QfabJtpal7yL/dpCZsX9PDtU1@vger.kernel.org
X-Gm-Message-State: APuU4Z/ZHU7F/JFAHuXlknT9JvWoWtHiPv16mp0NLENkwyQQjOM6QAB2
	zudOqhEqEn0gLyPR2AnH80QgYWGoVCH5UwfawBXkNT8+XBDKs/ZZhf1d4hz7kdsrAbInikZxDxd
	E6/+J2/+eHExGypldYwKCIlMThar4F2A=
X-Gm-Gg: AZFdTZelEWGn36As4p2dJ05KaUbq0yv9aNvlNVzjWwSjgEktIecgnPNplI6Zy0JA+wF
	OPJpR/mqyGGCOLGdt6EK7bwwLZR/VLBBicRE6iv/Q9EvEJJ26y23F8Ho35Gf0wwgxmpn6x1Q7MZ
	qR5/083Q6Q3T7XkxXwe5+sCTs5tTCLUYvF9hB9C9Dfwmhq0464YwhjwcA6v459sBI9C6JwGAmN9
	u/oigOzVUvoamDpboCGJkBHMdNJKdsshSW7Ck8S2gors72/uYWH7jT2jYEVj5xZOURTysk1B4LB
	gFCBFIV8rEuy1Q3huj3C7/dr7uLVEUlKfyUHbrODsDomMGI8YhzKLIsFPsOmRouZeVNPYn32VuJ
	k41LZnwy5ZviaoNGN6rk/kkv6aZUrPm6F7+f76k+gN50tNAB0r2vA
X-Received: by 2002:a05:600c:800e:b0:4bb:7757:fe58 with SMTP id
 5b1f17b1804b1-4bb8881b9d7mr305306125e9.19.1795528210579; Tue, 24 Nov 2026
 05:50:10 -0800 (PST)
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
 <20261124-v2_20230123_tjmercier_google_com-v6-6-dce12fa03ad6@redhat.com>
In-Reply-To: <20261124-v2_20230123_tjmercier_google_com-v6-6-dce12fa03ad6@redhat.com>
From: =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Date: Tue, 24 Nov 2026 14:49:55 +0100
X-Gm-Features: Aa3M54qkPJ8C4GRzLQzCC_QtBShd4rpGnT89RPbtOkkrzzkAiMVQPjTTZfQmmls
Message-ID: <CAJ2a_DeDF+9pbLKS9pcX4Tot4xZZ-K7HydKnDjW6TWC5bvREzQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/7] selinux: Restrict cross-cgroup memcg charging
To: Albert Esteve <aesteve@redhat.com>
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

On Tue, 24 Nov 2026 at 14:05, Albert Esteve <aesteve@redhat.com> wrote:
>
> The security_current_memcg_charge_task() and
> security_current_memcg_charge_cgroup() hooks allow security modules to
> control which processes may charge or transfer memcg memory to another
> process's cgroup, named by a pidfd, or to an arbitrary cgroup named by
> a cgroupfd, both passed in charge_fd. Without a policy implementation,
> either hook is a no-op and the restriction is not enforced.
>
> On SELinux-managed systems the only limit is CAP_SYS_RESOURCE. A
> domain that holds both dma-heap access (today's only exporter that
> opts-in) and that capability, can charge memory to any cgroup outside
> its own subtree. Since the capability is all-or-nothing, SELinux
> policy cannot express which targets such a domain may charge to.
>
> Implement both selinux_memcg_charge_task() and
> selinux_memcg_charge_cgroup() using avc_has_perm() with a new cgroup
> object class and a new charge_to permission. Both charge_fd flavours
> ultimately charge a cgroup, so one permission covers them and the
> target type keeps the distinction: for the pidfd path the target is
> the referred task's SID, as there is no cgroup object to take a label
> from; for the cgroupfd path it is the cgroup directory's inode SID,
> which comes from the genfscon entry for cgroupfs unless the directory
> is relabeled.
>
> The checks run when the charge target is resolved, before the
> CAP_SYS_RESOURCE baseline is evaluated, and apply to every explicit
> charge_fd target, including the caller's own subtree, so policy needs
> a rule even for self-charging. Policy authors can then grant
> cross-cgroup charging selectively, for example:
>
>   allow allocator_app_t client_app_t:cgroup charge_to;
>   allow allocator_app_t cgroup_t:cgroup charge_to;
>
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> ---
>  security/selinux/hooks.c            | 19 +++++++++++++++++++
>  security/selinux/include/classmap.h |  1 +
>  2 files changed, 20 insertions(+)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6c4c64d6e904..76a714107ae4 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2204,6 +2204,23 @@ static int selinux_capable(const struct cred *cred, struct user_namespace *ns,
>         return cred_has_capability(cred, cap, opts, ns == &init_user_ns);
>  }
>
> +static int selinux_memcg_charge_task(const struct cred *to)
> +{
> +       const struct cred *cred = current_cred();
> +
> +       return avc_has_perm(cred_sid(cred), cred_sid(to),

Small nit:
`cred_sid(current_cred())` could be simplified using `current_sid()`

> +                           SECCLASS_CGROUP, CGROUP__CHARGE_TO, NULL);
> +}
> +
> +static int selinux_memcg_charge_cgroup(const struct file *file)
> +{
> +       const struct cred *cred = current_cred();
> +       struct inode_security_struct *isec = inode_security(file_inode(file));
> +
> +       return avc_has_perm(cred_sid(cred), isec->sid, SECCLASS_CGROUP,
> +                           CGROUP__CHARGE_TO, NULL);
> +}
> +
>  static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
>  {
>         const struct cred *cred = current_cred();
> @@ -7683,6 +7700,8 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
>         LSM_HOOK_INIT(capget, selinux_capget),
>         LSM_HOOK_INIT(capset, selinux_capset),
>         LSM_HOOK_INIT(capable, selinux_capable),
> +       LSM_HOOK_INIT(memcg_charge_task, selinux_memcg_charge_task),
> +       LSM_HOOK_INIT(memcg_charge_cgroup, selinux_memcg_charge_cgroup),
>         LSM_HOOK_INIT(quotactl, selinux_quotactl),
>         LSM_HOOK_INIT(quota_on, selinux_quota_on),
>         LSM_HOOK_INIT(syslog, selinux_syslog),
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 90cb61b16425..1f1f2fc4d35d 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] = {
>         { "user_namespace", { "create", NULL } },
>         { "memfd_file",
>           { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
> +       { "cgroup", { "charge_to", NULL } },
>         /* last one */ { NULL, {} }
>  };
>
>
> --
> 2.55.0
>
>
