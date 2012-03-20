From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V4 07/10] hugetlbfs: Add memcg control files for hugetlbfs
Date: Tue, 20 Mar 2012 14:52:20 +0530
Message-ID: <874ntjtynn.fsf@linux.vnet.ibm.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F66A059.20801@jp.fujitsu.com> <87wr6hjc58.fsf@linux.vnet.ibm.com> <4F66E169.5000909@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F66E169.5000909@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

>
> O.K. BTW, please read Tejun's recent post..
>
> https://lkml.org/lkml/2012/3/16/522
>
> Can you use his methods ?
>
> I guess you can write...
>
> CGROUP_SUBSYS_CFTYLES_COND(mem_cgroup_subsys,
> 			hugetlb_cgroup_files,
> 			if XXXXMB hugetlb is allowed);
>

I may not be able to do CGROUP_SUBSYS_CFTYPES_COND(). But as long as we
are able to dynamically add new control files, we should be ok.

-aneesh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
