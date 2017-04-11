From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: move cgroup_subsys_state parent field for
 cache locality
Date: Tue, 11 Apr 2017 09:05:23 +0900
Message-ID: <20170411000523.GD28603@wtj.duckdns.org>
References: <1491529677-707-1-git-send-email-todd@tjlinux.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uFbis0etues0ofpyza2t/g3Xx6gmSeKAR6/IOVoQ7xY=;
        b=KnY6yWW8mMl0ZD4tADPaiOC9i2w0+jLVzkf8baoCr9BwQH1EnAEusG+Q1VgLgpmod4
         NjtQ9g5QEEBzCeGIrbZ+e+MguKXy2wJT/D3RsfYEwNR52crFjokMwjNqKbBVDZIBolk/
         ibQlb2DM+Z7/OHUsFK5H20VrVjeClPbFdkawYBKy9kFIF9R7WHU9ijzKOEGyDceZxWU5
         +XzuK2/F3OAviuwcljt79A5vYwoTXFOGsmVkGNdAwNtGM+VumXKX/P+p0oMaort9mCYU
         MpWoTo8F2TOOvqze8XGY9mwxeCNJaWIVdGorse2uBpBVDT1afMsCm9F6bVdntWhI8mvS
         wDoQ==
Content-Disposition: inline
In-Reply-To: <1491529677-707-1-git-send-email-todd-PpDmNYGCFmmZ9vWoFJJngh2eb7JE58TQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Todd Poynor <toddpoynor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Todd Poynor <toddpoynor-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Thu, Apr 06, 2017 at 06:47:57PM -0700, Todd Poynor wrote:
> From: Todd Poynor <toddpoynor-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Various structures embed a struct cgroup_subsys_state, typically at
> the top of the containing structure.  It is common for code that
> accesses the structures to perform operations that iterate over the
> chain of parent css pointers, also accessing data in each containing
> structure.  In particular, struct cpuacct is used by fairly hot code
> paths in the scheduler such as cpuacct_charge().
> 
> Move the parent css pointer field to the end of the structure to
> increase the chances of residing in the same cache line as the data
> from the containing structure.
> 
> Signed-off-by: Todd Poynor <toddpoynor-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.12.

Thanks.

-- 
tejun
