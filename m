From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Mon, 11 Jul 2022 17:44:10 -0700
Message-ID: <CA+khW7iE=qQTCMGteBysz509eSufc2EGu7T7A2ODMT1TZDsgug@mail.gmail.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-9-yosryahmed@google.com> <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
 <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com> <CA+khW7gu73pRFi73BR20OCJhzrs8-kHfTYYR38+MJUpt6wqXoA@mail.gmail.com>
 <e2f8fcd8-9219-1119-86ca-69714789d494@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bGTGuYa2fBktqF6ANS0pW/MRRXdihHucX+zpCB0BRDY=;
        b=YwfcYXk+tBGkgAD3HXPtacLw/NXJE4IHNS8mmUc5VhFYxm5hRuUexGwuzoMx7kF9Y5
         qE+cjG2m+mxPSQY8BfNUdmZb+6qgMoRUpUbOgsU/j4PzA0py9L0yQW1UP5hkqQIXCzas
         h9ZFY5+0K8rVQ8HBcODnA4HMnTYqBj4tqH+WMv2E04k8XMPD0CJG2vyVsg/sSayAB1ZO
         4FXj1p1zHQXIFVo73u3QBcewEQQrP5+2/uy6sM93i8G8AqkEux/9LNB5XxZopCzN9EUR
         NoL9uA4jmsf+por4SZA2GMvGF8eQBFWHgqGynpeMPShrW3SbFfgl4wfCjWAKjydi887h
         fHDA==
In-Reply-To: <e2f8fcd8-9219-1119-86ca-69714789d494-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Sun, Jul 10, 2022 at 11:19 PM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
>
>
>
> On 7/10/22 11:01 PM, Hao Luo wrote:
> > On Sun, Jul 10, 2022 at 5:51 PM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
> >>
> >>
> >>
> >> On 7/10/22 5:26 PM, Yonghong Song wrote:
> > [...]
> >>
> >> BTW, CI also reported the test failure.
> >> https://github.com/kernel-patches/bpf/pull/3284
> >>
> >> For example, with gcc built kernel,
> >> https://github.com/kernel-patches/bpf/runs/7272407890?check_suite_focus=true
> >>
> >> The error:
> >>
> >>     get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> >>     get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
> >>     check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan:
> >> actual 28390910 != expected 28390909
> >>     check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan:
> >> actual 0 != expected -2
> >>     check_vmscan_stats:PASS:test_vmscan 0 nsec
> >>     check_vmscan_stats:PASS:root_vmscan 0 nsec
> >>
> >
> > Yonghong,
> >
> > I noticed that the test only failed on test_progs-no_alu32, not
> > test_progs. test_progs passed. I believe Yosry and I have only tested
>
> In my case, both test_progs and test_progs-no_alu32 failed the test.
> I think the reason for the failure is the same.
>
> > on test_progs. I tried building and running the no_alu32 version, but
> > so far, not able to run test_progs-no_alu32. Whenever I ran
> > test_progs-no_alu32, it exits without any message. Do you have any
> > clue what could be wrong?
>
> It works fine in my environment. test_progs should be very similar to
> test_progs-no_alu32. The only difference is bpf programs with different
> insn set. Some tests may not run with test_progs-no_alu32, e.g., newer
> atomic insn tests.
>
> I have no idea why test_progs-no_alu32 won't work for you, I guess you
> may need to debug it a little bit.
>

Yonghong, I reproduced the failure using vmtest.sh now. Yosry and I
are debugging it. Once we have any result, we will report back. Thanks
for taking a look.

> >
> >>>
> > [...]
