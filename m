From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Date: Thu, 24 May 2012 16:20:23 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205241615540.9453@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com>
 <20120524155727.dc6c839e.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=VlprLLMU0ln678iizZSAL+u7Rlwi2t60EGpHK2ZE7go=;
        b=QfVNsLX5lWlivUILeIOeS72EHDxsN7e9LdRdqknBg59H3REeaWZpN5nJfAN4A5dAgp
         06aw+H+bOz3Vr6fxUprXBZNfbeMXOpDT2x+jaAZWcHay0AYJwn5cX6eFFfM8Djalh5LM
         fI/KZE9HNZdEc5GgP7KtwQipf6jIv7MLuX2I59sAFJHo2gki3YFpQzRoRBbCxiTDUV66
         VpFLFtblQlQRbSfe0BAsVsKIrtEU/byhmqJOTHs20s5h8ZU44NXSCoNcV9t734+dWs7V
         h8T06XXCN0+1Yj0DnYchPQMnHD8CP2wc+Zym9YoZVp6agdrY8Lbzi/FFZDbOy4IiWU/n
         ZEvQ==
In-Reply-To: <20120524155727.dc6c839e.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 24 May 2012, Andrew Morton wrote:

> These arguments look pretty strong to me.  But poorly timed :(
> 

What I argued here is nothing new, I said the same thing back on April 27 
and I was expecting it to be reproposed as a seperate controller.  The 
counter argument that memcg shouldn't cause a performance degradation 
doesn't hold water: you can't expect every page to be tracked without 
incurring some penalty somewhere.  And it certainly causes ~1% of memory 
to be used up at boot with all the struct page_cgroups.

The counter argument that we'd have to duplicate cgroup setup and 
initialization code from memcg also is irrelevant: all generic cgroup 
mounting, creation, and initialization code should be in kernel/cgroup.c.  
Obviously there will be added code because we're introducing a new cgroup, 
but that's not a reason to force everybody who wants to control hugetlb 
pages to be forced to enable memcg.
