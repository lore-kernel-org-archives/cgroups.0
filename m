From: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: Don't drop the cgroup_mutex in cgroup_rmdir
Date: Fri, 20 Jul 2012 12:49:20 -0700
Message-ID: <20120720194920.GB21218@google.com>
References: <87ipdjc15j.fsf@skywalker.in.ibm.com>
 <1342706972-10912-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vZEVey+j9uRCXPBIJm/aJx3P5SRQPcSvP+g03ZmceGs=;
        b=p4sS9kBrULIAPeTVWRmQWwMiPpea+WlkYg0LiMAYaXxi7UQatxOG7MoQFr1XiQ3VRP
         6tpt8MsW5ROTbn65mseraud6bur8B+UNcRXmtzf7N4wmjaLS+jO66pT8BiI0pUU/oAnK
         QcQEgh6w3KVO45+1hE3hv0XjW6k8nKQsXh0D4Ojo+NVbGk0rdkXPeQcbT33hgqYY6WZy
         3Dc3oS/8CZSVWshzgy4sGLaGFeXQMucIwLTwR6spqRTXh5V9TJkJXD5MpMyTcdyFVEF+
         dFvHsywaN2OcQMpB/C7PXsJ9tzddI1rXs9e80hKAf8eKgg7GxxEpI6+8b/B0s8+M5aBR
         3pMQ==
Content-Disposition: inline
In-Reply-To: <1342706972-10912-1-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Jul 19, 2012 at 07:39:32PM +0530, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> We dropped cgroup mutex, because of a deadlock between memcg and cpuset.
> cpuset took hotplug lock followed by cgroup_mutex, where as memcg pre_destroy
> did lru_add_drain_all() which took hotplug lock while already holding
> cgroup_mutex. The deadlock is explained in 3fa59dfbc3b223f02c26593be69ce6fc9a940405
> But dropping cgroup_mutex in cgroup_rmdir also means tasks could get
> added to cgroup while we are in pre_destroy. This makes error handling in
> pre_destroy complex. So move the unlock/lock to memcg pre_destroy callback.
> Core cgroup will now call pre_destroy with cgroup_mutex held.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

So, umm, let's not do this at this point.  Please just fix memcg such
that it doesn't fail ->pre_destroy() and drop
subsys->__DEPRECATED_clear_css_refs.  cgroup core won't give away new
references during or after pre_destroy that way and memcg is the ONLY
subsystem needing the deprecated behavior so it's rather
counter-productive to implement work-around at this point.

 Nacked-And-Please-Drop-The-DEPRECATED-Behavior-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
