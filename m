From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 1/7] mm: memcontrol: fix cpuhotplug statistics flushing
Date: Tue, 2 Feb 2021 18:28:53 -0800
Message-ID: <20210203022853.GG1812008@carbon.dhcp.thefacebook.com>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-2-hannes@cmpxchg.org>
 <20210202230747.GA1812008@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=UyikSY9c2CyK14yztGolAG6yxN2SE3+M5dkc3tRuvBU=;
 b=Jc/aoqFWSrNhfb6Yokv7YqwlCNhSSrrG2308Qymtq471i1pelHXYerJeO8FgYqQITeVE
 Mf0Of4JEoxmC3ZiXkEBmGmgMetawU1Jmf2lnGsKiAbXw0cFqRwdt/xYIUq4VEerWbVdy
 d7CnYd1Vvh8O8uv5h+3m/4hGp+w0FBVBMVY= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyikSY9c2CyK14yztGolAG6yxN2SE3+M5dkc3tRuvBU=;
 b=T4uPRSduQDXHw6fTaE4dg2MoWb5rKzdWQeUZo16QXGq9rukhA6cnfGP3exZNz2jq2IGWzSnxmwuU8/QBTpSy1nkhr2IpImz7aYXSwC8OdfcTCYw/fNX5LKDOym9vt23GrBe1fIDLLBwzPApkSeYvnfMHe8M+Q7JpZQP4toOJctA=
Content-Disposition: inline
In-Reply-To: <20210202230747.GA1812008-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Feb 02, 2021 at 03:07:47PM -0800, Roman Gushchin wrote:
> On Tue, Feb 02, 2021 at 01:47:40PM -0500, Johannes Weiner wrote:
> > The memcg hotunplug callback erroneously flushes counts on the local
> > CPU, not the counts of the CPU going away; those counts will be lost.
> > 
> > Flush the CPU that is actually going away.
> > 
> > Also simplify the code a bit by using mod_memcg_state() and
> > count_memcg_events() instead of open-coding the upward flush - this is
> > comparable to how vmstat.c handles hotunplug flushing.
> 
> To the whole series: it's really nice to have an accurate stats at
> non-leaf levels. Just as an illustration: if there are 32 CPUs and
> 1000 sub-cgroups (which is an absolutely realistic number, because
> often there are many dying generations of each cgroup), the error
> margin is 3.9GB. It makes all numbers pretty much random and all
> possible tests extremely flaky.

Btw, I was just looking into kmem kselftests failures/flakiness,
which is caused by exactly this problem: without waiting for the
finish of dying cgroups reclaim, we can't make any reliable assumptions
about what to expect from memcg stats.

So looking forward to have this patchset merged!
