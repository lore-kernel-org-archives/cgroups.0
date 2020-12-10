From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Date: Thu, 10 Dec 2020 15:54:01 +0100
Message-ID: <4f7b9c3f-200e-6127-1d94-91dd9c917921@de.ibm.com>
References: <20201209205413.3391139-1-vipinsh@google.com>
 <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VsCisPySZHG4Vff0eAvJw4F76GzoTiGXaBqWHoCkKF0=;
 b=H/i0vBJaVrEsIxTNzzpSFA/FCskUwAue6ja+2YX99G5xdQAchy5YHz28mh0jiokEVJh3
 cVZVOQaOOGLQHSbKM9vb4OlkQS0lpZNLgdmAh8uifjptyOloMlsBkGmjAkOL/h1hmyzo
 5ANkm8pODhkiJfDX7wP2kvW+FVbcpDzP7v9QbxASmDfzsNGCUl8QrHMs+c0AZVs4IHoc
 r9bYF0tv/FR5mng22P6Rrs6Qc283dFG5Jc4L9VdSpX8y9OHnYyDSwE27LhruKR4v7YxK
 zypN7M+fXF08EenWsawvPzSRb+wz9CHSdTqjHIRc4bmgMRRK7ZcttZS5CtfejBDyWve/ 3Q== 
In-Reply-To: <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj@kernel.org>, Vipin Sharma <vipinsh@google.com>
Cc: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On 09.12.20 21:58, Tejun Heo wrote:
> Hello,
>=20
> Rough take after skimming:
>=20
> * I don't have an overall objection. In terms of behavior, the only thing
>   which stood out was input rejection depending on the current usage. The
>   preferred way of handling that is rejecting future allocations rather t=
han
>   failing configuration as that makes it impossible e.g. to lower limit a=
nd
>   drain existing usages from outside the container.
>=20
> * However, the boilerplate to usefulness ratio doesn't look too good and I
>   wonder whether what we should do is adding a generic "misc" controller
>   which can host this sort of static hierarchical counting. I'll think mo=
re
>   on it.

We first dicussed to have
encryption_ids.stat
encryption_ids.max
encryption_ids.current

and we added the sev in later, so that we can also have tdx, seid, sgx or w=
hatever.
Maybe also 2 or more things at the same time.

Right now this code has

encryption_ids.sev.stat
encryption_ids.sev.max
encryption_ids.sev.current

And it would be trivial to extend it to have
encryption_ids.seid.stat
encryption_ids.seid.max
encryption_ids.seid.current
on s390 instead (for our secure guests).

So in the end this is almost already a misc controller, the only thing that=
 we
need to change is the capability to also define things other than encryptio=
n.*.*
And of course we would need to avoid adding lots of random garbage to such =
a thing.

But if you feel ok with the burden to keep things kind of organized a misc
controller would certainly work for the encryption ID usecase as well.=20
So I would be fine with the thing as is or a misc control=C4=BAer.

Christian
