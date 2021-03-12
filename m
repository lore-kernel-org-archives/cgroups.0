From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Date: Fri, 12 Mar 2021 15:18:28 -0600
Message-ID: <04f58780-5392-63ed-589b-259de695e4c3@amd.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com> <YEpod5X29YqMhW/g@blackbook>
 <YEvFldKZ8YQM+t2q@google.com> <YEvUTatAjIoP7dPD@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18cHAm1AC7Yf5jApTKiftia0rxqWJiiNh+UM0xqalZE=;
 b=aNX7sxStiIzkOyJyVxAzeIpHlv/0LRPkEebFLflQUkYca7YmEx3P3MXFcrutTSH2z7NIEVNyj4nA7kic+uRVwzcIQgUaTCgY6mJGt5rz2+YbOWi9XCs/kH6hWym16U9VH3v5CkR35+jginGCr4mmoLbgF38w5dIZYzf6tc9Sacw=
In-Reply-To: <YEvUTatAjIoP7dPD-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, brijesh.singh-5C7GfCeVMHo@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 3/12/21 2:51 PM, Sean Christopherson wrote:
> On Fri, Mar 12, 2021, Vipin Sharma wrote:
>> On Thu, Mar 11, 2021 at 07:59:03PM +0100, Michal Koutn=C3=BD wrote:
>>>> +#ifndef CONFIG_KVM_AMD_SEV
>>>> +/*
>>>> + * When this config is not defined, SEV feature is not supported and =
APIs in
>>>> + * this file are not used but this file still gets compiled into the =
KVM AMD
>>>> + * module.
>>>> + *
>>>> + * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries in=
 the enum
>>>> + * misc_res_type {} defined in linux/misc_cgroup.h.
>>> BTW, was there any progress on conditioning sev.c build on
>>> CONFIG_KVM_AMD_SEV? (So that the defines workaround isn't needeed.)
>>
>> Tom, Brijesh,
>> Is this something you guys thought about or have some plans to do in the
>> future? Basically to not include sev.c in compilation if
>> CONFIG_KVM_AMD_SEV is disabled.
>=20
> It's crossed my mind, but the number of stubs needed made me back off.  I=
'm
> certainly not opposed to the idea, it's just not a trivial change.

Right, I looked at it when I was doing the SEV-ES work and came to the=20
same conclusion.

Thanks,
Tom

>=20
