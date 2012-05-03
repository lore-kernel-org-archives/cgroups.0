From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Date: Thu, 03 May 2012 10:07:59 +0530
Message-ID: <87pqalhobc.fsf@skywalker.in.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <CAP=VYLqgaCabQGDVgUXnCwKCZHtz0nWxpm_a6Cgz_ciMzGe9gQ@mail.gmail.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAP=VYLqgaCabQGDVgUXnCwKCZHtz0nWxpm_a6Cgz_ciMzGe9gQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org> writes:

> On Mon, Apr 16, 2012 at 6:44 AM, Aneesh Kumar K.V
> <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>
>> This patch implements a memcg extension that allows us to control HugeTLB
>> allocations via memory controller. The extension allows to limit the
>
> Hi Aneesh,
>
> This breaks linux-next on some arch because they don't have any
> HUGE_MAX_HSTATE in scope with the current #ifdef layout.
>
> The breakage is in sh4, m68k, s390, and possibly others.
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/6228689/
> http://kisskb.ellerman.id.au/kisskb/buildresult/6228670/
> http://kisskb.ellerman.id.au/kisskb/buildresult/6228484/
>
> This is a commit in akpm's mmotm queue, which used to be here:
>
> http://userweb.kernel.org/~akpm/mmotm
>
> Of course the above is invalid since userweb.kernel.org is dead.
> I don't have a post-kernel.org break-in link handy and a quick
> search didn't give me one, but I'm sure you'll recognize the change.
>

Andrew have the below patch 

http://article.gmane.org/gmane.linux.kernel.commits.mm/71649

Does that fix the error ?

-aneesh
