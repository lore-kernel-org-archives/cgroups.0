From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Date: Mon, 6 Apr 2015 13:47:35 -0400
Message-ID: <20150406174735.GG10582@htj.duckdns.org>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
 <20141009130611.GA14387@htj.dyndns.org>
 <551CE820.9090900@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oI8ZmljZmrQjy9krxw9hO+bNvY89PZnZ+t3b+pDyuwU=;
        b=AlxTE3Wb9dHmmZmadOFZWnrwV0Z5rNUF3LrpIT49/tZocD1RIuze8bGeivwdiu8NvC
         xf89lv9GR7Lzx8qAwij0Bf/DXvvfoOZQCWo33h0CEpG0e2okb2gvKoQ7/sHUgatCX/pG
         +CofrgE29aefg09lxSl8EnnfL6o84CPIxREfio3El0fJMfyeelqkz4Ab0L5vaG/f84S4
         FXtxya5uWPdDSlFfTQ9YhyfGYYGVhfXHR7czOxkY67EUqaLQPpaeMGpOpXLQTd/Dgk5q
         Hs9cpZYvh5UzUHc0EaLfeO9EKchVZPEO1OBfYxbetzif/I4U2I1RxnqndC58+yril2ZL
         Rs5g==
Content-Disposition: inline
In-Reply-To: <551CE820.9090900-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org

Hello, Preeti.

On Thu, Apr 02, 2015 at 12:26:32PM +0530, Preeti U Murthy wrote:
> By ensuring that the user configured cpusets are untouched, I don't see
> how we affect userspace adversely. The expectation usually is that the
> kernel keeps track of the user configurations. If anything we would be
> fixing an undesired behavior, wouldn't we?

The problem is not really about which behavior is "righter" but rather
it's fairly likely that there are users / tools out there expecting
the current behavior and they wouldn't be too happy to see the
behavior flipping underneath them.

One way forward would be implementing a knob in cpuset which makes it
switch sbetween the old and new behaviors in the legacy hierarchy.
It's yucky but doable if absoluately necessary, but what's the reason
for you not being able to transition to the unified hierarchy (except
for it being under the devel flag but I'm really taking that devel
mask out in the next merge window)?  The default hierarchy can happily
co-exist with legacy hierarchies so you can just move over the cpuset
part to it if you need it.

Thanks.

-- 
tejun
