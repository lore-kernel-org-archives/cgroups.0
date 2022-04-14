From: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: don't queue css_release_work if one already
 pending
Date: Thu, 14 Apr 2022 10:51:18 -0700
Message-ID: <584183e2-2473-6185-e07d-f478da118b87@linaro.org>
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
 <20220414164409.GA5404@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=R60EpWC4+M+3jSe48lUE7Gq4ExP+RSflXlkjF6VcaNg=;
        b=MJT5ZerLaHe0JjBpnq1LElIVlHvKx2ombKDP9yRuUPnzETaAhn9nIFw2s+5thyg8ck
         z+Auc/bX6s4XDzQD7WK+/TG6WF/NPaz7NxNF+va1neIBQvkDM8rvE/Z8Bu7yJMiDjGhr
         Qq/F7VMSrZoc5QrzMA5rKvUUC9eGBE4aSx1/AZufDrZmL8MFVO75636rgU+GQRNVBJf+
         XMC2Wjv8LayNUGel212gOwnBPbKqlmm34ot5OyZMuDQLngo5WNI+Qvm1BsfC5EhRNMHA
         pczXurvhUftRw1ejmjb5pCtSqc/EQVw3Lip1QWxc1k5n4sDFrV6ZrKI9OY/a3Zk8+Y1S
         UitA==
Content-Language: en-US
In-Reply-To: <20220414164409.GA5404-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot+e42ae441c3b10acf9e9d-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

Hi Michal,
Thanks for your analysis.

On 4/14/22 09:44, Michal Koutn=C3=BD wrote:
> Hello Tadeusz.
>=20
> Thanks for analyzing this syzbot report. Let me provide my understanding
> of the test case and explanation why I think your patch fixes it but is
> not fully correct.
>=20
> On Tue, Apr 12, 2022 at 12:24:59PM -0700, Tadeusz Struk <tadeusz.struk-QS=
Ej5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> Syzbot found a corrupted list bug scenario that can be triggered from
>> cgroup css_create(). The reproduces writes to cgroup.subtree_control
>> file, which invokes cgroup_apply_control_enable(), css_create(), and
>> css_populate_dir(), which then randomly fails with a fault injected -ENO=
MEM.
>=20
> The reproducer code makes it hard for me to understand which function
> fails with ENOMEM.
> But I can see your patch fixes the reproducer and your additional debug
> patch which proves that css->destroy_work is re-queued.

Yes, it is hard to see the actual failing point because, I think it is rand=
omly
failing in different places. I think in the actual case that causes the list
corruption is in fact in css_create().
It is the css_create() error path that does fist rcu enqueue in:

https://elixir.bootlin.com/linux/v5.10.109/source/kernel/cgroup/cgroup.c#L5=
228

and the second is triggered by the css->refcnt calling css_release()

The reason why we don't see it actually failing in css_create() in the trace
dump is that the fail_dump() is rate-limited, see:
https://elixir.bootlin.com/linux/v5.18-rc2/source/lib/fault-inject.c#L44

I was confused as well, so I put additional debug prints in every place
where css_release() can fail, and it was actually in
css_create()->cgroup_idr_alloc() that failed in my case.

What happened was, the write triggered:
cgroup_subtree_control_write()->cgroup_apply_control()->cgroup_apply_contro=
l_enable()->css_create()

which, allocates and initializes the css, then fails in cgroup_idr_alloc(),
bails out and calls queue_rcu_work(cgroup_destroy_wq, &css->destroy_rwork);

then cgroup_subtree_control_write() bails out to out_unlock:, which then go=
es:

cgroup_kn_unlock()->cgroup_put()->css_put()->percpu_ref_put(&css->refcnt)->=
percpu_ref_put_many(ref)

which then calls ref->data->release(ref) and enqueues the same
&css->destroy_rwork on cgroup_destroy_wq causing list corruption in insert_=
work.

>> In such scenario the css_create() error path rcu enqueues css_free_rwork=
_fn
>> work for an css->refcnt initialized with css_release() destructor,
>=20
> Note that css_free_rwork_fn() utilizes css->destroy_*r*work.
> The error path in css_create() open codes relevant parts of
> css_release_work_fn() so that css_release() can be skipped and the
> refcnt is eventually just percpu_ref_exit()'d.
>=20
>> and there is a chance that the css_release() function will be invoked
>> for a cgroup_subsys_state, for which a destroy_work has already been
>> queued via css_create() error path.
>=20
> But I think the problem is css_populate_dir() failing in
> cgroup_apply_control_enable(). (Is this what you actually meant?
> css_create() error path is then irrelevant, no?)

I thought so too at first as the the crushdump shows that this is failing
in css_populate_dir(), but this is not the fail that causes the list corrup=
tion.
The code can recover from the fail in css_populate_dir().
The fail that causes trouble is in css_create(), that makes it go to its er=
ror path.
I can dig out the patch with my debug prints and request syzbot to run it
if you want.

>=20
> The already created csses should then be rolled back via
> 	cgroup_restore_control(cgrp);
> 	cgroup_apply_control_disable(cgrp);
> 	   ...
> 	   kill_css(css)
>=20
> I suspect the double-queuing is a result of the fact that there exists
> only the single reference to the css->refcnt. I.e. it's
> percpu_ref_kill_and_confirm()'d and released both at the same time.
>=20
> (Normally (when not killing the last reference), css->destroy_work reuse
> is not a problem because of the sequenced chain
> css_killed_work_fn()->css_put()->css_release().)
>=20
>> This can be avoided by adding a check to css_release() that checks
>> if it has already been enqueued.
>=20
> If that's what's happening, then your patch omits the final
> css_release_work_fn() in favor of css_killed_work_fn() but both should
> be run during the rollback upon css_populate_dir() failure.

This change only prevents from double queue:

queue_[rcu]_work(cgroup_destroy_wq, &css->destroy_rwork);

I don't see how it affects the css_killed_work_fn() clean path.
I didn't look at it, since I thought it is irrelevant in this case.

--=20
Thanks,
Tadeusz
