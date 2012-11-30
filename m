From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] cgroup: warn about broken hierarchies only after
 css_online
Date: Fri, 30 Nov 2012 07:11:58 -0800
Message-ID: <20121130151158.GB3873@htj.dyndns.org>
References: <1354282286-32278-1-git-send-email-glommer@parallels.com>
 <1354282286-32278-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=aXID+d4oXcvmbZrjxtdQqjymVPb9P/yujPTB1wWb+Kg=;
        b=atskM2lE9YgaAy3PElcfjHZF3HKoD3BJ4VHarDLHijXx62BiHcHGmP40a6in1NRAhl
         fieFZJavKgouzql9vtLmMJv1hEsIE7vuLXXFPDW8+yeNp1VaMBqBL7bUkNF+gsgp2SMa
         WBNheIj+oPT7FN2xZGZ6/uMIMVdNzqV8ysOOshpiXy/U6/jawRXcqIZRFH2/YUXTRP1+
         ohHL22fp16RhHRsLO4lXw5sVI2Q0mFAUyNxN1+KZD6Dcv2DndG9wtUwQ17MB1HxW4O1I
         dHv2VDhZ+/JF68J55GoZLmI4+v8PtZSRh9Hb9TsM82lJhWmmg4bWw4BlL/sQ8DFxp2Gu
         Hebg==
Content-Disposition: inline
In-Reply-To: <1354282286-32278-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

On Fri, Nov 30, 2012 at 05:31:23PM +0400, Glauber Costa wrote:
> If everything goes right, it shouldn't really matter if we are spitting
> this warning after css_alloc or css_online. If we fail between then,
> there are some ill cases where we would previously see the message and
> now we won't (like if the files fail to be created).
> 
> I believe it really shouldn't matter: this message is intended in spirit
> to be shown when creation succeeds, but with insane settings.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Applied to cgroup/for-3.8.  Thanks!

-- 
tejun
