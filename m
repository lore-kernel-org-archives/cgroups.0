From: Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH] cgroup: don't queue css_release_work if one already
 pending
Date: Wed, 18 May 2022 09:48:21 -0700
Message-ID: <317701e1-20a7-206f-92cd-cd36d436eee2@linaro.org>
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
 <20220414164409.GA5404@blackbody.suse.cz> <YmHwOAdGY2Lwl+M3@slm.duckdns.org>
 <20220422100400.GA29552@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=a/nioQD6LDBjjZNelJ71Lr4Cech0R4yZAq15sbuZJCc=;
        b=jeUGHyeLcHxjHkIIKYZBSEirqL6+qcT+SwaKdSDH0eEuWJX91z8H+/NwOyFm6Q/3sg
         L9XrfogqRU3oI6TnKgiJeHgrGw/oGUbpLfVj3kV+oLdnjWkaqqa+CybKP/FbOvy6F6IL
         rluB6UJhiQou1qwfVR+KdqqKcIz4w0sEumbGOiWOpSUME/YbUFIDrk//wtIR8X9N1Jm4
         NoDF8h/+RCgyROH58JFUlONkcnXtlIgRGqgWS0Jr9Wt4GrykPJjgvLd1ygMncVXda1mG
         rfViXBsfd8QYhpJJ3lk8Is4meGwXFAnxnTZ0OKw7eHzYV0K2t1q7aYsfC3i03hntXNgU
         GTGg==
Content-Language: en-US
In-Reply-To: <20220422100400.GA29552@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com

On 4/22/22 04:05, Michal Koutn=C3=BD wrote:
> On Thu, Apr 21, 2022 at 02:00:56PM -1000, Tejun Heo <tj@kernel.org> wrote:
>> If this is the case, we need to hold an extra reference to be put by the
>> css_killed_work_fn(), right?
>=20
> I looked into it a bit more lately and found that there already is such
> a fuse in kill_css() [1].
>=20
> At the same type syzbots stack trace demonstrates the fuse is
> ineffective
>=20
>> css_release+0xae/0xc0 kernel/cgroup/cgroup.c:5146                    (**)
>> percpu_ref_put_many include/linux/percpu-refcount.h:322 [inline]
>> percpu_ref_put include/linux/percpu-refcount.h:338 [inline]
>> percpu_ref_call_confirm_rcu lib/percpu-refcount.c:162 [inline]        (*)
>> percpu_ref_switch_to_atomic_rcu+0x5a2/0x5b0 lib/percpu-refcount.c:199
>> rcu_do_batch+0x4f8/0xbc0 kernel/rcu/tree.c:2485
>> rcu_core+0x59b/0xe30 kernel/rcu/tree.c:2722
>> rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2735
>> __do_softirq+0x27e/0x596 kernel/softirq.c:305
>=20
> (*) this calls css_killed_ref_fn confirm_switch
> (**) zero references after confirmed kill?
>=20
> So, I was also looking at the possible race with css_free_rwork_fn()
> (from failed css_create()) but that would likely emit a warning from
> __percpu_ref_exit().
>=20
> So, I still think there's something fishy (so far possible only via
> artificial ENOMEM injection) that needs an explanation...

I can't reliably reproduce this issue on neither mainline nor v5.10, where
syzbot originally found it. It still triggers for syzbot though.

--=20
Thanks,
Tadeusz
