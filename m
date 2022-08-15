From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: Query regarding deadlock involving cgroup_threadgroup_rwsem and
 cpu_hotplug_lock
Date: Mon, 15 Aug 2022 16:29:24 +0530
Message-ID: <f584fecd-6ca4-4ab0-763d-2ed219009c61@quicinc.com>
References: <8245b710-8acb-d8e6-7045-99a5f71dad4e@oracle.com>
 <26d0e4cc-be0e-2c12-6174-dfbb1edb1ed6@oracle.com>
 <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
 <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com>
 <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
 <YthDz4BnfYHce1od@slm.duckdns.org> <YuGTBLkFerUboctl@slm.duckdns.org>
 <dc0cff0e-b744-9d5d-e727-70d1c31b2a74@quicinc.com>
 <20220815090556.GB27407@blackbody.suse.cz>
 <CAB8ipk90LxNNbq5OKamd-ArkqhEZjxS1fFZJXtnbQwGzyyJ3wQ@mail.gmail.com>
 <20220815093934.GA29323@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=Z3aS594wlbhZKWisoOFso7+h9XZN3ISVE0QdwPxZcJY=;
 b=WRBbzsoENcdRq19Ujq2hw46Z6kxBNsWKO06VrzMF7SEyBencFrzeigFRF12ZLZzSkNXP
 0EpHbA96kWD0/6PCPMHpwlmD6XJ7ClZ3C5J0WGdSg5JXWc9Ud2rNs8Qf6nXHbWIBXW4x
 gWYRwVNfT7Lhl/3UVd0ni1Y6x0pIV50SiGAEjrzAk8nZFYIlanb+8wvt+i7A/lqdQg5W
 asIyl83STQ/srrHqvga0Dt67TY8WH5+/g9gOnyPs8FgQLHvrvtroZa8ReMh/PFt7FTi7
 QFuJB9ip3HQeqiTnKYIf403tk/9/MHOcUHiWzhqP00mxAfE893BDU4FhNDb9Tr65HCCI Ug== 
Content-Language: en-US
In-Reply-To: <20220815093934.GA29323-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Xuewen Yan <xuewen.yan94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>



On 8/15/2022 3:09 PM, Michal Koutn=C3=BD wrote:
> On Mon, Aug 15, 2022 at 05:25:52PM +0800, Xuewen Yan <xuewen.yan94-Re5JQE=
eQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Your means is that the problem should be fixed by [1]+[2]'s revert ?
>=20
> I understood that was already the combination you had tested.
> You write in [T] that [1] alone causes (another) deadlock and therefore
> the revert of [2] was suggested.
>=20
>> I just tested the case which reverted the [2]. Need I test with [1] and =
[2]?
>=20
> It'd be better (unless you haven't already :-), my reasoning is for the
> [1]+[2] combo.

Feel free to add my

Reported-and-tested-by: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@publ=
ic.gmane.org>

-Mukesh
>=20
> Thanks,
> Michal
>=20
> [T] https://lore.kernel.org/r/CAB8ipk_gCLtvEahsp2DvPJf4NxRsM8WCYmmH=3DyTd=
7zQE+81_Yg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
