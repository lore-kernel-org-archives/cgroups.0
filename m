From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Date: Tue, 10 Dec 2013 16:50:37 -0500
Message-ID: <20131210215037.GB9143@htj.dyndns.org>
References: <20131128115458.GK2761@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
 <20131204054533.GZ3556@cmpxchg.org>
 <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
 <20131205025026.GA26777@htj.dyndns.org>
 <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
 <20131206190105.GE13373@htj.dyndns.org>
 <alpine.DEB.2.02.1312061441390.8949@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=U3tMuXFVjeAiIlSnndOQwiAfNyZtWdl0sxrNhTrQs2k=;
        b=KBRIGyX5ZUoGVJ3823hNDuyIEQEtNyLVJJvbVtsrwhSLN8SEy3/mHoBiRMZv/2kjjO
         tilGokZt/fp9DufaEYLvyQ7rkj/XMpWuL8m0AHDzIK7FMf9jszty49eBIYF3WnAdrXzo
         F28g43Refb7yz1PcLIcufvl4Wl7f+T9mkzHbePQ3AbXSH6KRZhvpUcvmRph/BkSxcRZZ
         k8zlIitNFbQiGvhx0iZOSycI/piGoJiyDRScrQskfggCIFWMtGHC2hidU8uoMlT6K6Hp
         tkzij3KIhV9RAXgOeBQgfC8EqT5ZYYMW1TpXoNcsLcwHDG1wnGiVEgxJcPSYanDa3obD
         7YJQ==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312061441390.8949-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, David.

On Mon, Dec 09, 2013 at 12:10:44PM -0800, David Rientjes wrote:
> Indeed.  The setup I'm specifically trying to attack is where the sum of 
> the limits of all non-oom handling memcgs (A/b in my model, A in yours) 
> exceed the amount of RAM.  If the system has 256MB,
> 
> 				/=256MB
> 	A=126MB		A-oom=2MB	B=188MB		B-oom=4MB
> 
> or
> 
> 			/=256MB
> 	C=128MB				D=192MB
> 	C/a=126M			D/a=188MB
> 
> then it's possible for A + B or C/a + D/a to cause a system oom condition 
> and meanwhile A-oom/tasks, B-oom/tasks, C/tasks, and D/tasks cannot 
> allocate memory to handle it.

"tasks"?  You mean that tasks can't be read reliably once system-OOM
is hit regardless of memcg configuration?

> Right, and apologies for not discussing the system oom handling here since 
> its notification on the root memcg is currently being debated as well.  
> The idea is that admins and users aren't going to be concerned about 
> memory allocation through the page allocator vs memory charging through 
> the memory controller; they simply want memory for their userspace oom 
> handling.  And since the notification would be tied to the root memcg, it 
> makes sense to make the amount of memory allowed to allocate exclusively 
> for these handlers a memcg interface.  So the cleanest solution, in my 
> opinion, was to add the interface as part of memcg.

I'm still not quite following the reasoning.  Can you please elaborate
on what the distinction between "page allocator" and "charges through
memory controller" has to do with this interface?

> It's really the same thing, though, from the user perspective.  They don't 
> care about page allocation failure vs memcg charge failure, they simply 
> want to ensure that the memory set aside for memory.oom_reserve_in_bytes 
> is available in oom conditions.  With the suggested alternatives:
> 
> 				/=256MB
> 	A=126MB		A-oom=2MB	B=188MB		B-oom=4MB
> 
> or
> 
> 			/=256MB
> 	C=128MB				D=192MB
> 	C/a=126M			D/a=188MB
> 
> we can't distinguish between what is able to allocate below per-zone min 
> watermarks in the page allocator as the oom reserve.  The key point is 
> that the root memcg is not the only memcg concerned with page allocator 
> memory reserves, it's any oom reserve.  If A's usage is 124MB and B's 
> usage is 132MB, we can't specify that processes attached to B-oom should 
> be able to bypass per-zone min watermarks without an interface such as 
> that being proposed.

