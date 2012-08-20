From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 00/11] Request for Inclusion: kmem controller for memcg.
Date: Mon, 20 Aug 2012 11:51:58 +0400
Message-ID: <5031EC9E.1070000@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <CALWz4iycCxuUaEeBz_b8+U13fcCLep3rvuSNUTPD8N-eZkDBrg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALWz4iycCxuUaEeBz_b8+U13fcCLep3rvuSNUTPD8N-eZkDBrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 08/18/2012 01:37 AM, Ying Han wrote:
> On Thu, Aug 9, 2012 at 6:01 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>> Hi,
>>
>> This is the first part of the kernel memory controller for memcg. It has been
>> discussed many times, and I consider this stable enough to be on tree. A follow
>> up to this series are the patches to also track slab memory. They are not
>> included here because I believe we could benefit from merging them separately
>> for better testing coverage. If there are any issues preventing this to be
>> merged, let me know. I'll be happy to address them.
>>
>> The slab patches are also mature in my self evaluation and could be merged not
>> too long after this. For the reference, the last discussion about them happened
>> at http://lwn.net/Articles/508087/
>>
>> A (throwaway) git tree with them is placed at:
>>
>>         git://github.com/glommer/linux.git kmemcg-slab
> 
> I would like to make a kernel on the tree and run some perf tests on
> it. However the kernel
> doesn't boot due to "divide error: 0000 [#1] SMP".
> https://lkml.org/lkml/2012/5/21/502
> 
> I believe the issue has been fixed ( didn't look through) and can you
> do a rebase on your tree?
> 

Could you please try the branch memcg-3.5/kmemcg-slab instead? It is
rebased on top of the latest mmotm.
