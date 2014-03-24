From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] kernel: Use RCU_INIT_POINTER(x, NULL) in cgroup.c
Date: Mon, 24 Mar 2014 08:49:39 -0400
Message-ID: <20140324124939.GA29892@mtj.dyndns.org>
References: <1395600438-9838-1-git-send-email-monamagarwal123@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=l2i7HYWoQVCRO2W1IwHcSTmUQe6uM4TKTq1Uk6V4I1I=;
        b=0VrrCPTj6r6gYrVIGX+EpPu5bwHcSD70u6Y2I5rGsK2epk1q9wvGkLgudGEgte3S+2
         wi7ZxIVpbbDPf+EYRaKzuz/zIvF5PCegekkAg+0aRzwfucYI5yMZihqXHKXS72QHq+BG
         RzssvOifS53Ekr8oOOWr6UJdHeB4bOSa8W583oLvSuhR8L5aQP+HG0+i+hKvJ8F++0mj
         F92r3e51oXHZb8EbakrLBo73An7udA0GFpoYInatEPOqkCrqV4vzlkPf2u4WG4qt1WwX
         /KkSrh/eyGNMGObKbWEn8nQcao+JYd+xUfIYKi1KDS9lFuOrWsHeTQZjEVEOReQmoA4W
         TEXw==
Content-Disposition: inline
In-Reply-To: <1395600438-9838-1-git-send-email-monamagarwal123-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Monam Agarwal <monamagarwal123-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 24, 2014 at 12:17:18AM +0530, Monam Agarwal wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
> 
> The rcu_assign_pointer() ensures that the initialization of a structure       
> is carried out before storing a pointer to that structure. 
> And in the case of the NULL pointer, there is no structure to initialize. 
> So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)
> 
> Signed-off-by: Monam Agarwal <monamagarwal123-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-3.15.

Thanks.

-- 
tejun
