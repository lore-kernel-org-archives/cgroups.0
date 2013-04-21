From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/10] cpuset: don't update tasks' cpumask and nodemask
 in an empty cpuset
Date: Sat, 20 Apr 2013 18:42:41 -0700
Message-ID: <20130421014241.GC19097@mtj.dyndns.org>
References: <517137A7.4020605@huawei.com>
 <51713819.8050708@huawei.com>
 <20130419183618.GC13811@mtj.dyndns.org>
 <5171EA24.3070001@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=sZkdWHoEPP7Tn1tEMye70FKgvSyDJ2EAyUgMJ1qByVk=;
        b=c+1qVAwLUCO/UI67O3Xq1UQrCG45F19LfPv3QUkzxsQoxyiW239F2bNPxW7BOGUjPh
         taZDT6IoB6883Hhxjyio+GlKCZ2gW3GwXUFNQ2cQvpUbj65lJx0F6R829fmnrqkdJ/ab
         3FaEvhe6XqE0qk2wRorWojss8MYBTz1zfbaoql6Vx5Nni3JKUjeZcej9aBq4YNJnCJWD
         QnDcvEvFZhbuRQlCj3/AIakSHzS7OIVq271oRTW+AJDnvbmgiPkOUnv0kTjMny604Ifb
         LN7f1AdFDvD7Cz3bFZFc1nRGClOiB3pudLHE/FLfh2hTWUuqq1Lm9L3XoFElKo76VD1g
         e7ag==
Content-Disposition: inline
In-Reply-To: <5171EA24.3070001-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Hello,

On Sat, Apr 20, 2013 at 09:06:44AM +0800, Li Zefan wrote:
> I was trying to fix a bug: before moving tasks out of empty cpusets,
> update_tasks_nodemask() is called, which calls do_migrate_pages(xx, from, to)
> finally, from == node_to_be_offlined, to == empty_nodeamsk, so I guess
> no pages will be migrated.
> 
> Then when those tasks are moving to an ancestor, do_migrate_pages(xx, from, to)
> is called again, from == empty_nodemask, to == ancestor's nodemask,
> so I guess again no pages will be migrated.

Oh, I see.  I was a bit confused by the description.  Maybe include
the above?

Thanks.

-- 
tejun
