From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Fri, 7 May 2021 19:45:33 -0400
Message-ID: <YJXRHXIykyEBdnTF@slm.duckdns.org>
References: <YJVnO+TCRW83S6w4@phenom.ffwll.local>
 <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local>
 <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
 <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com>
 <YJVwtS9XJlogZRqv@phenom.ffwll.local>
 <YJWWByISHSPqF+aN@slm.duckdns.org>
 <CADnq5_Mwd-xHZQ4pt34=FPk2Gq3ij1FNHWsEz1LdS7_Dyo00iQ@mail.gmail.com>
 <YJWqIVnX9giaKMTG@slm.duckdns.org>
 <CADnq5_PudV4ufQW=DqrDow_vvMQDCJVxjqZeXeTvM=6Xp+a_RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rk5ZF5O3eDY1kMqyU3TfWHx2sPsSACItLLAgyKze1w4=;
 b=WRCthpiWBtHfvBKo/T251l8U1FYDhxXo7foPARg3JjejHTmSQOooowsVGhiLNOMcQq
 SEsxajIMgeAvkewvQIU3xgrOHNPR0Z9w1zSYWr8ZUs70zgkyMRMXPTpFsGKP4SdyAs1h
 gYDTlKwwBVwPfauLYsM/53bjt3mahmc4GsVenCC96iwSpELZA/54Bf6QYhKIYwdbb5z2
 AHAhzCo2p1w9E/No1NNALqOx7P42N3Pl5AwOysmoxj/mh3p8uYsuFodkyDeZIk0AsCsU
 MYajtRBmN8d9BC+YYXawJbrQNPVvtBq3Yp3ek+8RBg3AlU9ogvuprYYPRsriM88vgmM3
 SzVw==
Content-Disposition: inline
In-Reply-To: <CADnq5_PudV4ufQW=DqrDow_vvMQDCJVxjqZeXeTvM=6Xp+a_RQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Alex Deucher <alexdeucher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, DRI Development <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>

Hello,

On Fri, May 07, 2021 at 06:30:56PM -0400, Alex Deucher wrote:
> Maybe we are speaking past each other.  I'm not following.  We got
> here because a device specific cgroup didn't make sense.  With my
> Linux user hat on, that makes sense.  I don't want to write code to a
> bunch of device specific interfaces if I can avoid it.  But as for
> temporal vs spatial partitioning of the GPU, the argument seems to be
> a sort of hand-wavy one that both spatial and temporal partitioning
> make sense on CPUs, but only temporal partitioning makes sense on
> GPUs.  I'm trying to understand that assertion.  There are some GPUs

Spatial partitioning as implemented in cpuset isn't a desirable model. It's
there partly because it has historically been there. It doesn't really
require dynamic hierarchical distribution of anything and is more of a way
to batch-update per-task configuration, which is how it's actually
implemented. It's broken too in that it interferes with per-task affinity
settings. So, not exactly a good example to follow. In addition, this sort
of partitioning requires more hardware knowledge and GPUs are worse than
CPUs in that hardwares differ more.

Features like this are trivial to implement from userland side by making
per-process settings inheritable and restricting who can update the
settings.

> that can more easily be temporally partitioned and some that can be
> more easily spatially partitioned.  It doesn't seem any different than
> CPUs.

Right, it doesn't really matter how the resource is distributed. What
matters is how granular and generic the distribution can be. If gpus can
implement work-conserving proportional distribution, that's something which
is widely useful and inherently requires dynamic scheduling from kernel
side. If it's about setting per-vendor affinities, this is way too much
cgroup interface for a feature which can be easily implemented outside
cgroup. Just do per-process (or whatever handles gpus use) and confine their
configurations from cgroup side however way.

While the specific theme changes a bit, we're basically having the same
discussion with the same conclusion over the past however many months.
Hopefully, the point is clear by now.

Thanks.

-- 
tejun
