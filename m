From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Kernel scanning/freeing to relieve cgroup memory pressure
Date: Wed, 2 Apr 2014 14:00:19 -0400
Message-ID: <20140402180019.GL16631@htj.dyndns.org>
References: <533C0BB4.4070009@gopivotal.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=trP+dlP9D6Q43GAhcCkN1hmDZTGypMLVTl2LofNPIzM=;
        b=OfUvf19pY4EDN2UxA8WaqC9hvn3cT3aGLMtBkWPON2iFolbq1z8l/IfCC7x3rxxaox
         qPOq6NEMocyRSjcFn+DnQ0JGLIuHxmpbdUEpPTsxswQBCOh2Afu+Jh/gM0cljBXT6EtD
         Pw12vwpKpxCoySJ2N1hxggO6jdV01BkLmBBU3im5v2NOvvdqxLR8DJzwN85oUdHrIIBU
         uKXSLzzfDCsBKAZaI/l8E8Bc7wjnyJrDd+rRl/3CDMy3l2YWRdp0AiYn5kQLVsVTFI+O
         gSNPjGJNeo0GX61w5PuZDVH7rNdEi61JJ+vc4MQJ2pzA+uHc2BmUP2wEBTpnD44V9wdC
         2YPQ==
Content-Disposition: inline
In-Reply-To: <533C0BB4.4070009-6n0RBC2Q8y8S+FvcfC7Uqw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glyn Normington <gnormington-6n0RBC2Q8y8S+FvcfC7Uqw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(cc'ing memcg maintainers and cgroup ML)

On Wed, Apr 02, 2014 at 02:08:04PM +0100, Glyn Normington wrote:
> Currently, a memory cgroup can hit its oom limit when pages could, in
> principle, be reclaimed by the kernel except that the kernel does not
> respond directly to cgroup-local memory pressure.

So, ummm, it does.

> A use case where this is important is running a moderately large Java
> application in a memory cgroup in a PaaS environment where cost to the
> user depends on the memory limit ([1]). Users need to tune the memory
> limit to reduce their costs. During application initialisation large
> numbers of JAR files are opened (read-only) and read while loading the
> application code and its dependencies. This is reflected in a peak of
> file cache usage which can push the memory cgroup memory usage
> significantly higher than the value actually needed to run the application.
> 
> Possible approaches include (1) automatic response to cgroup-local
> memory pressure in the kernel, and (2) a kernel API for reclaiming
> memory from a cgroup which could be driven under oom notification (with
> the oom killer disabled for the cgroup - it would be enabled if the
> cgroup was still oom after calling the kernel to reclaim memory).
> 
> Clearly (1) is the preferred approach. The closest facility in the
> kernel to (2) is to ask the kernel to free pagecache using `echo 1 >
> /proc/sys/vms/drop_caches`, but that is too wide-ranging, especially in
> a PaaS environment hosting multiple applications. A similar facility
> could be provided for a cgroup via a cgroup pseudo-file
> `memory.drop_caches`.
> 
> Other approaches include a mempressure cgroup ([2]) which would not be
> suitable for PaaS applications. See [3] for Andrew Morton's response. A
> related workaround ([4]) was included in the 3.6 kernel.
> 
> Related discussions:
> [1] https://groups.google.com/a/cloudfoundry.org/d/topic/vcap-dev/6M8BDV_tq7w/discussion
> [2]https://lwn.net/Articles/531077/ <https://lwn.net/Articles/531077/>
> [3]https://lwn.net/Articles/531138/ <https://lwn.net/Articles/531138/>
> [4]https://lkml.org/lkml/2013/6/6/462 <https://lkml.org/lkml/2013/6/6/462>&
> https://github.com/torvalds/linux/commit/e62e384e
> <https://github.com/torvalds/linux/commit/e62e384e>.

-- 
tejun
