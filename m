From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 3/8] hugetlb_cgroup: add reservation accounting for
 private mappings
Date: Fri, 17 Jan 2020 14:09:42 -0800
Message-ID: <0ea993b0-af18-cee8-527e-f6df7e76b0be@oracle.com>
References: <20191217231615.164161-1-almasrymina@google.com>
 <20191217231615.164161-3-almasrymina@google.com>
 <dec1ccd5-5973-c498-f2fe-390c1c51b2d0@oracle.com>
 <CAHS8izMzXpNMCmFh_SD7n+4+rj3QTqyRfeWQyXAhFo1-qV4iEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=HFFGUnfSqVWShYbKt3p582lD3bfMPINDrNFPG0jJqvE=;
 b=kW1I3h9CqDB0WI8iNf10+m0iPa1caxU1I2lL1DtfW2t6Uujt+6MaHhDAA108OOEPPtMf
 goLIn+mP/rVpqL+EO+HM0B7wM5FQpwXMNqCmaqcrB6Z600IT925wNPtfUgkBRPg35LZM
 Mo3dMDUo92fmDi4WY7wvg2kCn4OK3T3EzCi9VB+NxluNT0ym96Ld1u4W/C9uk8KvsMGr
 ALkR6o/MlhLR0mM5EhBRvTo5MSi/0IRdQQoo4d7fwn4ZOJsqxEcP9dswoYez6M29dLuT
 +cn9qJ0lC19z4UEYkqRZLSynbDNwNVrxZ4aMQ/66dfOuMU/4COFYdA4k5s46rgjTEbHD 5A== 
In-Reply-To: <CAHS8izMzXpNMCmFh_SD7n+4+rj3QTqyRfeWQyXAhFo1-qV4iEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>

On 1/14/20 2:52 PM, Mina Almasry wrote:
> On Mon, Jan 13, 2020 at 4:55 PM Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>> +#ifdef CONFIG_CGROUP_HUGETLB
>>> +     /*
>>> +      * Since we check for HPAGE_RESV_OWNER above, this must a private
>>> +      * mapping, and these values should be none-zero, and should point to
>>> +      * the hugetlb_cgroup counter to uncharge for this reservation.
>>> +      */
>>> +     WARN_ON(!resv->reservation_counter);
>>> +     WARN_ON(!resv->pages_per_hpage);
>>> +     WARN_ON(!resv->css);
>>
>> I was once again wondering if these were always non-NULL for private mappings.
>> It seems that reservation_counter (h_gc) would be NULL in these cases from
>> these early checks in hugetlb_cgroup_charge_cgroup().
>>
> 
> You are right. I'm fixing in v10 the code and comments to account for
> h_cg potentially being NULL, but I'm having trouble testing. Looking
> at the code, I'm a bit confused by the checks. Seems to me
> hugetlb_cgroup_disabled() is the same as #ifdef CONFIG_CGROUP_HUGETLB;
> I can't find a way to enable the Kconfig but have that return false
> unless I hack the code.

What about the boot options?

cgroup_disable=
cgroup_no_v1=

-- 
Mike Kravetz
