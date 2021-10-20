From: Quanyang Wang <quanyang.wang-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Wed, 20 Oct 2021 13:16:01 +0800
Message-ID: <4644b5eb-8acf-45ef-e33e-84eee6394a57@windriver.com>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590> <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590> <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
 <YW78AohHqgqM9Cuw@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=pICHADg2kpfK+72cb3vjK2upNrD/fiz4CvSMBd0wers=;
 b=Nxzcz2+LpuQROIFnS+Ph4cFe9aOHGsPXyFb3nru+waTsm+ROkifKEezy5D9waoSxMXmP
 VMR1NENSvNkeur2Okr0y33Ei/LQUxIX/7r03XTC54pK+9Bw94Q/CKcilGqYFyM3hjWrK
 zkcOJDf0bMsOepXBAkY69oKjrU4uxgE1iqIu62N9XyNR5QpERZ/xqd+Fgho+FXiFs330
 mvHRoKOvFxLAweJz4Ohb7xRLUTyfcPMDdCe8vERZZUvnUqsNwZDuaheuZB6MzwOAvbuJ
 sTw9BoFA1fLez7QroAFlEeyPTm1/DiJ4e+qmSdgssX3kI6YHaqpUT6MwMZIiwnIdHEzs VQ== 
In-Reply-To: <YW78AohHqgqM9Cuw@blackbook>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michal,

On 10/20/21 1:10 AM, Michal Koutn=C3=BD wrote:
> Hi.
>=20
> On Tue, Oct 19, 2021 at 06:41:14PM +0800, Quanyang Wang <quanyang.wang-CW=
A4WttNNZF54TAoqtyWWQ@public.gmane.org> wrote:
>> So I add 2 "Fixes tags" here to indicate that 2 commits introduce two
>> different issues.
>=20
> AFAIU, both the changes are needed to cause the leak, a single patch
> alone won't cause the issue. Is that correct? (Perhaps not as I realize,
> see below.)
Yes, I back to the earlier commit 4bfc0bb2c60e and no memory leak is=20
observed.
>=20
> But on second thought, the problem is the missing percpu_ref_exit() in
> the (root) cgroup release path and percpu counter would allocate the
> percpu_count_ptr anyway, so 4bfc0bb2c60e is only making the leak more
> visible. Is this correct?
No, the earlier commit 4bfc0bb2c60e introduces a imbalance and the later
commit 2b0d3d3e4fcf introduces a visible leak.

Thanks,
Quanyang
>=20
> I agree the commit 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of
> percpu_ref in fast path") alone did nothing wrong.
>=20
> [On a related (but independent) note, there seems to be an optimization
> opportunity in not dealing with cgroup_bpf at all on the non-default
> hierarchies.]
>=20
> Regards,
> Michal
>=20
