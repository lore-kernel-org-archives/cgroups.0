From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/9] device_cgroup: prepare exception list handling
 functions for two lists
Date: Tue, 29 Jan 2013 11:41:55 -0800
Message-ID: <20130129194155.GB6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.321644928@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=MvYMWcCy+XGYuvY25VpB9szrbaz9jx25fCkizHqDm1I=;
        b=afXkQSXWPCgrzHpzNPQdgecTQN3Elb3q1+vnT49eTqrSBRF0hLloeu58o+NoD6nGWG
         hulJfs9zk1bmsh+MlLVlsa28LdaThc0ovBV6VM0zakEdiLtSd+U3vSxbFuSuAozx++TW
         Ge2jrdzMkpnyI3vownnGicMyVgjdv2BAuwRWSW7fkFUVX5dMvIUjaSy3d0lirfe4zZQX
         rhcMicJZ9JhNHtCGyYmezx2M4ByAqNcWRAjo2Ns1vRIqenQgb9AN7gVsalGSu3qIOCPw
         +KpS2uvlI3WT4JJ9ttNHt3CCqSHG88w/JFRnJ4WoO+ftw/hxeEhwS8Zf6WRqsIDWZiJd
         D+OA==
Content-Disposition: inline
In-Reply-To: <20130129190759.321644928-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Jan 29, 2013 at 02:08:00PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> In the following patches, device_cgroup structure will have two sets of
> behavior and exceptions list (actual one, another with the local settings)
> so rework the functions to use exception list, not a device_cgroup.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Can you please keep acks across postings?  That makes it a bit easier
for reviewers.

Thanks.

-- 
tejun
