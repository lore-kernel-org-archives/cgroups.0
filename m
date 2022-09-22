From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Thu, 22 Sep 2022 11:59:14 -0700
Message-ID: <4b8605533e5deade739249bfb341ab9c06d56a1e.camel@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
         <YyyeSVSk/lWdo/W4@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663873156; x=1695409156;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=nHUCn3fAp1cyQDcEoHfYvoWZgKU6VQGrac32k6xR4P0=;
  b=P3ln6hnc5jgZaQKAPiiI1e0ljLEJdeziQv1z5nniUHIzDRp2/USzbMUC
   qcSzJFDfipCO+HKs/2pylFlMEHMD9BY4oIXLtVQGbmjzmXAphXELSCT6q
   UZDKqIlnfKX0ELx/V1tb/uoLd7zCI16B7KzuvMAnCP4erefncTb/jlCfn
   HtYKUojpSEDh+jqmJxbUID9Z2XTF1zQZQF48/nTQfbm008XtO+GqUVtVA
   b7PBb3NhWX34WcYA7d/UtNZFztZjRxVS0Ya658MFxSWhSwTMMO3p5hVp6
   5R9+ckMoTI1A+UJcphyZ3JkV4pZ9tlDIVtbaqNlf3kduK+e3RxveRT79k
   A==;
In-Reply-To: <YyyeSVSk/lWdo/W4-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Thu, 2022-09-22 at 07:41 -1000, Tejun Heo wrote:
> Hello,
>=20
> (cc'ing memcg folks)
>=20
> On Thu, Sep 22, 2022 at 10:10:37AM -0700, Kristen Carlson Accardi
> wrote:
> > Add a new cgroup controller to regulate the distribution of SGX EPC
> > memory,
> > which is a subset of system RAM that is used to provide SGX-enabled
> > applications with protected memory, and is otherwise inaccessible.
> >=20
> > SGX EPC memory allocations are separate from normal RAM
> > allocations,
> > and is managed solely by the SGX subsystem. The existing cgroup
> > memory
> > controller cannot be used to limit or account for SGX EPC memory.
> >=20
> > This patchset implements the sgx_epc cgroup controller, which will
> > provide
> > support for stats, events, and the following interface files:
> >=20
> > sgx_epc.current
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0A read-only value which=
 represents the total amount of EPC
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memory currently being =
used on by the cgroup and its
> > descendents.
> >=20
> > sgx_epc.low
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0A read-write value whic=
h is used to set best-effort
> > protection
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0of EPC usage. If the EP=
C usage of a cgroup drops below this
> > value,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0then the cgroup's EPC m=
emory will not be reclaimed if
> > possible.
> >=20
> > sgx_epc.high
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0A read-write value whic=
h is used to set a best-effort limit
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0on the amount of EPC us=
age a cgroup has. If a cgroup's
> > usage
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0goes past the high valu=
e, the EPC memory of that cgroup
> > will
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0get reclaimed back unde=
r the high limit.
> >=20
> > sgx_epc.max
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0A read-write value whic=
h is used to set a hard limit for
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cgroup EPC usage. If a =
cgroup's EPC usage reaches this
> > limit,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0allocations are blocked=
 until EPC memory can be reclaimed
> > from
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0the cgroup.
>=20
> I don't know how SGX uses its memory but you said in the other
> message that
> it's usually a really small portion of the memory and glancing the
> code it
> looks like its own page aging and all. Can you give some concrete
> examples
> on how it's used and why we need cgroup support for it? Also, do you
> really
> need all three control knobs here? e.g. given that .high is only
> really
> useful in conjunction with memory pressure and oom handling from
> userspace,
> I don't see how this would actually be useful for something like
> this.
>=20
> Thanks.
>=20

Thanks for your question. The SGX EPC memory is a global shared
resource that can be over committed. The SGX EPC controller should be
used similarly to the normal memory controller. Normally when there is
pressure on EPC memory, the reclaimer thread will write out pages from
EPC memory to a backing RAM that is allocated per enclave. It is
possible currently for even a single enclave to force all the other
enclaves to have their epc pages written to backing RAM by allocating
all the available system EPC memory. This can cause performance issues
for the enclaves when they have to fault to load pages page in.

sgx_epc.high value will help control the EPC usage of the cgroup. The
sgx reclaimer will use this value to prevent the total EPC usage of a
cgroup from exceeding this value (best effort). This way, if a system
administrator would like to try to prevent single enclaves, or groups
of enclaves from allocating all of the EPC memory and causing
performance issues for the other enclaves on the system, they can set
this limit. sgx_epc.max can be used to set a hard limit, which will
cause an enclave to get all it's used pages zapped and it will
effectively be killed until it is rebuilt by the owning sgx
application. sgx_epc.low can be used to (best effort) try to ensure
that some minimum amount of EPC pages are protected for enclaves in a
particular cgroup. This can be useful for preventing evictions and thus
performance issues due to faults.

I hope this answers your question.

Thanks,
Kristen

