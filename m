From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Fri, 19 Feb 2021 11:02:41 -0800
Message-ID: <71092e0e-5c72-924b-c848-8ae9a589f6b0@infradead.org>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-3-vipinsh@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=eQRc2hVweb9hW0U8/mfMxGsY5GwShDfUkREH/4Ybsf4=; b=o14JEMvMVJp6U2Yde53xvkmB5H
        Sr3DZjZBhSij+WxewYeQLgg+oCv03f7wpMkRxYbvkaiuqHfReW1rLG++eegVtlty3hm0cjleO1cpy
        oJ9jzzyBgkpLiNS8M/MM/Bgqv8P5/vpJmF8Qg21gwKNb+d6UN2nS3pscO7aHbCxlIoK/u2Umj3jix
        yeRDJIIml5xqxWPYxVAEvD6qgxDyPuln/ejvkzUXOGcwXwqIEN6JWzxkVe/dz83u8/+DdI11OILhc
        jvaidLJbypjw8NAUXCGl1UIuuC0l48I9jIZvyZGG3HmLqJafyULiiLLfUKrIMvH/09jU87qJRIXM/
        kSfKRrWA==;
In-Reply-To: <20210218195549.1696769-3-vipinsh@google.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vipin Sharma <vipinsh@google.com>, tj@kernel.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com
Cc: corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

On 2/18/21 11:55 AM, Vipin Sharma wrote:
> Documentation of miscellaneous cgroup controller. This new controller is
> used to track and limit usage of scalar resources.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Reviewed-by: David Rientjes <rientjes@google.com>
> ---
>  Documentation/admin-guide/cgroup-v1/misc.rst |  1 +
>  Documentation/admin-guide/cgroup-v2.rst      | 64 +++++++++++++++++++-
>  2 files changed, 63 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst
> 
> diff --git a/Documentation/admin-guide/cgroup-v1/misc.rst b/Documentation/admin-guide/cgroup-v1/misc.rst
> new file mode 100644
> index 000000000000..8e9e9311daeb
> --- /dev/null
> +++ b/Documentation/admin-guide/cgroup-v1/misc.rst
> @@ -0,0 +1 @@
> +/Documentation/admin-guide/cgroup-v2.rst
What is the purpose of this (above) file?

> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 1de8695c264b..1a41a3623b9b 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -63,8 +63,11 @@ v1 is available under :ref:`Documentation/admin-guide/cgroup-v1/index.rst <cgrou
>         5-7-1. RDMA Interface Files
>       5-8. HugeTLB
>         5.8-1. HugeTLB Interface Files
> -     5-8. Misc
> -       5-8-1. perf_event
> +     5-9. Misc
> +       5.9-1 Miscellaneous cgroup Interface Files
> +       5.9-2 Migration and Ownership
> +     5-10. Others
> +       5-10-1. perf_event
>       5-N. Non-normative information
>         5-N-1. CPU controller root cgroup process behaviour
>         5-N-2. IO controller root cgroup process behaviour
> @@ -2161,6 +2164,63 @@ HugeTLB Interface Files
>  	generated on this file reflects only the local events.
>  
>  Misc
> +--------------
> +
> +The Miscellaneous cgroup provides the resource allocation and tracking
> +mechanism for the scalar resources which cannot be abstracted like the other
> +cgroup resources. Controller is enabled by the CONFIG_CGROUP_MISC config
> +option.
> +
> +The first two resources added to the miscellaneous controller are Secure
> +Encrypted Virtualization (SEV) ASIDs and SEV - Encrypted State (SEV-ES) ASIDs.
> +These limited ASIDs are used for encrypting virtual machines memory on the AMD
> +platform.
> +
> +Misc Interface Files
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Miscellaneous controller provides 3 interface files:
> +
> +  misc.capacity
> +        A read-only flat-keyed file shown only in the root cgroup.  It shows
> +        miscellaneous scalar resources available on the platform along with
> +        their quantities::
> +	  $ cat misc.capacity
> +	  sev 50
> +	  sev_es 10
> +
> +  misc.current
> +        A read-only flat-keyed file shown in the non-root cgroups.  It shows
> +        the current usage of the resources in the cgroup and its children.::
> +	  $ cat misc.current
> +	  sev 3
> +	  sev_es 0
> +
> +  misc.max
> +        A read-write flat-keyed file shown in the non root cgroups. Allowed
> +        maximum usage of the resources in the cgroup and its children.::
> +	  $ cat misc.max
> +	  sev max
> +	  sev_es 4
> +
> +	Limit can be set by::
> +	  # echo sev 1 > misc.max
> +
> +	Limit can be set to max by::
> +	  # echo sev max > misc.max
> +
> +        Limits can be set more than the capacity value in the misc.capacity

                             higher than

> +        file.
> +
> +Migration and Ownership
> +~~~~~~~~~~~~~~~~~~~~~~~
> +
> +A miscellaneous scalar resource is charged to the cgroup in which it is used
> +first, and stays charged to that cgroup until that resource is freed. Migrating
> +a process to a different cgroup do not move the charge to the destination

                                   does

> +cgroup where the process has moved.
> +
> +Others
>  ----

That underline is too short for "Others".

>  
>  perf_event
> 

Try building this doc file, please.

next-20210219/Documentation/admin-guide/cgroup-v2.rst:2196: WARNING: Unexpected indentation.
next-20210219/Documentation/admin-guide/cgroup-v2.rst:2203: WARNING: Unexpected indentation.
next-20210219/Documentation/admin-guide/cgroup-v2.rst:2210: WARNING: Unexpected indentation.
next-20210219/Documentation/admin-guide/cgroup-v2.rst:2232: WARNING: Title underline too short.

Others
----
next-20210219/Documentation/admin-guide/cgroup-v2.rst:2232: WARNING: Title underline too short.


I think that the first 3 warnings are due to missing a blank line after ::
or they could have something to do with mixed tabs and spaces in the misc.*
properties descriptions.


thanks.
-- 
~Randy

