From: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Thu, 2 Jun 2022 07:28:11 -0700
Message-ID: <1e4fe5c8-4bac-087b-ae32-6fa2fa5b44f6@linaro.org>
References: <Yo/DtjEU/kYr190u@slm.duckdns.org>
 <0babd7df-bdef-9edc-3682-1144bc0c2d2b@linaro.org>
 <Ypf0VnKUMiuRgZqT@slm.duckdns.org>
 <1fb4d8d7-ccc0-b020-715e-38c2dfd94c23@linaro.org>
 <Ypf5jpI7dSmpi4W0@slm.duckdns.org>
 <c3bd8e63-7204-f86d-8efa-254db71185fc@linaro.org>
 <Ypf/MpwzByOrSp6A@slm.duckdns.org>
 <416dc60a-f0e5-7d05-1613-3cd0ca415768@linaro.org>
 <YpgEY/lJbLidLOhc@slm.duckdns.org>
 <0fd1c3fd-fa86-dbed-f3f0-74c91b1efa11@linaro.org>
 <20220602114705.GB21320@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=L4Gxk4Bv5TfkgMZFmRZVdKI/nfnxSbVJuJD+KEhCTwA=;
        b=vznR9E/huPyrIZXpXnkqdLBfuApJkQscKlKcZknXDqfZ/UzpBujU19WWiJ4F6oTRe2
         lR7uP5EHAzxXwKjHa6B5RqiR9qnOaBkPs/hQSA9fnvdrxoQ3mFlfPq0VrvKG3gS6OE8R
         plY2qTLcDyWkxvE1BNieB15nFdOsnxMIE+Z3bRp/rMWZr/XzOq6qPJcP4JcL5r7v8+Rb
         AuEZVAjpLmZiBKWgqlash0NfkGGjUBMR+u0O48hccdnAFA9NmfkAD3b9WxtR17/cgOAz
         DCZGvSeh7xnKG8Wnji3N5tPQM53K3hXQH89J3bXgB0U78Q5roB6xZZQCZ+Ql/XFJLHXu
         pSWw==
Content-Language: en-US
In-Reply-To: <20220602114705.GB21320-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 6/2/22 04:47, Michal Koutn=C3=BD wrote:
> On Wed, Jun 01, 2022 at 05:40:51PM -0700, Tadeusz Struk<tadeusz.struk-QSE=
j5FYQhm4dnm+yROfE0A@public.gmane.org>  wrote:
>> css_killed_ref_fn() will be called regardless of the value of refcnt (vi=
a percpu_ref_kill_and_confirm())
>> and it will only enqueue the css_killed_work_fn() to be called later.
>> Then css_put()->css_release() will be called before the css_killed_work_=
fn() will even
>> get a chance to run, and it will also*only*  enqueue css_release_work_fn=
() to be called later.
>> The problem happens on the second enqueue. So there need to be something=
 in place that
>> will make sure that css_killed_work_fn() is done before css_release() ca=
n enqueue
>> the second job.
> IIUC, here you describe the same scenario I broke down at [1].

Right, except the last css_put(), which I think is called from cgroup_kn_un=
lock()
See below.

>> Does it sound right?
> I added a parameter A there (that is sum of base and percpu references
> before kill_css()).
> I thought it fails because A =3D=3D 1 (i.e. killing the base reference),
> however, that seems an unlikely situation (because cgroup code uses a
> "fuse" reference to pin css for offline_css()).
>=20
> So the remaining option (at least I find it more likely now) is that
> A =3D=3D 0 (A < 0 would trigger the warning in
> percpu_ref_switch_to_atomic_rcu()), aka the ref imbalance. I hope we can
> get to the bottom of this with detailed enough tracing of gets/puts.
>=20
> Splitting the work struct is condradictive to the existing approach with
> the "fuse" reference.
>=20
> (BTW you also wrote On Wed, Jun 01, 2022 at 05:00:44PM -0700, Tadeusz Str=
uk<tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>  wrote:
>> The fact the css_release() is called (via cgroup_kn_unlock()) just after
>> kill_css() causes the css->destroy_work to be enqueued twice on the same=
 WQ
>> (cgroup_destroy_wq), just with different function. This results in the
>> BUG: corrupted list in insert_work issue.
> Where do you see a critical css_release called from cgroup_kn_unlock()?
> I always observed the css_release() being called via
> percpu_ref_call_confirm_rcu() (in the original and subsequent syzbot

it goes like this:
cgroup_kn_unlock(kn)->cgroup_put(cgrp)->css_put(&cgrp->self), which
brings the refcnt to zero and triggers css_release().
I think what's missing is something that will serialize the kill
and release paths. I will try to put something together today.

--=20
Thanks,
Tadeusz
