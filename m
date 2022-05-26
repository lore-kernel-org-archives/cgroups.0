From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Thu, 26 May 2022 08:15:18 -1000
Message-ID: <Yo/DtjEU/kYr190u@slm.duckdns.org>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
 <20220525161455.GA16134@blackbody.suse.cz>
 <Yo7KfEOz92kS2z5Y@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6qtpXMNwSeKb2/ZB0dn4b9L5gJCZbExzN3Ar6qUIAGk=;
        b=DvngC5Bk5mSGIVEwnc//TJTs6pULwXNDU5y3gFp4sI2ZDCXte23y1tV1Vb4ZPYlkqC
         aTfWZl2UvanZ6Xz/ozofK9h1prT+sIi0W6zZqomwx7FPYOdZQItLDJJIu3pOUOL5Xtg0
         VyYRokizo6Ar77W4aMzNK0Vdz5OzizMyUafqvlWqERKtiJuqHzXNc3vfWCoGxyO0P+Sr
         JeAP7D1jg66OsWSSGebw1QRpMfN4O8dhRQz0Zqie3pkqGDp83GXkni1SXi98ctQ3catV
         /rINz2RtcTf2We8eYodn0tL6fzO/3A1gPPEhFRrFoq4GUTKuOtNuRZvz1ea3mTADZsyf
         Doug==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Yo7KfEOz92kS2z5Y@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Hello, Michal.

On Thu, May 26, 2022 at 11:56:34AM +0200, Michal Koutn=FD wrote:
> // ref=3DA: initial state
> kill_css()
>   css_get // ref+=3DF =3D=3D A+F: fuse
>   percpu_ref_kill_and_confirm
>     __percpu_ref_switch_to_atomic
>       percpu_ref_get
>         // ref +=3D 1 =3D=3D A+F+1: atomic mode, self-protection
>     percpu_ref_put
>       // ref -=3D 1 =3D=3D A+F: kill the base reference
>   [via rcu]
>   percpu_ref_switch_to_atomic_rcu
>     percpu_ref_call_confirm_rcu
>       css_killed_ref_fn =3D=3D refcnt.confirm_switch
>         queue_work(css->destroy_work)        (1)
>                                                      [via css->destroy_wo=
rk]
>                                                      css_killed_work_fn =
=3D=3D wq.func
>                                                        offline_css() // n=
eeds fuse
>                                                        css_put // ref -=
=3D F =3D=3D A: de-fuse
>       percpu_ref_put
>         // ref -=3D 1 =3D=3D A-1: remove self-protection
>         css_release                                   // A <=3D 1 -> 2nd =
queue_work explodes!

I'm not sure I'm following it but it's perfectly fine to re-use the work
item at this point. The work item actually can be re-cycled from the very
beginning of the work function. The only thing we need to make sure is that
we don't css_put() prematurely to avoid it being freed while we're using it.

For the sharing to be a problem, we should be queueing the release work item
while the destroy instance is still pending, and if that is the case, it
doesn't really matter whether we use two separate work items or not. We're
already broken and would just be shifting the problem to explode elsewhere.

The only possibility that I can think of is that somehow we're ending up
with an extra css_put() somewhere thus triggering the release path
prematurely. If that's the case, we'll prolly need to trace get/puts to find
out who's causing the ref imbalance.

Thanks.

--=20
tejun
