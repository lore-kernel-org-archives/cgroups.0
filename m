From: David Gibson <dwg-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH -V2 0/9] memcg: add HugeTLB resource tracking
Date: Fri, 2 Mar 2012 14:28:53 +1100
Message-ID: <20120302032853.GB2728@truffala.fritz.box>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120301144029.545a5589.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120301144029.545a5589.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 01, 2012 at 02:40:29PM -0800, Andrew Morton wrote:
> On Thu,  1 Mar 2012 14:46:11 +0530
> "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> 
> > This patchset implements a memory controller extension to control
> > HugeTLB allocations. It is similar to the existing hugetlb quota
> > support in that, the limit is enforced at mmap(2) time and not at
> > fault time. HugeTLB's quota mechanism limits the number of huge pages
> > that can allocated per superblock.
> > 
> > For shared mappings we track the regions mapped by a task along with the
> > memcg. We keep the memory controller charged even after the task
> > that did mmap(2) exits. Uncharge happens during truncate. For Private
> > mappings we charge and uncharge from the current task cgroup.
> 
> I haven't begin to get my head around this yet, but I'd like to draw
> your attention to https://lkml.org/lkml/2012/2/15/548.  That fix has
> been hanging around for a while, but I haven't done anything with it
> yet because I don't like its additional blurring of the separation
> between hugetlb core code and hugetlbfs.  I want to find time to sit
> down and see if the fix can be better architected but haven't got
> around to that yet.

So.. that version of the fix I specifically rebuilt to address your
concerns about that blurring - in fact I think it reduces the current
layer blurring.  I haven't had any reply - what problems do see it as
still having?

> I expect that your patches will conflict at least mechanically with
> David's, which is not a big issue.  But I wonder whether your patches
> will copy the same bug into other places, and whether you can think of
> a tidier way of addressing the bug which David is seeing?

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
