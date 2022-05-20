From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: enable accounting for struct cgroup
Date: Fri, 20 May 2022 10:24:06 +0300
Message-ID: <740dfcb1-5c5f-6a40-0f71-65f277f976d6@openvz.org>
References: <Ynv7+VG+T2y9rpdk@carbon>
 <a17be77f-dc3b-d69a-16e2-f7309959c525@openvz.org>
 <20220519165325.GA2434@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qdKh+N5pd3RacKLxyxnq7jBphDna5YoiYMrg0p2wipA=;
        b=5jgKeLMV735gNvNQvBxyWcKxrinA/LTQb+b782a1NT6dU8Hb8SwexSfGf3rr6Urfg/
         A4ulspIJhZ3yOgPJZd+EKgl0kpahqXgFG9HCgN1Wc8GjBaWrXg58cC/HpNBxipLfUVmm
         C4fRFmODcna91lSjcUnQol9cuES8Sfnijsv9sdrHJicrrtFayez6dTiUhjC7pthBoeHx
         YzHcD5rk+a4JszXIOzAp2/GDY88BpXCM9JJQ5708wwNf3+X8K7fuOM1ykSdVtKAi/wEY
         AAcr0ZK59rSxCEkQPd0o2XuJ8TO5oJrKJjaWcEdEDp+nfQDK0PNHPwv3MkelltsubHI0
         Rj8A==
Content-Language: en-US
In-Reply-To: <20220519165325.GA2434-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 5/19/22 19:53, Michal Koutn=C3=BD wrote:
> On Fri, May 13, 2022 at 06:52:12PM +0300, Vasily Averin <vvs-GEFAQzZX7r8d=
nm+yROfE0A@public.gmane.org> wrote:
>> Creating each new cgroup allocates 4Kb for struct cgroup. This is the
>> largest memory allocation in this scenario and is epecially important
>> for small VMs with 1-2 CPUs.
>=20
> What do you mean by this argument?
>=20
> (On bigger irons, the percpu components becomes dominant, e.g. struct
> cgroup_rstat_cpu.)

Michal, Shakeel,
thank you very much for your feedback, it helps me understand how to improve
the methodology of my accounting analyze.
I considered the general case and looked for places of maximum memory alloc=
ations.
Now I think it would be better to split all called allocations into:
- common part, called for any cgroup type (i.e. cgroup_mkdir and cgroup_cre=
ate),
- per-cgroup parts,
and focus on 2 corner cases: for single CPU VMs and for "big irons".
It helps to clarify which allocations are accounting-important and which on=
es
can be safely ignored.

So right now I'm going to redo the calculations and hope it doesn't take lo=
ng.

Thank you,
	Vasily Averin
