From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup] cgroup: set the correct return code if hierarchy
 limits are reached
Date: Wed, 29 Jun 2022 09:13:02 +0300
Message-ID: <525a3eea-8431-64ad-e464-5503f3297722@openvz.org>
References: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org>
 <d8a9e9c6-856e-1502-95ac-abf9700ff568@openvz.org> <YrpO9CUDt8hpUprr@castle>
 <17916824-ba97-68ba-8166-9402d5f4440c@openvz.org>
 <20220628091648.GA12249@blackbody.suse.cz> <YrrIWe/nn5hoVyu9@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tXBEMcYdLbL7j0CBnFEQrI7j8CDRw/szwLk4z5HVwIU=;
        b=6xIoLTbTENo5N5hHKjhjfiPk6YpVnyqcLFcwoVzvW3j8d4aWTu8RxffBad1YuW22ZQ
         B7JUZzvMlY3hMEVofUyVtHBYlj7NYSiQSjSmRtHMHwYaGzHsaqvwDqH4SBVu0eg2wt1p
         09spkd8NH3luZDqG7H3iAwgS+g1MUQ3GRFz+F1gyrPFJjm6z7aaVcn7gc2MOrFB/p6kF
         JajynDxOhztcu9FGmfWos5JDk1HGKQ0g4bqDoY+ExizDNO0aXZPzeg0b1uGZ74fHWMX+
         +J+20MEXlTNZIPQhPd4BwwqzofH2gf1h83iJVr7esOJIGCDxJ6fleBsVho2LMH/DFy0V
         agWA==
Content-Language: en-US
In-Reply-To: <YrrIWe/nn5hoVyu9-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/28/22 12:22, Tejun Heo wrote:
> On Tue, Jun 28, 2022 at 11:16:48AM +0200, Michal Koutn=C3=BD wrote:
>> The mkdir(2) manpage doesn't list EAGAIN at all. ENOSPC makes better
>> sense here. (And I suspect the dependency on this particular value won't
>> be very wide spread.)
>=20
> Given how we use these system calls as triggers for random kernel
> operations, I don't think adhering to posix standard is necessary or
> possible. Using an error code which isn't listed in the man page isn't
> particularly high in the list of discrepancies.
>=20
> Again, I'm not against changing it but I'd like to see better
> rationales. On one side, we have "it's been this way for a long time
> and there's nothing particularly broken about it". I'm not sure the
> arguments we have for the other side is strong enough yet.

I would like to recall this patch.

I experimented on fedora36 node with LXC and centos stream 9 container.
and I did not noticed any critical systemd troubles with original -EAGAIN.
When cgroup's limit is reached systemd cannot start new services,=20
for example lxc-attach generates following output:

[root@fc34-vvs ~]# lxc-attach c9s
lxc-attach: c9s: cgroups/cgfsng.c: cgroup_attach_leaf: 2084 Resource tempor=
arily unavailable - Failed to create leaf cgroup ".lxc"
lxc-attach: c9s: cgroups/cgfsng.c: __cgroup_attach_many: 3517 Resource temp=
orarily unavailable - Failed to attach to cgroup fd 11
lxc-attach: c9s: attach.c: lxc_attach: 1679 Resource temporarily unavailabl=
e - Failed to attach cgroup
lxc-attach: c9s: attach.c: do_attach: 1237 No data available - Failed to re=
ceive lsm label fd
lxc-attach: c9s: attach.c: do_attach: 1375 Failed to attach to container

I did not found any loop in userspace caused by EAGAIN.
Messages looks unclear, however situation with the patched kernel is not mu=
ch better:

[root@fc34-vvs ~]# lxc-attach c9s
lxc-attach: c9s: cgroups/cgfsng.c: cgroup_attach_leaf: 2084 No space left o=
n device - Failed to create leaf cgroup ".lxc"
lxc-attach: c9s: cgroups/cgfsng.c: __cgroup_attach_many: 3517 No space left=
 on device - Failed to attach to cgroup fd 11
lxc-attach: c9s: attach.c: lxc_attach: 1679 No space left on device - Faile=
d to attach cgroup
lxc-attach: c9s: attach.c: do_attach: 1237 No data available - Failed to re=
ceive lsm label fd
lxc-attach: c9s: attach.c: do_attach: 1375 Failed to attach to container

Thank you,
	Vasily Averin
