From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [HMM-CDM 0/5] Cache coherent device memory (CDM) with HMM
Date: Thu, 15 Jun 2017 09:40:43 +1000
Message-ID: <CAKTCnz=4AKGnfF5HtcyMQot6zMgtOc+eRiZ5=G+MDYWAFN1bEg@mail.gmail.com>
References: <20170614201144.9306-1-jglisse@redhat.com> <8219f8fb-65bb-7c6b-6c4c-acc0601c1e0f@intel.com>
 <20170614213800.GD4160@redhat.com> <3a617630-2406-da49-707c-4959a2afd8e1@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZNmWJZokLhknfGInBjEUE1ugdxF0kCL5E+xENPLXWqk=;
        b=ek5H0IbULDiDe9B00ZoRiA3xF2vUpBtndqAO7R0nrYvTjjYQFo0DQ/Rs7ME1qpbJW5
         bYBodshpv7Eg5RpLpz5QyuIk/lpSmTRPxZj747RnlKmBeQhFsGVUi+dGQvYLufI4PgvS
         Ezm6Z6HcQhRzYtvhH7hfBfk2/Zy/7r0nORnd3dXDPgC150BkgMVe0HbvJKveXqpjUtXL
         JWfljBR+ZJOQuhfKWzIEiKZBTCD98qPDGSaTvbW5YjydIPK1KWJJPhM630FQUxlbQqIw
         YCGx72mpDc+4uQyrDDAc24GvNEnK5ZhCiW3wkdQq43J0lSHYQCVOuUEkIAvKvU0r3D5T
         iDxg==
In-Reply-To: <3a617630-2406-da49-707c-4959a2afd8e1-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>

On Thu, Jun 15, 2017 at 7:58 AM, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On 06/14/2017 02:38 PM, Jerome Glisse wrote:
>> On Wed, Jun 14, 2017 at 02:20:23PM -0700, Dave Hansen wrote:
>>> On 06/14/2017 01:11 PM, J=C3=A9r=C3=B4me Glisse wrote:
>>>> Cache coherent device memory apply to architecture with system bus
>>>> like CAPI or CCIX. Device connected to such system bus can expose
>>>> their memory to the system and allow cache coherent access to it
>>>> from the CPU.
>>> How does this interact with device memory that's enumerated in the new
>>> ACPI 6.2 HMAT?  That stuff is also in the normal e820 and, by default,
>>> treated as normal system RAM.  Would this mechanism be used for those
>>> devices as well?
>>>
>>> http://www.uefi.org/sites/default/files/resources/ACPI_6_2.pdf
>> It doesn't interact with that. HMM-CDM is a set of helper that don't
>> do anything unless instructed so. So for device memory to be presented
>> as HMM-CDM you need to hotplug it as ZONE_DEVICE(DEVICE_PUBLIC) which
>> can be done with the helper introduced in patch 2 of this patchset.
>

[Removing my cc'd email id and responding from a different address]

> I guess I'm asking whether we *should* instruct HMM-CDM to manage all
> coherent device memory.  If not, where do we draw the line for what we
> use HMM-CDM, and for what we use the core MM?
>

If you believe the memory is managed by the device (and owned by a device
driver) I'd suggest using HMM-CDM. The idea behind HMM-CDM was that
it enables transparent migration of pages and its preferred when
locality of computation
and locality of memory access is the preferred model.

The other model was N_COHERENT_MEMORY that used the core MM, but
there were objections to exposing device memory using that technology.

Balbir Singh.