Okay, are you saying that userland OOM handlers will be able to dip
into kernel reserve memory?  Maybe I'm mistaken but you realize that
that reserve is there to make things like task exits work under OOM
conditions, right?  The only way userland OOM handlers as you describe
would work would be creating a separate reserve for them.

Aren't you basically suggesting two memcg domains - one which is
overcommitted and the other which isn't?  But if you want to do that,
wouldn't that be something which is a natural fit for memch hierarchy?
Not only that, such hierarchical setup would make sense for other
controllers too - you're really creating two fundamentally different
resource groups.

> It's much more powerful than that; you're referring to the mechanism to 
> guarantee future memory freeing so the system or memcg is no longer oom, 
> and that's only one case of possible handling.  I have a customer who 
> wants to save heap profiles at the time of oom as well, for example, and 
> their sole desire is to be able to capture memory statistics before the 
> oom kill takes place.  The sine qua non is that memory reserves allow 
> something to be done in such conditions: if you try to do a "ps" or "ls" 
> or cat a file in an oom memcg, you hang.  We need better functionality to 
> ensure that we can do some action prior to the oom kill itself, whether 
> that comes from userspace or the kernel.  We simply cannot rely on things 

Well, the gotcha there is that you won't be able to do that with
system level OOM handler either unless you create a separately
reserved memory, which, again, can be achieved using hierarchical
memcg setup already.  Am I missing something here?

> like memory thresholds or vmpressure to grab these heap profiles, there is 
> no guarantee that memory will not be exhausted and the oom kill would 
> already have taken place before the process handling the notification 
> wakes up.  (And any argument that it is possible by simply making the 
> threshold happen early enough is a non-starter: it does not guarantee the 
> heaps are collected for oom conditions and the oom kill can still occur 
> prematurely in machines that overcommit their memcg limits, as we do.)

I don't really follow your "guarantee" argument regarding OOM.  It's
not like we have mathmatically concrete definition of OOM conditions.
That'd be nice to have but we simply don't have them.  As it currently
is defined, it's just "oh well, we tried hard enough but nothing seems
to give in.  whatever".  As currently defined, it's an inherently
fuzzy and racy thing.  Sure, it *could* be meaningful to try to
decrease the raciness if the difference is significant but using
absolute terms like guarantee is just misleading, IMHO.  You can't
guarantee much with something which is racy to begin with.

...
> conditions, provides.  I also proposed a memory.oom_delay_millisecs that 
> we have used for several years dating back to even cpusets that simply 
> delays the oom kill such that userspace can do "something" like send a 
> kill itself, collect heap profiles, send a signal to our malloc() 
> implementation to free arena memory, etc. prior to the kernel oom kill.

All the above would require a separately reserved memory, right?
Also, a curiosity, how would "sending a signal to our malloc()" work?
If you mean sending a signal to malloc() in a different process,
that's not gonna work.  How is that process gonna have memory to
process the signal and free memory from malloc() under OOM condition?

> We certainly can get away with the kernel oom killer in 99% of cases with 
> this functionality for users who choose to have their own oom handling 
> implementations.  We also can't possibly code every single handling policy 
> into the kernel: we can't guarantee that our version of malloc() is 
> guaranteed to be able to free memory back to the kernel when waking up on 
> a memory.oom_control notification prior to the memcg oom killer killing 
> something, for example, without this functionality.

So, malloc() is mapped into the same process as the OOM handler which
is gonna be able to tap into physically reserved memory?  Also, while
freeing, it won't need to coordinate with other processes?

If I'm not mistaken, we're talking about a lot of additional
complexities throughout the whole mm layer for something which seems,
to me, achieveable through proper memcg configuration without any
modification to the kernel and doesn't seem all that necessary for 99%
of use cases, as you said.  Unless I'm missing something major (quite
possible, of course), I think you'd need stronger rationale.

Thanks.

-- 
tejun
