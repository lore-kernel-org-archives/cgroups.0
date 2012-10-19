From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Date: Fri, 19 Oct 2012 13:04:21 -0700
Message-ID: <20121019200421.GO13370@google.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <2424755.Pg0O5tTD3k@vostro.rjw.lan>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qdrK1iuCSDgplXscH3E+C74uj4Rav0LYj6G340kTEYE=;
        b=R6Y2q6UPW7OOkhqLJ5eA43Xh7JVy0KNHU0TEOLqjE5mHCua7KGRHOirE6LX+3/TYib
         rW3nruF7p/JkuGU4WpzkgmkXFl7t67fog8X3zrl3mh6Irqnx3vGvq7w7UK9h9y10SiI9
         gZi+TMWTAV6qtMyCa5z+RP5wKo5SLIuG/qgXhkr9k3SybaJczRAkwZ8kuKLoSCYUy3Dw
         3cNc+67QhMFDLQrASNDFrbaUs0q19qWvOfO33qHix4mazrClTzV7W5FDYV7QqDHS/Oud
         J5q70vtHQxwlQUBiGC288sdwHcC3dnm1tTp8vppHyq5v3i66u0bAfyc3f8vT5ZrxxctA
         CCTA==
Content-Disposition: inline
In-Reply-To: <2424755.Pg0O5tTD3k-sKB8Sp2ER+y1GS7QM15AGw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Cc: oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Oct 19, 2012 at 06:54:42PM +0200, Rafael J. Wysocki wrote:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup_freezer-locking
> 
> It seems that no one has any comments. :-)
> 
> Are you going to prepare a branch for me to pull from?

I'm waiting for Oleg to poke some holes in the synchronization
department but if that doesn't happen you can pull from the above
branch.  I'll pull it into cgroup/for-3.8 too.

Thanks.

-- 
tejun
