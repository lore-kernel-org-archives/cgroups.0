From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [HMM-CDM 0/5] Cache coherent device memory (CDM) with HMM
Date: Wed, 14 Jun 2017 17:38:01 -0400
Message-ID: <20170614213800.GD4160@redhat.com>
References: <20170614201144.9306-1-jglisse@redhat.com>
 <8219f8fb-65bb-7c6b-6c4c-acc0601c1e0f@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com E433B80C11
Content-Disposition: inline
In-Reply-To: <8219f8fb-65bb-7c6b-6c4c-acc0601c1e0f-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Balbir Singh <balbirs-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>

On Wed, Jun 14, 2017 at 02:20:23PM -0700, Dave Hansen wrote:
> On 06/14/2017 01:11 PM, J=E9r=F4me Glisse wrote:
> > Cache coherent device memory apply to architecture with system bus
> > like CAPI or CCIX. Device connected to such system bus can expose
> > their memory to the system and allow cache coherent access to it
> > from the CPU.
>=20
> How does this interact with device memory that's enumerated in the new
> ACPI 6.2 HMAT?  That stuff is also in the normal e820 and, by default,
> treated as normal system RAM.  Would this mechanism be used for those
> devices as well?
>=20
> http://www.uefi.org/sites/default/files/resources/ACPI_6_2.pdf

It doesn't interact with that. HMM-CDM is a set of helper that don't
do anything unless instructed so. So for device memory to be presented
as HMM-CDM you need to hotplug it as ZONE_DEVICE(DEVICE_PUBLIC) which
can be done with the helper introduced in patch 2 of this patchset.

I don't think that the HMAT inside ACPI is restricted or even intended
for device memory. The kind of memory i am refering too in HMM-CDM is
for instance GPU on board memory. On PCIE system the CPU can not access
such memory in the same manner as regular memory but on CAPI or CCIX
system it can.

How such memory is listed is platform/architecture specific and HMM-CDM
does not deal with that. So PowerPC CAPI will have its own way of
discovering such device memory. So will CCIX platform (thought for CCIX
i expect that UEFI/ACPI will be involve through HMAT or something new).

Also if HMAT allow represent device memory, the choice to use HMM-CDM
would still be with the device driver. For persistent memory is does not
make sense and it might not make sense for other devices too. I expect
this to be usefull for GPU, FPGA or similar accelerator (like Xeon Phi
as add on card if there is ever something like CCIX supported by Intel).

Hope this answer your question

J=E9r=F4me
