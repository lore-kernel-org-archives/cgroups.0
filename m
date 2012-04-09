From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V5 07/14] memcg: Add HugeTLB extension
Date: Mon, 09 Apr 2012 14:13:45 +0530
Message-ID: <87zkalcn26.fsf@skywalker.in.ibm.com>
References: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1333738260-1329-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F827BF9.2090205@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F827BF9.2090205-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> writes:

> (2012/04/07 3:50), Aneesh Kumar K.V wrote:
>
>> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> This patch implements a memcg extension that allows us to control HugeTLB
>> allocations via memory controller. The extension allows to limit the
>> HugeTLB usage per control group and enforces the controller limit during
>> page fault. Since HugeTLB doesn't support page reclaim, enforcing the limit
>> at page fault time implies that, the application will get SIGBUS signal if it
>> tries to access HugeTLB pages beyond its limit. This requires the application
>> to know beforehand how much HugeTLB pages it would require for its use.
>> 
>> The charge/uncharge calls will be added to HugeTLB code in later patch.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
>
> Hmm, seems ok to me. please explain 'this patch doesn't include updates
> for memcg destroying, it will be in patch 12/14' or some...
>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>
>
> BTW, you don't put res_counter for hugeltb under CONFIG_MEM_RES_CTLR_HUGETLB...
> do you think we need the config ?


That results in more #ifdef CONFIG_MEM_RES_CTLR_HUGETLB in the
memcg code (mem_cgroup_create/mem_cgroup_read/write etc). I was not
sure we want to do that. Let me know if you think we really need to do this.


-aneesh
