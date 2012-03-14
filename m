From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V3 4/8] memcg: track resource index in cftype private
Date: Wed, 14 Mar 2012 16:18:44 +0530
Message-ID: <87obrz8nlf.fsf@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F5F4CD0.3080207@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F5F4CD0.3080207-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 13 Mar 2012 17:34:08 +0400, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On 03/13/2012 11:07 AM, Aneesh Kumar K.V wrote:
> >   		if (type == _MEM)
> >   			ret = mem_cgroup_resize_limit(memcg, val);
> > -		else
> > +		else if (type == _MEMHUGETLB) {
> > +			int idx = MEMFILE_IDX(cft->private);
> > +			ret = res_counter_set_limit(&memcg->hugepage[idx], val);
> > +		} else
> >   			ret = mem_cgroup_resize_memsw_limit(memcg, val);
> >   		break;
> >   	case RES_SOFT_LIMIT:
> 
> What if a user try to set limit < usage ? Isn't there any reclaim that 
> we could possibly do, like it is done by normal memcg ?

No, HugeTLB doesn't support reclaim. If we set the limit to a value
below current usage, future allocations will fail, but we don't reclaim.


-aneesh
