From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] cgroups: Resource controller for open files.
Date: Wed, 2 Jul 2014 10:33:00 -0400
Message-ID: <20140702143300.GB23275@htj.dyndns.org>
References: <1404311407-4851-1-git-send-email-merimus@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wAAV1iUg8hjUwO9T33kENDr2Ej5nCYr4qLVGnSC5Cto=;
        b=aorlISztlfcImlLichzUwWfR+ON5V2nT6WD8P4M35BElPdKHqriOUpS2kRNYsvxfip
         RHcdwmHYpi5xAcE4QWNcA9KmZVA+KP/2iTeflNWZ/u3en8l9UIXP41b1heOJmK0mxbOn
         AX/4DeQNsgu9xKj2XIbo/mPmEd6Sbmf8u/Dsp5Jh3mB7sqHPdTylYqhrlD6LAiCM3EZf
         /7/hLCBqMc6yB19N20dIEt0aS915ybj1RDdWPkHW5F6uuZXUWP6q0YFSvv0x0g/qMepN
         kVEXInwV2Tm2FjkPBtABaO6bpTJYiDFPNskkYFk6uV7CJ/yhTSzAEL/0x9aiRti4ce7W
         pNKw==
Content-Disposition: inline
In-Reply-To: <1404311407-4851-1-git-send-email-merimus-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Binder Makin <merimus-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmj-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Jul 02, 2014 at 10:30:07AM -0400, Binder Makin wrote:
> Add a resource controller for limiting the number of open
> file handles.  This allows us to catch misbehaving processes
> and return EMFILE instead of ENOMEM for kernel memory limits.

cc'ing memcg people.  Isn't kmemcg supposed to cover this by
controlling kernel memory usage?

Thanks.

-- 
tejun
