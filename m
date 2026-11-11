Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794368771;
	b=Dh613Vh96bcSPbinpa6e9iYHDfeVOYuxi7F/mLN9G580G4e6FWtFF056WbAM1duR0/cj
	 mk0py80c1t/mbqrbmvy5CemCnqZby32bprJ/HpLwy9bBBV4hP632aj/wCSYM/1A8XKqBY
	 9xseFoLMKlN4VlSRjpkiMAh2jaS1KEVxoXAn0VBL2t4w0fqXG6JI9/KMrrv/rCQEabqRF
	 l56wgQ/hQMkEHd5ly9xD/Hy8VVU9UYIWt2QDv7HKK/CBXGIY42nYo7OE7YBIRylwWbwmH
	 rOyCHslVoTBuJZJRqFnI+dCzlApkGmVbbmPbJCA6j4Ywg++A8urRHVEu027xvWM3Ybg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794368771;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=RXpnzG8jc2yYtoFLBv7ZARt98Mz5wOXGm+EBvSjKUfM=;
	b=0eNaAHfWKXh7WyUpP1Bp4EO0xQHE06q6SQoqez1RawmkhQTWsZ6/9UPBxt4b3nMYO1QT
	 VmLg5fpAWDp9G4NjqUmGX4+86bmYpidiqw844bxlbJagkv2YHuRj8f7h2v9vzVXn+rhPs
	 xAki+4w6i6jAOo37vGK4XwHg9Z0ujdCAOE/JG1i/PYz9wmrbS3ar++toL8uePAzgKrPbR
	 EXh/fHcxJdQcJGJ9LvpxMW4lic5gPWEFarMBr9DF52VhrKALYTe5/Q8lsnMZDw483uZCn
	 s58y3fTjJ5wbVxSs7zKeOvPmjzpeukAfqVn1Azftu49XlLmi6Rxy4UlRGucoUMNSrtw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wDmRvi5U;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.50
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A91606A320
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 03:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93A91606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wDmRvi5U
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-67c6a0abc2eso327893d50.0
        for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 19:46:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794368770; cv=none;
        d=google.com; s=arc-20260327;
        b=EIxrl/CBHh76ASX8QeubV1gbD9/5fkIfufBW/Fpy/sXBbmoueVgD1R5UfC4AENDgCR
         qFumZvgbycgMcLkJPJuMvHMNA5SbA+EnF8q2eu4Qpm5fyE9DkMNLwkMQcVcybDJCWD6X
         y7eRCl6j2NK4Z88JBLydBcY4sESUbe6QRiGqSMLBkSnGcodLGsnDK36RF6q8raME/oDk
         eHdtLYO56kuXcsAnSZT8Y0T+ixI3Nd3bJzLgJcYkQE/Fw4Vy1C3alNpTf1OY4MFTrpQS
         TTYtm4RJCkFSNdTt9aRLnzTS9euA00QNMuwrwRBxIK+5h+m2XeVAkmtsKDB2FyLxL0zr
         d50g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RXpnzG8jc2yYtoFLBv7ZARt98Mz5wOXGm+EBvSjKUfM=;
        fh=aqqsLRdLi6KnBHIx3wYIubCDbR0WziOQH8CKdTDVYJA=;
        b=NTMHVjSH1qrGjLk9vE6yiZhNLnsJ224A8dHywy8Zjxxkmw9QsvO0VPTisAm1Nz7lbq
         hBODltfUt1ez43nl9qp2qZevNd196YNn4O0w5CQ/OZ/jABDnNV0SYZKZX0Te9np16Sil
         3H/OioZeG+vReDbX09v+xYOPoJgsp+DtxxnrsvIo2+DqF3FjDHnPm3cPZ8T8SRbKSjai
         QjfHiJRGZxUJMLSrXjqkbERB5AVfIpZJD6sqAsBvV8JfqHTzLljy+SuOleag3hmWXLkc
         2AH0bD226PcJjTYOX5cv10cDb/latYz+E5mxzHdssXw0cTELeP+YKvkgH9mUnvVHMp1Y
         C7YQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794368770; x=1794973570; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RXpnzG8jc2yYtoFLBv7ZARt98Mz5wOXGm+EBvSjKUfM=;
        b=wDmRvi5UDOHoU7lvv5PYFvNw/6ZCjkQMZd1A9CuYNK61SeWNpUw7SFVHSuXK81Jftx
         LqFrl+MMeAfNQ1dN4VgAkPSGL4mGMkvB85vU/HldNCWDivRC/cNo4PAavvHG3u6/x6iD
         NvRqkYXq0KioY9aYKfoeF3x7hZmb4oN/Cqv1MDDJdEPflYm+1hQTIMTqO/hDwl2WXw+g
         lbD5aDQpTz5+uWMvoBX+3lAEIgoX1bdI53Fov3ccsCW6voIrj/vZlzWrwWwJdofq3w17
         T8mGbovHjlrnUYPSCtJpVDvopcd/+XZlW3WKBxmeYfVmguC1aytJJ6cwhXCyv3d0lwMT
         X/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794368770; x=1794973570;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RXpnzG8jc2yYtoFLBv7ZARt98Mz5wOXGm+EBvSjKUfM=;
        b=MTsGP9nalUnP5ZqMA/6JSDPFZk+DeY/SiLeXGNpr0n7Sw+48Mq7ePxrSbPLXQyYXIL
         NoFxxVZ4CLHENhMiF5y1oYD/zd2U70QPIuk2gkvTevvUqk6hMu5Q7ilqzacM4iwXy0CY
         tSl0Wm+Zy5dxjPKpS6uyczClnyggLlri9UA6GRP5WuwR59DBJACe4x+UPMsDGnRZQEW+
         F0TGso5SyuI8XEuv7CK8GThjSvCMUsPWxgRWt2vdC5F5tf7Jwcbf//rmw0jopRSZ3dVb
         SKzP2171wXdyDZm+VzPnapm8mzM5uTyYbwtem0mKi3fLgpOyROshNIM4gRp7YIuIePj/
         tdxQ==
