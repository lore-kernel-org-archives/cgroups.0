From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v6 5/8] selftests/bpf: Test cgroup_iter.
Date: Mon, 1 Aug 2022 21:09:25 -0700
Message-ID: <CAEf4BzZcwN3N-8iHrHWFmunoWAVP4-snUs7kxpLLnQJpOtR+rw@mail.gmail.com>
References: <20220801175407.2647869-1-haoluo@google.com> <20220801175407.2647869-6-haoluo@google.com>
 <CAEf4Bzbdz7=Cg-87G2tak1Mr=1wJkqr6g2d=dkHqu0YH+j2unA@mail.gmail.com> <CA+khW7jiW=oAHS-N1ADLbqB74jTwAaLqUFFvYgb4xTz9WFwtZg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UocwHfpqhdsaKRBjXUO3oWoo5VgvByxIYhhk++TJzww=;
        b=jx4n8eOOxofhaSZH8qAE8+C6TnYGtkoSskRxtdK6cpEuJs3B2/r/mtS+LfGdb607Z+
         Pt706y5owNULu/vT+bzuxlMpb2iAnCL2E0Y5Wi5ngS2662xLzjr/k72ssPZBwg7ee0M/
         zepD+iNbd8FUgpsRoAHdZUDWBWHTxN/pdEOFPX5Uha6kIcv96xO8u3cQvd4100gd9i1E
         O8ysJtP8T++KWGFyqQ68Xvs7n5ypjil/P8MXrTBcSLTJBBoeAg7ayjvnfyNgCh3r8xV8
         3LnE2hkBGhoIu41apN04xmyBhTNU+cphPbdgr5N+UbDCDF2MJhvMjx495VwSEh1m0AKL
         FxUA==
In-Reply-To: <CA+khW7jiW=oAHS-N1ADLbqB74jTwAaLqUFFvYgb4xTz9WFwtZg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Luo <haoluo@google.com>
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, Michal Koutny <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Shakeel Butt <shakeelb@google.com>

On Mon, Aug 1, 2022 at 3:55 PM Hao Luo <haoluo@google.com> wrote:
>
> On Mon, Aug 1, 2022 at 2:51 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Aug 1, 2022 at 10:54 AM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
> > > of the following structure:
> > >
> > >     ROOT (working cgroup)
> > >      |
> > >    PARENT
> > >   /      \
> > > CHILD1  CHILD2
> > >
> > > and tests the following scenarios:
> > >
> > >  - invalid cgroup fd.
> > >  - pre-order walk over descendants from PARENT.
> > >  - post-order walk over descendants from PARENT.
> > >  - walk of ancestors from PARENT.
> > >  - early termination.
> > >
> > > Acked-by: Yonghong Song <yhs@fb.com>
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
> > >  .../selftests/bpf/prog_tests/cgroup_iter.c    | 193 ++++++++++++++++++
> > >  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
> > >  .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++++
> > >  3 files changed, 239 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
> > >

[...]

> > > +#define format_expected_output3(cg_id1, cg_id2, cg_id3) \
> > > +       snprintf(expected_output, sizeof(expected_output), \
> > > +                PROLOGUE "%8llu\n%8llu\n%8llu\n" EPILOGUE, \
> > > +                (cg_id1), (cg_id2), (cg_id3))
> > > +
> >
> > you use format_expected_output{1,2} just once and
> > format_expected_output3 twice. Is it worth defining macros for that?
> >
>
> If not, we'd see this snprintf and format all over the place. It looks
> worse than the current one I think, prefer leave as-is.

All over the place == 4 places where it matters.

We are not trying to write the most beautiful code through macro
obfuscation. The point is to write tests that are easy to follow,
debug, understand, and potentially modify. Adding extra layers of
macros goes against this. Instead of clearly seeing in each individual
subtest that we expect "%llu\n%llu\n", I need to search what
"format_expected_output3" is actually doing, then I'm wondering where
expected_output is coming from (I scan macro input args, see nothing,
then I conclude it must be coming from the environment; I jump to one
of the format_expected_output3 invocation sites, see no local variable
named "expected_output", then I look around and see global variable;
aha, finally!) Sure it's a rather trivial thing, but this adds up.

*Unnecessary* macros are bad and a hindrance. Please avoid them, if
possible. Saving 20 characters is not a sufficient justification in my
view.

>
> > > +const char *cg_path[] = {
> > > +       "/", "/parent", "/parent/child1", "/parent/child2"
> > > +};
> > > +

[...]

> > > +       link = bpf_program__attach_iter(skel->progs.cgroup_id_printer, &opts);
> > > +       if (!ASSERT_ERR_PTR(link, "attach_iter"))
> > > +               bpf_link__destroy(link);
> >
> > nit: you can call bpf_link__destroy() even if link is NULL or IS_ERR
> >
>
> Ack. Still need to ASSERT on 'link' though, so the saving is probably
> just an indentation. Anyway, will change.

Yeah, of course you need to assert. But it's nice to have
unconditional assertion.

>
> > > +}
> > > +
> >
> > [...]
> >

[...]
