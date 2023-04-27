From: Anand Krishnamoorthi <anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: Re: [EXTERNAL] [PATCH v2 00/18]  Add Cgroup support for SGX EPC
 memory
Date: Thu, 27 Apr 2023 16:53:52 +0000
Message-ID: <DM6PR21MB11773AC7B4ED51BF1DC46AF8C46A9@DM6PR21MB1177.namprd21.prod.outlook.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <DM6PR21MB11778ABA54CD33A5822D5B24C4929@DM6PR21MB1177.namprd21.prod.outlook.com>
 <DM6PR21MB11772A6ED915825854B419D6C4989@DM6PR21MB1177.namprd21.prod.outlook.com>
 <ZD7Iutppjj+muH4p@himmelriiki>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9VA/y0ULWdq2yOPtKaNNmChNlJPTp+5aSkzz1wc4b4=;
 b=CsoLQ34Q4UXb4wbeKJm1yQBEp3EmsTMJeIy4nvWjFaLcfFGkJ/JVim7AXgJ+DHfJEr9+Kx2Gos4ps0PE0BtcCKTzQAB2V39yv86Wa0Jzq4iUfLzMuWlnd1UZeTsBAOn/2QaqVE4Aa9LmwcwfyXU3gp/9qHbE6DMjlzN4csEYPWE=
In-Reply-To: <ZD7Iutppjj+muH4p@himmelriiki>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mikko Ylinen <mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Liz Zhang <lizzha-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Bo Zhang (ACC)" <zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Adding Liz Zhang.




From: Mikko Ylinen <mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sent: Tuesday, April 18, 2023 9:44 AM
To: Anand Krishnamoorthi <anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>; jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org <j=
arkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org=
>; tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <linux-kerne=
l@vger.kernel.org>; linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; =
cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Bo Zhang (ACC) <zhanb@mi=
crosoft.com>; zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [EXTERNAL] [PATCH v2 00/18] Add Cgroup support for SGX EPC mem=
ory

[Some people who received this message don't often get email from mikko.yli=
nen-VuQAYsv1561d/zcNHIZz5Q@public.gmane.org Learn why this is important at https://aka.ms/LearnAbo=
utSenderIdentification ]

Hi,

On Thu, Apr 13, 2023 at 06:49:53PM +0000, Anand Krishnamoorthi wrote:
> For Azure, SGX cgroup support feature is very useful.
> It is needed to enforce the EPC resource limitation of Kubernetes pods on=
 SGX nodes.

I've been working on enabling the same use case with the difference that
I'm setting per container EPC limits (instead of pods). The Open Container
Initiative (OCI) runtime spec [1] defines how it's done and with the misc
controller implemented here "misc.max": "sgx_epc 42" setting for a containe=
r
is supported by runc out of the box.

In addition to being able to set limits per container/pod, the cgroup for
SGX EPC helps to build better telemetry/monitoring for EPC consumtion.

[1] https://github.com/opencontainers/runtime-spec/blob/main/config-linux.m=
d#unified

>
> Today, in Azure Kubernetes Service, each pod on SGX node claims a nominal=
 EPC memory requirement. K8s will track the unclaimed EPC memories on SGX n=
odes to schedule pods.
> However, there's no enforcement on the node whether the pod uses more EPC=
 memory than what it claims. If EPC is running out on the node, the kernel =
will do EPC paging, which will cause all pods suffering performance degrada=
tion.
>
> Cgroup support for EPC will enforce EPC resource limitation on pod level,=
 so that when a pod tries to use more EPC than what it claims, it will be E=
