From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcontrol: return 1 from cgroup.memory __setup()
 handler
Date: Thu, 3 Mar 2022 14:53:59 -0800
Message-ID: <8c61e14d-493d-ecea-6bc5-076781e8e93d@infradead.org>
References: <20220222005811.10672-1-rdunlap@infradead.org>
 <20220302185300.GA19699@blackbody.suse.cz>
 <9f8d4ddb-81ce-738a-d1f7-346ff9bf8ebd@infradead.org>
 <20220303101406.GE10867@blackbody.suse.cz>
 <5130da56-0f22-8212-0ea3-6ddb8a8f5455@infradead.org>
 <YiFCAFZwG//aeQP2@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=WhlL7h61341iIESeWTlGbuGhMPR1lyzTfnmPlu4dcLQ=; b=SCFq8+cO6okq1ihYq2bG0Y1KNL
        AdmVymHxeldmywraXF2E/01Df0bz2MzSsQbpLLy4eD7iL2hltsD/4KXshR4FmgEp3vNhjyv9C94n+
        r42JfSLPt8b6a+pAo7vx3UajGo1JZi9bpNegCTmSLaXHJJFzsOKU2PqJ5UPSjoYD6tN6gMQA6pXeY
        Oh2sGCJ8qeT2mpBtzfjfINkRtttkHBXJjHs8xlRMLgQIdNqdqJBQkXpiq42qvedN4f9IDnGLLYFae
        DlPxT5/h4R9ZA7udADgVmsGtNDtMBGKN84O9S9kKdGfHx+tPuIvBhjrMJ9PX4mMb0a5Lgof8bVfGX
        ArPe3CUg==;
Content-Language: en-US
In-Reply-To: <YiFCAFZwG//aeQP2@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Igor Zhbanov <i.zhbanov-4G3FwjhnV40EXkLx5dDeUA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 3/3/22 14:32, Michal Koutn=C3=BD wrote:
> On Thu, Mar 03, 2022 at 01:53:03PM -0800, Randy Dunlap <rdunlap-wEGCiKHe2=
LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>> Isn't mere presence of the handler sufficient to filter those out? [1]
>>
>> What is [1] here?
>=20
> Please ignore, too much editing on my side.
>=20
>> I don't know of any case where "foo=3D2" should be passed to init if
>> there is a setup function for "foo=3D" defined.
>=20
> Good. I was asking because of the following semantics:
> - absent handler -- pass to init,

Ack: if the handler code is not built, it is an Unknown boot option
and is passed to init.

> - returns 0 -- filter out,
> - returns negative -- filter out, print message.

Currently setup functions should return 1 (or any non-zero value)
to indicate "handled" or should return 0 to indicate "not handled".

Andrew has a patch in mmotm: include/linux/init.h so that the comment
before __setup() says:

/*
 * NOTE: __setup functions return values:
 * @fn returns 1 (or non-zero) if the option argument is "handled"
 * and returns 0 if the option argument is "not handled".
 */

>>> (Richer reporting or -EINVAL is by my understanding now a different
>>> problem.)

--=20
~Randy
