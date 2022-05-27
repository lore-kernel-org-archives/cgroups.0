From: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Fri, 27 May 2022 09:39:20 -0700
Message-ID: <904ef8af-13a5-e566-b760-74519f70fa62@linaro.org>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
 <20220525161455.GA16134@blackbody.suse.cz> <Yo7KfEOz92kS2z5Y@blackbook>
 <Yo/DtjEU/kYr190u@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jeA4ER8KbBHKcyc+TaHYMfBnKpuDxMWJ6quO+9dHOWE=;
        b=NSLHsjgjrWqwX/1FYyNqbRe5eG4yejZ3h0d0GNRHAthad8+JrxNe0WwprdS58sHjLG
         +DFIEYNpeUJHV1+de7IN6+6hqCPJvHZpAzT/KyT4Uzzs40+wPILx3PmuZDo3ZE7laNTS
         cwg6C2WrHXDx3w7d9mw/XHohR5XWW2bqpm59bOC9y2hMyncS06X7fS/n/NsOeOA+Auc9
         yWGy/DpZq9uCpNRVlldmo3BHO8pSLPlvYA2RE6DnbPWcNLlS8+5yHlyGWpFiLVxCzD0r
         PuYmyh6SzT4L9DJ+6NrhKH9xQH8MHTACWPpile6TcTNUhr0PsJUw3REwgEWUWiHDp7J3
         0CGA==
Content-Language: en-US
In-Reply-To: <Yo/DtjEU/kYr190u-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 5/26/22 11:15, Tejun Heo wrote:
> Hello, Michal.
>=20
> On Thu, May 26, 2022 at 11:56:34AM +0200, Michal Koutn=C3=BD wrote:
>> // ref=3DA: initial state
>> kill_css()
>>    css_get // ref+=3DF =3D=3D A+F: fuse
>>    percpu_ref_kill_and_confirm
>>      __percpu_ref_switch_to_atomic
>>        percpu_ref_get
>>          // ref +=3D 1 =3D=3D A+F+1: atomic mode, self-protection
>>      percpu_ref_put
>>        // ref -=3D 1 =3D=3D A+F: kill the base reference
>>    [via rcu]
>>    percpu_ref_switch_to_atomic_rcu
>>      percpu_ref_call_confirm_rcu
>>        css_killed_ref_fn =3D=3D refcnt.confirm_switch
>>          queue_work(css->destroy_work)        (1)
>>                                                       [via css->destroy_=
work]
>>                                                       css_killed_work_fn=
 =3D=3D wq.func
>>                                                         offline_css() //=
 needs fuse
>>                                                         css_put // ref -=
=3D F =3D=3D A: de-fuse
>>        percpu_ref_put
>>          // ref -=3D 1 =3D=3D A-1: remove self-protection
>>          css_release                                   // A <=3D 1 -> 2n=
d queue_work explodes!
>=20
> I'm not sure I'm following it but it's perfectly fine to re-use the work
> item at this point. The work item actually can be re-cycled from the very
> beginning of the work function. The only thing we need to make sure is th=
at
> we don't css_put() prematurely to avoid it being freed while we're using =
it.
>=20
> For the sharing to be a problem, we should be queueing the release work i=
tem
> while the destroy instance is still pending, and if that is the case, it
> doesn't really matter whether we use two separate work items or not. We're
> already broken and would just be shifting the problem to explode elsewher=
e.
>=20
> The only possibility that I can think of is that somehow we're ending up
> with an extra css_put() somewhere thus triggering the release path
> prematurely. If that's the case, we'll prolly need to trace get/puts to f=
ind
> out who's causing the ref imbalance.

Hi Michal,
As far as I can see we are trying to test the same thing suggested by Tejun.
I just sent a test request to try this:
https://github.com/tstruk/linux/commit/master

Let me know if you have any more tests to run and I will hold off until
you are done.

--=20
Thanks,
Tadeusz