PC paged while other pods are not affected.
>
> -Anand
>
> From: Anand Krishnamoorthi <anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Sent: Monday, April 3, 2023 2:26 PM
> To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>; jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org =
<jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org <dave.hansen-VuQAYsv1563A2t4k+OOtxA@public.gmane.org=
om>; tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <linux-ker=
nel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>=
; cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Bo Zhang (ACC) <zhanb@=
microsoft.com>
> Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [EXTERNAL] [PATCH v2 00/18] Add Cgroup support for SGX EPC m=
emory
>
> Adding Bo Zhang to thread.
>
> -Anand
>
>
> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Sent: Friday, December 2, 2022 10:36 AM
> To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org <d=
ave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>; tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; linux-kernel@vg=
er.kernel.org <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <li=
nux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: [EXTERNAL] [PATCH v2 00/18] Add Cgroup support for SGX EPC memor=
y
>
> Utilize the Miscellaneous cgroup controller to regulate the distribution
> of SGX EPC memory, which is a subset of system RAM that is used to provid=
e
> SGX-enabled applications with protected memory, and is otherwise inaccess=
ible.
>
> SGX EPC memory allocations are separate from normal RAM allocations,
> and is managed solely by the SGX subsystem. The existing cgroup memory
> controller cannot be used to limit or account for SGX EPC memory.
>
> This patchset implements the support for sgx_epc memory within the
> misc cgroup controller, and then utilizes the misc cgroup controller
> to provide support for setting the total system capacity, max limit
> per cgroup, and events.
>
> This work was originally authored by Sean Christopherson a few years ago,
> and was modified to work with more recent kernels, and to utilize the
> misc cgroup controller rather than a custom controller. It is currently
> based on top of the MCA patches.
>
> Here's the MCA patchset for reference.
> https://lore.kernel.org/linux-sgx/2d52c8c4-8ed0-6df2-2911-da5b9fcc9ae4@in=
tel.com/T/#t
>
> The patchset adds support for multiple LRUs to track both reclaimable
> EPC pages (i.e. pages the reclaimer knows about), as well as unreclaimabl=
e
> EPC pages (i.e. pages which the reclaimer isn't aware of, such as va page=
s).
> These pages are assigned to an LRU, as well as an enclave, so that an
> enclave's full EPC usage can be tracked, and limited to a max value. Duri=
ng
> OOM events, an enclave can be have its memory zapped, and all the EPC pag=
es
> not tracked by the reclaimer can be freed.
>
> I appreciate your comments and feedback.
>
> Changelog:
>
> v2:
>  * rename struct sgx_epc_lru to sgx_epc_lru_lists to be more clear
>    that this struct contains 2 lists.
>  * use inline functions rather than macros for sgx_epc_page_list*
>    wrappers.
>  * Remove flags macros and open code all flags.
>  * Improve the commit message for RECLAIM_IN_PROGRESS patch to make
>    it more clear what the patch does.
>  * remove notifier_block from misc cgroup changes and use a set
>    of ops for callbacks instead.
>  * rename root_misc to misc_cg_root and parent_misc to misc_cg_parent
>  * consolidate misc cgroup changes to 2 patches and remove most of
>    the previous helper functions.
>
> Kristen Carlson Accardi (7):
>   x86/sgx: Add 'struct sgx_epc_lru_lists' to encapsulate lru list(s)
>   x86/sgx: Use sgx_epc_lru_lists for existing active page list
>   x86/sgx: Track epc pages on reclaimable or unreclaimable lists
>   cgroup/misc: Add per resource callbacks for css events
>   cgroup/misc: Prepare for SGX usage
>   x86/sgx: Add support for misc cgroup controller
>   Docs/x86/sgx: Add description for cgroup support
>
> Sean Christopherson (11):
>   x86/sgx: Call cond_resched() at the end of sgx_reclaim_pages()
>   x86/sgx: Store struct sgx_encl when allocating new VA pages
>   x86/sgx: Introduce RECLAIM_IN_PROGRESS flag for EPC pages
>   x86/sgx: Use a list to track to-be-reclaimed pages during reclaim
>   x86/sgx: Allow reclaiming up to 32 pages, but scan 16 by default
>   x86/sgx: Return the number of EPC pages that were successfully
>     reclaimed
>   x86/sgx: Add option to ignore age of page during EPC reclaim
>   x86/sgx: Prepare for multiple LRUs
>   x86/sgx: Expose sgx_reclaim_pages() for use by EPC cgroup
>   x86/sgx: Add helper to grab pages from an arbitrary EPC LRU
>   x86/sgx: Add EPC OOM path to forcefully reclaim EPC
>
>  Documentation/x86/sgx.rst            |  77 ++++
>  arch/x86/Kconfig                     |  13 +
>  arch/x86/kernel/cpu/sgx/Makefile     |   1 +
>  arch/x86/kernel/cpu/sgx/encl.c       |  90 ++++-
>  arch/x86/kernel/cpu/sgx/encl.h       |   4 +-
>  arch/x86/kernel/cpu/sgx/epc_cgroup.c | 539 +++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/epc_cgroup.h |  59 +++
>  arch/x86/kernel/cpu/sgx/ioctl.c      |  14 +-
>  arch/x86/kernel/cpu/sgx/main.c       | 412 ++++++++++++++++----
>  arch/x86/kernel/cpu/sgx/sgx.h        | 122 +++++-
>  arch/x86/kernel/cpu/sgx/virt.c       |  28 +-
>  include/linux/misc_cgroup.h          |  35 ++
>  kernel/cgroup/misc.c                 |  76 +++-
>  13 files changed, 1341 insertions(+), 129 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.h
>
> --
> 2.38.1
