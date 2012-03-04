From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 0/9] memcg: add HugeTLB resource tracking
Date: Sun, 04 Mar 2012 23:39:23 +0530
Message-ID: <87fwdodyr0.fsf@linux.vnet.ibm.com>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120301144029.545a5589.akpm@linux-foundation.org> <20120302032853.GB2728@truffala.fritz.box>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120302032853.GB2728@truffala.fritz.box>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <dwg@au1.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, 2 Mar 2012 14:28:53 +1100, David Gibson <dwg@au1.ibm.com> wrote:
> On Thu, Mar 01, 2012 at 02:40:29PM -0800, Andrew Morton wrote:
> > On Thu,  1 Mar 2012 14:46:11 +0530
> > "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > 
> > > This patchset implements a memory controller extension to control
> > > HugeTLB allocations. It is similar to the existing hugetlb quota
> > > support in that, the limit is enforced at mmap(2) time and not at
> > > fault time. HugeTLB's quota mechanism limits the number of huge pages
> > > that can allocated per superblock.
> > > 
> > > For shared mappings we track the regions mapped by a task along with the
> > > memcg. We keep the memory controller charged even after the task
> > > that did mmap(2) exits. Uncharge happens during truncate. For Private
> > > mappings we charge and uncharge from the current task cgroup.
> > 
> > I haven't begin to get my head around this yet, but I'd like to draw
> > your attention to https://lkml.org/lkml/2012/2/15/548.  That fix has
> > been hanging around for a while, but I haven't done anything with it
> > yet because I don't like its additional blurring of the separation
> > between hugetlb core code and hugetlbfs.  I want to find time to sit
> > down and see if the fix can be better architected but haven't got
> > around to that yet.
> 
> So.. that version of the fix I specifically rebuilt to address your
> concerns about that blurring - in fact I think it reduces the current
> layer blurring.  I haven't had any reply - what problems do see it as
> still having?
> 

https://lkml.org/lkml/2012/2/16/179 ?

That is a serious issue isn't it ?

-aneesh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
