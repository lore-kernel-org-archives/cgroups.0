From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Cgroup v2 thread mode oddity: "domain invalid" cgroup with
 threaded controller enabled
Date: Tue, 16 Oct 2018 17:11:41 +0200
Message-ID: <4fd48929-69fa-f13b-0095-1d210068684d@gmail.com>
References: <a4912516-8c6b-d8d3-b714-5c03bcfc5e91@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=os7yITSbdycw4FtWMHMzor8Qmp5i56pB04eEadWuHqU=;
        b=W0EqXhLB0O8NfTAI56CTyGQo2nXO/MuXHjyGjjVa4atNkh2WNnfrvIktaqcsS3R+tX
         qHyFaE/vKdzkdHBVf05HUR/WUWlm9Gkb6FnGIIBYlf6gUEBJ/eJn3ngQvrMTxUYnDHaQ
         eP7WYWwLtZViLQRf4nT0gykc4pJZFfJBlN6Ef94qlIoHDfg2IIRSSenW0WN+WPjx07tN
         EpajyGMxB8qSaIdWBZOxGYI85QCyXodeCcbJDKgXFzmDRnQNFKZbi2U/gTDjTk8HFIrf
         /xwRob8emC3hTAlSP3HT66AIjDMbkfnzx0vU4pNjI82b6ZQulc8rRTLpjGLXPDMctXO0
         meGA==
In-Reply-To: <a4912516-8c6b-d8d3-b714-5c03bcfc5e91@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: mtk.manpages@gmail.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, lkml <linux-kernel@vger.kernel.org>

Hello Tejun,

A ping on the below...

Thanks,

Michael

On 10/04/2018 09:40 PM, Michael Kerrisk (man-pages) wrote:
> Hello Tejun,
> 
> Suppose we have the following scenario:
> 
> x [d]    (pids)
>     y [dt]    (pids)
>         p [t]
>         q [t]
>         r [t]
>     z [d]
> 
> Here, x/y is a "domain threaded root" with a threaded controller
> (the 'pids' controller) enabled. (In this scenario, there are no
> member processes in any of the cgroups.)
> 
> Suppose we now convert x/z to "threaded" type:
> 
>      # echo threaded > x/z/cgroup.type
> 
> Now we end up in the following state:
> 
> x [dt]    (pids)
>     y [inv]    (pids)
>         p [t]
>         q [t]
>         r [t]
>     z [t]
> 
> This seems odd. x/y is now of "domain invalid" type with a controller
> enabled! This feels like a violation of the rules, since we can't
> in other circumstances do anything with a "domain invalid" cgroup
> except convert it to "threaded". In particular, we can't create
> child cgroups under a "domain invalid" cgroup, or add member processes
> to the cgroup, or *enable controllers in the cgroup*. In fact, when
> doing the 
> 
>     # echo threaded > x/z/cgroup.type
> 
> I had expected a write(2) error because the state of x/y should
> (I thought) not be permitted.
> 
> Your thoughts?
> 
> Thanks,
> 
> Michael
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
