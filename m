From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/6] mm: vmstat: move slab statistics from zone to node
 counters
Date: Tue, 6 Jun 2017 10:33:49 -0400
Message-ID: <20170606143349.GB1602@cmpxchg.org>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-3-hannes@cmpxchg.org>
 <20170531091256.GA5914@osiris>
 <20170531113900.GB5914@osiris>
 <20170531171151.e4zh7ffzbl4w33gd@yury-thinkpad>
 <87mv9s2f8f.fsf@concordia.ellerman.id.au>
 <20170605183511.GA8915@cmpxchg.org>
 <87k24prb3u.fsf@concordia.ellerman.id.au>
 <87mv9lpdsr.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iFPbLElzwRxDNu75g6CJbK0jfkrJeZsg7qWSQIvzH7I=; b=NUEWlyOOKe+biYBtJZlW2lGO62
        pjbxQQNtlqpevpf7Od1kH0i099f4if1qCuKLozINOezb9LSwZ8EWfB2dsDKSUZyLYoeyDZuk7E87k
        ICECJc0PTkkbzAcJj55m4DM0BQfIgyPPlP/u9ulBhA95aQgc6RvnKM/IJS2+9dBQCLU8=;
Content-Disposition: inline
In-Reply-To: <87mv9lpdsr.fsf-W0DJWXSxmBNbyGPkN3NxC2scP1bn1w/D@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Yury Norov <ynorov-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 06, 2017 at 09:15:48PM +1000, Michael Ellerman wrote:
> But today's linux-next is OK. So I must have missed a fix when testing
> this in isolation.
> 
> commit d94b69d9a3f8139e6d5f5d03c197d8004de3905a
> Author:     Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> AuthorDate: Tue Jun 6 09:19:50 2017 +1000
> Commit:     Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> CommitDate: Tue Jun 6 09:19:50 2017 +1000
> 
>     mm: vmstat: move slab statistics from zone to node counters fix
>     
>     Unable to handle kernel paging request at virtual address 2e116007
>     pgd = c0004000
>     [2e116007] *pgd=00000000
>     Internal error: Oops: 5 [#1] SMP ARM
> 
> ...
> 
> Booted to userspace:
> 
> $ uname -a
> Linux buildroot 4.12.0-rc4-gcc-5.4.1-00130-gd94b69d9a3f8 #354 SMP Tue Jun 6 20:44:42 AEST 2017 ppc64le GNU/Linux

Thanks for verifying!
