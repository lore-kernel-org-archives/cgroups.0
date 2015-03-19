From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] cpusets,isolcpus: add file to show isolated cpus in
 cpuset
Date: Wed, 18 Mar 2015 21:48:27 -0400
Message-ID: <20150319014827.GH25365@htj.duckdns.org>
References: <1425917530-1771-1-git-send-email-riel@redhat.com>
 <1425917530-1771-4-git-send-email-riel@redhat.com>
 <20150318164745.GA21564@htj.duckdns.org>
 <550A2A49.4060704@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zt0ewxNEmM6Y4U0zTH5ZOggg3tqoc+RI6DmwqdjVqi0=;
        b=iUqTLtinmbUosnpprPLcBjodDXNwB0XhTz7DzBkmE9Y/Vbh90WAKauron0us84v6gF
         Y6mQRyD0ro9Zrno0PIJkZKfnKnViAZRhQnQKLKMTGAn2PdHRzX5OZrieZQJJxYruNv1H
         LxcuNOogVB+8MG1goNP6Z4jx9jb7Hj113rH+2ZDusoIuqJQektfotS66as61mhKC7SOV
         zMuqOm6UyAQRTRIFm/JsQsw+lHv5WmJBmcNDdBF2sjMbc1t919RTprTugOe03jV+HpGk
         fusNgnUWC2F5kBDIAcrhwH4gMws3ljdFo+8Fi/V1de2/HOPwJG6opNR1xGG2z/mPRLTB
         Pgog==
Content-Disposition: inline
In-Reply-To: <550A2A49.4060704-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello,

On Wed, Mar 18, 2015 at 09:45:45PM -0400, Rik van Riel wrote:
> Going back through my email, it looks like Li
> previously acked this patch.

Ooh, the patch didn't have acked-by.  Sorry about the confusion.

> That explains why I'm confused about your comment :)

I still don't think cpuset is the right place to put this knob.  This
is a system-wide boot paramter, isn't it?  There gotta be a place
better suited for this, be that a sysctl knob or a file under sys.

Thanks.

-- 
tejun
