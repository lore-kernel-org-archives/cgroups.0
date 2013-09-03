From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/9] cgroup: fix css leaks on online_css() failure
Date: Tue, 3 Sep 2013 16:06:56 -0400
Message-ID: <20130903200656.GD27092@mtj.dyndns.org>
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
 <1377723829-22814-2-git-send-email-tj@kernel.org>
 <52245DE0.1010701@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=byZPBd8wCKm+qG+ErbB9dP1TLnHD88FxVum3ZQ7Fczc=;
        b=dTHpCxiURRV26saz5E5IUf73lC3R2UnyxL5V0e68+xyGOOliyk9E56cBe2P1vZvPFz
         7UIooGhDMPs2l9ID31DoLcKcwc1MY5oPYAqBfJ86Fzo12xPcvKMgesRrWZtbn6UEbIf9
         WK9HHAFkYfYMSE7qpGYP3UjXXLlBlL5BgAYyZa970fACCYqP1zrbNR5cbbPIBeWzRh9O
         KVUdnBHtib9qHjJtM4J/g66gADvQD97o69X5PROwEO0/lYP0W20r+MU/Y1kO5hYLSug/
         PwriozyCrQmMym0bQy2rKVWOkyilvTXrL58YV0Ysr7wCXHmsJRhdi24xjB5BXl+KTKnX
         wqqA==
Content-Disposition: inline
In-Reply-To: <52245DE0.1010701-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Sep 02, 2013 at 05:44:00PM +0800, Li Zefan wrote:
> Now cgroup_destroy_locked() is called:
> 
> 	for_each_root_subsys(cgrp->root, ss)
> 		kill_css(cgroup_css(cgrp, ss));

Oops, yes, later in the series, for_each_css() is introduced and
replaces for_each_root_subsys() usages solving the above problem.  I
should have put those patches before this one.  Will re-sequence the
patches.

Thanks.

-- 
tejun
