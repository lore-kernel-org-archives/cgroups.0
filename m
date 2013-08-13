From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: decouple cgroup_subsys_state
 lifetime from that of cgroup
Date: Tue, 13 Aug 2013 11:02:45 -0400
Message-ID: <20130813150245.GE26596@mtj.dyndns.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9SKgb0RXUifM7VTkAYSF1pVfZLVdByoKtydsMuVzc9Y=;
        b=WvJbLbkxD9Ufvxv92PP5hOZhQwLsrleyCNecUQWYImAqlnWP9vuzLvdn51UtiHIL9e
         fPV9zwysWlTBm/fg+mP4jqimLnPKU4dYGTqftgklarzGdxJ49jde9Jdn+wCMkCq7cwRT
         jjyYdYkWnkebmRpSBzIUCvf9LzBMtF+ES/vRe4O+ZCH6wu+VHCD09zfJYbc1YaW25q9f
         huqdLeMyrIy0lpBJDAKUx9MrrLbH0UrwtJUWJh78vdbgKLBcOJCnjH1td01aEB0sHLje
         CIrlQPclKKFlJGwj/ZFes80TLHN88h/rTnb8sHi+ZH9Gi0b36ROgrMlIhJkRuOeUGB6C
         7ucw==
Content-Disposition: inline
In-Reply-To: <1375992831-4650-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 08, 2013 at 04:13:37PM -0400, Tejun Heo wrote:
> With the planned unified hierarchy, we'll be dynamically creating and
> destroying css's through the lifetime of a cgroup, so we can no longer
> hitch css lifetime management onto cgroup's.  This patchset separates
> out css lifetime management from that of cgroup.  After the patchset,
> each css is individually RCU protected.

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
