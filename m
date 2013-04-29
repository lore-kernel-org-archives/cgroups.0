From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/10] freezer: skip waking up tasks with PF_FREEZER_SKIP
 set
Date: Mon, 29 Apr 2013 14:57:45 -0700
Message-ID: <20130429215745.GB2395@htj.dyndns.org>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
 <1367271946-7239-3-git-send-email-ccross@android.com>
 <20130429215157.GA2395@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=qxjHsjrZZ9qxvzHOzkCliQTh7KyJ+sICu6Rx/dseNWs=;
        b=ZRk5tf0wDUKXhuNm6x6RJEebJAggs7cMVYp86quRfKJ8x4p+upENwJ2By+8Vampb4Q
         Yx7HBYY/NPjGzqr6+L5O6vlmC9/Di3Ni7LpKXt2Wr66/G1ZvsPxOuYqQmqQpAlXbPMDx
         mJF35Hgot2ShpaNrzSsSuuC7mOhgYQh0bozQc4DOGnsOeHPqDNGTitUtdpw9T2DzpnQn
         VmJnHNwWrGk2qmHLRi/Lrprnj7l6jzZ+h3EdK4NWVeMuB/KguTiqexCixlgZ8AfVMB6v
         d0G0e6xMYQafWriimluWZoFzoOpm7IZhHkNHo2+2ddflDmIz61Kzcyu8cM1RVMkWYhrt
         KAkw==
Content-Disposition: inline
In-Reply-To: <20130429215157.GA2395-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Cc: linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 29, 2013 at 02:51:57PM -0700, Tejun Heo wrote:
> I feel a bit weary of changes which try to optimize state checks for
> freezer because the synchronization rules are kinda fragile and things
> may not work reliably depending on who's testing the flag, and it has
> been subtly broken in various ways in the past (maybe even now).  Can

And BTW, this is why the function is only used when checking whether a
task is frozen rather than to decide to issue freeze_task() on it, and
it seems your change is correct now that we don't have per-task FREEZE
flag but I can't say I like the change.  I'd really like to keep
things as dumb as possible for freezer.

Thanks.

-- 
tejun
