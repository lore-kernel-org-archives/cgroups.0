From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 5 Apr 2016 05:39:21 -0700
Message-ID: <CAG53R5WBBUj6=B81Q-zEwL_xy3_yXUofJ6p921baqnqeVocDPQ@mail.gmail.com>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
	<1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
	<20160404193640.GA7822@mtj.duckdns.org>
	<CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
	<20160405012504.GG24661@htj.duckdns.org>
	<20160405090627.GA26425@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=v2MHKaMcyEPfwlS0IjoDE0+1UBsg7mAIacgwRAnc73k=;
        b=k1F6ruotHlKC9nxEzF96/3xL2JWBU2AIoJxO3NV+VAQrSRU0U5O7Vl0hARBpsFPvyl
         ZOoPY4J3reAWAbeUhVz1s/t8FYRwt2/JLc//s0bpkEI1Pf/cZbAtUyEdGSvSXMBz62dk
         /+czmrXK6axIrb0JekE6fam8O7B1xd3KIZfXYTiQ0IJiU+TI7cN53nMOPf6eTJJrWxa0
         f97TuLu2ECTXNsUzU0hI5aS0g+KuptZBR86rSOPfGclPq4LhDcSNBjlHLtRX9izifL9N
         IsGT459w9yk8tWeu4CmlTsAvIICJTXQ+qmdEoSLxTwsnJgTIM7dQXgZWourGVcKWQcDF
         sciQ==
In-Reply-To: <20160405090627.GA26425-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Christoph,

On Tue, Apr 5, 2016 at 2:06 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Mon, Apr 04, 2016 at 09:25:04PM -0400, Tejun Heo wrote:
>> Is it actually customary to have rdma core module updated more
>> frequently separate from the kernel?  Out-of-tree modules being
>> updated separately happens quite a bit but this is an in-kernel
>> module, which usually is tightly coupled with the rest of the kernel.
>
> People do it for all the wrong reasons - OFED and organization of morons
> wants people to use their modules, which causes lots of harm.  Anything
> that makes this harder is a good thing.
>
I am not really trying to address OFED issues here. I am sure you
understand that if ib_core.ko kernel module is in-kernel module than,
for all the fixes/enhancements that goes to it would require people to
upgrade to newer kernel, instead of just modules upgrade. Such heavy
weight upgrade slows down the adoption which i am trying to avoid here
by placing knobs in right kernel module's hand.
Its like making ib_core.ko from module to in kernel component, if I
understand correctly nobody wants to do that.
