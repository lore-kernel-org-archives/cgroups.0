From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Date: Sat, 16 Jun 2012 13:26:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206161322310.8407@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com> <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
 <87lik920h8.fsf@skywalker.in.ibm.com> <20120608160612.dea6d1ce.akpm@linux-foundation.org> <4FD56C19.4060307@jp.fujitsu.com> <alpine.DEB.2.00.1206110220290.6843@chino.kir.corp.google.com> <CAGr1F2EzDc3Ypv6twFE8Ua-JZUEkEVQJOPKwLt0O56c2-PycvA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=bJXjuVUKJDSOAmMfEFJckazlhxZfFF5tTIEN7ksXmQ0=;
        b=Lrj9d7P96gTB+q01JRlebvMVBCgFKGDpMdZVTy2ESlUwMqn7AEZPXRY1XRoOpQJisc
         tLeKKj0bLF5PRcNbNAWaBaoNslnsNCSq+bvuKilHb/7gADQzyHpxyvPubBxqMeJpEcKn
         9IBQWhfk3wPPS8rL+wLfgs1L6yUVn6ezn160L5c9JyqMb4X+/Rz6dWF5ZLilJaIkLm2P
         QpBYdDm+oDEHTOtzVDQ0557ldOSWhGdE+QR7aoBHkuqVdETE8KMG3jsccKbzcMZg1ton
         5oebaUljdNQ1mNETO8mUcuPE1Hwq069RDqWHcAxFyZmU+3o8M8Bdyw0ijj7eM8kA0yBx
         /eOQ==
In-Reply-To: <CAGr1F2EzDc3Ypv6twFE8Ua-JZUEkEVQJOPKwLt0O56c2-PycvA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, 15 Jun 2012, Aditya Kali wrote:

> Based on the usecase at Google, I see a definite value in including
> hugepage usage in memory.usage_in_bytes as well and having a single
> limit for memory usage for the job. Our jobs wants to specify only one
> (total) memory limit (including slab usage, and other kernel memory
> usage, hugepages, etc.).
> 
> The hugepage/smallpage requirements of the job vary during its
> lifetime. Having two different limits means less flexibility for jobs
> as they now have to specify their limit as (max_hugepage,
> max_smallpage) instead of max(hugepage + smallpage). Two limits
> complicates the API for the users and requires them to over-specify
> the resources.
> 

If a large number of hugepages, for example, are allocated on the command 
line because there's a lower success rate of dynamic allocation due to 
fragmentation, with your suggestion it would no longer allow the admin to 
restrict the use of those hugepages to only a particular set of tasks.  
Consider especially 1GB hugepagez on x86, your suggestion would treat a 
single 1GB hugepage which cannot be freed after boot exactly the same as 
using 1GB of memory which is obviously not the desired behavior of any 
hugetlb controller.
