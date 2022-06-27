From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Tue, 28 Jun 2022 04:10:29 +0900
Message-ID: <YroApRMPV/6zO5I8@mtj.duckdns.org>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-8-longman@redhat.com>
 <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
 <404171dc-0da3-21f2-5003-9718f875e967@redhat.com>
 <YqarMyNo9oHxhZFh@slm.duckdns.org>
 <20220613142452.GB6910@blackbody.suse.cz>
 <YqdzuSQuAeiPXQvy@slm.duckdns.org>
 <20220613175548.GB21665@blackbody.suse.cz>
 <Yqd7WMFj6AEyV3Cy@slm.duckdns.org>
 <20220614115345.GA6771@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/TJYBcpsxpHM1dgljke9KHv7g4SupUF3o95Sw1aZ2ck=;
        b=IUrCqExbfNSEqdj1+aclN5lVCX6iP7eBPxz3UnA29I42X7w8qUJC0d2QFa6lECfvHS
         lTMdErf6FACs1/hyp38L86tGz+o787pLf2VIheb7iIKAGcJlc9+ImxpPc6dZHKPr2Lnd
         297Swn9MhvVXOe5pLyL9hyobmlUtJUylIgtVuWFNUy7M/cvy0Ei9a+7/6RNLP/vuaWpm
         qPXLfyJ7VkpxIpiy0dSvQGEwS2wO1IikzptCMphwHEF+yGlRha2BCj6vVKJloizO0jzV
         wtWURRXun0tZKmoLu2aju0/0SznVwcWbO33ww6x17xU68Xd6vEBZdnna3JSmuqObPHbN
         196g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220614115345.GA6771-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Tue, Jun 14, 2022 at 01:53:45PM +0200, Michal Koutn=FD wrote:
> On Mon, Jun 13, 2022 at 08:00:56AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yR=
OfE0A@public.gmane.org> wrote:
> > Yeah, I don't know why this part is different from any other errors tha=
t the
> > parent can make.
>=20
> It's different because a write to parent's cpuset.cpus is independent of
> whether cpuset.cpus of its children are exclusive or not.
> In an extreme case the children may be non-exclusive
>=20
>     parent	cpuset.cpus=3D0-3 //   valid partition
>     `- child_1	cpuset.cpus=3D0-1	// invalid partition
>     `- child_2	cpuset.cpus=3D1-2 // invalid partition
>=20
> but the parent can still be a valid partition (thanks to cpu no. 3 in
> the example above).
>=20
> Do I miss anything?

What I'm trying to say is that cpuset.cpus of child_1 and child_2 are
owned by the parent, so a feature which blocks siblings from
intersecting each other doesn't make whole lot of sense because all
those files are under the control of the parent who would have the
power to enable or disable the restrition anyway.

The partition mode file is owned by the parent too, right? So, all
these are to be configured by the same entity and the errors can be
reported the same way, no?

Thanks.

--=20
tejun