X-Forwarded-Encrypted: i=1; AL+hErGDy3M373ChkgsbRDgQqaAZqiXCEWzGDEPsCbATSXsuJ8m7z1i1kS8TzRTMngUBmzZNyHQIepf7@vger.kernel.org
X-Gm-Message-State: APuU4Z/7b3920+KWqHVEV4Iq4Kwm58KSFCHyHDPOQvitgPTzabA/5e89
	RSzln+t4142igBVAp/JVdTsqEaTWme30kSMiNCdfhQeOfMjsRYH3V8TEI3pQgPoMUrk5GvxwDiX
	wNXGiWPK9nmPNKlFwRfvDod2R1xgzUZw=
X-Gm-Gg: AYBFou1Vf9+qeNfT+YaR7zxC8K4IKxqNraH1qhzpQiSREnSvQPydQIwKOejU925LMoJ
	80EJ9L88fff1EuXH4qTYqpYsvJ5MnLWSE5eKIqpw+hdqmdBGEuQdjkQpdxviNftjDBdBapPRIYb
	YSMoSmxLldM5QvwzBkldGlfaWCiT3RBiVTXEwMUeXctK56l/Ukv5wTYW/+KskeL2E51IiDQwJMF
	9N3GBswZhfBkoLfcxPfDgp1FPAvOyFjZvGbZdebF6xJcgnSEuVt5hAbzYkRqXWKjfJZ4gmiiRyr
	+nKxJxCE2pqQyEVrtRjjTFxDnNEOTx2AROzPAsFG+l7Io9EmWwjTbIaJbzpVfVgWmz3ysKbUlNt
	0eRFkxlrFj1ne/Z3NP+TQqdJENj6S3EmwyJ1MJ48mZH3POspTqRRwWktlmbm4G3gtvsg=
X-Received: by 2002:a05:690c:f04:b0:8b1:567c:e7ae with SMTP id
 00721157ae682-8b3a8114a85mr9107737b3.47.1794368770490; Tue, 10 Nov 2026
 19:46:10 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110032913.71974-1-laoar.shao@gmail.com> <3296ff1ecad6573e1719cb205d9128f7@kernel.org>
