From: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] perf stat: Support old kernels for bperf cgroup
 counting
Date: Fri, 14 Oct 2022 14:10:40 -0300
Message-ID: <Y0mYEBVbJTwNIjSM@kernel.org>
References: <Y0Sx2KWX4gPlLytq@slm.duckdns.org>
 <20221011052808.282394-1-namhyung@kernel.org>
 <Y0Wfl88objrECjSo@slm.duckdns.org>
 <Y0ljzN920sWalEHR@kernel.org>
 <Y0mRGJx4Mc7t7fGB@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665767443;
        bh=h1ZcOrur4TJeGwPpm76nE+8Oc267yBVgjArLBmRvdEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V2GSIz1DbBVxLG+rKYKYlDhGQOHkEfjNRC8vZtLNlPkFYqCHiZI+GaH14mtNHa+tM
         CewaQ4ktqTh2kGctbw2eyV128CJH/RfGZ7FMcL5UbcP70/kqZa80jK6W+8gFMOVUAM
         55h5/ngRkRkQ/HnX+rtVMZ5rqOSxEpLUsF/cThTa9KgjPQresGEDslFDkZlddIsUzS
         sL7BQ5kco/pbTVmjF/pwoow0Q/OxLvkcOz2GxA0nE1H0oM8tM3YOv8OSmhh1rSNSNu
         5jS44D7gsgtCTQ9GH8pD/9Fl6d39Y9xID2qUlXyj73WVAjfjB087bB7IkceXRTLibt
         f4VjU0V4sDwUg==
Content-Disposition: inline
In-Reply-To: <Y0mRGJx4Mc7t7fGB-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Em Fri, Oct 14, 2022 at 06:40:56AM -1000, Tejun Heo escreveu:
> On Fri, Oct 14, 2022 at 10:27:40AM -0300, Arnaldo Carvalho de Melo wrote:
> > Hey, I noticed that the perf build is broken for the
> > tools/perf/util/bpf_skel/bperf_cgroup.bpf.c skell, so I tried using b4
> > on this Namhyung patch, it ended up getting a newer version, by Tejun,
> > that mixes up kernel code and tooling, which, when I tried to apply
> > upstream didn't work.

> > Please try not to mix up kernel and tools/ changes in the same patch to
> > avoid these issues.
 
> I didn't write a newer version of this patch. What are you talking about?

So, I saw this message from you in reply to Namhyung's v2 patch:

--------------------------

Date: Tue, 11 Oct 2022 06:53:43 -1000
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] perf stat: Support old kernels for bperf cgroup counting
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Song Liu
        <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Message-ID: <Y0Wfl88objrECjSo-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>

On Mon, Oct 10, 2022 at 10:28:08PM -0700, Namhyung Kim wrote:
> The recent change in the cgroup will break the backward compatiblity in
> the BPF program.  It should support both old and new kernels using BPF
> CO-RE technique.

> Like the task_struct->__state handling in the offcpu analysis, we can
> check the field name in the cgroup struct.

> Acked-by: Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-6.1-fixes.

Thanks.

--
tejun
--------------------------

So, I picked the message id, Y0Wfl88objrECjSo-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org, and asked
b4 to pick the patch:

⬢[acme@toolbox perf]$ b4 am --help | grep -A1 -- -c,
  -c, --check-newer-revisions
                        Check if newer patch revisions exist
⬢[acme@toolbox perf]$

⬢[acme@toolbox perf]$ b4 am -ctsl --cc-trailers Y0Wfl88objrECjSo-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org
Grabbing thread from lore.kernel.org/all/Y0Wfl88objrECjSo%40slm.duckdns.org/t.mbox.gz
Checking for newer revisions on https://lore.kernel.org/all/
Analyzing 27 messages in the thread
('Acked-by', 'Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>', None)
Will use the latest revision: v3
You can pick other revisions using the -vN flag
Checking attestation on all messages, may take a moment...
---
  ✓ [PATCH v3] cgroup: Replace cgroup->ancestor_ids[] with ->ancestors[]
  ---
  ✓ Signed: DKIM/gmail.com (From: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org)
---
Total patches: 1
---
 Link: https://lore.kernel.org/r/YuRo2PLFH6wLgEkm-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org
 Base: not specified
       git am ./v3_20220729_tj_cgroup_replace_cgroup_ancestor_ids_with_ancestors.mbx
⬢[acme@toolbox perf]$

Which got me this:

⬢[acme@toolbox perf]$ diffstat ./v3_20220729_tj_cgroup_replace_cgroup_ancestor_ids_with_ancestors.mbx
 include/linux/cgroup-defs.h                 |   16 ++++++++++------
 include/linux/cgroup.h                      |    8 +++-----
 kernel/cgroup/cgroup.c                      |    7 +++----
 net/netfilter/nft_socket.c                  |    9 +++++----
 tools/perf/util/bpf_skel/bperf_cgroup.bpf.c |    2 +-
 5 files changed, 22 insertions(+), 20 deletions(-)
⬢[acme@toolbox perf]$

⬢[acme@toolbox perf]$ grep From: ./v3_20220729_tj_cgroup_replace_cgroup_ancestor_ids_with_ancestors.mbx
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
⬢[acme@toolbox perf]$

That mixes kernel and tools bits and touches
tools/perf/util/bpf_skel/bperf_cgroup.bpf.c, hence my request to add me
to the CC list for patches touching tools/perf/.

My assumption that it was a new patch was because b4 somehow got to
v3_20220729_tj_cgroup_replace_cgroup_ancestor_ids_with_ancestors,
which has v3 and touches the tools cgroup bpf skel.

So it seems b4 is confused somehow.

Hope this clarifies.

- Arnaldo
