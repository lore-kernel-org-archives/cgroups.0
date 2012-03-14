From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V3 0/8] memcg: Add memcg extension to control HugeTLB allocation
Date: Wed, 14 Mar 2012 18:31:09 +0530
Message-ID: <87fwdb8hgq.fsf@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120313144930.284228c4.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120313144930.284228c4.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Tue, 13 Mar 2012 14:49:30 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 13 Mar 2012 12:37:04 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > This patchset implements a memory controller extension to control
> > HugeTLB allocations.
> 
> Well, why?  What are the use cases?  Who is asking for this?  Why do
> they need it and how will they use it?  etcetera.
> 
> Please explain, with some care, why you think we should add this
> feature to the kernel.  So that others can assess whether the value it
> adds is worth the cost of adding and maintaining it.
> 

The goal is to control how many HugeTLB pages a group of task can
allocate. It can be looked at as an extension of the existing quota
interface which limits the number of HugeTLB pages per hugetlbfs
superblock. HPC job scheduler requires jobs to specify their resource
requirements in the job file. Once their requirements can be met,
job schedulers like (SLURM) will schedule the job. We need to make sure
that the jobs won't consume more resources than requested. If they do
we should error out or kill the application.

-aneesh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
