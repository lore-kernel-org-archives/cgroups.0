From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Fri, 1 Jul 2022 16:28:11 -0700
Message-ID: <CA+khW7jLLwgLBxpyn5s6Nc8V=0fjfH22193kjP1STbU2A+3v6Q@mail.gmail.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-9-yosryahmed@google.com> <00df1932-38fe-c6f8-49d0-3a44affb1268@fb.com>
 <CAJD7tkaNnx6ebFrMxWgkJbtx=Qoe+cEwnjtWeY5=EAaVktrenw@mail.gmail.com>
 <CAJD7tkbOztCEWgMzoCOdD+g3whMMQWW2e0gwo9p0tVK=3hqmcw@mail.gmail.com> <59376285-21bc-ff12-3d64-3ea7257becb2@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vB+wIPmejTn5guDzm5cOLEtXJ3nVXhdD7b4J4pd+cFY=;
        b=g6OkOcxXIvG59akpnlImlIcETkdMs26zUNWZQ7dS0paRnswQFjyUzljmU0lm45Ib0h
         0G/oxnjfVsmFsfH9s8GG0BWyLSiR43LrciR6mGgnaBm1jZmpQxOM+VER18y0zlcr2kfM
         2/TQ/BiTV0uXVtJBx3k/DlrG4G5htuJ4I0T2sN4KYYSSQAGYRhaG3AuEkPZbLt3h5pXf
         5WALSJGk8C8SFulTVbniylYxiH6EBhxnRVlM/VcL3kHGVTyle1R047fofkkf62Bxghqo
         pqw/irKAUFGsBAXs+wUObzD/Q0FAxX1Hk8lrghs+vElBBVNb7lf7JhOHrcR9IpYWq4kn
         z9Mg==
In-Reply-To: <59376285-21bc-ff12-3d64-3ea7257becb2-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf@vg>

On Tue, Jun 28, 2022 at 11:27 PM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
>
>
>
> On 6/28/22 12:43 AM, Yosry Ahmed wrote:
> > On Mon, Jun 27, 2022 at 11:47 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >> On Mon, Jun 27, 2022 at 11:14 PM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
[...]
> >>> btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
> >>> expected/actual match: actual '(union bpf_iter_link_info){.map =
> >>> (struct){.map_fd = (__u32)1,},.cgroup '
> >>> test_btf_dump_struct_data:PASS:find struct sk_buff 0 nsec
> >>>
> >>
> >> Yeah I see what happened there. bpf_iter_link_info was changed by the
> >> patch that introduced cgroup_iter, and this specific union is used by
> >> the test to test the "union with nested struct" btf dumping. I will
> >> add a patch in the next version that updates the btf_dump_data test
> >> accordingly. Thanks.
> >>
> >
> > So I actually tried the attached diff to updated the expected dump of
> > bpf_iter_link_info in this test, but the test still failed:
> >
> > btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
> > expected/actual match: actual '(union bpf_iter_link_info){.map =
> > (struct){.map_fd = (__u32)1,},.cgroup = (struct){.cgroup_fd =
> > (__u32)1,},}'  != expected '(union bpf_iter_link_info){.map =
> > (struct){.map_fd = (__u32)1,},.cgroup = (struct){.cgroup_fd =
> > (__u32)1,.traversal_order = (__u32)1},}'
> >
> > It seems to me that the actual output in this case is not right, it is
> > missing traversal_order. Did we accidentally find a bug in btf dumping
> > of unions with nested structs, or am I missing something here?
>
> Probably there is an issue in btf_dump_data() function in
> tools/lib/bpf/btf_dump.c. Could you take a look at it?
>

Regarding this failure of btf_dump_data, the cause seems that:

I added a new struct in 'union bpf_iter_link_info' in this patch
series, which expanded bpf_iter_link_info's size from 32bit to 64bit.
However, the test still used the old struct to initialize, which makes
a temporary stack variable (of type bpf_iter_link_info) partially
initialized. If I initialize the type by the larger new struct only,
btf_dump_data will output the correct content and the said test will
pass.

Yosry, we need to fold the said solution in the patch which introduced
changes to bpf_iter_link_info, so that it won't break the test.

I haven't dug into btf_dump_data() on why partially initialized union
fails. I need to look at the get_cgroup_vmscan_delay selftest in this
patch now.

Hao
