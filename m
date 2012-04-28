From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 8/9 v2] cgroup: avoid creating new cgroup under a
 cgroup being destroyed
Date: Fri, 27 Apr 2012 19:00:03 -0700
Message-ID: <20120428020003.GA26573@mtj.dyndns.org>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A36DE.30301@jp.fujitsu.com>
 <20120427204035.GN26595@google.com>
 <CABEgKgrJ68wU-L17zwN4_htX948TNFnLVgts=hFeY7QG3etwCA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+Ta1Q8OJsNhSd9ijD+ULmkxvnoLx4q4QZVAwDNwLMfY=;
        b=whWkDOq5s94HB6sp+dTUeuiokWNYFOX/OfNSDJ7RFlbgsSbeBn28tiWKXmYbcOavZO
         fLyHslCaiicmYa5jl8MA5dXWQQf7l4CO4YTLYRzmsCjbPAoM9eOnijnrR/lrCQ3Y0o+y
         9d8D6Q49jg+5h5tt6/jk9b0jJtUAY+vtw5RnCNO1T/0GLWH2Ccmt+XjoldTnfAW7A1VN
         hXL+C1JX8HaH/3Onf17Xa/RLG4VpBpQ04gR7VHsLWFmgMzRNrSCDMlsA6mCvOmpEyoSG
         Mdw4mZ2pdItolntmZNrBQB6g6yF07SH973zKy9qV8izZjbxsXOZ4/pmKhdIGPAtE88oS
         A0mA==
Content-Disposition: inline
In-Reply-To: <CABEgKgrJ68wU-L17zwN4_htX948TNFnLVgts=hFeY7QG3etwCA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Linux Kernel <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Frederic Weisbecker <fweisbec@gmail.com>, Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>

Hi, KAME.

On Sat, Apr 28, 2012 at 09:20:52AM +0900, Hiroyuki Kamezawa wrote:
> What I thought was...
> Assume a memory cgoup A, with use_hierarchy==1.
> 
> 1.  thread:0   start calling pre->destroy of cgroup A
> 2.  thread:0   it sometimes calls cond_resched or other sleep functions.
> 3.  thread:1   create a cgroup B under "A"
> 4.  thread:1   attach a thread X to cgroup A/B
> 5.  res_counter of A charged up. but pre_destroy() can't find what happens
>     because it scans LRU of A.
> 
> So, we have -EBUSY now. I considered some options to fix this.
> 
> option 1) just return 0 instead of -EBUSY when pre_destroy() finds a
> task or a child.
> 
> There is a race....even if we return 0 here and expects cgroup code
> can catch it,
> the thread or a child we found may be moved to other cgroup before we check it
> in cgroup's final check.
> In that case, the cgroup will be freed before full-ack of
> pre_destory() and the charges
> will be lost.

So, cgroup code won't proceed with rmdir if children are created
inbetween and note that the race condition of lost charge you
described above existed before this change - ie. new cgroup could be
created after pre_destroy() is complete.

The current cgroup rmdir code is transitional.  It has to support both
retrying and non-retrying pre_destroy()s and that means we can't mark
the cgroup DEAD before starting invoking pre_destroy(); however, we
can do that once memcg's pre_destroy() is converted which will also
remove all the WAIT_ON_RMDIR mechanism and the above described race.

There really isn't much point in trying to make the current cgroup
rmdir behave perfectly when the next step is removing all the fixed up
parts.

So, IMHO, just making pre_destroy() clean up its own charges and
always returning 0 is enough.  There's no need to fix up old
non-critical race condition at this point in the patch stream.  cgroup
rmdir simplification will make them disappear anyway.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
