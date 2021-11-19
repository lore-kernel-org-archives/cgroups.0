From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 4/4] bpf,cgroup,perf: extend bpf-cgroup to support
 tracepoint attachment
Date: Fri, 19 Nov 2021 01:01:15 -0500
Message-ID: <CAOWid-dFFjrBx1YxRxssP=uAWAjQ75iU2jj_uRkBnx4Vt5YrpA@mail.gmail.com>
References: <20211118202840.1001787-1-Kenny.Ho@amd.com>
 <20211118202840.1001787-5-Kenny.Ho@amd.com>
 <20211119043326.a4pmgitlkljpamgh@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=cpacwUyzE+yZQi2HRsigmJjkmcIiIOSGZw3OzHsfooo=;
 b=RldlS2C/ckDa2ilqyd5cvlc3AjbT6JqCEXn82gXQCs6cELL7iYMIp14cSXKt0Pkve1
 jTesFFg+9gJSMX1G5oBdXRmcbNMdvb2tp21b0Cny/h3y4O81NUztrQExa82xCOsaoSYp
 ZUTJhomesLSaZWLLRMRpB+jgTQkwqv7IEDCbLcEBADbtKyUw6915Z5srh7D55OKNossi
 h0dcACKcphWlDBXg6grG4gE7CPxc7kyPmJwHgO8qCxXOWCpyvmhf3cQRglqv5k807Hd9
 x9bareYiM2HG5ucRSP21DZl0qs3ZYj8HICCV5GfknAxsyJYEJmZNSkr1YDswhBvmK47K
 GNKg==
In-Reply-To: <20211119043326.a4pmgitlkljpamgh-+o4/htvd0TCa6kscz5V53/3mLCh9rsb+VpNB7YpNyf8@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiri Olsa <jolsa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Thu, Nov 18, 2021 at 11:33 PM Alexei Starovoitov
<alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Thu, Nov 18, 2021 at 03:28:40PM -0500, Kenny Ho wrote:
> > +     for_each_possible_cpu(cpu) {
> > +             /* allocate first, connect the cgroup later */
> > +             events[i] = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
>
> This is a very heavy hammer for this task.
> There is really no need for perf_event to be created.
> Did you consider using raw_tp approach instead?

I came across raw_tp but I don't have a good understanding of it yet.
Initially I was hoping perf event/tracepoint is a stepping stone to
raw tp but that doesn't seem to be the case (and unfortunately I
picked the perf event/tracepoint route to dive in first because I saw
cgroup usage.)  Can you confirm if the following statements are true?

- is raw_tp related to writable tracepoint
- are perf_event/tracepoint/kprobe/uprobe and fentry/fexit/raw_tp
considered two separate 'things' (even though both of their purpose is
tracing)?

> It doesn't need this heavy stuff.
> Also I suspect in follow up you'd be adding tracepoints to GPU code?
> Did you consider just leaving few __weak global functions in GPU code
> and let bpf progs attach to them as fentry?
There are already tracepoints in the GPU code.  And I do like fentry
way of doing things more but my head was very much focused on cgroup,
and tracepoint/kprobe path seems to have something for it.  I
suspected this would be a bit too heavy after seeing the scalability
discussion but I wasn't sure so I whip this up quickly to get some
feedback (while learning more about perf/bpf/cgroup.)

> I suspect the true hierarchical nature of bpf-cgroup framework isn't necessary.
> The bpf program itself can filter for given cgroup.
> We have bpf_current_task_under_cgroup() and friends.
Is there a way to access cgroup local storage from a prog that is not
attached to a bpf-cgroup?  Although, I guess I can just store/read
things using a map with the cg id as key.  And with the
bpf_get_current_ancestor_cgroup_id below I can just simulate the
values being propagated if the hierarchy ends up being relevant.  Then
again, is there a way to atomically update multiple elements of a map?
 I am trying to figure out how to support a multi-user multi-app
sharing use case (like user A given quota X and user B given quota Y
with app 1 and 2 each having a quota assigned by A and app 8 and 9
each having quota assigned by B.)  Is there some kind of 'lock'
mechanism for me to keep quota 1,2,X in sync? (Same for 8,9,Y.)

> I suggest to sprinkle __weak empty funcs in GPU and see what
> you can do with it with fentry and bpf_current_task_under_cgroup.
> There is also bpf_get_current_ancestor_cgroup_id().
