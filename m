From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: don't queue css_release_work if one already
 pending
Date: Thu, 21 Apr 2022 14:00:56 -1000
Message-ID: <YmHwOAdGY2Lwl+M3@slm.duckdns.org>
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
 <20220414164409.GA5404@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zNM0T6G9nbgHrNZ4fTkXwyWCBaHcehFw/2xC4YUFDsI=;
        b=EuvVsx4ZgPslFCb7gOV55CeCnLpdDVKzvax8LPd7QTAK+3cU87Nftp2h7LeD7u3x2U
         PO69KJYfLa71urQQP2eN+4+QzGZOFbUrNStJDozSoWX4l5jGuO1fYDQUPM7oTzQ8wB2U
         8EIgEV6FSttJlevNQj86csduSGRTjcTwZHEIHMy9jGjOczOnergao1IJkSzCCnshkNPJ
         Py6NTTy2g3djoSt3B+mT0dIwNsW/H2Eqoy9JrURvzKTT9fe9QNKppdTpHmWnLEPGs5gR
         mcaxAyyi41329d31VgPJuKePYtKsinZGMVLpeuN/3ZZvqvZv6ZUF8piVfQllRNkVMPdm
         7ZLw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220414164409.GA5404@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com

On Thu, Apr 14, 2022 at 06:44:09PM +0200, Michal Koutn=FD wrote:
> I suspect the double-queuing is a result of the fact that there exists
> only the single reference to the css->refcnt. I.e. it's
> percpu_ref_kill_and_confirm()'d and released both at the same time.
>=20
> (Normally (when not killing the last reference), css->destroy_work reuse
> is not a problem because of the sequenced chain
> css_killed_work_fn()->css_put()->css_release().)

If this is the case, we need to hold an extra reference to be put by the
css_killed_work_fn(), right?

Thanks.

--=20
tejun
