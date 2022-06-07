From: Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH v2] cgroup: serialize css kill and release paths
Date: Tue, 7 Jun 2022 11:47:00 -0700
Message-ID: <d079b7d4-c538-8a50-3375-fab0d3a0f0e6@linaro.org>
References: <20220603173455.441537-1-tadeusz.struk@linaro.org>
 <20220603181321.443716-1-tadeusz.struk@linaro.org>
 <20220606123910.GF6928@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=ClvLn1v0KW5jcy2W1CElCvPJ8/3zjMIv2rSPG5d3wcg=;
        b=tc1I+sdA0FwDJ/gsRcalhTdWIHb3oeBmUEKkK8g4OZEMjXtAlRTZvaNhHDSk/3+9Zf
         ZCnTm71Ikwc9fj78Z6tJ+r+s3NKyZPGXQUM5GKc63uB2wcSoTM+yHLH1Ir/Fm51e9ot0
         iPOjiMnofGcQT1I4z3zOljtH0zbFxSybwkGC8Uh8OTfQAgLL0VB/fu8yQm7VfTWTj1iK
         ViabI4/ZPV3krTjB9RtlTrwxbRjkqxfKSGqc7GY05gqlqamDH4sYLLUCxRq+Tg2RE6e2
         AQwMtPhyN/4yV7ZESuVPupvYQ3xLbWu98R4sqW9Vc3joiZka92axUvzIDfM/7JpyJlSZ
         AErQ==
Content-Language: en-US
In-Reply-To: <20220606123910.GF6928@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com

On 6/6/22 05:39, Michal Koutn=C3=BD wrote:
> On Fri, Jun 03, 2022 at 11:13:21AM -0700, Tadeusz Struk<tadeusz.struk@lin=
aro.org>  wrote:
>> In such scenario the css_killed_work_fn will be en-queued via
>> cgroup_apply_control_disable(cgrp)->kill_css(css), and bail out to
>> cgroup_kn_unlock(). Then cgroup_kn_unlock() will call:
>> cgroup_put(cgrp)->css_put(&cgrp->self), which will try to enqueue
>> css_release_work_fn for the same css instance, causing a list_add
>> corruption bug, as can be seen in the syzkaller report [1].
> This hypothesis doesn't add up to me (I am sorry).
>=20
> The kill_css(css) would be a css associated with a subsys (css.ss !=3D
> NULL) whereas css_put(&cgrp->self) is a different css just for the
> cgroup (css.ss =3D=3D NULL).

Yes, you are right. I couldn't figure it out where the extra css_put()
is called from, and the only place that fitted into my theory was from
the cgroup_kn_unlock() in cgroup_apply_control_disable().
After some more debugging I can see that, as you said, the cgrp->self
is a different css. The offending _put() is actually called by the
percpu_ref_kill_and_confirm(), as it not only calls the passed confirm_kill
percpu_ref_func_t, but also it puts the refcnt iself.
Because the cgroup_apply_control_disable() will loop for_each_live_descenda=
nt,
and call css_kill() on all css'es, and css_killed_work_fn() will also loop
and call css_put() on all parents, the css_release() will be called on the
first parent prematurely, causing the BUG(). What I think should be done
to balance put/get is to call css_get() for all the parents in kill_css():

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c1e1a5c34e77..3ca61325bc4e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5527,6 +5527,8 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
   */
  static void kill_css(struct cgroup_subsys_state *css)
  {
+       struct cgroup_subsys_state *_css =3D css;
+
         lockdep_assert_held(&cgroup_mutex);
 =20
         if (css->flags & CSS_DYING)
@@ -5541,10 +5543,13 @@ static void kill_css(struct cgroup_subsys_state *cs=
s)
         css_clear_dir(css);
 =20
         /*
-        * Killing would put the base ref, but we need to keep it alive
-        * until after ->css_offline().
+        * Killing would put the base ref, but we need to keep it alive,
+        * and all its parents, until after ->css_offline().
          */
-       css_get(css);
+       do {
+               css_get(_css);
+               _css =3D _css->parent;
+       } while (_css && atomic_read(&_css->online_cnt));
 =20
         /*
          * cgroup core guarantees that, by the time ->css_offline() is

This will be then "reverted" in css_killed_work_fn()
Please let me know if it makes sense to you.
I'm still testing it, but syzbot is very slow today.

--=20
Thanks,
Tadeusz
