From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] memcg: generate file modified notifications on
 "memory.events"
Date: Mon, 21 Sep 2015 15:16:30 -0400
Message-ID: <20150921191630.GG13263@mtj.duckdns.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
 <1439315889-3492-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7ej2Z17dc1npO449hYkOezfIAVO/T//kqXWSfj2wkd4=;
        b=KicTUS2MLiJGaSulrpZZQ9k+5jOHInA8/riN4KIO/iOF6cfS82soe847EDX5H5aPmM
         XUthEy1U0MyeuanD4vFrOWF+4isv2X0t1bw9k66jcKyLxyILVaG/icIN6N6vf9IhsWZZ
         o8hJ1uipHc116WAnRTwM0YnMDmwn64OiMpsKGhHDOPyu+HJ9GN9xFwE4rjYlnipNdQlo
         e/ZVESVpgE9B66646M77n34+5s/GTP/Jlenvyri4EDhVTTVJYHQJjC5YOg3EU3md76gU
         Iu+RUm38aTIHQkOX8m02IssBKqAH3JDzEANvL+zZL9lFKa1o1UztgwctVsW0pvQFJ1Rv
         VQrA==
Content-Disposition: inline
In-Reply-To: <1439315889-3492-9-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 11, 2015 at 01:58:09PM -0400, Tejun Heo wrote:
> cgroup core only recently grew generic notification support.  Wire up
> "memory.events" so that it triggers a file modified event whenever its
> content changes.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-4.4.

Thanks.

-- 
tejun