In-Reply-To: <3296ff1ecad6573e1719cb205d9128f7@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 11 Nov 2026 11:45:33 +0800
X-Gm-Features: AclHuK_EYuNKM1uN4O291ubvtl6N0s-HDZmJBzZexNtlBKQbnavU5QXTx2HKC3E
Message-ID: <CALOAHbDqE5qD7y5_A25wxWR603QcGnSVFFoBe6iZ4TH7t4a_Sw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v4 0/4] BPF-based per-cgroup NUMA balancing
 mode selection
To: Tejun Heo <tj@kernel.org>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, 
	ziy@nvidia.com, mgorman@suse.de, bpf@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 2:45=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello, Yafang.
>
> I'm not going to engage further in this series until the situation
> changes.
>
> LLMs have made it much cheaper to produce plausible-looking patchsets
> for new features. That makes it easy to keep sending iterations of a
> feature which touches code that the submitter doesn't really understand
> or hasn't thought through in depth. The reviewer ends up doing much of
> the developer's work while the submitter sits between the reviewer and
> whatever the LLM produces. I think this series is an example of that.

Thanks, and I'm sorry for the time this has taken.

>
> Some examples from v4:
>
> - A folio belongs to a memcg and that memcg decides the policies around
>   it. That's how memcg works for every other memory policy, and tasks
>   belong to a memcg too. The series still splits NUMA balancing into a
>   task side and a folio side with different semantics. DISABLED applies
>   to tasks but not to their memory, and the two sides combine the
>   hierarchy differently.
>
>   On v3, I asked why. v4 moves the storage into memcg and keeps the
>   split, but doesn't give a high-level reason why NUMA balancing should
>   work differently from how memcg handles every other memory policy.
>   More generally, the major design decisions come without the reasoning
>   behind them, and asking didn't produce it. Each iteration only barely
>   updates what was pointed out in the previous one.

The task/folio split was my attempt to avoid defining a single owner
for shared folios. That was not a principled design choice.

Shared page-cache accounting in memcg is not a clean ownership model:
pages can remain charged to a memcg after the tasks that used them
have moved on or exited. That limitation is real, but it does not
justify giving tasks and folios different policy semantics, and I
don't currently have a defensible model for the split.

>
> - numab_memcg_mode() walks up to the root memcg and recombines the
>   requests on every call. The callers include every load-balancing
>   candidate in can_migrate_task(), every task migration, every NUMA hint
>   fault and every page migration including compaction. This happens
>   whenever any cgroup has a mode set, although the result changes only
>   when a mode is set or a memcg goes offline.

You're right: the ancestor walk is not an optional optimization. It is
on hot paths, and leaving it for follow-up measurements is not
acceptable.

>
> - numab_memcg_active() reads css->flags once and the comment says that
>   this makes the three state bits describe the same moment. However,
>   nothing synchronizes those flags with the mode. In the lookups, the
>   check is redundant anyway because offlining a memcg or disabling its
>   controller already clears the mode.

For numab_memcg_active(): the technical point is that the check is
only needed where the memcg does not come from a task/folio.

In the task/folio lookups, the memcg is tied to the object being
examined, So the active check is indeed redundant there, and I'll
remove it.

bpf_numab_get_mode() is different: it resolves an arbitrary cgroup id.
There is no task/folio context that pins the policy. So I use
numab_memcg_active() there to skip an unusable memcg and continue with
its parent.

I agree the check should not be in the task/folio lookups.

>
> A developer could cost reviewers time before too, but each round took
> the developer much more effort in comparison. That kept the effort
> balanced between developer and reviewer in a sustainable way, and it
> made sure that the developer learned and improved while working through
> each iteration. LLMs broke that balance.
>
> I don't know what the right solution is, but at this point shepherding
> patchsets like this doesn't make sense for me.

Anyway thanks for taking time into it.


--
Regards
Yafang
