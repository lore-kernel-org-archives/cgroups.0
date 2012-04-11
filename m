From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-3.5] cgroup: remove cgroup_subsys->populate()
Date: Wed, 11 Apr 2012 09:16:06 -0700
Message-ID: <20120411161606.GA12887@google.com>
References: <20120410171636.GB21311@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F84D2FB.4050001@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=736nKtAJXVttEGxF7q+/ldKkYvZNzCcq1vqO+5SUZLU=;
        b=kJ6L8JwLffekb911Ed+zujYfrTMWgKzi9h4U4bbQrh8XuHLBRXmsstzYsOxPVUDVvr
         FkSfgNMeVbXszK3ozuFaNkTiwvSf5soMy1EzlN6rGbZy6dxtOOrLgmYQ4UXdbaKVDaO4
         G32tk37aYmEjHVSBu6MzNUxiLNiow3bC/yyoGVITP71Uu25WZUlOanfRUfuskDopXRjM
         eno6He9POpjHrstf++fT875MreSTp8xKh+wPV3mOO0E7aHK2PX8lGrYc2ZBYBcVaffgt
         hZga9HvpyWGsXSaAKc6FohZ8xoIc0WHd2HuWfaRaVzt4N2WqgcxiMBwQ08w57z6vjoi1
         rpoQ==
Content-Disposition: inline
In-Reply-To: <4F84D2FB.4050001-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 11, 2012 at 08:40:27AM +0800, Li Zefan wrote:
> Tejun Heo wrote:
> 
> > With memcg converted, cgroup_subsys->populate() doesn't have any user
> > left.  Remove it.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > Li, can you please ack this?  Thanks.
> 
> 
> You forgot to update Documentation/cgroups/cgroups.txt. ;)

Yeah, the doc is getting out of sync (->cftypes update is missing
too).  I'll get to it later.

> And with that:
> 
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks.

-- 
tejun
