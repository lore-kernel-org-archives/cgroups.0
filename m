From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2 13/17] cgroup: Allow fine-grained controllers
 control in cgroup v2
Date: Wed, 24 May 2017 13:56:00 -0400
Message-ID: <20170524175600.GL24798@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-14-git-send-email-longman@redhat.com>
 <20170519205550.GD15279@wtj.duckdns.org>
 <6fe07727-e611-bfcd-8382-593a51bb4888@redhat.com>
 <20170524173144.GI24798@htj.duckdns.org>
 <29bc746d-f89b-3385-fd5c-314bcd22f9f7@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fkvQ0hukKmNP8+fshGTkfgmRAcKxfzC1IywBxRqg7Xs=;
        b=GbwrEGCmVTG0MNed1LWfD/tkLSAByfy5d4BA5Rl5DxtcbJUpPRbjSOoipDCPzFeWkY
         w/Ss3P7An6jtxlYvwlWDvii7GFLojL3bLJpxOmaAyx0W4qN5vU5v3w3xICh8+lZLC+Fi
         inbcFfi2S9FglAXZ2x1ae+qen0YvLfI9HHgBO+0MKAhnXe1/QKVk4DV4oJbdrwlrHSnc
         wV3g79QeprXkxroyC1grqp+msI+boFGZYXbbARhNMkNOfCdOZhu/dSO7i8v04JR29bA8
         g3m5unc1ee8+uPiM1FmFFklwTVinsiXBDIST8ASRiRV06/phSLQ9d2v3Iim9d4Ry85RQ
         XWng==
Content-Disposition: inline
In-Reply-To: <29bc746d-f89b-3385-fd5c-314bcd22f9f7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org

Hello,

On Wed, May 24, 2017 at 01:49:46PM -0400, Waiman Long wrote:
> What I am saying is as follows:
>     / A
> P - B
>    \ C
> 
> # echo +memory > P/cgroups.subtree_control
> # echo -memory > P/A/cgroup.controllers
> # echo "#memory" > P/B/cgroup.controllers
> 
> The parent grants the memory controller to its children - A, B and C.
> Child A has the memory controller explicitly disabled. Child B has the
> memory controller in pass-through mode, while child C has the memory
> controller enabled by default. "echo +memory > cgroup.controllers" is
> not allowed. There are 2 possible choices with regard to the '-' or '#'
> prefixes. We can allow them before the grant from the parent or only
> after that. In the former case, the state remains dormant until after
> the grant from the parent.

Ah, I see, you want cgroup.controllers to be able to mask available
controllers by the parent.  Can you expand your example with further
nesting and how #memory on cgroup.controllers would affect the nested
descendant?

Thanks.

-- 
tejun
